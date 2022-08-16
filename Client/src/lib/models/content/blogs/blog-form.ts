import type { ContentRating } from "../content-rating";

export interface BlogForm {
	readonly title: string;
	readonly desc?: string;
	readonly body: string;
	readonly rating: ContentRating;
}