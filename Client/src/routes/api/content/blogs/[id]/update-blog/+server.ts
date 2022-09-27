import type { RequestHandler } from "./$types";
import type { Blog, BlogForm } from "$lib/models/content";
import { patchReq } from "$lib/http";
import type { ResponseError } from "$lib/http";

export const PATCH: RequestHandler = async ({ request, cookies, url, params }) => {
	const profileId = url.searchParams.get('profileId');
	const formInfo: BlogForm = await request.json();

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await patchReq<Blog>(`/blogs/update-blog/${params.id}?profileId=${profileId}`, formInfo, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});

		if (!(response as Blog).id) {
			return new Response(JSON.stringify(response as ResponseError), { status: (response as ResponseError).statusCode });
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