import type { RequestHandler } from "./$types";
import type { ResponseError } from "$lib/http";
import type { Blog } from "$lib/models/content";
import { patchReq } from "$lib/http";

export const POST: RequestHandler = async ({ url, request, params, cookies }) => {
	const profileId = url.searchParams.get('profileId');
	const data = await request.formData();

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	return await patchReq<Blog>(`/blogs/update-cover/${params.id}`, data, {
		headers: {
			'content-type': 'multipart/form-data',
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		},
		timeout: 1000 * 60 * 2,
	}).then(res => {
		if (!(res as Blog).id) {
			return new Response(null, { status: (res as ResponseError).statusCode, statusText: (res as ResponseError).message });
		} else {
			return new Response(JSON.stringify(res), { status: 200 });
		}
	});
}