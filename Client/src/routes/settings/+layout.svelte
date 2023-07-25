<script>
	import {
		Settings5Line,
		Settings6Line,
		AccountCircleLine,
		InformationLine,
		GroupLine,
		HandHeartLine
	} from "svelte-remixicon";
	import { page } from "$app/stores";
	import { account } from "$lib/state/account.state";
	import { cubicIn, cubicOut } from "svelte/easing";
	import { fly } from "svelte/transition";

	export let data;
	const iconSize = "24px";
	$: basePathname = data.pathname;
</script>

<svelte:head>
	<title>Settings &mdash; Offprint</title>
</svelte:head>

<div
	class="lg:flex lg:flex-col lg:items-center mb-6 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed overflow-hidden"
>
	<div
		class="flex items-center justify-center px-4 py-4 lg:py-6 w-full"
		style="background: var(--accent-dark)"
	>
		<Settings5Line class="mr-2 text-white w-[36px] h-[36px]" />
		<h1 class="text-white text-3xl lg:text-4xl relative top-1">Settings</h1>
	</div>
	<div class="flex items-center overflow-x-auto whitespace-nowrap p-2">
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname === "/settings"}
			href="/settings"
		>
			<Settings6Line class="mr-1" size={iconSize} />
			<span>General</span>
		</a>
		{#if $account.account}
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/settings/account")}
				href="/settings/account"
			>
				<AccountCircleLine class="mr-1" size={iconSize} />
				<span>Your Account</span>
			</a>
		{/if}
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/settings/accessibility")}
			href="/settings/accessibility"
		>
			<HandHeartLine class="mr-1" size={iconSize} />
			<span>Accessibility</span>
		</a>
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/settings/about")}
			href="/settings/about"
		>
			<InformationLine class="mr-1" size={iconSize} />
			<span>Docs & Policies</span>
		</a>
	</div>
</div>

{#key basePathname}
	<div
		in:fly={{ easing: cubicOut, x: 10, delay: 400, duration: 300 }}
		out:fly={{ easing: cubicIn, x: -10, duration: 300 }}
	>
		<slot />
	</div>
{/key}

<style lang="scss">
	a.feature-link {
		@apply flex text-base lg:text-lg items-center p-3 rounded-lg no-underline mr-0.5 last:mr-0 transition transform;
		color: var(--text-color);
		font-family: var(--header-text);
		span {
			@apply relative top-0.5;
		}
		&.active {
			@apply text-white;
			background: var(--accent);
		}
	}
</style>
