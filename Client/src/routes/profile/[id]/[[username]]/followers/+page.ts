import type { PageLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { getReq, type ResponseError } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import { error } from "@sveltejs/kit";

export const load: PageLoad = async ({ parent, url }): Promise<Paginate<Profile>> => {
	const data = (await parent()) as Profile;
	const page = +(url.searchParams.get("page") ?? "1");
	const per = +(url.searchParams.get("per") ?? "21");
	const response = await getReq<Paginate<Profile>>(
		`/followers/fetch-followers/${data.id}?page=${page}&per=${per}`
	);
	if ((response as ResponseError).error) {
		const err = response as ResponseError;
		throw error(err.statusCode, { message: err.message });
	}
	return response as Paginate<Profile>;
};
