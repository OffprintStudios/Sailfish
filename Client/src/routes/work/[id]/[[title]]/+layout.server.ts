import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { FetchWorkPage } from "$lib/models/content/works";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: LayoutServerLoad = async ({ params }): Promise<FetchWorkPage> => {
	const response = await getReqServer<FetchWorkPage>(`/reading/fetch-work/${params.id}`);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as FetchWorkPage;
	}
};
