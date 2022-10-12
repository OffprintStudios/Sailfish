import type { RequestHandler } from "./$types";
import type { FavoriteBlog } from "$lib/models/content";
import { getReq } from "$lib/http";

export const GET: RequestHandler = async ({ url, params, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const blogId = params.id;

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	const response = await getReq<FavoriteBlog>(
		`/blogs/fetch-favorite/${blogId}?profileId=${profileId}`,
		{
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		}
	);

	if (!(response as FavoriteBlog).id) {
		return new Response(null, { status: 200 });
	} else {
		return new Response(JSON.stringify(response as FavoriteBlog), {
			status: 200,
			headers: {
				'content-type': 'application/json'
			}
		})
	}
}
