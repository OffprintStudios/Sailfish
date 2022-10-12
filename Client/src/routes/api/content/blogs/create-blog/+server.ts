import type { RequestHandler } from "./$types";
import type { Blog, BlogForm } from "$lib/models/content";
import { postReq } from "$lib/http";

export const POST: RequestHandler = async ({ request, cookies, url }) => {
	const profileId = url.searchParams.get('profileId');
	const formInfo: BlogForm = await request.json();

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await postReq<Blog>(`/blogs/create-blog?profileId=${profileId}`, formInfo, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		if (!(response as Blog).id) {
			return new Response(null, { status: 500 });
		} else {
			return new Response(JSON.stringify(response as Blog), {
				status: 200,
				headers: {
					'content-type': 'application/json',
				}
			});
		}
	}
}