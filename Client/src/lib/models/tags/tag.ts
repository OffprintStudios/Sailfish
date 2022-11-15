import type { TagKind } from "./tag-kind";

export interface Tag {
	readonly id: string;
	readonly name: string;
	readonly desc: string;
	readonly parent?: Tag;
	readonly children?: Tag[];
	readonly works?: { readonly id: string };
	readonly kind: TagKind;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}