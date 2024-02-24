import { writable } from "svelte/store";
import { browser } from "$app/environment";
import type { Account, Profile } from "$lib/models/accounts";

interface AuthState {
    account?: Account;
    token?: string;
    profiles?: Profile[];
    currProfile?: Profile;
}

const defaultAuthState: AuthState = {
    account: undefined,
    token: undefined,
    profiles: undefined,
    currProfile: undefined,
}

const initialAuthState: AuthState = browser
    ? JSON.parse(window.localStorage.getItem("auth") ?? "null") ?? defaultAuthState
    : defaultAuthState;

export const auth = writable<AuthState>(initialAuthState);

auth.subscribe((value) => {
    if (browser) {
        window.localStorage.setItem('auth', JSON.stringify(value));
    }
});
