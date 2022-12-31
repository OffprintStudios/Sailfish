<script lang="ts">
	import type { Profile, Roles } from "$lib/models/accounts";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { CupLine, EyeLine, QuillPenLine } from "svelte-remixicon";

	export let profile: Profile;
	export let roles: Roles[];
	export let showBanner = true;
	export let showOptions = true;
</script>

<div class="profile-block bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	{#if showBanner}
		<div class="h-[6rem] overflow-hidden w-full relative">
			{#if profile.bannerArt !== null && profile.bannerArt !== undefined}
				<img
					src={profile.bannerArt}
					class="h-full w-full object-cover"
					alt="profile avatar"
				/>
			{:else}
				<div class="h-full w-full absolute" style="background: var(--accent);">
					<!--intentionally left blank-->
				</div>
			{/if}
		</div>
	{/if}
	<div class="py-2 px-4 flex items-center">
		<Avatar src={profile.avatar} borderWidth="1px" size="64px" />
		<div class="ml-2 flex-1">
			<h4 class="text-2xl">
				<a
					class="text-ellipsis overflow-hidden"
					href="/profile/{profile.id}/{slugify(profile.username)}"
				>
					{profile.username}
				</a>
			</h4>
			{#if roles}
				<RoleBadge {roles} size="large" />
			{/if}
		</div>
	</div>
	<div
		class="w-full flex items-center justify-center border-t border-zinc-300 dark:border-zinc-500 mt-0.5"
	>
		<a
			class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
			href="/profile/{profile.id}/{slugify(profile.username)}/works"
		>
			<div class="stat">
				<QuillPenLine size="18.4px" class="mr-1" />
				<span class="select-none">{abbreviate(profile.stats.works)}</span>
			</div>
			<div class="stat-label">Works</div>
		</a>
		<a
			class="stat-box border-l border-r border-zinc-300 dark:border-zinc-500 hover:bg-zinc-300 dark:hover:bg-zinc-600"
			href="/profile/{profile.id}/{slugify(profile.username)}/blogs"
		>
			<div class="stat">
				<CupLine size="18.4px" class="mr-1" />
				<span class="select-none">{abbreviate(profile.stats.blogs)}</span>
			</div>
			<div class="stat-label">Blogs</div>
		</a>
		<a
			class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
			href="/profile/{profile.id}/{slugify(profile.username)}/followers"
		>
			<div class="stat">
				<EyeLine size="18.4px" class="mr-1" />
				<span class="select-none">{abbreviate(profile.stats.followers)}</span>
			</div>
			<div class="stat-label">Follows</div>
		</a>
	</div>
</div>

<style lang="scss">
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
