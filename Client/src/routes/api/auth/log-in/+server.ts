import type { RequestHandler } from "./$types";
import type { ClientPackage } from "$lib/models/accounts";
import type { LoginForm } from "$lib/models/accounts/forms";
import type { ServerResponseError } from "$lib/server";
import { postReqServer } from "$lib/server";

export const POST: RequestHandler = async ({ request, cookies }) => {
	const formInfo: LoginForm = await request.json();
	const userAgent = request.headers.get("User-Agent") ?? "";
	const response = await postReqServer<ClientPackage>(`/auth/login`, formInfo, {
		headers: {
			"User-Agent": userAgent
		}
	});
	if ((response as ServerResponseError).statusCode) {
		const error = response as ServerResponseError;
		return new Response(JSON.stringify(error), { status: error.statusCode });
	} else {
		const data = response as ClientPackage;
		cookies.set("refreshToken", data.refreshToken, {
			path: "/",
			httpOnly: true,
			expires: new Date(Date.now() + 2592000)
		});
		data.refreshToken = "";
		return new Response(JSON.stringify(data), { status: 200 });
	}
};
