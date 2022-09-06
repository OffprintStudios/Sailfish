import type { RequestHandler } from "./$types";
import type { Session } from "$lib/models/accounts";
import { getReq } from "$lib/http";
import cookie from "cookie";

export const GET: RequestHandler = async ({ request }) => {
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	const response = await getReq<Session[]>(`/sessions/fetch-sessions`, {
		headers: {
			'Authorization': `Bearer ${cookies["accessKey"]}`
		}
	});
	if ((response as Session[]).length >= 0) {
		return new Response(JSON.stringify(response), { status: 200 });
	}
	return new Response(null, { status: 500, statusText: 'Something went wrong!' });
}