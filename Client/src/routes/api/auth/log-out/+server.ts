import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async ({ cookies }) => {
	cookies.delete('accessKey');
	return new Response(null, { status: 200 });
}