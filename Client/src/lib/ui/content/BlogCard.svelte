<script lang="ts">
	import { TimeLine, LineChartLine, PenNibLine, StarLine, More2Fill, AlarmWarningLine, Edit2Line, DeleteBin2Line, ShareBoxLine } from "svelte-remixicon";
	import { account } from "$lib/state/account.state";
	import type { Blog } from "$lib/models/content";
	import { Time, Avatar } from "$lib/ui/util";
	import { pluralize, slugify } from "../../util/functions";
	import { Dropdown } from "$lib/ui/dropdown";

	export let blog: Blog;
	export let showAvatar = false;
</script>

<div class="blog-card bg-zinc-200 dark:bg-zinc-700 hover:bg-zinc-300 hover:dark:bg-zinc-600" title={blog.title}>
	<a
		class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
		href="/profile/{blog.author.id}/{slugify(blog.author.username)}/blog/{blog.id}/{slugify(blog.title)}"
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
		{#if $account.account && $account.currProfile}
			<Dropdown kind="primary">
				<svelte:fragment slot="button">
					<More2Fill size="18px" class="button-icon no-text text-white" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
						<button>
							<Edit2Line size="18px" class="mr-2" />
							<span>Edit</span>
						</button>
						<button>
							<ShareBoxLine size="18px" class="mr-2" />
							<span>Share</span>
						</button>
						<div class="w-full my-1 border-b border-zinc-300"><!--divider--></div>
						<button>
							<DeleteBin2Line size="18px" class="mr-2" />
							<span>Delete</span>
						</button>
					{:else}
						<button>
							<AlarmWarningLine size="18px" class="mr-2 relative -top-0.5" />
							<span>Report</span>
						</button>
					{/if}
				</svelte:fragment>
			</Dropdown>
		{/if}
	</div>
	<div class="blog-preview">
		{@html blog.body}
	</div>
	<div class="blog-stats bg-zinc-300 dark:bg-zinc-600">
		<span class="flex items-center">
			<LineChartLine size="16px" class="mr-1" />
			{blog.stats.views} view{pluralize(blog.stats.views)}
		</span>
		<span class="mx-1">•</span>
		<span class="flex items-center">
			<StarLine size="16px" class="mr-1" />
			{blog.stats.favorites} fave{pluralize(blog.stats.favorites)}
		</span>
		<span class="mx-1">•</span>
		<span class="flex items-center">
			<PenNibLine size="16px" class="mr-1" />
			{blog.stats.words} word{pluralize(blog.stats.words)}
		</span>
		<div class="flex-1"><!--spacer--></div>
		<span class="flex items-center">
			<TimeLine size="16px" class="mr-1 relative -top-[0.02rem]" />
			<Time timestamp={blog.createdAt} relative="true" />
		</span>
	</div>
</div>

<style lang="scss">
	div.blog-card {
		@apply block rounded-lg overflow-hidden no-underline transition relative;
		color: var(--text-color);
		div.blog-header {
			@apply flex items-center px-4 py-3.5;
			background: var(--accent);
		}
		div.blog-preview {
			@apply px-6 line-clamp-[8] max-h-[14rem];
		}
		div.blog-stats {
			@apply flex items-center rounded-xl mx-2 my-2.5 px-2 py-1;
		}
	}
</style>