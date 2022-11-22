import type { Category } from "./category";
import type { ContentRating } from "../content-rating";
import type { Status } from "./status";
import type { Kind } from "./kind";

export interface WorkForm {
	readonly title: string;
	readonly shortDesc: string;
	readonly longDesc: string;
	readonly category: Category;
	tags: string[];
	readonly rating: ContentRating;
	readonly status: Status;
	readonly kind: Kind;
}