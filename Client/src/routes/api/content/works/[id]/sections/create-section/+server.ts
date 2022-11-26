import type { RequestHandler } from "./$types";
import { postReq } from "$lib/http";
import type { Section } from "$lib/models/content/works";

export const POST: RequestHandler = async ({ params, cookies, request, url }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	} else {
		const formInfo = await request.json();
		const response = await postReq<Section>(`/sections/create-section?profileId=${profileId}&workId=${params.id}`, formInfo, {
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
