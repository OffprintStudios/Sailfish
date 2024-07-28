import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import { BASE_URL } from "$lib/http";
import type { Profile } from "$lib/models/accounts";

export const load: PageServerLoad = async ({ cookies }) => {
    const token = cookies.get("token");

    if (!token) {
        error(401, "Unauthorized");
    }

    const apiResponse = await fetch(`${BASE_URL}/accounts/profiles/all`, {
        method: "GET",
        headers: {
            "Authorization": `Bearer ${token}`,
        },
    });

    if (apiResponse.ok) {
        const result: Profile[] = await apiResponse.json();
        return { profiles: result };
    } else {
        error(apiResponse.status, apiResponse.statusText);
    }
}