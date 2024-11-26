import { BASE_URL } from "$lib/http";
import type { Actions } from "./$types";
import { fail } from "@sveltejs/kit";

export const actions = {
    default: async ({ request, url, fetch }) => {
        const data = await request.formData();
        const newPassword = data.get("new-password");
        const repeatPassword = data.get("repeat-password");
        const token = url.searchParams.get("token");

        if (!token) {
            return fail(422, { message: "Wait a minute, something ain't right!" });
        }

        if ((newPassword !== null || repeatPassword !== null) && (newPassword?.toString() !== repeatPassword?.toString())) {
            return fail(422, { message: "The passwords you entered do not match." });
        }

        const apiResponse = await fetch(`${BASE_URL}/auth/reset-password`, {
            method: "PATCH",
            body: JSON.stringify({ token, newPassword }),
            headers: {
                "Content-Type": "application/json",
            }
        });

        if (apiResponse.ok) {
            return { success: true };
        }

        return fail(500, { message: "Uh-oh. Looks like something went wrong." });
    }
} satisfies Actions;