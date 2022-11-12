import type { RequestHandler } from "./$types";
import { getReq } from "$lib/http";
import type { Blog, ApprovalStatus } from "$lib/models/content";
import type { ContentFilter } from "$lib/util/constants";
import type { Paginate } from "$lib/util/types";

export const GET: RequestHandler = async ({ url }) => {
	const authorId = url.searchParams.get("profileId");
	const status: ApprovalStatus = url.searchParams.get("status") as ApprovalStatus;
	const filter: ContentFilter = url.searchParams.get("filter") as ContentFilter;
	const page: number = +(url.searchParams.get("page") ?? 1);
	const per: number = +(url.searchParams.get("per") ?? 10);

	const response = await getReq<Paginate<Blog>>(
		`/blogs/fetch-blogs?authorId=${authorId}&status=${status}&filter=${filter}&page=${page}&per=${per}`
	);

	if (!(response as Paginate<Blog>).metadata) {
		return new Response(null, { status: 500 });
	} else {
		return new Response(JSON.stringify(response as Paginate<Blog>), {
			status: 200,
			headers: {
				'content-type': 'application/json',
			}
		});
	}
}
