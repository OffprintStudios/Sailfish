import type { RequestHandler } from "./$types";
import { delReq } from "$lib/http";
import type { ResponseError } from "$lib/http";

export const DELETE: RequestHandler = async ({ params, cookies, url }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const workId = params.id;
		const sectionId = params.sectionId;
		const response = await delReq<void>(`/sections/delete-section/${sectionId}?workId=${workId}&profileId=${profileId}`, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		if ((response as ResponseError).error) {
			return new Response(null, { status: 500 });
		} else {
			return new Response(null, { status: 200 });
		}
	}
}
