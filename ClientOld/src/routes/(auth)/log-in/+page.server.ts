import type { Actions, PageServerLoad } from "./$types";
import { BASE_URL, type ResponseError } from "$lib/http";
import type { Account } from "$lib/models/accounts";
import { redirect, fail } from "@sveltejs/kit";

export const load: PageServerLoad = async ({ cookies }) => {
    const token = cookies.get("token");

    if (token) {
        redirect(303, "/switch-profile");
    }
}

export const actions = {
    default: async ({ request, fetch, cookies }) => {
        const data = await request.formData();
        const email = data.get("email");
        const password = data.get("password");
        const rememberMe = data.get("remember-me");

        const authAsBase64 = btoa(`${email?.toString()}:${password?.toString()}`);
        const apiResponse = await fetch(`${BASE_URL}/auth/log-in`, {
            method: "POST",
            headers: {
                "Authorization": `Basic ${authAsBase64}`,
                "X-Offprint-Remember-Me": rememberMe === "on" ? "long" : "short",
            }
        });

        if (apiResponse.ok) {
            const account: Account = await apiResponse.json();
            const expiration = new Date();
                expiration.setDate(expiration.getDate() + (rememberMe === "on" ? 30 : 1));
                cookies.delete("token", { path: "/" });
                cookies.set("token", account.token!, {
                    path: "/",
                    httpOnly: true,
                    expires: expiration,
                });

            return redirect(303, "/switch-profile");
        } else {
            if (apiResponse.status === 405) {
                return redirect(303, "/check-email");
            } else {
                const apiError = await apiResponse.json();
                return fail(apiResponse.status, { message: apiError.reason });
            }
        }
    }
} satisfies Actions;