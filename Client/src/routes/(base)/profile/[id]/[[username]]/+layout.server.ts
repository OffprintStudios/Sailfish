import type { LayoutServerLoad } from "./$types";
import type { Profile } from "$lib/models/accounts";
import { BASE_URL } from "$lib/http";
import { error } from "@sveltejs/kit";

export const load: LayoutServerLoad = async ({ params }): Promise<Profile> => {
    const response = await fetch(`${BASE_URL}/profiles/${params.id}`, {
        method: "GET",
    });

    if (response.ok) {
        return await response.json();
    } else {
        const err = await response.json();
        throw error(response.status, { message: err.reason });
    }
}
