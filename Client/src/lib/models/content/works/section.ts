import type { Language } from "./language";
import type { Volume } from "$lib/models/content/works/volume";

export interface Section {
	readonly id: string;
	readonly work: { readonly id: string };
	readonly title: string;
	readonly body: string;
	readonly words: number;
	readonly noteTop?: string;
	readonly noteBottom?: string;
	readonly lang: Language;
	readonly rank: number;
	readonly volume?: Volume;
	readonly publishedOn?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
