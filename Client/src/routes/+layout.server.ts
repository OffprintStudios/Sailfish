import type { LayoutServerLoad } from "./$types";

export const load: LayoutServerLoad = async ({ locals }): Promise<{ hasKey: boolean }> => {
	return { hasKey: !!locals.user };
};
