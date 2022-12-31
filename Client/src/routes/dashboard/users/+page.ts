import type { PageLoad } from "./$types";
import { getReq, postReq } from "$lib/http";
import type { ResponseError } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import { error } from "@sveltejs/kit";
import { Roles } from "$lib/models/accounts";
import type { AccountWithReports } from "$lib/models/accounts";

export const load: PageLoad = async (): Promise<Paginate<AccountWithReports>> => {
	const roleCheck = { needs: [Roles.Admin, Roles.Moderator] };
	const roleResponse = await postReq<{ goodToGo: boolean }>(`/auth/check-roles`, roleCheck);
	if ((roleResponse as { goodToGo: boolean }).goodToGo) {
		const response = await getReq<Paginate<AccountWithReports>>(
			`/admin/fetch-users?page=1&per=24`
		);
		if ((response as ResponseError).error) {
			const err = response as ResponseError;
			throw error(err.statusCode, { message: err.message });
		} else {
			return response as Paginate<AccountWithReports>;
		}
	} else {
		throw error(403, { message: "You must have the proper access level to use this feature." });
	}
};
