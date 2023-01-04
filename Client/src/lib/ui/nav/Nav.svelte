<script lang="ts">
	import { page, navigating } from "$app/stores";
	import {
		CompassDiscoverFill,
		CompassDiscoverLine,
		SearchEyeFill,
		SearchEyeLine,
		BookOpenFill,
		Book2Line,
		BookmarkLine,
		BookmarkFill,
		NewspaperFill,
		NewspaperLine,
		Dashboard2Line,
		Dashboard2Fill
	} from "svelte-remixicon";
	import { guide, openGuide, closeGuide } from "../guide";
	import { account } from "$lib/state/account.state";
	import { activity } from "$lib/state/activity.state";
	import { hasRoles } from "$lib/util/functions";
	import { Roles } from "$lib/models/accounts";
	import { getReq, type ResponseError } from "$lib/http";
	import { CountBadge } from "$lib/ui/util";

	const iconSize = "24px";

	$: {
		if ($account.account && $account.currProfile) {
			fetchActivityCount();
		}
	}

	setInterval(async () => {
		if ($account.account && $account.currProfile) {
			await fetchActivityCount();
		}
	}, 1000 * 15);

	async function fetchActivityCount() {
		const response = await getReq<{ count: number }>(
			`/notifications/fetch-count?profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			console.error(`ERROR: ${error.message}`);
		} else {
			$activity.count = (response as { count: number }).count;
		}
	}

	$: {
		if ($navigating !== null) {
			closeGuide();
		}
	}
</script>

<nav>
	{#if $guide.routing.length > 0}
		<button class="link" class:active={$guide.routing.length > 0} on:click={closeGuide}>
			<span class="link-icon"><BookOpenFill size={iconSize} /></span>
			<span class="link-name">Close</span>
		</button>
	{:else}
		<button class="link relative" on:click={openGuide}>
			{#if $activity.count > 0}
				<CountBadge value={$activity.count} />
			{/if}
			<span class="link-icon"><Book2Line size={iconSize} /></span>
			<span class="link-name">Guide</span>
		</button>
	{/if}
	<div
		class="flex-1 lg:flex-initial lg:block lg:w-10/12 lg:mx-auto lg:border-b lg:border-white lg:my-2"
	>
		<!--separator-->
	</div>
	{#if $account.account && $account.currProfile && hasRoles( $account.account?.roles, [Roles.Admin, Roles.Moderator, Roles.WorkApprover] )}
		<a
			class="link"
			class:active={$page.url.pathname.startsWith("/dashboard") && $guide.open === false}
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
		class="link"
		class:active={($page.url.pathname === "/" || $page.url.pathname.includes("/explore")) &&
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
		class="link"
		class:active={$page.url.pathname.startsWith("/search") && $guide.open === false}
		href="/search"
	>
		<span class="link-icon">
			{#if $page.url.pathname === "/search" && $guide.open === false}
				<SearchEyeFill size={iconSize} />
			{:else}
				<SearchEyeLine size={iconSize} />
			{/if}
		</span>
		<span class="link-name">Search</span>
	</a>
	{#if $account.account && $account.currProfile}
		<a
			class="link"
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
			class="link"
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
	{/if}
</nav>

<style lang="scss">
	nav {
		@apply flex lg:flex-col items-center w-full lg:w-[75px] z-50 relative lg:h-full px-2 lg:px-0 pt-1.5 pb-1 lg:py-2;
		background: var(--accent);
		box-shadow: var(--dropshadow);

		a.link,
		button.link {
			@apply p-2 mx-0.5 lg:mx-2 mb-1 border-2 border-transparent rounded-lg transition transform text-white flex flex-col items-center justify-center lg:w-[61px] lg:h-[61px] relative;
			&:hover {
				@apply no-underline;
				box-shadow: var(--dropshadow);
				background: var(--accent-light);
				color: white;
				border-color: white;
			}

			&:active {
				@apply scale-95;
			}

			&.active {
				@apply no-underline shadow-xl;
				background: var(--accent-light);
				color: white;
				border-color: white;
			}

			span.link-name {
				@apply text-[0.6rem] uppercase font-bold tracking-wider hidden lg:block;
			}
		}
	}
</style>
