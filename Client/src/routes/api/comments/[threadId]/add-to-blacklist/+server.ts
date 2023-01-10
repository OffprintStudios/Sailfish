import type { RequestHandler } from "./$types";
import type { ThreadBlacklist } from "$lib/models/comments";
import { postReq } from "$lib/http";

export const POST: RequestHandler = async ({ request, url, cookies }) => {
	const formInfo = await request.json();
	const profileId = url.searchParams.get("profileId");
	const accessKey = cookies.get("accessKey");

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	return await postReq<ThreadBlacklist>(`/comments/add-to-blacklist?profileId=${profileId}`, formInfo, {
		headers: {
			'content-type': 'application/json',
			'Authorization': `Bearer ${accessKey}`
		}
	}).then(res => {
		if ((res as ThreadBlacklist).id) {
			return new Response(JSON.stringify(res), { status: 200 });
		} else {
			return new Response(null, { status: 500 });
		}
	}).catch(() => {
		return new Response(null, { status: 500 });
	});
}