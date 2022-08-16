<script lang="ts">
	import { account } from "../../../state/account.state";
	import RegistrationPanel from "./RegistrationPanel.svelte";
	import SwitchProfilePanel from "./SwitchProfilePanel.svelte";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import {
		ArrowLeftRightLine,
		ArrowRightSLine,
		BookLine,
		CupLine,
		EyeLine,
		Link,
		LogoutCircleRLine,
		QuillPenLine
	} from "svelte-remixicon";
	import { nextPage } from "../guide.state";
	import { slugify, abbreviate } from "$lib/util/functions";
</script>

{#if $account.account === null}
	<RegistrationPanel />
{:else if $account.currProfile === null}
	<SwitchProfilePanel />
{:else}
	<div class="panel-container">
		<div class="content-container">
			<div class="panel-section">
				<div class="profile-block bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
					<div class="max-h-[6rem] min-h-[6rem] overflow-hidden w-full relative">
						{#if $account.currProfile.info.coverPic !== null && $account.currProfile.info.coverPic !== undefined}
							<img src={$account.currProfile.info.coverPic} class="h-full w-full object-cover" alt="profile avatar" />
						{:else}
							<div class="h-full w-full absolute" style="background: var(--accent);"></div>
						{/if}
					</div>
					<div class="py-2 px-4 flex items-center">
						<Avatar src={$account.currProfile.avatar} borderWidth="1px" size="64px" />
						<div class="ml-2 flex-1">
							<h4 class="text-2xl">
								<a class="text-ellipsis overflow-hidden" href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}">
									{$account.currProfile.username}
								</a>
							</h4>
							<RoleBadge roles={$account.account.roles} size="large" />
						</div>
					</div>
					<div class="w-full flex items-center justify-center border-t border-zinc-300 dark:border-zinc-500 mt-0.5">
						<a
							class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/works"
						>
							<div class="stat">
								<QuillPenLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.works)}</span>
							</div>
							<div class="stat-label">Works</div>
						</a>
						<a
							class="stat-box border-l border-r border-zinc-300 dark:border-zinc-500 hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/blogs"
						>
							<div class="stat">
								<CupLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.blogs)}</span>
							</div>
							<div class="stat-label">Blogs</div>
						</a>
						<a
							class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/following"
						>
							<div class="stat">
								<EyeLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.followers)}</span>
							</div>
							<div class="stat-label">Follows</div>
						</a>
					</div>
				</div>
			</div>

			<div class="panel-section">
				<a href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/works" class="nav-button">
					<BookLine size="24px" />
					<span>Create Prose</span>
					<Link class="text-zinc-400" />
				</a>
				<a href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/works" class="nav-button">
					<QuillPenLine size="24px" />
					<span>Create Poetry</span>
					<Link class="text-zinc-400" />
				</a>
				<a href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/blogs" class="nav-button">
					<CupLine size="24px" />
					<span>Create Blog</span>
					<Link class="text-zinc-400" />
				</a>
			</div>

			<div class="panel-section">
				<button class="nav-button" on:click={() => nextPage(SwitchProfilePanel)}>
					<ArrowLeftRightLine size="24px" />
					<span>Switch profile</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
				<button class="nav-button">
					<LogoutCircleRLine size="24px" />
					<span>Log out</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
			</div>
		</div>
	</div>
{/if}

<style lang="scss">
	@use '../Guide';

	div.profile-block {
		@apply flex flex-col overflow-hidden rounded-md;
	}

	a.stat-box {
		@apply block cursor-pointer flex flex-col items-center select-none no-underline p-4 w-1/3 transition transform;
		color: var(--text-color);
		div.stat {
			@apply flex items-center;
		}
		div.stat-label {
			@apply text-xs uppercase font-bold tracking-wider;
		}
	}
</style>