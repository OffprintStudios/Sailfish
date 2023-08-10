import type { Handle } from "@sveltejs/kit";
import type { RefreshPackage, SessionInfo } from "$lib/models/accounts";
import { postReqServer, type ServerResponseError } from "$lib/server";

export const handle: Handle = async ({ event, resolve }) => {
	const accountId = event.cookies.get("accountId");
	const refreshToken = event.cookies.get("refreshToken");

	if (accountId && refreshToken) {
		const info: SessionInfo = {
			accountId: event.cookies.get("accountId") ?? "",
			refreshToken: event.cookies.get("refreshToken") ?? ""
		};
		const response = await postReqServer<RefreshPackage>(`/auth/refresh`, info);
		if ((response as ServerResponseError).statusCode) {
			event.cookies.delete("token");
		} else {
			const result = response as RefreshPackage;
			event.cookies.delete("token");
			event.cookies.set("token", result.accessToken, {
				path: "/",
				httpOnly: true
			});
		}
	}

	return resolve(event);
};
