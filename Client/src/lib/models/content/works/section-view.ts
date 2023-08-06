import type { Presence } from "$lib/models/accounts";
import type { Language } from "./language";

export interface SectionView {
	readonly id: string;
	readonly work: {
		readonly id: string;
		readonly title: string;
		readonly desc: string;
		readonly coverArt?: string;
		likes: number;
		dislikes: number;
	};
	readonly volume: {
		readonly id: string;
		readonly title: string;
	};
	readonly author: {
		readonly id: string;
		readonly name: string;
		readonly info: {
			readonly bio?: string;
			readonly tagline?: string;
			readonly presence: Presence;
		};
		readonly avatar: string;
		readonly links: Map<string, string>;
	};
	section: {
		title: string;
		body: string;
		words: number;
		cheers: number;
		comments: number;
		noteTop?: string;
		noteBottom?: string;
		lang: Language;
		rank: number;
		publishedOn?: Date;
		firstPublished?: Date;
		createdAt: Date;
		updatedAt: Date;
		deletedAt?: Date;
	};
}
