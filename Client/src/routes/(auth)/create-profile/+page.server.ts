import type { Actions, PageServerLoad } from "./$types";
import { fail, error } from "@sveltejs/kit";
import { BASE_URL, type ResponseError } from "$lib/http";
import type { ProfileForm } from "$lib/models/accounts";


export const load: PageServerLoad = async ({ cookies }) => {
    const token = cookies.get("token");

    if (!token) {
        error(401, "Unauthorized");
    }
}

export const actions = {
    default: async ({ request, fetch, cookies }) => {
        const data = await request.formData();
        const username = data.get("username");

        if (!username || (username!.toString().trim().length < 3 || username!.toString().trim().length > 32)) {
            return fail(400, { message: "Usernames needs to be between 3 and 32 characters long." });
        }

        const formInfo: ProfileForm =  {
            username: username!.toString().trim(),
            links: [],
        }

        console.log(JSON.stringify(formInfo));

        const apiResponse = await fetch(`${BASE_URL}/accounts/profiles/create`, {
            method: "POST",
            body: JSON.stringify(formInfo),
            headers: {
                'Authorization': `Bearer ${cookies.get("token")}`,
                "Content-Type": "application/json"
            }
        });

        if (apiResponse.ok) {
            return { success: true };
        } else {
            const apiError = await apiResponse.json();
            return fail(400, { message: apiError.reason });
        }
    }
} satisfies Actions;