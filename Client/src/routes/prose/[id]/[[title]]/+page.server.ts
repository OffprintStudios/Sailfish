import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import { BASE_URL } from "$lib/http";
import type { Paginate } from "$lib/util/types";
import type { Comment } from "$lib/models/comments";

export const load: PageServerLoad = async ({
	url,
	params,
	fetch
}): Promise<{ work: Work; comments: Paginate<Comment> }> => {
	const page = url.searchParams.get("page") ?? "1";
	const per = url.searchParams.get("per") ?? "25";
	const response = await fetch(
		`${BASE_URL}/works/fetch-work/${params.id}?page=${page}&per=${per}`
	);
	if (response.status === 200) {
		return await response.json();
	} else {
		const errorRes: { error: boolean; reason: string } = await response.json();
		throw error(response.status, { message: errorRes.reason });
	}
};
