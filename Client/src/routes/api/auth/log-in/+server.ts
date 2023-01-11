import type { RequestHandler } from "./$types";
import type { ResponseError } from "$lib/http";
import type { ClientPackage } from "$lib/models/accounts";
import type { LoginForm } from "$lib/models/accounts/forms";
import { BASE_URL } from "$lib/http";


// this better fucking work
export const POST: RequestHandler = async ({ request, cookies, fetch }) => {
	const formInfo: LoginForm = await request.json();
	const userAgent = request.headers.get("User-Agent") ?? "";
	const response = await fetch(`${BASE_URL}/auth/login`, {
		body: JSON.stringify(formInfo),
		method: "POST",
		headers: {
			"User-Agent": userAgent,
			"Content-Type": "application/json"
		}
	});

	if (response.status === 200) {
		const data: ClientPackage = await response.json();
		cookies.set("refreshToken", data.refreshToken, {
			path: "/",
			httpOnly: true,
			expires: new Date(Date.now() + 2592000)
		});
		data.refreshToken = "";
		return new Response(JSON.stringify(data), { status: 200 });
	} else {
		const error: { error: boolean; reason: string } = await response.json();
		const errorMsg: ResponseError = {
			statusCode: response.status,
			error: response.statusText,
			message: error.reason
		};
		return new Response(JSON.stringify(errorMsg), { status: response.status });
	}
};
