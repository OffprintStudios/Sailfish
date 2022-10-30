import type { PaginateResults } from "../../util/types";
import type { BlacklistForm, Comment, CommentForm, Thread, ThreadBlacklist } from "../../models/comments";
import { writable } from "svelte/store";
import { BASE_URL } from "../../http";
import toast from "svelte-french-toast";

interface CommentsState {
	loading: boolean;
	thread: Thread | null;
	page: PaginateResults<Comment> | null;
}

export const comments = writable<CommentsState>({
	loading: false,
	thread: null,
	page: null,
});

export async function fetchContentThread(contentId: string, page: number, per: number) {
	comments.update((state) => ({...state, loading: true}));
	const threadResponse = await fetch(`${BASE_URL}/comments/fetch-content-thread/${contentId}`, {
		method: 'GET'
	});
	if (threadResponse.status === 200) {
		const pageResponse = await fetch(`${BASE_URL}/comments/fetch-comments/${contentId}?page=${page}&per=${per}`, {
			method: 'GET'
		});

		if (pageResponse.status === 200) {
			const thread: Thread = await threadResponse.json();
			const page: PaginateResults<Comment> = await pageResponse.json();

			comments.update(() => ({
				loading: false,
				thread,
				page,
			}));
		} else {
			toast.error("Something went wrong fetching comments!")
		}
	}
}

export async function addComment(profileId: string, formInfo: CommentForm) {
	const response = await fetch(`/api/comments/${formInfo.threadId}/add-comment?profileId=${profileId}`, {
		method: 'POST',
		body: JSON.stringify(formInfo)
	});

	if (response.status === 200) {
		const newComment: Comment = await response.json();
		comments.update((state) => {
			if (state.page === null) {
				state.page = {
					items: [newComment],
					metadata: {
						page: 1,
						per: 25,
						total: 1,
					}
				};
			} else {
				state.page = {
					items: [...state.page.items, newComment],
					metadata: {
						page: state.page.metadata.page,
						per: state.page.metadata.per,
						total: state.page.metadata.total + 1,
					}
				};
			}
			return state;
		});
	} else {
		toast.error("Something went wrong! Try again in a little bit.");
	}
}

export async function editComment(commentId: string, profileId: string, formInfo: CommentForm) {
	const response = await fetch(`/api/comments/${formInfo.threadId}/edit-comment?commentId=${commentId}&profileId=${profileId}`, {
		method: 'PATCH',
		body: JSON.stringify(formInfo),
	});

	if (response.status === 200) {
		const updatedComment: Comment = await response.json();
		comments.update((state) => {
			const newArr = state.page?.items.map((x) => {
				if (x.id === updatedComment.id) {
					return updatedComment;
				} else {
					return x;
				}
			});
			state.page = {
				items: newArr ?? [],
				metadata: {
					page: state.page?.metadata.page ?? 1,
					per: state.page?.metadata.per ?? 25,
					total: state.page?.metadata.page ?? 1,
				}
			};
			return state;
		})
	} else {
		toast.error("Something went wrong! Try again in a little bit.");
	}
}

export async function addToBlacklist(profileId: string, formInfo: BlacklistForm) {
	const response = await fetch(`/api/comments/${formInfo.threadId}/add-to-blacklist?profileId=${profileId}`, {
		method: 'POST',
		body: JSON.stringify(formInfo)
	});

	if (response.status === 200) {
		const newEntry: ThreadBlacklist = await response.json();
		comments.update((state) => {
			if (state.thread !== null) {
				state.thread.blacklist = [...state.thread.blacklist, newEntry];
			}
			return state;
		})
	} else {
		toast.error("Something went wrong! Try again in a little bit.");
	}
}

export async function removeFromBlacklist(profileId: string, blacklistId: string, threadId: string) {
	const response = await fetch(`/api/comments/${threadId}/add-to-blacklist?profileId=${profileId}&blacklistId=${blacklistId}`, {
		method: 'DELETE',
	});

	if (response.status === 200) {
		comments.update((state) => {
			if (state.thread !== null) {
				state.thread.blacklist = state.thread.blacklist.filter(x => x.id !== blacklistId);
			}
			return state;
		})
	} else {
		toast.error("Something went wrong! Try again in a little bit.");
	}
}
