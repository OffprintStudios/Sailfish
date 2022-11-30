import type { PageServerLoad } from "./$types";
import { error } from "@sveltejs/kit";
import type { Work, Section } from "$lib/models/content/works";
import { getReq } from "$lib/http";

export const load: PageServerLoad = async ({ params }): Promise<{work: Work, section: Section, allSections: Section[]}> => {
	const workRes = await getReq<Work>(`/works/fetch-work/${params.id}`);
	const sectionRes = await getReq<Section>(`/sections/fetch-section/${params.sectionId}?workId=${params.id}`);
	const sectionListRes = await getReq<Section[]>(`/sections/fetch-sections?workId=${params.id}&published=${false}`)

	if ((workRes as Work).id && (sectionRes as Section).id && (sectionListRes as Section[]).length) {
		return {
			work: workRes as Work,
			section: sectionRes as Section,
			allSections: sectionListRes as Section[],
		};
	} else {
		throw error(404, 'Not Found');
	}
}