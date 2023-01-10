import type { PageLoad } from "./$types";
import type { Account } from "$lib/models/accounts";
import type { ResponseError } from "$lib/http";
import { getReq } from "$lib/http";
import { error } from "@sveltejs/kit";

export const load: PageLoad = async ({ params }): Promise<Account> => {
	const response = await getReq<Account>(`/admin/fetch-user/${params.id}`);
	if ((response as ResponseError).error) {
		const err = response as ResponseError;
		throw error(err.statusCode, { message: err.message });
	}
	return response as Account;
};
