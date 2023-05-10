<script lang="ts">
	import {
		LoginCircleLine,
		ArrowLeftRightLine,
		UserAddLine,
		QuestionAnswerLine,
		CloseLine,
		Notification2Line,
		HistoryLine
	} from "svelte-remixicon";
	import SearchDropdown from "$lib/ui/nav/SearchDropdown.svelte";
	import { navigating } from "$app/stores";
	import { closeGuide, openGuide, guide } from "$lib/ui/guide";
	import Button from "$lib/ui/util/Button.svelte";
	import { AccountPanel } from "$lib/ui/guide/account";
	import { account } from "$lib/state/account.state";
	import Avatar from "$lib/ui/util/Avatar.svelte";
	import { HistoryPanel } from "$lib/ui/guide/history";
	import { MessagesPanel } from "$lib/ui/guide/messages";
	import { ActivityPanel } from "$lib/ui/guide/activity";
	import type { SvelteComponentTyped } from "svelte";

	$: {
		if ($navigating !== null) {
			closeGuide();
		}
	}

	enum GuideTabs {
		Closed,
		Account,
		Activity,
		Messages,
		History
	}

	let currTab = GuideTabs.Closed;

	function toggleGuide(panel: SvelteComponentTyped, tab: GuideTabs) {
		if (!$guide.open) {
			openGuide(panel);
			currTab = tab;
			return;
		}

		// assumes guide is open
		if (currTab === tab) {
			currTab = GuideTabs.Closed;
			closeGuide();
		} else {
			closeGuide();
			setTimeout(() => openGuide(panel), 250);
			currTab = tab;
		}
	}
</script>

<div
	class="flex items-center text-white w-full px-4 h-[60px] sticky z-[50]"
	style="background: var(--accent); box-shadow: var(--dropshadow);"
>
	<div class="w-1/3 flex items-center">
		<h3 class="text-white text-2xl tracking-wide mr-2">Offprint</h3>
		<div class="hidden lg:block text-white font-bold tracking-widest mb-1">
			[ <span class="relative text-xs">BETA</span> ]
		</div>
	</div>
	<div class="w-1/3 relative">
		<SearchDropdown />
	</div>
	<div class="w-1/3 flex items-center">
		<div class="flex-1"><!--spacer--></div>
		{#if $account.account}
			<Button
				kind="primary"
				disabled={!$account.currProfile}
				isActive={currTab === GuideTabs.History}
				on:click={() => toggleGuide(HistoryPanel, GuideTabs.History)}
			>
				<HistoryLine class="button-icon no-text" size="26px" />
			</Button>
			<div class="mx-1"><!--spacer--></div>
			<Button
				kind="primary"
				disabled={!$account.currProfile}
				isActive={currTab === GuideTabs.Messages}
				on:click={() => toggleGuide(MessagesPanel, GuideTabs.Messages)}
			>
				<QuestionAnswerLine class="button-icon no-text" size="26px" />
			</Button>
			<div class="mx-1"><!--spacer--></div>
			<Button
				kind="primary"
				disabled={!$account.currProfile}
				isActive={currTab === GuideTabs.Activity}
				on:click={() => toggleGuide(ActivityPanel, GuideTabs.Activity)}
			>
				<Notification2Line class="button-icon no-text" size="26px" />
			</Button>
			<div class="mx-1"><!--spacer--></div>
			<Button
				kind="primary"
				on:click={() => toggleGuide(AccountPanel, GuideTabs.Account)}
				isActive={currTab === GuideTabs.Account}
			>
				{#if $account.currProfile}
					<Avatar src={$account.currProfile.avatar} size="36px" borderWidth="1px" />
				{:else}
					<ArrowLeftRightLine class="button-icon no-text -rotate-45" size="36px" />
				{/if}
			</Button>
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
</div>

<style lang="scss">
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
