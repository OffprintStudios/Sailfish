import type { PageServerLoad } from "./$types";
import type { Shelf } from "$lib/models/content/library";
import { BASE_URL } from "$lib/http";
import { error } from "@sveltejs/kit";

export const load: PageServerLoad = async ({ params, fetch }): Promise<Shelf> => {
	const response = await fetch(`${BASE_URL}/shelves/fetch-one?shelfId=${params.id}`);
	if (response.status === 200) {
		return await response.json();
	} else {
		const errorMsg: { error: boolean, reason: string } = await response.json();
		throw error(response.status, { message: errorMsg.reason });
	}
}
