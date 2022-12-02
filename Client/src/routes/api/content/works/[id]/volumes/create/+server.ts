import type { RequestHandler } from "./$types";
import type { Volume } from "$lib/models/content/works";
import { postReq } from "$lib/http";

export const POST: RequestHandler = async ({ request, params, cookies, url }) => {
	const profileId = url.searchParams.get('profileId');

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	const formInfo = await request.json();
	const response = await postReq<Volume>(`/volumes/create-volume?workId=${params.id}&profileId=${profileId}`, formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		}
	});

	if ((response as Volume).id) {
		return new Response(JSON.stringify(response), { status: 200 });
	} else {
		return new Response(null, { status: 500 });
	}
}
