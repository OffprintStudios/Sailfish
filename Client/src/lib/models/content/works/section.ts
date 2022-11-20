import type { Language } from "./language";

export interface Section {
	readonly id: string;
	readonly work: { readonly id: string; };
	readonly title: string;
	readonly body: string;
	readonly words: number;
	readonly noteTop?: string;
	readonly noteBottom?: string;
	readonly lang: Language;
	readonly rank: number;
	readonly publishedOn?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}