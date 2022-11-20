import type { Section } from "./section";

export interface Volume {
	readonly id: string;
	readonly work: { readonly id: string; };
	readonly title: string;
	readonly desc: string;
	readonly sections: Section[];
	readonly coverArt?: string;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}