import type { ReportKind } from "./report-kind";

export interface Report {
	readonly id: string;
	readonly reportedBy: { readonly id: string };
	readonly account: { readonly id: string };
	readonly type: ReportKind;
	readonly metadata: {
		readonly itemId?: string;
		readonly reason: string;
		readonly desc?: string;
		readonly link?: string;
	};
	readonly closedOn?: Date;
	readonly createdAt: Date;
}
