/// <reference types="@sveltejs/kit" />

// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
// and what to do when importing types
import type { Account } from "$lib/models/accounts";

declare namespace App {
	interface Locals {
		user: Account;
	}
	// interface Error {}
	// interface PageData {}
	// interface Platform {}
}
