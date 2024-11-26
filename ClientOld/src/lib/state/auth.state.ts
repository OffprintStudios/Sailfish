import type { Profile } from "$lib/models/accounts";
import { browser } from "$app/environment";
import { writable } from "svelte/store";

interface AuthState {
    currProfile?: Profile;
}

const defaultAuthState: AuthState = {
    currProfile: undefined,
};

const initialAuthState: AuthState = browser
    ? JSON.parse(window.localStorage.getItem("auth") ?? "null") ?? defaultAuthState
    : defaultAuthState;

export const auth = writable<AuthState>(initialAuthState);

auth.subscribe((value) => {
    if (browser) {
        window.localStorage.setItem('auth', JSON.stringify(value));
    }
});