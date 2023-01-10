import type { PageServerLoad } from "./$types";
import { error } from "@sveltejs/kit";
import type { Work, Section } from "$lib/models/content/works";
import { BASE_URL } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import type { Comment } from "$lib/models/comments";

export const load: PageServerLoad = async ({
	url,
	params,
	fetch
}): Promise<{
	work: Work;
	comments?: Paginate<Comment>;
	section: Section;
	allSections: Section[];
}> => {
	const page = url.searchParams.get("page") ?? "1";
	const per = url.searchParams.get("per") ?? "25";
	const workRes = await fetch(
		`${BASE_URL}/works/fetch-work/${params.id}?sectionId=${params.sectionId}&page=${page}&per=${per}`
	);
	const sectionRes = await fetch(
		`${BASE_URL}/sections/fetch-section/${params.sectionId}?workId=${params.id}`
	);
	const sectionListRes = await fetch(
		`${BASE_URL}/sections/fetch-sections?workId=${params.id}&published=${false}`
	);

	if (workRes.status === 200 && sectionRes.status === 200 && sectionListRes.status === 200) {
		const workResults: { work: Work; comments?: Paginate<Comment> } = await workRes.json();
		return {
			work: workResults.work,
			comments: workResults.comments,
			section: await sectionRes.json(),
			allSections: await sectionListRes.json()
		};
	} else {
		throw error(404, "Not Found");
	}
};
