import type { Roles } from "./roles";

export interface Account {
	readonly id: string;
	roles: Roles[];
	termsAgree: boolean;
	emailConfirmed: boolean;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}