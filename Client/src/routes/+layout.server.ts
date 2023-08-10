import type { LayoutServerLoad } from "./$types";

export const load: LayoutServerLoad = async ({
	cookies,
	url
}): Promise<{ token: string | null; pathname: string }> => {
	const accountId = cookies.get("accountId");
	const refreshToken = cookies.get("refreshToken");
	const { pathname } = url;

	if (accountId && refreshToken) {
		const token = cookies.get("token") ?? null;
		return { token, pathname };
	} else {
		return { token: null, pathname };
	}
};
