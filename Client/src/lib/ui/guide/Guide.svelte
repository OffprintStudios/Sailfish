<script lang="ts">
	import { fade, fly } from "svelte/transition";
	import {
		QuestionAnswerLine,
		Group2Line,
		HistoryLine,
		LoginCircleLine,
		Notification3Line,
		Settings5Line
	} from "svelte-remixicon";
	import { closeGuide, guide, GuideTabs, switchTab } from "./guide.state";
	import { account } from "$lib/state/account.state";
	import { activity } from "$lib/state/activity.state";
	import { AccountPanel } from "./account";
	import { SettingsPanel } from "./settings";
	import { Avatar } from "../util";
	import { HistoryPanel } from "./history";
	import { CountBadge } from "../util";
	import { ActivityTabsPanel } from "./activity";
	import { MessagesPanel } from "./messages";

	const iconSize = "24px";

	function close() {
		if ($guide.canClose) {
			closeGuide();
		}
	}
</script>

<div class="flex-1 relative">
	{#if $guide.open}
		<div class="absolute z-40 top-0 h-full w-full flex">
			<div
				class="absolute z-30 bg-black w-full h-full bg-opacity-50"
				transition:fade|local={{ delay: 0, duration: 100 }}
				on:click={close}
			>
				<!--backdrop-->
			</div>
			<div class="guide" transition:fly|local={{ delay: 0, duration: 200, x: -200 }}>
				<div class="guide-nav">
					<button
						title="History"
						class:active={$guide.currTab === GuideTabs.HistoryTab}
						class:disabled={$account.account === null || $account.currProfile === null}
						disabled={$account.account === null || $account.currProfile === null}
						on:click={() => switchTab(HistoryPanel, GuideTabs.HistoryTab)}
					>
						<HistoryLine size={iconSize} />
					</button>
					<button
						title="Activity"
						class:active={$guide.currTab === GuideTabs.ActivityTab}
						class:disabled={$account.account === null || $account.currProfile === null}
						disabled={$account.account === null || $account.currProfile === null}
						on:click={() => switchTab(ActivityTabsPanel, GuideTabs.ActivityTab)}
					>
						<span class="flex items-center relative">
							{#if $activity.count > 0}
								<span class="absolute -top-1 -right-1">
									<CountBadge value={$activity.count} />
								</span>
							{/if}
							<Notification3Line size={iconSize} />
							<!--<span class="text-sm ml-0.5">0</span>-->
						</span>
					</button>
					{#if $account.account === null && $account.currProfile === null}
						<button
							title="Log In or Sign Up"
							on:click={() => switchTab(AccountPanel, GuideTabs.AccountTab)}
							class:active={$guide.currTab === GuideTabs.AccountTab}
						>
							<LoginCircleLine size={iconSize} />
						</button>
					{:else if $account.account !== null && $account.currProfile !== null}
						<button
							title="Your Info"
							on:click={() => switchTab(AccountPanel, GuideTabs.AccountTab)}
							class:active={$guide.currTab === GuideTabs.AccountTab}
						>
							<Avatar
								src={$account.currProfile.avatar}
								borderWidth="1px"
								size="42px"
							/>
						</button>
					{:else}
						<button
							title="Select Profile"
							on:click={() => switchTab(AccountPanel, GuideTabs.AccountTab)}
							class:active={$guide.currTab === GuideTabs.AccountTab}
						>
							<Group2Line size={iconSize} />
						</button>
					{/if}
					<button
						title="Messages"
						class:disabled={$account.account === null || $account.currProfile === null}
						disabled={$account.account === null || $account.currProfile === null}
						on:click={() => switchTab(MessagesPanel, GuideTabs.MessagesTab)}
						class:active={$guide.currTab === GuideTabs.MessagesTab}
					>
						<span class="flex items-center">
							<QuestionAnswerLine size={iconSize} />
							<!--<span class="text-sm ml-0.5">0</span>-->
						</span>
					</button>
					<button
						title="Settings"
						class:active={$guide.currTab === GuideTabs.SettingsTab}
						on:click={() => switchTab(SettingsPanel, GuideTabs.SettingsTab)}
					>
						<Settings5Line size={iconSize} />
					</button>
				</div>
				{#if $guide.routing.length === 1}
					{#key $guide.currTab}
						<div in:fade|local={{ delay: 0, duration: 200 }}>
							<svelte:component this={$guide.routing[$guide.currPage]} />
						</div>
					{/key}
				{:else}
					<div in:fade|local={{ delay: 0, duration: 200 }}>
						<svelte:component this={$guide.routing[$guide.currPage]} />
					</div>
				{/if}
			</div>
		</div>
	{/if}

	<div class="h-full lg:h-screen lg:overflow-y-auto">
		<slot />
	</div>
</div>

<style lang="scss">
	div.guide {
		@apply h-full lg:h-screen z-40 min-w-full max-w-full lg:min-w-[24rem] lg:max-w-[24rem];
		@apply lg:overflow-hidden lg:overflow-y-auto;
		box-shadow: var(--dropshadow);
		background: var(--background);

		div.guide-nav {
			@apply flex items-center justify-center mb-2 lg:mb-0 lg:pt-2 lg:pb-4 sticky top-0 z-20;
			background: var(--accent);
			@media (min-width: 1024px) {
				background: linear-gradient(
					180.2deg,
					var(--background) 75%,
					rgba(255, 0, 0, 0) 100%
				);
			}
			button {
				@apply relative flex flex-col items-center justify-center w-[60px] h-[62px] lg:w-[70px] lg:h-[62px] relative lg:first:rounded-l-md lg:last:rounded-r-md;
				@apply transition transform text-white border-b-4 border-t-4 border-t-transparent border-b-transparent transition-all;
				background: var(--accent);
				&.active {
					background: var(--accent);
					border-bottom-color: var(--accent-light);
					@apply text-white;
				}
				&.disabled {
					color: var(--accent-dark);
					&:hover {
						color: var(--accent-dark);
						border-bottom-color: transparent;
					}
				}
				&:hover {
					background: var(--accent);
					border-bottom-color: var(--accent-light);
					@apply text-white;
				}
			}
		}
	}
</style>
