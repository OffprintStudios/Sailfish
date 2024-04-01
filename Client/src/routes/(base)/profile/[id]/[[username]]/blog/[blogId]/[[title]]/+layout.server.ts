import type { LayoutServerLoad } from "./$types";
import type { Blog } from "$lib/models/blogs";
import { BASE_URL } from "$lib/http";
import { error } from '@sveltejs/kit';

export const load: LayoutServerLoad = async ({ params }): Promise<{blog: Blog}> => {
    const response = await fetch(`${BASE_URL}/blogs/${params.blogId}`, {
        method: "GET",
    });

    if (response.ok) {
        return { blog: await response.json() };
    } else {
        const err = await response.json();
        return error(response.status, { message: err.reason });
    }
}
