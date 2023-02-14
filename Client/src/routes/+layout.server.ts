import type { LayoutServerLoad } from "./$types";
import { postReqServer, type ServerResponseError } from "$lib/server";
import type { RefreshPackage, SessionInfo } from "$lib/models/accounts";

export const load: LayoutServerLoad = async ({ cookies }): Promise<{ token: string | null }> => {
	const accountId = cookies.get("accountId");
	const refreshToken = cookies.get("refreshToken");

	if (accountId && refreshToken) {
		const info: SessionInfo = {
			accountId: accountId,
			refreshToken: refreshToken
		};
		const response = await postReqServer<RefreshPackage>(`/auth/refresh`, info);
		if ((response as ServerResponseError).statusCode) {
			return { token: null };
		} else {
			const result = response as RefreshPackage;
			return { token: result.accessToken };
		}
	} else {
		return { token: null };
	}
};
