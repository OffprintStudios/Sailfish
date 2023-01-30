import type { RequestHandler } from "./$types";
import type { SessionInfo } from "$lib/models/accounts";
import { postReqServer } from "$lib/server";

export const POST: RequestHandler = async ({ cookies, locals }) => {
	if (!locals.user) {
		return new Response(null, { status: 422 });
	}

	if (cookies.get("refreshToken")) {
		const sessionInfo: SessionInfo = {
			accountId: locals.user.id,
			refreshToken: cookies.get("refreshToken") ?? ""
		};

		await postReqServer<void>(`/auth/logout`, sessionInfo);
	}
	cookies.delete("refreshToken", { path: "/" });
	return new Response(null, { status: 200 });
};
