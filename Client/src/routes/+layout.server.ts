import type { LayoutServerLoad } from "./$types";
import { postReqServer, type ServerResponseError } from "$lib/server";
import type { RefreshPackage, SessionInfo } from "$lib/models/accounts";

export const load: LayoutServerLoad = async ({
	cookies,
	url
}): Promise<{ token: string | null; pathname: string }> => {
	const accountId = cookies.get("accountId");
	const refreshToken = cookies.get("refreshToken");
	const { pathname } = url;

	if (accountId && refreshToken) {
		const info: SessionInfo = {
			accountId: accountId,
			refreshToken: refreshToken
		};
		const response = await postReqServer<RefreshPackage>(`/auth/refresh`, info);
		if ((response as ServerResponseError).statusCode) {
			return { token: null, pathname };
		} else {
			const result = response as RefreshPackage;
			return { token: result.accessToken, pathname };
		}
	} else {
		return { token: null, pathname };
	}
};
