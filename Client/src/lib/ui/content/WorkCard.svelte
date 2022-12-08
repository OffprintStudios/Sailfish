<script lang="ts">
	import TagBadge from "./TagBadge.svelte";
	import { TagKind } from "../../models/tags";
	import type { Work } from "$lib/models/content/works";
	import { slugify, abbreviate } from "../../util/functions";
	import { account } from "../../state/account.state";
	import { Dropdown } from "../dropdown";
	import { Time } from "../util";
	import { Calendar2Line, MoreFill, LineChartLine, PenNibLine, DiscussLine } from "svelte-remixicon";

	export let work: Work;

	const calculateApprovalRating = (likes: number, dislikes: number): number => {
		const totalVotes = likes + dislikes;
		if (totalVotes === 0) {
			return 0;
		} else {
			return Math.ceil((likes / totalVotes) * 100);
		}
	};
</script>

<div class="work-card bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed" title={work.title}>
	<a
		class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
		href="/prose/{work.id}/{slugify(work.title)}"
		data-sveltekit-preload-data
	>
		<!--should be empty-->
	</a>
	<div class="card-banner" class:h-[120px]={!work.bannerArt}>
		<div class="flex items-center">
			{#if $account.account && $account.currProfile}
				<Dropdown kind="primary">
					<svelte:fragment slot="button">
						<MoreFill size="18px" class="button-icon no-text" />
					</svelte:fragment>
					<svelte:fragment slot="items">
						hi hello
					</svelte:fragment>
				</Dropdown>
			{/if}
			<div class="flex-1"><!--spacer--></div>
			<TagBadge kind={TagKind.category} category={work.category} size="small" />
			<div class="mx-[0.025rem]"></div>
			<TagBadge kind={TagKind.status} status={work.status} size="small" />
			<div class="mx-[0.025rem]"></div>
			<TagBadge kind={TagKind.rating} rating={work.rating} size="small" />
		</div>
	</div>
	<div class="card-body">
		<div class="p-2 pb-1 bg-zinc-200 dark:bg-zinc-700">
			<div class="flex-1">
				<div class="flex items-center mb-2">
					<div class="self-end relative w-1/3 max-w-[6.5rem]">
						<img
							src="/images/offprint_icon.png"
							class="absolute bottom-0 border-4 border-zinc-300 dark:border-zinc-600 object-contain rounded-xl max-w-[6rem] max-h-[6rem]"
							style="box-shadow: var(--dropshadow);"
							alt="cover-art"
						/>
					</div>
					<div class="flex-1 relative w-2/3">
						<h3 class="font-medium text-lg truncate" style="color: var(--text-color);">
							{work.title}
						</h3>
						<div class="flex items-center text-zinc-400" style="font-family: var(--header-text);">
							<span class="mr-1">by</span>
							<a class="text-zinc-400 hover:text-zinc-400 relative z-[2]" href="/profile/{work.author.id}/{slugify(work.author.username)}">{work.author.username}</a>
						</div>
					</div>
				</div>
				<div class="flex items-center flex-wrap">
					{#each work.tags.filter(item => item.kind === TagKind.genre) as tag}
						<TagBadge tag={tag} kind={tag.kind} size="small" />
						<div class="mx-[0.05rem] last:mx-0"></div>
					{/each}
				</div>
				<div class="text-xs px-2 mt-4 mb-4">
					{@html work.shortDesc}
				</div>
				<div class="flex items-center justify-end text-zinc-400" style="font-family: var(--header-text);">
					<span class="flex items-center relative z-[2]" title="Views">
						<LineChartLine class="mr-1" size="16px" />
						<span class="relative">{abbreviate(work.views)}</span>
					</span>
					<span class="mx-2">/</span>
					<span class="flex items-center relative z-[2]" title="Words">
						<PenNibLine class="mr-1" size="16px" />
						<span class="relative">{abbreviate(work.words)}</span>
					</span>
					<span class="mx-2">/</span>
					<span class="flex items-center relative z-[2]" title="Comments">
						<DiscussLine class="mr-1" size="16px" />
						<span class="relative">{abbreviate(work.comments)}</span>
					</span>
					<span class="mx-2">/</span>
					{#if work.publishedOn}
						<span class="flex items-center relative z-[2]" title="Published On">
							<Calendar2Line class="mr-1" size="16px" />
							<span class="relative"><Time timestamp={work.publishedOn} format="M-D-YY" /></span>
						</span>
					{:else}
						<span class="flex items-center relative z-[2]" title="Created On">
							<Calendar2Line class="mr-1" size="16px" />
							<span class="relative"><Time timestamp={work.createdAt} format="M-D-YY" /></span>
						</span>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="scss">
	div.work-card {
		@apply block rounded-xl overflow-hidden no-underline transition relative;
		div.card-banner {
			@apply flex flex-col relative p-2;
			background: var(--accent);
		}
		div.card-body {
			@apply flex flex-col justify-end relative;
		}
	}
</style>