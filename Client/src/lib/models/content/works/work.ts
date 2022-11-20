import type { Profile } from "../../accounts";
import type { Category } from "./category";
import type { ContentRating } from "../content-rating";
import type { Status } from "./status";
import type { Tag } from "../../tags";
import type { Kind } from "./kind";
import type { ApprovalStatus } from "./approval-status";

export interface Work {
	readonly id: string;
	readonly author: Profile;
	readonly title: string;
	readonly shortDesc: string;
	readonly longDesc: string;
	readonly category: Category;
	readonly rating: ContentRating;
	readonly status: Status;
	readonly tags: Tag[];
	readonly coverArt?: string;
	readonly bannerArt?: string;
	readonly words: number;
	readonly views: number;
	readonly likes: number;
	readonly dislikes: number;
	readonly comments: number;
	readonly kind: Kind;
	readonly approvalStatus: ApprovalStatus;
	readonly publishedOn?: Date;
	readonly lastSectionUpdate?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}