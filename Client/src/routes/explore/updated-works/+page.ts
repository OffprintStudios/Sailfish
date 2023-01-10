import type { PageLoad } from "./$types";
import { error } from "@sveltejs/kit";
import { getReq } from "$lib/http";
import { app } from "$lib/state/app.state";
import { get } from "svelte/store";
import type { ResponseError } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import type { Work } from "$lib/models/content/works";

export const load: PageLoad = async ({ url }): Promise<Paginate<Work>> => {
	const page = +(url.searchParams.get("page") ?? "1");
	const per = +(url.searchParams.get("per") ?? "24");
	const response = await getReq<Paginate<Work>>(
		`/explore/updated-works?filter=${get(app).filter}&page=${page}&per=${per}`
	);
	if ((response as ResponseError).error) {
		const errorRes = response as ResponseError;
		throw error(errorRes.statusCode, { message: errorRes.message });
	}
	return response as Paginate<Work>;
};
