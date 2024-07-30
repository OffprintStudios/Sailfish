import type { Actions } from "./$types";

export const actions = {
    default: async ({ request, fetch }) => {
        const data = await request.formData();
    }
} satisfies Actions;