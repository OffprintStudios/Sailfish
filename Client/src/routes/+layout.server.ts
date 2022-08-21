import type { LayoutServerLoad } from "./$types";
import cookie from "cookie";
import type { Typify } from "$lib/util/types";

type LoadOutput = Typify<{ hasKey: boolean }>;

export const load: LayoutServerLoad = async ({ request }): Promise<LoadOutput> => {
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	return { hasKey: !!cookies["accessKey"] };
}