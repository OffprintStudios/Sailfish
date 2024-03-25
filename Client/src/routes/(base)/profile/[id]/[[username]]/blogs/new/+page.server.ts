import type { Actions } from "./$types";
import { BASE_URL, type ResponseError } from "$lib/http";
import type { BlogForm } from "$lib/models/blogs";
import { ContentRating } from "$lib/models/util";
import { redirect } from "@sveltejs/kit";

export const actions = {
    default: async ({ request, fetch, cookies }) => {
        const data = await request.formData();
        const token = cookies.get("token");

        if (!token) {
            const error: ResponseError = {
                statusCode: 401,
                error: "Unauthorized",
                message: "You don't have permission to do that"
            };

            console.log(error);

            return { error };
        }

        const blogForm: BlogForm = {
            title: data.get("title")!.toString(),
            body: data.get("body")!.toString(),
            rating: data.get("rating")!.toString() as ContentRating,
        };

        const apiResponse = await fetch(`${BASE_URL}/blogs/create?profileId=${data.get("profileId")!.toString()}`, {
            method: "POST",
            body: JSON.stringify(blogForm),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        });

        if (apiResponse.ok) {
            redirect(303, data.get("redirectUrl")!.toString());
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
