import type { RequestHandler } from "./$types";
import type { PaginateResults } from "$lib/util/types";
import type { FavoriteBlog } from "$lib/models/content";
import { getReq } from "$lib/http";

export const GET: RequestHandler = async ({ url, cookies }) => {
	const profileId = url.searchParams.get("profileId");

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	const response = await getReq<PaginateResults<FavoriteBlog>>(
		`/blogs/fetch-favorites?profileId=${profileId}`,
		{
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		}
	);

	if (!(response as PaginateResults<FavoriteBlog>).items) {
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
