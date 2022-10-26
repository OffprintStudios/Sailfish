import toast from "svelte-french-toast";
import { account } from "../../state/account.state";
import { get, writable } from "svelte/store";

export enum UploadType {
	CoverArt = "coverart",
	BlogBanner = "blogbanner",
	Avatar = "avatar",
	ProfileBanner = "profilebanner",
	WorkBanner = "workbanner",
}

export class UploadService<T> {
	isUploading = writable<boolean>(false);
	name = UploadType.CoverArt;
	itemId = "";
	result = writable<T | null>(null);

	constructor(name: UploadType, itemId: string) {
		this.name = name;
		this.itemId = itemId;
	}

	async handleDrop(event: DragEvent): Promise<void> {
		const items = event.dataTransfer?.items;
		const files = event.dataTransfer?.files ?? [];
		let file = null;

		if (items) {
			if (items.length > 1) {
				toast.error("You can only upload one image!");
				throw Error("Unsupported file type");
			}

			file = items[0].getAsFile();

			if (file?.type === 'image/png' || file?.type === 'image/jpeg' ||file?.type === 'image/jpg') {
				await this.processFile(file);
			} else {
				toast.error(`Unsupported file type ${file?.type}`);
				throw Error("Unsupported file type");
			}
		} else {
			if (files?.length !== undefined && files?.length > 1) {
				toast.error("You can only upload one image!");
				throw Error("Unsupported file type");
			}
			file = files[0];

			if (file?.type === 'image/png' || file?.type === 'image/jpeg' ||file?.type === 'image/jpg') {
				await this.processFile(file);
			} else {
				toast.error(`Unsupported file type ${file?.type}`);
				throw Error("Unsupported file type");
			}
		}
	}

	async handleFileSelected(event: any): Promise<void> {
		const file = event.target.files[0];
		if (file.type === 'image/png' || file.type === 'image/jpeg' || file.type === 'image/jpg') {
			await this.processFile(file);
		} else {
			toast.error(`Unsupported file type '${file.type}'`);
			throw Error("Unsupported file type");
		}
	}

	private async processFile(image: File): Promise<void> {
		this.isUploading.set(true);
		const reader = new FileReader();
		reader.readAsDataURL(image);
		reader.onload = async (event) => {
			const fileUrl = (event.target?.result as string).split(',')[1];
			await this.uploadImage(fileUrl, image.name, image.type);
		}
	}

	private async uploadImage(image: string, filename: string, mime: string): Promise<void> {
		const url = this.determineUrl();
		const formData = {
			image,
			filename,
			mime,
		};

		return await fetch(url, {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
			},
			body: JSON.stringify(formData),
		}).then(async data => {
			this.result.set(await data.json() as T);
			this.isUploading.set(false);
		})
	}

	private determineUrl() {
		switch(this.name) {
			case UploadType.Avatar:
				return `/api/accounts/upload-avatar?profileId=${get(account).currProfile?.id}`;
			case UploadType.BlogBanner:
				return `/api/content/blogs/${this.itemId}/upload-banner?profileId=${get(account).currProfile?.id}`;
			case UploadType.CoverArt:
				return `/api/content/works/${this.itemId}/upload-coverart?profileId=${get(account).currProfile?.id}`;
			case UploadType.ProfileBanner:
				return `/api/accounts/upload-banner?profileId=${get(account).currProfile?.id}`;
			case UploadType.WorkBanner:
				return `/api/content/works/${this.itemId}/upload-banner?profileId=${get(account).currProfile?.id}`
		}
	}
}