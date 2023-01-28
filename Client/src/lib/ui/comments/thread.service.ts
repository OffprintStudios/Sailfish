import type { Comment, CommentForm } from "$lib/models/comments";
import type { Paginate } from "$lib/util/types";
import { CommentType } from "$lib/models/comments";
import { writable } from "svelte/store";
import { getReq, postReq, patchReq } from "$lib/http";
import type { ResponseError } from "$lib/http";
import { get } from "svelte/store";
import { account } from "$lib/state/account.state";
import toast from "svelte-french-toast";

export class ThreadService {
	threadId: string;
	page = writable<Paginate<Comment>>({
		items: [],
		metadata: {
			page: 1,
			per: 25,
			total: 0
		}
	});
	url: string;
	loading = writable<boolean>(false);
	replies = writable<Comment[]>([]);

	constructor(kind: CommentType, threadId: string, page: Paginate<Comment>, sectionId?: string) {
		this.threadId = threadId;
		this.page.set(page);
		switch (kind) {
			case CommentType.Blog:
				this.url = `/blogs/${this.threadId}/comments`;
				break;
			case CommentType.Work:
				if (sectionId) {
					this.url = `/works/${this.threadId}/comments?sectionId=${sectionId}`;
				} else {
					this.url = `/works/${this.threadId}/comments`;
				}
				break;
			case CommentType.Forum:
				this.url = `/threads/${this.threadId}/posts`;
				break;
		}
	}

	async fetchPage(pageNum: number, perPage: number, sectionId?: string): Promise<void> {
		this.loading.update(() => true);
		const response = await getReq<Paginate<Comment>>(
			sectionId
				? `${this.url}?page=${pageNum}&per=${perPage}&sectionId=${sectionId}`
				: `${this.url}?page=${pageNum}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			this.page.update(() => response as Paginate<Comment>);
		}
		this.loading.update(() => false);
	}

	async addComment(formInfo: CommentForm): Promise<void> {
		const response = await postReq<Comment>(
			`${this.url}/add?profileId=${get(account).currProfile?.id}`,
			formInfo
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const comment = response as Comment;
			this.page.update((state) => ({
				items: [...state.items, comment],
				metadata: {
					page: state.metadata.page,
					per: state.metadata.per,
					total: state.metadata.total + 1
				}
			}));
			this.replies.set([]);
			toast.success(`Comment added!`);
		}
	}

	async editComment(id: string, formInfo: CommentForm): Promise<Comment> {
		const response = await patchReq<Comment>(
			`${this.url}/${id}/edit?profileId=${get(account).currProfile?.id}`,
			formInfo
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
			throw Error(error.message);
		} else {
			toast.success(`Changes saved!`);
			return response as Comment;
		}
	}
}
