import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import { BASE_URL } from "$lib/http";
import type { ThreadPage } from "$lib/models/comments";

export const load: PageServerLoad = async ({ params, url, fetch }): Promise<{ blog: Blog, page?: ThreadPage }> => {
	const response = await fetch(`${BASE_URL}/blogs/fetch-blog/${params.blogId}`);
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 25;

	if (response.status === 200) {
		const blog: Blog = await response.json();
		if (blog.publishedOn) {
			const threadRes = await fetch(`${BASE_URL}/comments/fetch-content-thread/${blog.id}?page=${page}&per=${per}`);
			if (threadRes.status === 200) {
				return {
					blog,
					page: await threadRes.json(),
				};
			}
		}
		return { blog };
	} else {
		const errorMsg: { error: boolean, reason: string } = await response.json();
		throw error(response.status, { message: errorMsg.reason });
	}
}