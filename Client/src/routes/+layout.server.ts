import type { LayoutServerLoad } from "./$types";

export const load: LayoutServerLoad = async ({ cookies }): Promise<{ hasKey: boolean }> => {
	return { hasKey: !!cookies.get("accessKey") };
}