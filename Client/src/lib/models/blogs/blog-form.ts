import { ContentRating } from "$lib/models/util";

export interface BlogForm {
    readonly title: string;
    readonly body: string;
    readonly rating: ContentRating;
}
