<script lang="ts">
	import { account } from "$lib/state/account.state";
	import { HeartLine, DislikeLine, ImageAddLine, ImageEditLine, Bookmark3Line } from "svelte-remixicon";
	import type { Work } from "$lib/models/content/works";
	import { TagBadge } from "$lib/ui/content";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { TagKind } from "$lib/models/tags";
	import { NavLink } from "$lib/ui/nav";
	import { Button } from "$lib/ui/util";

	export let work: Work;
</script>

<div class="flex flex-col rounded-xl relative bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed mb-6 overflow-hidden">
	{#if work.bannerArt}
		<!--TODO: add banner art container-->
		<div class="w-full h-[150px] relative" style="background: var(--accent);">
			{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
				<div class="absolute top-2 right-2">
					<Button title="Edit Banner" kind="primary">
						<ImageEditLine size="18px" class="button-icon no-text" />
					</Button>
				</div>
			{/if}
		</div>
	{:else}
		<div class="w-full h-[150px] relative" style="background: var(--accent);">
			{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
				<div class="absolute top-2 right-2">
					<Button title="Add Banner" kind="primary">
						<ImageAddLine size="18px" class="button-icon no-text" />
					</Button>
				</div>
			{/if}
		</div>
	{/if}
	<div class="flex items-center p-4">
		{#if work.coverArt}
			<div class="relative self-end w-[150px]">
				<!--TODO: add cover art container-->
				<div class="absolute -bottom-0 flex flex-col items-center justify-center w-[150px] h-[215px] bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl" style="box-shadow: var(--dropshadow);">
					{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
						<NavLink type="button">
							<ImageAddLine class="link-icon" />
							<span class="link-name">Add Cover</span>
						</NavLink>
					{/if}
				</div>
			</div>
		{:else}
			{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
				<div class="relative self-end w-[150px]">
					<div class="absolute -bottom-0 flex flex-col items-center justify-center w-[150px] h-[215px] bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl" style="box-shadow: var(--dropshadow);">
						<NavLink type="button">
							<ImageAddLine class="link-icon" />
							<span class="link-name">Add Cover</span>
						</NavLink>
					</div>
				</div>
			{/if}
		{/if}
		<div class="flex-1 relative" class:pl-4={work.coverArt}>
			<h1 class="text-3xl text-ellipsis" style="color: var(--text-color);">
				{work.title}
			</h1>
			<div class="flex items-center flex-wrap">
				<span class="relative top-0.5 text-xl font-medium text-zinc-400" style="font-family: var(--header-text);">
					by <a class="text-zinc-400" href="/profile/{work.author.id}/{slugify(work.author.username)}">{work.author.username}</a>
				</span>
				<span class="mx-1 text-zinc-400">•</span>
				<TagBadge kind={TagKind.rating} rating={work.rating} />
				<div class="mx-[0.075rem]"></div>
				<TagBadge kind={TagKind.category} category={work.category} />
				<div class="mx-[0.075rem]"></div>
				{#each work.tags as tag}
					<TagBadge tag={tag} kind={tag.kind} />
					<div class="mx-[0.075rem]"></div>
				{/each}
			</div>
		</div>
		<button title="{work.likes} likes" type="button" class="flex items-center p-2 rounded-xl transition">
			<HeartLine class="mr-1" size="24px" />
			<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.likes)}</span>
		</button>
		<div class="mx-0.5"><!--spacer--></div>
		<button title="{work.dislikes} dislikes" type="button" class="flex items-center p-2 rounded-xl transition">
			<DislikeLine class="mr-1" size="24px" />
			<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.dislikes)}</span>
		</button>
		<div class="mx-0.5"><!--spacer--></div>
		<button title="Add to Library" type="button" class="flex items-center p-2 rounded-xl transition">
			<Bookmark3Line size="24px" />
		</button>
	</div>
</div>
