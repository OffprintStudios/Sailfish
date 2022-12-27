<script lang="ts">
	import { onMount } from "svelte";
	import { fade } from "svelte/transition";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Blog } from "$lib/models/content";
	import {
		CheckboxBlankCircleLine,
		CheckboxBlankCircleFill,
		DiscussLine,
		CalendarLine,
		LineChartLine
	} from "svelte-remixicon";
	import { DEFAULT_SLOGANS } from "$lib/util/constants";
	import { Time } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { abbreviate, slugify } from "$lib/util/functions";

	let loading = false;
	let currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
	const today = new Date();
	let posts: Paginate<Blog> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
			total: 0
		}
	};
	let currPost: Blog;

	onMount(async () => {
		await fetchNews();
	});

	setInterval(() => {
		const idx = posts.items.findIndex((item) => item.id === currPost.id);
		if (idx === posts.items.length - 1) {
			currPost = posts.items[0];
		} else {
			currPost = posts.items[idx + 1];
		}
	}, 8000);

	async function fetchNews() {
		loading = true;
		const response = await getReq<Paginate<Blog>>(`/news/fetch-posts?page=1&per=3`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			posts = response as Paginate<Blog>;
			if (posts.items.length > 0) {
				currPost = posts.items[0];
			}
		}
		loading = false;
	}
</script>

<div class="carousel-container bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="home-header">
		<div class="hidden lg:block w-1/4">
			<div class="deco-box flex-col">
				<span class="relative top-2 left-[0.075rem] text-4xl"
					>{today.toLocaleString("default", { month: "short" })}</span
				>
				<span class="relative bottom-1.5 left-[0.075rem] text-xl"
					>{today.getFullYear()}</span
				>
			</div>
		</div>
		<div class="lg:w-2/4 flex flex-col items-center justify-center">
			<img
				src="/images/logo.png"
				alt="offprint logo"
				class="max-w-[8rem] lg:max-w-[18rem] mx-auto"
			/>
			<h2 class="hidden lg:block text-white font-light text-lg">
				{currSlogan}
			</h2>
		</div>
		<div class="hidden w-1/4 lg:flex items-center justify-end">
			<div class="deco-box flex-row">
				<span class="relative text-5xl font-normal">25</span>
				<span class="relative text-3xl bottom-0.5 ml-1">¢</span>
			</div>
		</div>
	</div>
	<div class="carousel-items">
		{#if currPost}
			<a
				class="absolute h-full w-full text-white z-20"
				href="/profile/{currPost.author.id}/{slugify(
					currPost.author.username
				)}/blog/{currPost.id}/{slugify(currPost.title)}"
			>
				<!--meant to be invisible-->
			</a>
		{/if}
		{#if posts.metadata.total === 0}
			<div class="flex flex-col items-center justify-center w-full h-full">
				<span class="uppercase font-bold tracking-wider">No Posts Found</span>
			</div>
		{:else}
			{#if currPost}
				{#key currPost}
					<div class="post" transition:fade|local={{ delay: 0, duration: 400 }}>
						<img
							alt={currPost.title}
							src={currPost.bannerArt}
							class="h-full w-full object-cover"
						/>
						<div
							class="absolute bottom-[50px] left-[50px] rounded-xl py-2 px-4 bg-zinc-600 opacity-75 backdrop-blur z-10"
							style="font-family: var(--header-text);"
						>
							<div class="relative top-1">
								<h3 class="text-white text-4xl relative top-0.5">
									{currPost.title}
								</h3>
								<span class="text-white text-2xl italic relative bottom-0.5">
									{currPost.desc}
								</span>
							</div>
							<div class="flex items-center text-zinc-400">
								<span>by {currPost.author.username}</span>
								<span class="mx-1.5 text-xl relative top-0.5">/</span>
								<span class="flex items-center">
									<LineChartLine size="18px" class="mr-1" />
									<span>{abbreviate(currPost.stats.views)}</span>
								</span>
								<span class="mx-1.5 text-xl relative top-0.5">/</span>
								<span class="flex items-center">
									<DiscussLine size="18px" class="mr-1" />
									<span>{abbreviate(currPost.stats.comments)}</span>
								</span>
								<span class="mx-1.5 text-xl relative top-0.5">/</span>
								<span class="flex items-center">
									<CalendarLine size="18px" class="mr-1" />
									<Time timestamp={currPost.publishedOn} />
								</span>
							</div>
						</div>
					</div>
				{/key}
			{/if}
			<div class="post-buttons">
				<div
					class="flex items-center bg-zinc-600 bg-opacity-75 backdrop-blur p-1 rounded-full relative z-20"
				>
					{#each posts.items as post}
						<button class="rounded-full mx-0.5" on:click={() => (currPost = post)}>
							{#if currPost.id === post.id}
								<CheckboxBlankCircleFill size="18px" />
							{:else}
								<CheckboxBlankCircleLine size="18px" />
							{/if}
						</button>
					{/each}
				</div>
			</div>
		{/if}
	</div>
</div>

<style lang="scss">
	div.carousel-container {
		@apply rounded-xl overflow-hidden my-6 w-full;
		div.home-header {
			@apply text-white text-center px-4 py-2 flex items-center justify-center;
			background: var(--accent);
		}
		div.deco-box {
			@apply h-20 w-20 rounded-full flex items-center justify-center text-white font-semibold all-small-caps;
			font-family: var(--header-text), sans-serif;
		}
		div.carousel-items {
			@apply relative h-[350px];
			div.post {
				@apply h-full w-full absolute top-0 z-10;
			}
			div.post-buttons {
				@apply absolute bottom-4 w-full flex items-center justify-center;
			}
		}
	}
</style>
