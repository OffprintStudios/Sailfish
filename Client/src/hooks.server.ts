import type { Handle } from "@sveltejs/kit";
import { getReqServer, type ServerResponseError } from "$lib/server";
import type { Account } from "$lib/models/accounts";

export const handle: Handle = async ({ event, resolve }) => {
	const { cookies } = event;
	const sessionId = cookies.get("refreshToken");

	// before calling our endpoint
	if (sessionId) {
		const account = await getReqServer<Account>(
			`/auth/get-account-from-session?sessionId=${sessionId}`
		);
		if ((account as ServerResponseError).statusCode) {
			event.locals.user = null;
			cookies.delete("refreshToken");
		} else {
			event.locals.user = account as Account;
		}
	}

	const response = await resolve(event);

	return response;
};
