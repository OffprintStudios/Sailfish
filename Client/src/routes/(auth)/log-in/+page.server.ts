import type { Actions } from "./$types";
import { BASE_URL, type ResponseError } from "$lib/http";
import type { Account } from "$lib/models/accounts";
import { redirect } from "@sveltejs/kit";

export const actions = {
    default: async ({ request, fetch, cookies }) => {
        const data = await request.formData();
        const email = data.get("email");
        const password = data.get("password");

        const authAsBase64 = btoa(`${email?.toString()}:${password?.toString()}`);
        const apiResponse = await fetch(`${BASE_URL}/auth/log-in`, {
            method: "POST",
            headers: {
                "Authorization": `Basic ${authAsBase64}`
            }
        });

        if (apiResponse.ok) {
            const account: Account = await apiResponse.json();
            if (account.emailConfirmed) {
                const expiration = new Date();
                expiration.setDate(expiration.getDate() + 30);
                cookies.delete("token", { path: "/" });
                cookies.set("token", account.token!, {
                    path: "/",
                    httpOnly: true,
                    expires: expiration,
                });
                return { account };
            } else {
                redirect(303, "/check-email");
            }
        } else {
            const error: ResponseError = {
                statusCode: apiResponse.status,
                message: "Nobody 'round here with that email address/password combo, friend",
                error: apiResponse.statusText
            }
            return { error };
        }
    }
} satisfies Actions;
