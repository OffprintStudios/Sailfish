<script lang="ts">
	import {
		LoginCircleLine,
		UserAddLine,
		SearchEyeLine,
		Notification2Line,
		RefreshLine
	} from "svelte-remixicon";
	import SearchDropdown from "$lib/ui/nav/SearchDropdown.svelte";
	import Button from "$lib/ui/util/Button.svelte";
	import { account } from "$lib/state/account.state";
	import { getReq, type ResponseError } from "$lib/http";
	import { activity } from "$lib/state/activity.state";
	import CountBadge from "$lib/ui/util/CountBadge.svelte";
	import NavDropdown from "$lib/ui/nav/NavDropdown.svelte";
	import { AccountDropdown } from "$lib/ui/user";

	enum GuideTabs {
		Closed,
		Account,
		Activity,
		Messages,
		History
	}

	let currTab = GuideTabs.Closed;

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
</script>

<div
	class="flex items-center text-white w-full pr-2 pl-1 lg:px-4 h-[50px] lg:h-[60px] fixed top-0 z-[50]"
	style="background: var(--accent); box-shadow: var(--dropshadow);"
>
	<div class="lg:w-1/3 flex items-center flex-1 lg:flex-initial">
		<div class="lg:hidden">
			<NavDropdown />
		</div>
		<h3 class="text-white text-lg lg:text-2xl tracking-wide mr-2">Offprint</h3>
		<button class="update-pill">
			<RefreshLine class="lg:mr-1" />
			<span>New Update</span>
		</button>
	</div>
	<div class="hidden lg:block w-1/3 relative">
		<SearchDropdown />
	</div>
	<div class="hidden lg:w-1/3 lg:flex items-center">
		<div class="flex-1"><!--spacer--></div>
		{#if $account.account}
			<Button kind="primary" disabled={!$account.currProfile}>
				{#if $activity.count > 0}
					<CountBadge value={$activity.count} />
				{/if}
				<Notification2Line class="button-icon no-text" size="22px" />
			</Button>
			<div class="mx-1" />
			<AccountDropdown />
		{:else}
			<Button kind="primary" asLink href="/registration/log-in" title="Log In">
				<LoginCircleLine class="button-icon" />
				<span class="button-text">Log in</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button kind="primary" asLink href="/registration/sign-up" title="Sign Up">
				<UserAddLine class="button-icon" />
				<span class="button-text">Sign up</span>
			</Button>
		{/if}
	</div>
	<div class="lg:hidden flex items-center">
		<Button kind="primary" asLink href="/search" title="Sign Up">
			<SearchEyeLine class="button-icon no-text" size="24px" />
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		{#if $account.account}
			<AccountDropdown />
		{:else}
			<Button kind="primary" asLink href="/registration/log-in" title="Log In">
				<LoginCircleLine class="button-icon no-text" size="24px" />
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button kind="primary" asLink href="/registration/sign-up" title="Sign Up">
				<UserAddLine class="button-icon no-text" size="24px" />
			</Button>
		{/if}
	</div>
</div>

<style lang="scss">
	button.update-pill {
		@apply flex items-center rounded-full p-1 lg:py-[0.075rem] lg:px-2 text-white all-small-caps font-bold tracking-wider transition;
		background: var(--accent-light);
		&:hover {
			background: var(--accent-dark);
		}
		span {
			@apply relative -top-[0.075rem] hidden lg:block;
		}
	}
	button.search-button {
		@apply w-9/12 mx-auto flex items-center justify-center py-2 border-b-2 border-white text-sm rounded-md z-10 transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
		&:hover {
			@apply scale-[1.025];
		}
	}
	a.dropdown-link {
		@apply flex items-center;
		&:hover {
			background: var(--accent) !important;
		}
	}
</style>
