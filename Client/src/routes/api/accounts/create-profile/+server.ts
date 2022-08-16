import type { RequestHandler } from "./$types";
import type { Profile, ProfileForm } from "$lib/models/accounts";
import { postReq } from "$lib/http";
import cookie from "cookie";

export const POST: RequestHandler = async ({ request }) => {
	const formInfo: ProfileForm = await request.json();
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	const response = await postReq<Profile>('/accounts/create-profile', formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies["accessKey"]}`
		}
	});
	if (!(response as Profile).id) {
		console.log(response);
		return new Response(null, { status: 500, statusText: 'Something went wrong!' });
	}

	return new Response(JSON.stringify(response as Profile), { status: 200 });
}