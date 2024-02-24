import { Account, Profile } from "$models/accounts";

export interface AuthModel {
    readonly account?: Account;
    readonly token?: string;
    profiles: Profile[];
    currProfile?: Profile;
}
