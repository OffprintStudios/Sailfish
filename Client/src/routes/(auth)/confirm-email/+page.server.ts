import { BASE_URL } from "$lib/http";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ url, fetch }) => {
    const token = url.searchParams.get("token");

    if (!token) {
        return { missing: true };
    }

    const apiResponse = await fetch(`${BASE_URL}/auth/confirm-email`, {
        method: "PATCH",
        body: JSON.stringify({ token }),
        headers: {
            "Content-Type": "application/json"
        }
    });

    if (apiResponse.ok) {
        return { success: true };
    }

    return { error: true };
}