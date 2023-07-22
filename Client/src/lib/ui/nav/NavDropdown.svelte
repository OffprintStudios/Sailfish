<script lang="ts">
	import { computePosition, flip, offset, shift, type ShiftOptions } from "@floating-ui/dom";
	import {
		BookmarkFill,
		BookmarkLine,
		CompassDiscoverFill,
		CompassDiscoverLine,
		Dashboard2Fill,
		Dashboard2Line,
		MenuLine,
		NewspaperFill,
		NewspaperLine
	} from "svelte-remixicon";
	import { slide } from "svelte/transition";
	import { clickOutside, hasRoles, throttle } from "$lib/util/functions";
	import Button from "$lib/ui/util/Button.svelte";
	import { account } from "$lib/state/account.state";
	import { Roles } from "$lib/models/accounts";
	import { page } from "$app/stores";
	import { guide } from "$lib/ui/guide";
	import { navigating } from "$app/stores";

	export let open = false;

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	const iconSize = "24px";

	function determineState() {
		open = !open;
	}

	const throttled = throttle(determineState, 150);

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom",
				middleware: [
					offset({ mainAxis: 16 }),
					flip(),
					shift({ padding: 5 } as ShiftOptions)
				]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}
</script>

<div class="relative z-[2]">
	<Button on:click={throttled} bind:thisButton={button} isActive={open} kind="primary">
		<MenuLine class="button-icon no-text" size="24px" />
	</Button>
	{#if open}
		<div
			class="nav-dropdown-items bg-zinc-200 dark:bg-zinc-700"
			transition:slide|local={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			on:click={throttled}
			use:clickOutside
			on:outclick={throttled}
		>
			{#if $account.account && $account.currProfile && hasRoles( $account.account?.roles, [Roles.Admin, Roles.Moderator, Roles.WorkApprover] )}
				<a
					class="dropdown-link"
					class:active={$page.url.pathname.startsWith("/dashboard") &&
						$guide.open === false}
					href="/dashboard"
				>
					<span class="link-icon">
						{#if $page.url.pathname.startsWith("/dashboard") && $guide.open === false}
							<Dashboard2Fill size={iconSize} />
						{:else}
							<Dashboard2Line size={iconSize} />
						{/if}
					</span>
					<span class="link-name">Dash</span>
				</a>
			{/if}
			<a
				class="dropdown-link"
				class:active={($page.url.pathname === "/" ||
					$page.url.pathname.includes("/explore")) &&
					$guide.open === false}
				href="/"
			>
				<span class="link-icon">
					{#if ($page.url.pathname === "/" || $page.url.pathname.includes("/explore")) && $guide.open === false}
						<CompassDiscoverFill size={iconSize} />
					{:else}
						<CompassDiscoverLine size={iconSize} />
					{/if}
				</span>
				<span class="link-name">Explore</span>
			</a>
			<a
				class="dropdown-link"
				class:active={$page.url.pathname.includes("/library") && $guide.open === false}
				href="/library"
			>
				<span class="link-icon">
					{#if $page.url.pathname.includes("/library") && $guide.open === false}
						<BookmarkFill size={iconSize} />
					{:else}
						<BookmarkLine size={iconSize} />
					{/if}
				</span>
				<span class="link-name">Library</span>
			</a>
			<a
				class="dropdown-link"
				class:active={$page.url.pathname === "/feed" && $guide.open === false}
				href="/feed"
			>
				<span class="link-icon">
					{#if $page.url.pathname === "/feed" && $guide.open === false}
						<NewspaperFill size={iconSize} />
					{:else}
						<NewspaperLine size={iconSize} />
					{/if}
				</span>
				<span class="link-name"> Feed </span>
			</a>
		</div>
	{/if}
</div>

<style lang="scss">
	div.nav-dropdown-items {
		@apply absolute rounded-lg z-50 p-1.5 min-w-[12rem] max-w-[12rem] overflow-hidden overflow-y-scroll;
		box-shadow: var(--dropshadow);
		a.dropdown-link {
			@apply w-full flex p-2 items-center no-underline rounded-lg;
			color: var(--text-color);
			font-family: var(--header-text);
			span.link-icon {
				@apply mr-2;
			}
			span.link-name {
				@apply text-lg relative top-0.5;
			}
			&:hover {
				background: var(--accent);
				color: white;
			}
		}
	}
</style>
