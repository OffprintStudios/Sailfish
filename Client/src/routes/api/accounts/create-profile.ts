import type { RequestHandler } from "./__types/create-profile";
import type { ResponseError } from "$lib/http";
import type { Profile, ProfileForm } from "$lib/models/accounts";
import { postReq } from "$lib/http";
import cookie from "cookie";

type OutputType = Profile | ResponseError;

export const POST: RequestHandler<OutputType> = async ({ request }) => {
	const formInfo: ProfileForm = await request.json();
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	const response = await postReq<Profile>('/accounts/create-profile', formInfo, {
		headers: {
			'Authorization': `Bearer ${cookies["accessKey"]}`
		}
	});
	if (!(response as Profile).id) {
		console.log(response);
		return {
			status: 500,
			headers: {
				'content-type': 'application/json',
			}
		};
	}
	return {
		status: 200,
		body: response as Profile,
		headers: {
			'content-type': 'application/json',
		}
	};
}