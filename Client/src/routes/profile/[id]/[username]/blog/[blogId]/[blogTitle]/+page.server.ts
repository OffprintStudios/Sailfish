import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import { getReq } from "$lib/http";
import type { ThreadPage } from "$lib/models/comments";

export const load: PageServerLoad = async ({ params, url }): Promise<{ blog: Blog, page?: ThreadPage }> => {
	const blogRes = await getReq<Blog>(`/blogs/fetch-blog/${params.blogId}`);
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 25;

	if ((blogRes as Blog).id) {
		const blog = blogRes as Blog;
		if (blog.publishedOn) {
			const threadRes = await getReq<ThreadPage>(`/comments/fetch-content-thread/${blog.id}?page=${page}&per=${per}`);
			if ((threadRes as ThreadPage).thread) {
				return {
					blog,
					page: threadRes as ThreadPage,
				};
			} else {
				throw error(404, 'Not Found');
			}
		} else {
			return {
				blog
			};
		}
	}

	throw error(404, 'Not Found');
}