<script lang="ts">
	import { fade, fly } from "svelte/transition";
	import { ChatSmile2Line, Group2Line, HistoryLine, LoginCircleLine, Notification3Line, Settings5Line } from "svelte-remixicon";
	import { closeGuide, guide, GuideTabs, switchTab } from "./guide.state";
	import { account } from "../../state/account.state";
	import { AccountPanel } from "./account";
	import { SettingsPanel } from "./settings";
	import { Avatar } from "../util";

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
			></div>
			<div class="guide" transition:fly|local={{ delay: 0, duration: 200, x: -200 }}>
				<div class="guide-nav">
					<button
						title="History"
						class:disabled={$account.account === null || $account.currProfile === null}
						disabled={$account.account === null || $account.currProfile === null}
					>
						<HistoryLine size={iconSize} />
					</button>
					<button
						title="Activity"
						class:disabled={$account.account === null || $account.currProfile === null}
						disabled={$account.account === null || $account.currProfile === null}
					>
            			<span class="flex items-center">
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
							<Avatar src={$account.currProfile.avatar} borderWidth="1px" size="42px" />
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
					>
            			<span class="flex items-center">
              				<ChatSmile2Line size={iconSize} />
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
						<div in:fly|local={{ delay: 0, duration: 200, x: -200 }}>
							<svelte:component this={$guide.routing[$guide.currPage]}></svelte:component>
						</div>
					{/key}
				{:else}
					<div in:fly|local={{ delay: 0, duration: 200, x: -200 }}>
						<svelte:component this={$guide.routing[$guide.currPage]}></svelte:component>
					</div>
				{/if}
			</div>
		</div>
	{/if}

	<div class="h-full lg:h-screen overflow-y-auto">
		<slot />
	</div>
</div>

<style lang="scss">
	div.guide {
		@apply h-screen z-40 min-w-full max-w-full md:min-w-[24rem] md:max-w-[24rem];
		@apply overflow-hidden overflow-y-auto;
		box-shadow: var(--dropshadow);
		background: var(--background);

		div.guide-nav {
			@apply flex items-center justify-center pt-2 pb-4 sticky top-0 z-10;
			background: linear-gradient(180.2deg, var(--background) 75%, rgba(255,0,0, 0) 100%);
			button {
				@apply flex flex-col items-center justify-center w-[70px] h-[62px] relative first:rounded-l-md last:rounded-r-md;
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