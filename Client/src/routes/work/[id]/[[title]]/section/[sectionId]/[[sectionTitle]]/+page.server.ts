import type { PageServerLoad } from "./$types";
import { error } from "@sveltejs/kit";
import type { Work, Section } from "$lib/models/content/works";
import type { Paginate } from "$lib/util/types";
import type { Comment } from "$lib/models/comments";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: PageServerLoad = async ({
	url,
	params
}): Promise<{
	work: Work;
	comments?: Paginate<Comment>;
	section: Section;
	allSections: Section[];
}> => {
	const page = url.searchParams.get("page") ?? "1";
	const per = url.searchParams.get("per") ?? "25";
	const workRes = await getReqServer<{ work: Work; comments?: Paginate<Comment> }>(
		`/works/fetch-work/${params.id}?sectionId=${params.sectionId}&page=${page}&per=${per}`
	);
	const sectionRes = await getReqServer<Section>(
		`/sections/fetch-section/${params.sectionId}?workId=${params.id}`
	);
	const sectionListRes = await getReqServer<Section[]>(
		`/sections/fetch-sections?workId=${params.id}&published=${false}`
	);
	if (
		(workRes as ServerResponseError).statusCode ||
		(sectionRes as ServerResponseError).statusCode ||
		(sectionListRes as ServerResponseError).statusCode
	) {
		throw error(404, "Not Found");
	} else {
		const { work, comments } = workRes as { work: Work; comments?: Paginate<Comment> };
		return {
			work,
			comments,
			section: sectionRes as Section,
			allSections: sectionListRes as Section[]
		};
	}
};
