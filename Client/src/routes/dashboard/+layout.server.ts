import type { LayoutServerLoad } from "./$types";
import { error } from "@sveltejs/kit";
import { postReq } from "$lib/http";
import { Roles } from "../../lib/models/accounts";

export const load: LayoutServerLoad = async ({ cookies }): Promise<void> => {
	if (cookies.get("accessKey")) {
		const response = await postReq<{ goodToGo: boolean }>(`/auth/check-roles`, { needs: [Roles.Admin, Roles.Moderator, Roles.WorkApprover] }, {
			headers: {
				'Authorization': `Bearer ${cookies.get('accessKey')}`
			}
		});
		if ((response as { goodToGo: boolean }).goodToGo === true) {
			return;
		} else {
			throw error(403, { message: "You must have the proper access level to use this feature." });
		}
	} else {
		throw error(403, {
			message: "You must have the proper access level to use this feature."
		});
	}
}