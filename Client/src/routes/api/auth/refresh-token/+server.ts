import type { RequestHandler } from "./$types";
import type { RefreshPackage, SessionInfo } from "$lib/models/accounts";
import { postReqServer, type ServerResponseError } from "$lib/server";

export const POST: RequestHandler = async ({ url, cookies }) => {
	const accountId = url.searchParams.get("accountId");

	if (!accountId) {
		return new Response(null, { status: 422 });
	}

	const info: SessionInfo = {
		accountId: accountId,
		refreshToken: cookies.get("refreshToken") ?? ""
	};

	const response = await postReqServer<RefreshPackage>(`/auth/refresh`, info);
	if ((response as ServerResponseError).statusCode) {
		const error = response as ServerResponseError;
		return new Response(JSON.stringify(error), { status: error.statusCode });
	} else {
		const data = response as RefreshPackage;
		return new Response(JSON.stringify(data), { status: 200 });
	}
};
