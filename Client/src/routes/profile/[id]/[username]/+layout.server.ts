import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { BASE_URL } from "$lib/http";

export const load: LayoutServerLoad = async ({ params, fetch }): Promise<Profile> => {
	const response = await fetch(`${BASE_URL}/profiles/fetch-profile/${params.id}`);
	if (response.status === 200) {
		return await response.json();
	} else {
		const errorMsg: { error: boolean, reason: string } = await response.json();
		throw error(response.status, { message: errorMsg.reason });
	}
}