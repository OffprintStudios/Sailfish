import type { NewComment } from "./new-comment";

export interface SectionComment extends NewComment {
	readonly section: { readonly id: string };
}
