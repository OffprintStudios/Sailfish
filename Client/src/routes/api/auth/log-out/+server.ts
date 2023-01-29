import type { RequestHandler } from "./$types";
import type { SessionInfo } from "$lib/models/accounts";
import { postReqServer } from "$lib/server";

export const POST: RequestHandler = async ({ cookies, url }) => {
	const accountId = url.searchParams.get("accountId");

	if (!accountId) {
		return new Response(null, { status: 422 });
	}

	if (cookies.get("refreshToken")) {
		const sessionInfo: SessionInfo = {
			accountId: accountId,
			refreshToken: cookies.get("refreshToken") ?? ""
		};

		await postReqServer<void>(`/auth/logout`, sessionInfo);
	}
	cookies.delete("refreshToken", { path: "/" });
	return new Response(null, { status: 200 });
};
