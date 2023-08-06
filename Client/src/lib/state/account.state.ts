import { writable } from "svelte/store";
import { browser } from "$app/environment";
import type { Account, Profile } from "../models/accounts";

interface AccountState {
	account: Account | null;
	token: string | null;
	profiles: Profile[];
	currProfile: Profile | null;
}

const defaultAccountState: AccountState = {
	account: null,
	token: null,
	profiles: [],
	currProfile: null
};

const initialAccountState: AccountState = browser
	? JSON.parse(window.localStorage.getItem("account") ?? "null") ?? defaultAccountState
	: defaultAccountState;

export const account = writable<AccountState>(initialAccountState);

account.subscribe((value) => {
	if (browser) {
		window.localStorage.setItem("account", JSON.stringify(value));
	}
});
