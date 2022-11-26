import type { RequestHandler } from "./$types";
import { patchReq } from "$lib/http";
import type { Section } from "$lib/models/content/works";

export const PATCH: RequestHandler = async ({ params, url, cookies }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const workId = params.id;
		const sectionId = params.sectionId;

		const response = await patchReq<Section>(`/sections/publish-section/${sectionId}?workId=${workId}&profileId=${profileId}`, {}, {
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
