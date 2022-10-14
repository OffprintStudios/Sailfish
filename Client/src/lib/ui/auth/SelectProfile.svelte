<script lang="ts">
	import { account } from "../../state/account.state";
	import { Avatar } from "../util";
	import type { Profile } from "../../models/accounts";
	import { closePopup } from "../popup";

	function selectProfile(profile: Profile) {
		$account.currProfile = profile;
		closePopup();
	}
</script>

<div class="lg:w-[470px] px-4 py-5">
	{#each $account.profiles as profile}
		<button
			class="profile-box bg-zinc-300 dark:bg-zinc-600 dark:highlight-shadowed"
			on:click={() => selectProfile(profile)}
		>
			<Avatar src={profile.avatar} size="64px" />
			<span class="user-info-container">
				<span class="username">{profile.username}</span>
			</span>
		</button>
	{:else}
		<div class="empty">
			<h3>No profiles available</h3>
			<p>Head over to the Add New tab to start adding a profile!</p>
		</div>
	{/each}
</div>

<style lang="scss">
	button.profile-box {
		@apply relative w-full rounded-xl flex items-center p-2 transition transform cursor-pointer select-none mb-4 last:mb-0;
		&:hover {
			background: var(--accent);

			span.user-info-container {
				span.username {
					@apply text-white;
				}
			}
		}

		&:active {
			@apply scale-95;
		}

		span.user-info-container {
			@apply ml-2;
			span.username {
				@apply text-2xl font-medium;
				color: var(--accent);
				font-family: var(--header-text);
			}
		}
	}
</style>