import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: PageServerLoad = async ({ params }): Promise<Work> => {
	const response = await getReqServer<{ work: Work }>(`/works/fetch-work/${params.id}`);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		const { work } = response as { work: Work };
		return work;
	}
};
