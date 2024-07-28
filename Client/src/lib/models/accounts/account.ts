import type { Roles } from "./roles";

export interface Account {
    readonly id: string;
    readonly roles: [Roles];
    readonly termsAgree: boolean;
    readonly emailConfirmed: boolean;
    readonly createdAt: Date;
    readonly updatedAt: Date;
    readonly token?: string;
}