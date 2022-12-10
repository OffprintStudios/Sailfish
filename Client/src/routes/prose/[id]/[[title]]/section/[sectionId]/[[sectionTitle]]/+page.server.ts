import type { PageServerLoad } from "./$types";
import { error } from "@sveltejs/kit";
import type { Work, Section } from "$lib/models/content/works";
import { BASE_URL } from "$lib/http";

export const load: PageServerLoad = async ({ params, fetch }): Promise<{work: Work, section: Section, allSections: Section[]}> => {
	const workRes = await fetch(`${BASE_URL}/works/fetch-work/${params.id}`);
	const sectionRes = await fetch(`${BASE_URL}/sections/fetch-section/${params.sectionId}?workId=${params.id}`);
	const sectionListRes = await fetch(`${BASE_URL}/sections/fetch-sections?workId=${params.id}&published=${false}`)

	if (workRes.status === 200 && sectionRes.status === 200 && sectionListRes.status === 200) {
		return {
			work: await workRes.json(),
			section: await sectionRes.json(),
			allSections: await sectionListRes.json(),
		};
	} else {
		throw error(404, 'Not Found');
	}
}