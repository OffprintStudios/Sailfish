import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { SectionPage } from "$lib/models/content/works";
import { getReqServer, type ServerResponseError } from "$lib/server";
import { PUBLIC_ENV } from "$env/static/public";

export const load: LayoutServerLoad = async ({ params, request, cookies, getClientAddress }) => {
	const refreshToken = cookies.get("refreshToken");
	const ipAddress =
		PUBLIC_ENV === "development" ? getClientAddress() : request.headers.get("CF-Connecting-IP");
	const response = await getReqServer<SectionPage>(`/reading/fetch-section/${params.id}`, {
		headers: {
			Authorization: `Bearer ${refreshToken}`,
			"X-Offprint-Client-IP": ipAddress
		}
	});
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as SectionPage;
	}
};
