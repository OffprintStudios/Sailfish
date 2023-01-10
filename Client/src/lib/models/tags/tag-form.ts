import type { TagKind } from "./tag-kind";

export interface TagForm {
	readonly name: string;
	readonly desc?: string;
	readonly parentId?: string;
	readonly kind: TagKind;
}