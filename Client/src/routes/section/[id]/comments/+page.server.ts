import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import { getReqServer, type ServerResponseError } from "$lib/server";
import type { SectionCommentsPage } from "$lib/models/comments";

export const load: PageServerLoad = async ({ params, cookies, url }) => {
	const page = +(url.searchParams.get("page") ?? "1");
	const per = +(url.searchParams.get("per") ?? "25");
	const sectionId = params.id;
	const token = cookies.get("token");
	const currProfile = cookies.get("currProfile");

	const response = await getReqServer<SectionCommentsPage>(
		`/reading/fetch-section-comments/${sectionId}?page=${page}&per=${per}&profileId=${currProfile}`,
		{
			headers: {
				Authorization: token ? `Bearer ${token}` : null
			}
		}
	);

	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return { sectionComments: response as SectionCommentsPage };
	}
};
