import type { PageLoad } from "./$types";
import { getReq, postReq } from "$lib/http";
import type { ResponseError } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import type { ApprovalQueue } from "$lib/models/admin/approval-queue";
import { error } from "@sveltejs/kit";
import { Roles } from "$lib/models/accounts";

export const load: PageLoad = async (): Promise<Paginate<ApprovalQueue>> => {
	const roleCheck = { needs: [Roles.Admin, Roles.Moderator, Roles.WorkApprover] };
	const roleResponse = await postReq<{ goodToGo: boolean }>(`/auth/check-roles`, roleCheck);
	if ((roleResponse as { goodToGo: boolean }).goodToGo === true) {
		const response = await getReq<Paginate<ApprovalQueue>>(
			`/approval-queue/fetch-all?page=1&per=24`
		);
		if ((response as ResponseError).error) {
			const err = response as ResponseError;
			throw error(err.statusCode, { message: err.message });
		} else {
			return response as Paginate<ApprovalQueue>;
		}
	} else {
		throw error(403, { message: "You must have the proper access level to use this feature." });
	}
};
