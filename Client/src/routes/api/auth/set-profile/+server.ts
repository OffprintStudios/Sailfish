import type { RequestHandler } from "./$types";

export const POST: RequestHandler = async ({ url, cookies }) => {
	const profileId = url.searchParams.get("profileId");
	cookies.set("currProfile", profileId ?? "", {
		path: "/",
		httpOnly: true
	});

	return new Response(null, { status: 200 });
};
