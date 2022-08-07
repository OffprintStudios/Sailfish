import { writable } from "svelte/store";
import type { Profile } from "$lib/models/accounts";

export const profileState = writable<Profile>();