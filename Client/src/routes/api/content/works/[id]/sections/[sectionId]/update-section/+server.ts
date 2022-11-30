import type { RequestHandler } from "./$types";
import { patchReq } from "$lib/http";
import type { Section } from "$lib/models/content/works";

export const PATCH: RequestHandler = async ({ params, url, request, cookies }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const formInfo = await request.json();
		const response = await patchReq<Section>(`/sections/update-section/${params.sectionId}?workId=${params.id}&profileId=${profileId}`, formInfo, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		if ((response as Section).id) {
			return new Response(JSON.stringify(response), { status: 200 });
		} else {
			return new Response(null, { status: 500 });
		}
	}
}
