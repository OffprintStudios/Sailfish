import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import { BASE_URL } from "$lib/http";
import type { Comment } from "$lib/models/comments";
import type { Paginate } from "$lib/util/types";

export const load: PageServerLoad = async ({
	params,
	url,
	fetch
}): Promise<{ blog: Blog; comments: Paginate<Comment> }> => {
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 25;
	const response = await fetch(`${BASE_URL}/blogs/${params.blogId}?page=${page}&per=${per}`);
	if (response.status === 200) {
		return await response.json();
	}
	const errorMsg: { error: boolean; reason: string } = await response.json();
	throw error(response.status, { message: errorMsg.reason });
};
