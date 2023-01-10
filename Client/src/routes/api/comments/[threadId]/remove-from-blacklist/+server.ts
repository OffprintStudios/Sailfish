import type { RequestHandler } from "./$types";
import type { ResponseError } from "$lib/http";
import { delReq } from "$lib/http";

export const POST: RequestHandler = async ({ url, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const blacklistId = url.searchParams.get("blacklistId");
	const accessKey = cookies.get("accessKey");

	if (!profileId && !blacklistId) {
		return new Response(null, { status: 422 });
	}

	return await delReq<void>(`/comments/add-to-blacklist?profileId=${profileId}&blacklistId=${blacklistId}`, {
		headers: {
			'Authorization': `Bearer ${accessKey}`
		}
	}).then(res => {
		if ((res as ResponseError).error) {
			return new Response(null, { status: 500 });
		}
		return new Response(null, { status: 200 });
	}).catch(() => {
		return new Response(null, { status: 500 });
	});
}