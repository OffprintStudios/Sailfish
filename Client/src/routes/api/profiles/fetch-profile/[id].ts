import type { RequestHandler } from "./__types/[id]";
import type { ResponseError } from "$lib/http";
import type { Profile } from "$lib/models/accounts";
import { getReq } from "$lib/http";

type OutputType = { profile: Profile } | ResponseError

export const GET: RequestHandler<OutputType> = async ({ params }) => {
	const response = await getReq<Profile>(`/profiles/fetch-profile/${params.id}`);

	if ((response as Profile).id) {
		return {
			status: 200,
			headers: {},
			body: { profile: response as Profile }
		}
	} else {
		return {
			status: 404,
			body: response as ResponseError
		}
	}
}