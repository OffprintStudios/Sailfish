import type { Account } from "./account";
import type { Profile } from "./profile";

export interface ClientPackage {
	account: Account;
	profiles: Profile[];
	accessKey: string;
}