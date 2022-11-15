import type { RequestHandler } from "./$types";
import { postReq } from "$lib/http";
import type { TagForm, Tag } from "$lib/models/tags";

export const POST: RequestHandler = async ({ request, cookies }) => {
	const formInfo: TagForm = await request.json();

	const response = await postReq<Tag>(`/tags/create-tag`, formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		}
	});

	if ((response as Tag).id) {
		return new Response(JSON.stringify(response), { status: 200 });
	}

	return new Response(null, { status: 500 });
}