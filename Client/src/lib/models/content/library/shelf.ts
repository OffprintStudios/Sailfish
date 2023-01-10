export interface Shelf {
	readonly id: string;
	readonly profile: { readonly id: string };
	name: string;
	desc?: string;
	coverArt?: string;
	works: number;
	isPublic: boolean;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}