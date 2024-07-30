import { BASE_URL } from "$lib/http";
import type { Actions } from "./$types";

export const actions = {
    default: async ({ request, fetch }) => {
        const data = await request.formData();
        const email = data.get("email");

        await fetch(`${BASE_URL}/auth/forgot-password`, {
            method: "PATCH",
            body: JSON.stringify({ email }),
            headers: {
                "Content-Type": "application/json",
            }
        });

        return { message: "If the email you entered belongs to a valid Offprint account, we've sent you an email with instructions on how to reset your password." };
    }
} satisfies Actions;