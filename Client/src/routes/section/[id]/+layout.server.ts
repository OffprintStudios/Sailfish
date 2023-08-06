import { error } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import type { SectionPage } from "$lib/models/content/works";
import { getReqServer, type ServerResponseError } from "$lib/server";
import { PUBLIC_ENV } from "$env/static/public";

export const load: LayoutServerLoad = async ({ params, request, cookies, getClientAddress }) => {
	const token = cookies.get("token");
	const currProfile = cookies.get("currProfile");
	const ipAddress =
		PUBLIC_ENV === "development" ? getClientAddress() : request.headers.get("CF-Connecting-IP");

	const response = await getReqServer<SectionPage>(
		`/reading/fetch-section/${params.id}?profileId=${currProfile}`,
		{
			headers: {
				Authorization: token ? `Bearer ${token}` : null,
				"X-Offprint-Client-IP": ipAddress
			}
		}
	);
	if ((response as ServerResponseError).statusCode) {
		const err = response as ServerResponseError;
		throw error(err.statusCode, { message: err.message });
	} else {
		return response as SectionPage;
	}
};
