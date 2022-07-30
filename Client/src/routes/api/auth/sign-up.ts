import type { RequestHandler } from "./__types/sign-up";
import type { ResponseError } from "$lib/http";
import { postReq } from "$lib/http";
import type { Account, ClientPackage } from "$lib/models/accounts";
import type { LoginForm } from "$lib/models/accounts/forms";
import cookie from "cookie";

type OutputType = Account | ResponseError;

export const POST: RequestHandler<OutputType> = async ({ request }) => {
	const formInfo: LoginForm = await request.json();
	const response = await postReq<ClientPackage>('/auth/register', formInfo);

	if (!(response as ClientPackage).token) {
		return {
			status: 422,
			body: response as ResponseError,
			headers: {
				'content-type': 'application/json',
			}
		};
	} else if (response === undefined) {
		return {
			status: 500
		}
	} else {
		return {
			status: 200,
			body: (response as ClientPackage).account,
			headers: {
				'content-type': 'application/json',
				'set-cookie': [
					cookie.serialize(
						'accessKey',
						(response as ClientPackage).token,
						{
							path: '/',
							httpOnly: true,
							expires: new Date(Date.now() + 2592000)
						}
					)
				]
			}
		};
	}
}