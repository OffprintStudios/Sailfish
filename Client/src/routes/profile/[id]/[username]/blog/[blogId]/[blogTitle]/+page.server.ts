import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import { getReq } from "$lib/http";
import type { Typify } from "$lib/util/types";

type LoadOutput = Typify<Blog>;

export const load: PageServerLoad = async ({ params }): Promise<LoadOutput> => {
	const response = await getReq<Blog>(`/blogs/fetch-blog/${params.blogId}`);

	if ((response as Blog).id) {
		return response as Blog;
	}

	throw error(404, 'Not Found');
}