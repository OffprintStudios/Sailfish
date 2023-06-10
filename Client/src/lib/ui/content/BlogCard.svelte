<script lang="ts">
	import { LineChartLine, PenNibLine, StarLine, More2Fill, DiscussLine } from "svelte-remixicon";
	import { account } from "$lib/state/account.state";
	import type { Blog } from "$lib/models/content";
	import { Time, Avatar } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { Dropdown } from "$lib/ui/dropdown";
	import { abbreviate } from "$lib/util/functions/index.js";

	export let blog: Blog;
	export let showAvatar = false;
	export let hasDropdown = true;
	export let bigPreview = false;
	export let showPreview = true;
</script>

<div
	class="blog-card bg-zinc-200 dark:bg-zinc-700 hover:bg-zinc-300 hover:dark:bg-zinc-600"
	title={blog.title}
>
	<a
		class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
		href="/profile/{blog.author.id}/{slugify(blog.author.username)}/blog/{blog.id}/{slugify(
			blog.title
		)}"
		data-sveltekit-preload-data
	>
		<!--nothing goes here-->
	</a>
	<div class="blog-header">
		{#if showAvatar}
			<Avatar src={blog.author.avatar} size="50px" borderWidth="1px" />
		{/if}
		<div class="flex-1 w-[275px]" class:ml-4={showAvatar}>
			<h3 class="text-white font-medium text-2xl truncate">
				{blog.title}
			</h3>
			<span class="flex items-center text-white text-xs">
				<Time timestamp={blog.createdAt} />
			</span>
		</div>
		{#if $account.account && $account.currProfile && hasDropdown}
			<Dropdown kind="primary">
				<svelte:fragment slot="button">
					<More2Fill size="18px" class="button-icon no-text text-white" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					<slot name="dropdown" />
				</svelte:fragment>
			</Dropdown>
		{/if}
	</div>
	{#if showPreview}
		<div
			class="hidden blog-preview blog-body"
			class:small-preview={!bigPreview}
			class:big-preview={bigPreview}
		>
			{@html blog.body}
		</div>
	{/if}
	<div class="blog-stats bg-zinc-300 dark:bg-zinc-600">
		<div class="flex-1"><!--spacer--></div>
		<span class="flex items-center relative z-[2]" title="Views">
			<LineChartLine size="16px" class="mr-1" />
			{abbreviate(blog.stats.views)}
		</span>
		<span class="mx-1">•</span>
		<span class="flex items-center relative z-[2]" title="Faves">
			<StarLine size="16px" class="mr-1" />
			{abbreviate(blog.stats.favorites)}
		</span>
		<span class="mx-1">•</span>
		<span class="flex items-center relative z-[2]" title="Comments">
			<DiscussLine size="16px" class="mr-1" />
			{abbreviate(blog.stats.comments)}
		</span>
		<span class="mx-1">•</span>
		<span class="flex items-center relative z-[2]" title="Words">
			<PenNibLine size="16px" class="mr-1" />
			{abbreviate(blog.stats.words)}
		</span>
	</div>
</div>

<style lang="scss">
	div.blog-card {
		@apply block rounded-xl overflow-hidden no-underline transition relative;
		color: var(--text-color);
		div.blog-header {
			@apply flex items-center px-4 py-3.5;
			background: var(--accent);
		}
		div.blog-preview {
			@apply px-6;
			&.small-preview {
				@apply max-h-[14rem] line-clamp-[8];
			}
			&.big-preview {
				@apply max-h-[24rem] line-clamp-[16];
			}
		}
		div.blog-stats {
			@apply flex items-center rounded-xl mx-2 my-2.5 px-2 py-1;
		}
	}
</style>
