import type { RequestHandler } from "./$types";
import type { Paginate } from "$lib/util/types";
import type { FavoriteBlog } from "$lib/models/content";
import { getReq } from "$lib/http";

export const GET: RequestHandler = async ({ url, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const page = url.searchParams.has("page") ? url.searchParams.get("page") : 1;
	const per = url.searchParams.has("per") ? url.searchParams.get("per") : 15;

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	const response = await getReq<Paginate<FavoriteBlog>>(
		`/blogs/fetch-favorites?profileId=${profileId}&page=${page}&per=${per}`,
		{
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		}
	);

	if (!(response as Paginate<FavoriteBlog>).items) {
		return new Response(null, {
			status: 500
		});
	} else {
		return new Response(JSON.stringify(response), {
			status: 200,
			headers: {
				'content-type': 'application/json'
			}
		});
	}
}
