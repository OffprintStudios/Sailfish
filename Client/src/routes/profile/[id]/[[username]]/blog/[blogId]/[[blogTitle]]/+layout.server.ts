import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { Blog } from "$lib/models/content";
import type { Comment } from "$lib/models/comments";
import type { Paginate } from "$lib/util/types";
import { getReqServer, type ServerResponseError } from "$lib/server";
import { PUBLIC_ENV } from "$env/static/public";

export const load: LayoutServerLoad = async ({
	params,
	url,
	getClientAddress,
	request
}): Promise<{ blog: Blog; comments: Paginate<Comment> }> => {
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 25;
	const ipAddress =
		PUBLIC_ENV === "development" ? getClientAddress() : request.headers.get("CF-Connecting-IP");
	const response = await getReqServer<{ blog: Blog; comments: Paginate<Comment> }>(
		`/blogs/${params.blogId}?page=${page}&per=${per}`,
		{
			headers: {
				"X-Offprint-Client-IP": ipAddress
			}
		}
	);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as { blog: Blog; comments: Paginate<Comment> };
	}
};
