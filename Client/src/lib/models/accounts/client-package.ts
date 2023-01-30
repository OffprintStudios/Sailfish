import type { Account } from "./account";
import type { Profile } from "./profile";

export interface ClientPackage {
	readonly account: Account;
	readonly profiles: Profile[];
	readonly accessToken: string;
	refreshToken: string;
	refreshExpirationTime: number;
}
