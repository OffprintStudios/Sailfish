import type { LayoutLoad } from "./$types";
import { error } from "@sveltejs/kit";
import { postReq } from "$lib/http";
import { Roles } from "$lib/models/accounts";

export const load: LayoutLoad = async (): Promise<void> => {
	const roleCheck = { needs: [Roles.Admin, Roles.Moderator, Roles.WorkApprover] };
	const response = await postReq<{ goodToGo: boolean }>(`/auth/check-roles`, roleCheck);
	if ((response as { goodToGo: boolean }).goodToGo === true) {
		return;
	} else {
		throw error(403, { message: "You must have the proper access level to use this feature." });
	}
};
