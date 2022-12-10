import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import { BASE_URL } from "$lib/http";

export const load: PageServerLoad = async ({ params, fetch }): Promise<Work> => {
	const response = await fetch(`${BASE_URL}/works/fetch-work/${params.id}`);

	if (response.status === 200) {
		return await response.json();
	} else {
		const errorRes: { error: boolean, reason: string } = await response.json();
		throw error(response.status, { message: errorRes.reason });
	}
}