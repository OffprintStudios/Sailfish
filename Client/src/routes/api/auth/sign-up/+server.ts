import type { RequestHandler } from "./$types";
import type { ClientPackage } from "$lib/models/accounts";
import type { RegisterForm } from "$lib/models/accounts/forms";
import { postReqServer, type ServerResponseError } from "$lib/server";
import { PUBLIC_ENV } from "$env/static/public";

export const POST: RequestHandler = async ({ request, cookies, getClientAddress }) => {
	const formInfo: RegisterForm = await request.json();
	const userAgent = request.headers.get("User-Agent") ?? "";
	const ipAddress =
		PUBLIC_ENV === "development" ? getClientAddress() : request.headers.get("CF-Connecting-IP");
	const response = await postReqServer<ClientPackage>(`/auth/register`, formInfo, {
		headers: {
			"User-Agent": userAgent,
			"X-Offprint-Client-IP": ipAddress
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
			expires: new Date(Date.now() + data.refreshExpirationTime * 1000)
		});
		data.refreshToken = "";
		data.refreshExpirationTime = 0;
		return new Response(JSON.stringify(data), { status: 200 });
	}
};
