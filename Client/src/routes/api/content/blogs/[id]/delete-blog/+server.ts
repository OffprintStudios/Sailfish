import type { RequestHandler } from "./$types";
import cookie from "cookie";
import type { ResponseError } from "$lib/http";
import { delReq } from "$lib/http";

export const DELETE: RequestHandler = async ({ request, url, params }) => {
	const profileId = url.searchParams.get('profileId');
	const cookies = cookie.parse(request.headers.get('cookie') ?? '');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await delReq<void>(`/blogs/delete-blog/${params.id}?profileId=${profileId}`, {
			headers: {
				'Authorization': `Bearer ${cookies["accessKey"]}`
			}
		});

		return new Response(null, {
			status: (response as ResponseError).error ? 500 : 200,
		});
	}
}