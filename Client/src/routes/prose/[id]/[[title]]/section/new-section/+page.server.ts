import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import { getReq } from "$lib/http";

export const load: PageServerLoad = async ({ params }): Promise<Work> => {
	const workRes = await getReq<Work>(`/works/fetch-work/${params.id}`);

	if ((workRes as Work).id) {
		return workRes as Work;
	} else {
		throw error(404, 'Not Found');
	}
}