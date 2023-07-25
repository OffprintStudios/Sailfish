import { error } from "@sveltejs/kit";
import type { PageLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { getReq, type ResponseError } from "$lib/http";

export const load: PageLoad = async ({ params }): Promise<Profile> => {
	const response = await getReq<Profile>(`/profiles/fetch-profile/${params.id}`);
	if ((response as ResponseError).statusCode) {
		const err = response as ResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as Profile;
	}
};
