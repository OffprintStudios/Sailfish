<script lang="ts">
	import { page } from "$app/stores";
	import {
		CompassDiscoverFill,
		CompassDiscoverLine,
		BookmarkLine,
		BookmarkFill,
		NewspaperFill,
		NewspaperLine,
		Dashboard2Line,
		Dashboard2Fill
	} from "svelte-remixicon";
	import { guide } from "../guide";
	import { account } from "$lib/state/account.state";
	import { hasRoles } from "$lib/util/functions";
	import { Roles } from "$lib/models/accounts";

	const iconSize = "24px";
</script>

<nav>
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
</nav>

<style lang="scss">
	nav {
		@apply flex flex-col items-center relative w-[55px] lg:w-[75px] z-50 h-[calc(100vh-50px)] lg:h-[calc(100vh-60px)] px-0 py-2 rounded-tr-[-50%];
		background: var(--accent);

		&::before {
			content: "";
			position: absolute;
			background: transparent;
			top: 0;
			right: -50px;
			height: 50px;
			width: 50px;
			border-top-left-radius: 25px;
			box-shadow: -8px -8px 0 0 var(--accent);
		}

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

			&.avatar {
				@apply p-0 lg:p-2 w-[44px] h-[44px] lg:w-[61px] lg:h-[61px];
			}
		}
	}
</style>
