import type { RequestHandler } from "./__types/fetch-profiles";
import type { ResponseError } from "$lib/http";
import { getReq } from "$lib/http";
import type { Profile } from "$lib/models/accounts";
import cookie from "cookie";

type OutputType = Profile[] | ResponseError;

export const GET: RequestHandler<OutputType> = async ({ request }) => {
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	const response = await getReq<Profile[]>('/accounts/fetch-profiles', {
		headers: {
			'Authorization': `Bearer ${cookies["accessKey"]}`
		}
	});

	if ((response as ResponseError).error) {
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
		body: response as Profile[],
		headers: {
			'content-type': 'application/json',
		}
	};
}