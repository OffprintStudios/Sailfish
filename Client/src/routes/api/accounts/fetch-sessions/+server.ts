import type { RequestHandler } from "./$types";
import type { Session } from "$lib/models/accounts";
import { getReq } from "$lib/http";

export const GET: RequestHandler = async ({ cookies }) => {
	const response = await getReq<Session[]>(`/sessions/fetch-sessions`, {
		headers: {
			'Authorization': `Bearer ${cookies.get('accessKey')}`
		}
	});
	if ((response as Session[]).length >= 0) {
		return new Response(JSON.stringify(response), { status: 200 });
	}
	return new Response(null, { status: 500, statusText: 'Something went wrong!' });
}