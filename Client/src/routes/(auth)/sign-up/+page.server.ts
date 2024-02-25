import type { Actions } from "./$types";
import { BASE_URL, type ResponseError } from "$lib/http";
import { redirect } from "@sveltejs/kit";
import type { RegisterForm } from "$lib/models/accounts";

export const actions = {
    default: async ({ request, fetch }) => {
        const data = await request.formData();
        const email = data.get("email");
        const password = data.get("password");
        const repeatPassword = data.get("repeat-password");
        const ageCheck = data.get("age-check");
        const termsAgree = data.get("terms-agree");

        if ((password !== null || repeatPassword !== null) && (password?.toString() !== repeatPassword?.toString())) {
            const error: ResponseError = {
                statusCode: 422,
                error: "Unprocessable Content",
                message: "The passwords you entered do not match"
            };

            return { error };
        }

        const formInfo: RegisterForm = {
            email: email!.toString(),
            password: password!.toString(),
            ageCheck: !!(ageCheck!),
            termsAgree: !!(termsAgree!),
        };

        const apiResponse = await fetch(`${BASE_URL}/auth/register`, {
            method: "POST",
            body: JSON.stringify(formInfo),
            headers: {
                "Content-Type": "application/json"
            }
        });

        if (apiResponse.ok) {
            redirect(303, "/check-email");
        } else {
            const apiError = await apiResponse.json();
            const error: ResponseError = {
                statusCode: apiResponse.status,
                error: apiResponse.statusText,
                message: apiError.reason,
            };

            return { error };
        }
    }
} satisfies Actions;
