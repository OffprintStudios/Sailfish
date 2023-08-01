export interface Cheer {
	readonly id: string;
	readonly profile: { readonly id: string };
	readonly section: { readonly id: string };
	readonly createdAt: Date;
}
