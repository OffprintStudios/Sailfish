import type { PageLoad } from "./$types";
import type { Paginate } from "$lib/util/types";
import type { Work } from "$lib/models/content/works";
import type { Tag } from "$lib/models/tags";
import type { ResponseError } from "$lib/http";
import { getReq } from "$lib/http";
import { error } from "@sveltejs/kit";

export const load: PageLoad = async ({
	params,
	url
}): Promise<{ tag: Tag; works: number; page: Paginate<Work> }> => {
	const page = +(url.searchParams.get("page") ?? "1");
	const per = +(url.searchParams.get("per") ?? "24");
	const tagResponse = await getReq<{ tag: Tag; works: number }>(`/tags/fetch-tag/${params.id}`);
	const worksResponse = await getReq<Paginate<Work>>(
		`/explore/works-by-tag?tagId=${params.id}&page=${page}&per=${per}`
	);
	if ((tagResponse as ResponseError).error) {
		const err = tagResponse as ResponseError;
		throw error(err.statusCode, { message: err.message });
	}
	if ((worksResponse as ResponseError).error) {
		const err = worksResponse as ResponseError;
		throw error(err.statusCode, { message: err.message });
	}
	const tagResult = tagResponse as { tag: Tag; works: number };
	const worksResult = worksResponse as Paginate<Work>;
	return { tag: tagResult.tag, works: tagResult.works, page: worksResult };
};
