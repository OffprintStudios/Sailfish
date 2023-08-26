import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import type { Work } from "$lib/models/content/works";
import { getReqServer, type ServerResponseError } from "$lib/server";
import { PUBLIC_ENV } from "$env/static/public";

export const load: PageServerLoad = async ({
	params,
	getClientAddress,
	request
}): Promise<{ work: Work }> => {
	const ipAddress =
		PUBLIC_ENV === "development" ? getClientAddress() : request.headers.get("CF-Connecting-IP");
	const response = await getReqServer<{ work: Work }>(
		`/works/fetch-work/${params.id}`,
		{
			headers: {
				"X-Offprint-Client-IP": ipAddress
			}
		}
	);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as { work: Work };
	}
};
