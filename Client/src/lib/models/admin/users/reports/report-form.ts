import type { ReportKind } from "./report-kind";
import type { ReportWork, ReportBlog, ReportUser, ReportComment } from "./reasons";

export interface ReportForm {
	readonly type: ReportKind;
	readonly accountId: string;
	readonly itemId?: string;
	readonly desc?: string;
	readonly link?: string;
}

export interface ReportWorkForm extends ReportForm {
	readonly reason: ReportWork;
}

export interface ReportBlogForm extends ReportForm {
	readonly reason: ReportBlog;
}

export interface ReportUserForm extends ReportForm {
	readonly reason: ReportUser;
}

export interface ReportCommentForm extends ReportForm {
	readonly reason: ReportComment;
}
