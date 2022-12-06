import type { RequestHandler } from "./$types";
import type { SessionInfo } from "$lib/models/accounts";
import { BASE_URL } from "$lib/http";

export const POST: RequestHandler = async ({ cookies, url }) => {
	const accountId = url.searchParams.get('accountId');

	if (!accountId) {
		return new Response(null, { status: 422 });
	}

	if (cookies.get('refreshToken')) {
		const sessionInfo: SessionInfo = {
			accountId: accountId,
			refreshToken: cookies.get('refreshToken') ?? '',
		}
		await fetch(`${BASE_URL}/auth/logout`, {
			body: JSON.stringify(sessionInfo),
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
			},
		});
	}
	cookies.delete('refreshToken');
	return new Response(null, { status: 200 });
}