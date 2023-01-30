import type { RequestHandler } from "./$types";
import type { ClientPackage } from "$lib/models/accounts";
import type { LoginForm } from "$lib/models/accounts/forms";
import type { ServerResponseError } from "$lib/server";
import { postReqServer } from "$lib/server";

export const POST: RequestHandler = async ({ request, cookies, getClientAddress }) => {
	const formInfo: LoginForm = await request.json();
	const userAgent = request.headers.get("User-Agent") ?? "";
	const response = await postReqServer<ClientPackage>(`/auth/login`, formInfo, {
		headers: {
			"User-Agent": userAgent,
			"X-Offprint-Client-IP": getClientAddress()
		}
	});
	if ((response as ServerResponseError).statusCode) {
		const error = response as ServerResponseError;
		return new Response(JSON.stringify(error), { status: error.statusCode });
	} else {
		const data = response as ClientPackage;
		const expirationDate = new Date(Date.now() + data.refreshExpirationTime * 1000);
		cookies.set("refreshToken", data.refreshToken, {
			path: "/",
			httpOnly: true,
			expires: expirationDate
		});
		data.refreshToken = "";
		data.refreshExpirationTime = 0;
		return new Response(JSON.stringify(data), { status: 200 });
	}
};
