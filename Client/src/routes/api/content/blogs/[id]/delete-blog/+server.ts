import type { RequestHandler } from "./$types";
import type { ResponseError } from "$lib/http";
import { delReq } from "$lib/http";

export const DELETE: RequestHandler = async ({ url, params, cookies }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await delReq<void>(`/blogs/delete-blog/${params.id}?profileId=${profileId}`, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});

		return new Response(null, {
			status: (response as ResponseError).error ? (response as ResponseError).statusCode : 200,
		});
	}
}