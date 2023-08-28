import type { Review } from "./review";
import type { SectionList } from "./section-list";
import type { Work } from "./work";

export interface FetchWorkPage {
    readonly work: Work;
    readonly tableOfContents: SectionList[];
    readonly topReviews: Review[];
}