import type { LayoutServerLoad } from "./$types";
import { error } from "@sveltejs/kit";

export const load: LayoutServerLoad = async ({ cookies }): Promise<void> => {
	if (cookies.get("refreshToken")) {
		return;
	} else {
		throw error(403, {
			message: "You must be logged in to use this feature."
		})
	}
}
