import type { Profile } from "../../accounts";
import type { ContentRating } from "../content-rating";

export interface Blog {
	readonly id: string;
	readonly author: Profile;
	title: string;
	desc?: string;
	body: string;
	cover?: string;
	rating: ContentRating;
	stats: {
		words: number;
		views: number;
		comments: number;
	}
	publishedOn?: Date;
	editedOn?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
	readonly deletedAt: Date;
}