import type { PageLoad } from "./$types";
import type { Tag } from "$lib/models/tags";
import type { ResponseError } from "$lib/http";
import { getReq } from "$lib/http";
import { error } from "@sveltejs/kit";

export const load: PageLoad = async (): Promise<{ data: { tag: Tag; works: number }[] }> => {
	const response = await getReq<{ tag: Tag; works: number }[]>(`/explore/fandoms`);
	if ((response as ResponseError).error) {
		const err = response as ResponseError;
		throw error(err.statusCode, { message: err.message });
	}
	return { data: response as { tag: Tag; works: number }[] };
};
