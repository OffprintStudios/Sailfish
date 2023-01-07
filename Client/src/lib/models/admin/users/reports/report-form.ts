import type { ReportKind } from "./report-kind";

export interface ReportForm {
	readonly type: ReportKind;
	readonly accountId: string;
	readonly reason: string;
	readonly itemId?: string;
	readonly desc?: string;
	readonly link?: string;
}
