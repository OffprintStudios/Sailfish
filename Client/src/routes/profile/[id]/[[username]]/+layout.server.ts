import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { getReqServer, type ServerResponseError } from "$lib/server";

export const load: LayoutServerLoad = async ({ params }): Promise<Profile> => {
	const response = await getReqServer<Profile>(`/profiles/fetch-profile/${params.id}`);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as Profile;
	}
};
