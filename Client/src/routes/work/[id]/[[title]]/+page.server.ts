import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import type { Paginate } from "$lib/util/types";
import type { Comment } from "$lib/models/comments";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: PageServerLoad = async ({
	url,
	params,
	getClientAddress
}): Promise<{ work: Work; comments: Paginate<Comment> }> => {
	const page = url.searchParams.get("page") ?? "1";
	const per = url.searchParams.get("per") ?? "25";
	const response = await getReqServer<{ work: Work; comments: Paginate<Comment> }>(
		`/works/fetch-work/${params.id}?page=${page}&per=${per}`,
		{
			headers: {
				"X-Offprint-Client-IP": getClientAddress()
			}
		}
	);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as { work: Work; comments: Paginate<Comment> };
	}
};
