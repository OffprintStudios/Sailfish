import type { SectionView } from "./section-view";
import type { SectionList } from "./section-list";
import type { ReadingHistory } from "$lib/models/content/library";
import type { Highlight } from "./highlight";
import type { Cheer } from "./cheer";
import type { SectionComment } from "$lib/models/comments";

export interface SectionPage {
	readonly section: SectionView;
	readonly tableOfContents: SectionList[];
	readingHistory?: ReadingHistory;
	highlights: Highlight[];
	cheer?: Cheer;
	readonly topComments: SectionComment[];
	libraryItem?: { hasItem: boolean };
}
