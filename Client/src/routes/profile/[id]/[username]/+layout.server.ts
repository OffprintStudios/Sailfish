import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { getReq } from "$lib/http";
import type { Typify } from "$lib/util/types";

type LoadOutput = Typify<Profile>;

export const load: LayoutServerLoad = async ({ params }): Promise<LoadOutput> => {
	const response = await getReq<Profile>(
		`/profiles/fetch-profile/${params.id}`
	);

	if ((response as Profile).id) {
		return response as Profile;
	}

	throw error(404, 'Not Found');
}