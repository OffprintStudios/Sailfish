import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import type { Comment } from "$lib/models/comments";
import type { Paginate } from "$lib/util/types";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: LayoutServerLoad = async ({
	params,
	url
}): Promise<{ blog: Blog; comments: Paginate<Comment> }> => {
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 25;
	const response = await getReqServer<{ blog: Blog; comments: Paginate<Comment> }>(
		`/blogs/${params.blogId}?page=${page}&per=${per}`
	);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as { blog: Blog; comments: Paginate<Comment> };
	}
};
