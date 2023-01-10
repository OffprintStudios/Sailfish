import type { RequestHandler } from "./$types";
import type { RefreshPackage, SessionInfo } from "$lib/models/accounts";
import { BASE_URL } from "$lib/http";
import type { ResponseError } from "$lib/http";

export const POST: RequestHandler = async ({ url, cookies, fetch }) => {
	const accountId = url.searchParams.get('accountId');

	if (!accountId) {
		return new Response(null, { status: 422 });
	}

	const info: SessionInfo = {
		accountId: accountId,
		refreshToken: cookies.get('refreshToken') ?? '',
	};

	const response = await fetch(`${BASE_URL}/auth/refresh`, {
		body: JSON.stringify(info),
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		},
	});

	if (response.status === 200) {
		const data: RefreshPackage = await response.json();
		return new Response(JSON.stringify(data), { status: 200 });
	} else {
		const error: { error: boolean, reason: string } = await response.json();
		const errorMsg: ResponseError = {
			statusCode: response.status,
			error: response.statusText,
			message: error.reason,
		};
		return new Response(JSON.stringify(errorMsg), { status: response.status });
	}
}
