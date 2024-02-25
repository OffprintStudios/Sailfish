import type { ResponseError } from "$lib/http";
import type { Actions } from "./$types";

export const actions = {
    default: async () => {
        const error: ResponseError = {
            statusCode: 501,
            error: "Not Implemented",
            message: "This functionality has not yet been implemented."
        };

        return { error };
    }
} satisfies Actions;
