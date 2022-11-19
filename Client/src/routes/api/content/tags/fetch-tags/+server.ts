import type { RequestHandler } from './$types';
import type { Tag } from "$lib/models/tags";
import { getReq } from "$lib/http";
import type { ResponseError } from "$lib/http";

export const GET: RequestHandler = async ({ url }) => {
	const kind = url.searchParams.get('kind');
	const withCounts = url.searchParams.get('withCounts');
	const ascending = url.searchParams.get('ascending');

	const response = await getReq<{tag: Tag, works: number}[]>(`/tags/fetch-tags?kind=${kind}&withCounts=${!!withCounts}&ascending=${ascending}`);

	if ((response as ResponseError).error) {
		return new Response(null, { status: 500 });
	}
	return new Response(JSON.stringify({ data: response }), { status: 200 });
}