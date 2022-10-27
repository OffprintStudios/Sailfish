import type { RequestHandler } from "./$types";
import type { Comment } from "$lib/models/comments";
import { postReq } from "$lib/http";

export const POST: RequestHandler = async ({ url, request, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	const formInfo = await request.json();

	if (!profileId) {
		return new Response(null, { status: 422 });
	}

	return await postReq<Comment>(`/comments/add-comment?profileId=${profileId}`, formInfo, {
		headers: {
			'content-type': 'application/json',
			'Authorization': `Bearer ${cookies.get('accessKey')}`,
		},
	}).then(res => {
		if ((res as Comment).id) {
			return new Response(JSON.stringify(res), { status: 200 });
		} else {
			return new Response(null, { status: 500 });
		}
	}).catch(() => {
		return new Response(null, { status: 500 });
	});
}
