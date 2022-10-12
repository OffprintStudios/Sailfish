import type { RequestHandler } from "./$types";
import type { ResponseError } from "$lib/http";
import { delReq } from "$lib/http";

export const DELETE: RequestHandler = async ({ params, url, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const blogId = params.id;

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const response = await delReq<void>(`/blogs/remove-favorite/${blogId}?profileId=${profileId}`, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		return new Response(null, {
			status: (response as ResponseError).error ? (response as ResponseError).statusCode : 200,
		});
	}
}