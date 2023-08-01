import type { HighlightKind } from "$lib/models/content/works/highlight-kind";

export interface Highlight {
	readonly id: string;
	readonly profile: { readonly id: string };
	readonly section: { readonly section: string };
	kind: HighlightKind;
	startIdx: number;
	endIdx: number;
	note?: string;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
