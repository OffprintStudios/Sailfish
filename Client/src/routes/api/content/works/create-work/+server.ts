import type { RequestHandler } from './$types';
import { postReq } from "$lib/http";
import type { Work } from "$lib/models/content/works";

export const POST: RequestHandler = async ({ request, url, cookies }) => {
	const profileId = url.searchParams.get('profileId');
	const formInfo = await request.json();

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	const response = await postReq<Work>(`/works/create-work?profileId=${profileId}`, formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`,
		}
	});

	if ((response as Work).id) {
		return new Response(JSON.stringify(response), { status: 200 });
	} else {
		return new Response(null, { status: 500 });
	}
}