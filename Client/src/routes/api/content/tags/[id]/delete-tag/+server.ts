import type { RequestHandler } from './$types';
import { delReq } from "$lib/http";
import type { ResponseError } from "$lib/http";

export const DELETE: RequestHandler = async ({ params, cookies }) => {
	const id = params.id;

	const response = await delReq<void>(`/tags/delete-tag/${id}`, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		}
	});

	if ((response as ResponseError).statusCode) {
		return new Response(null, { status: 500 });
	} else {
		return new Response(null, { status: 200 });
	}
}
