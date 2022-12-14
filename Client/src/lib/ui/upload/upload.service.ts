import toast from "svelte-french-toast";
import { writable } from "svelte/store";
import { patchReq } from "../../http";
import type { ResponseError } from "../../http";

export enum UploadType {
	CoverArt = "coverart",
	BlogBanner = "blogbanner",
	Avatar = "avatar",
	ProfileBanner = "profilebanner",
	WorkBanner = "workbanner",
	VolumeCover = "volumecover"
}

export class UploadService<T> {
	isUploading = writable<boolean>(false);
	name = UploadType.CoverArt;
	itemId = "";
	profileId = "";
	result = writable<T | null>(null);
	otherParams: string | undefined = undefined;

	constructor(name: UploadType, itemId: string, profileId: string, otherParams?: string) {
		this.name = name;
		this.itemId = itemId;
		this.profileId = profileId;
		this.otherParams = otherParams;
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

			if (
				file?.type === "image/png" ||
				file?.type === "image/jpeg" ||
				file?.type === "image/jpg"
			) {
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

			if (
				file?.type === "image/png" ||
				file?.type === "image/jpeg" ||
				file?.type === "image/jpg"
			) {
				await this.processFile(file);
			} else {
				toast.error(`Unsupported file type ${file?.type}`);
				throw Error("Unsupported file type");
			}
		}
	}

	async handleFileSelected(event: any): Promise<void> {
		const file = event.target.files[0];
		if (file.type === "image/png" || file.type === "image/jpeg" || file.type === "image/jpg") {
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
			const fileUrl = (event.target?.result as string).split(",")[1];
			await this.uploadImage(fileUrl, image.name, image.type);
		};
	}

	private async uploadImage(image: string, filename: string, mime: string): Promise<void> {
		const url = this.determineUrl();
		const formData = {
			image,
			filename,
			mime
		};

		const response = await patchReq<T>(url, formData);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			this.result.set(response as T);
			this.isUploading.set(false);
		}
	}

	private determineUrl() {
		switch (this.name) {
			case UploadType.Avatar:
				return `/profiles/update-avatar?profileId=${this.profileId}`;
			case UploadType.ProfileBanner:
				return `/profiles/update-banner?profileId=${this.profileId}`;
			case UploadType.BlogBanner:
				return `/blogs/${this.itemId}/update-cover?profileId=${this.profileId}`;
			case UploadType.CoverArt:
				return `/works/update-cover/${this.itemId}?profileId=${this.profileId}`;
			case UploadType.WorkBanner:
				return `/works/update-banner/${this.itemId}?profileId=${this.profileId}`;
			case UploadType.VolumeCover:
				return `/volumes/update-cover/${this.itemId}?profileId=${this.profileId}${
					this.otherParams ? this.otherParams : ""
				}`;
		}
	}
}
