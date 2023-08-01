import type { Language } from "./language";

export interface SectionList {
	readonly id: string;
	readonly work: { readonly id: string };
	readonly volume: { readonly id: string };
	readonly volumeTitle: string;
	readonly title: string;
	readonly words: number;
	readonly cheers: number;
	readonly comments: number;
	readonly lang: Language;
	readonly rank: number;
	readonly publishedOn?: Date;
	readonly createdAt: Date;
}
