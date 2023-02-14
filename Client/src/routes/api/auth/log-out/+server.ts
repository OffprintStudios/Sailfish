import type { RequestHandler } from "./$types";
import type { SessionInfo } from "$lib/models/accounts";
import { postReqServer } from "$lib/server";

export const POST: RequestHandler = async ({ cookies }) => {
	const accountId = cookies.get("accountId");
	const refreshToken = cookies.get("refreshToken");
	if (accountId && refreshToken) {
		const sessionInfo: SessionInfo = {
			accountId: accountId,
			refreshToken: refreshToken
		};

		await postReqServer<void>(`/auth/logout`, sessionInfo);
	}
	cookies.delete("accountId", { path: "/" });
	cookies.delete("refreshToken", { path: "/" });
	return new Response(null, { status: 200 });
};
