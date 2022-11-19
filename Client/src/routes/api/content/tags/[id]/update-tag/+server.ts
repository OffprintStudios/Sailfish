import type { RequestHandler } from './$types';
import { patchReq } from "$lib/http";
import type { Tag, TagForm } from "$lib/models/tags";

export const PATCH: RequestHandler = async ({ params, cookies, request }) => {
	const formInfo: TagForm = await request.json();
	const id = params.id;

	const response = await patchReq<Tag>(`/tags/update-tag/${id}`, formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		}
	});

	if ((response as Tag).id) {
		return new Response(JSON.stringify(response), { status: 200 });
	} else {
		return new Response(null, { status: 500 });
	}
}
