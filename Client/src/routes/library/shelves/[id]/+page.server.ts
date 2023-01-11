import type { PageServerLoad } from "./$types";
import type { Shelf } from "$lib/models/content/library";
import { error } from "@sveltejs/kit";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: PageServerLoad = async ({ params }): Promise<Shelf> => {
	const response = await getReqServer<Shelf>(`/shelves/fetch-one?shelfId=${params.id}`);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as Shelf;
	}
};
