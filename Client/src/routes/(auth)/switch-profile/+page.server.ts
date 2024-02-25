import { BASE_URL, type ResponseError } from "$lib/http";
import type { Profile, ProfileForm } from "$lib/models/accounts";
import type { Actions, PageServerLoad } from "./$types";
import { error } from "@sveltejs/kit";

export const load: PageServerLoad = ({ cookies }) => {
    if (cookies.get("token")) {
        return;
    }

    error(403, "You're not allowed to be here!");
}

export const actions = {
    default: async ({ request, fetch, cookies }) => {
        const data = await request.formData();
        const username = data.get("username");
        const bio = data.get("bio");

        if (!username) {
            const error: ResponseError = {
                statusCode: 422,
                error: "Unprocessable Content",
                message: "Usernames need to be between 3 and 32 characters long.",
            };

            return { error };
        }

        if (username!.toString().length < 3 || username!.toString().length > 32) {
            const error: ResponseError = {
                statusCode: 422,
                error: "Unprocessable Content",
                message: "Usernames need to be between 3 and 32 characters long.",
            };

            return { error };
        }

        if (bio && (bio.toString().length < 3 || bio.toString().length > 120)) {
            const error: ResponseError = {
                statusCode: 422,
                error: "Unprocessable Content",
                message: "Profile bios need to be between 3 and 120 characters long.",
            };

            return { error };
        }

        const formInfo: ProfileForm =  {
            username: username!.toString(),
            bio: bio?.toString(),
            links: []
        }

        const apiResponse = await fetch(`${BASE_URL}/accounts/profiles/create`, {
            method: "POST",
            body: JSON.stringify(formInfo),
            headers: {
                'Authorization': `Bearer ${cookies.get("token")}`
            }
        });

        if (apiResponse.ok) {
            const profile: Profile = await apiResponse.json();
            return { profile };
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
