import type { RequestHandler } from "./$types";
import { postReq } from "$lib/http";
import type { FavoriteBlog } from "$lib/models/content";

export const POST: RequestHandler = async ({ params, url, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const blogId = params.id;

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await postReq<FavoriteBlog>(`/blogs/add-favorite/${blogId}?profileId=${profileId}`, {}, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		if (!(response as FavoriteBlog).id) {
			return new Response(null, { status: 500 });
		} else {
			return new Response(JSON.stringify(response as FavoriteBlog), {
				status: 200,
				headers: {
					'content-type': 'application/json',
				}
			});
		}
	}
}
