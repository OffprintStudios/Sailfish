<script lang="ts">
	import { slide } from "svelte/transition";
	import { StarLine, AlarmWarningLine, ChatNewLine, Edit2Line, CalendarCheckLine, Save2Line, CloseLine } from "svelte-remixicon";
	import { Time } from "$lib/ui/util";
	import type { Blog } from "$lib/models/content";
	import { abbreviate, pluralize, slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import BlogForm from "./BlogForm.svelte";

	export let data: Blog;

	const iconSize = '24px';
	let showLabels = false;
	let isEditing = false;
</script>

<svelte:head>
	<title>{data.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.title}" />
	<meta name="description" content="{data.desc ? data.desc : `From the desk of ${data.author.username}.`}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/profile/{data.author.id}/{slugify(data.author.username)}/blog/{data.id}/{slugify(data.title)}" />
	<meta property="og:title" content="{data.title}" />
	<meta
		property="og:description"
		content="{data.desc ? data.desc : `From the desk of ${data.author.username}.`}"
	/>
	<meta property="og:image" content="{data.author.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/profile/{data.author.id}/{slugify(data.author.username)}/blog/{data.id}/{slugify(data.title)}" />
	<meta property="twitter:title" content="{data.title}" />
	<meta
		property="twitter:description"
		content="{data.desc ? data.desc : `From the desk of ${data.author.username}.`}"
	/>
	<meta property="twitter:image" content="{data.author.avatar}" />
</svelte:head>

<div class="mx-auto max-w-4xl flex flex-col">
	<div class="blog-header" class:rounded-b-xl={isEditing}>
		<div class="flex-1">
			<h1 class="text-white text-4xl font-medium">{data.title}</h1>
			<div class="flex items-center text-white text-xs">
				<Time timestamp={data.publishedOn ? data.publishedOn : data.createdAt} />
				<span class="mx-1">•</span>
				<span>{abbreviate(data.stats.comments)} comment{pluralize(data.stats.comments)}</span>
				<span class="mx-1">•</span>
				<span>{abbreviate(data.stats.views)} view{pluralize(data.stats.views)}</span>
			</div>
		</div>
		{#if $account.account && $account.currProfile && $account.currProfile.id === data.author.id}
			{#if isEditing}
				<button
					class="header-button rounded-l-lg"
					on:mouseenter={() => showLabels = true}
					on:mouseleave={() => showLabels = false}
					on:click={() => isEditing = false}
				>
					<Save2Line size={iconSize} class="button-icon" />
					<span>Save</span>
				</button>
				<button
					class="header-button rounded-r-lg"
					on:mouseenter={() => showLabels = true}
					on:mouseleave={() => showLabels = false}
					on:click={() => isEditing = false}
				>
					<CloseLine size={iconSize} class="button-icon" />
					<span>Cancel</span>
				</button>
			{:else}
				<button
					class="header-button rounded-l-lg"
					on:mouseenter={() => showLabels = true}
					on:mouseleave={() => showLabels = false}
					on:click={() => isEditing = true}
				>
					<Edit2Line size={iconSize} class="button-icon" />
					{#if showLabels}
						<span transition:slide|local={{ delay: 0, duration: 150 }}>Edit</span>
					{/if}
				</button>
				<button class="header-button rounded-r-lg" on:mouseenter={() => showLabels = true} on:mouseleave={() => showLabels = false}>
					<CalendarCheckLine size={iconSize} class="button-icon" />
					{#if showLabels}
						<span transition:slide|local={{ delay: 0, duration: 150 }}>Publish</span>
					{/if}
				</button>
			{/if}
		{:else if $account.account && $account.currProfile}
			<button class="header-button rounded-l-lg" on:mouseenter={() => showLabels = true} on:mouseleave={() => showLabels = false}>
				<StarLine size={iconSize} class="button-icon" />
				{#if showLabels}
					<span transition:slide|local={{ delay: 0, duration: 150 }}>Favorite</span>
				{/if}
			</button>
			<button class="header-button" on:mouseenter={() => showLabels = true} on:mouseleave={() => showLabels = false}>
				<ChatNewLine size={iconSize} class="button-icon" />
				{#if showLabels}
					<span transition:slide|local={{ delay: 0, duration: 150 }}>Discuss</span>
				{/if}
			</button>
			<button class="header-button rounded-r-lg" on:mouseenter={() => showLabels = true} on:mouseleave={() => showLabels = false}>
				<AlarmWarningLine size={iconSize} class="button-icon" />
				{#if showLabels}
					<span transition:slide|local={{ delay: 0, duration: 150 }}>Report</span>
				{/if}
			</button>
		{/if}
	</div>
	{#if isEditing}
		<div>
			<BlogForm blog={data} />
		</div>
	{:else}
		<div class="bg-zinc-200 dark:bg-zinc-700 rounded-b-xl">
			<div class="blog-body">{@html data.body}</div>
		</div>
	{/if}
</div>

<style lang="scss">
	div.blog-header {
		@apply rounded-t-xl flex items-center justify-center px-4 py-3.5;
		background: var(--accent);
		button.header-button {
			@apply w-[61px] h-[61px] flex flex-col items-center justify-center text-white transition;
			background: var(--accent-light);
			&:hover {
				background: var(--accent-dark);
			}
			span {
				@apply all-small-caps font-bold tracking-wide;
			}
			.button-icon {
				@apply relative top-0.5;
			}
		}
	}
	div.blog-body {
		@apply w-10/12 mx-auto text-[16px] py-6;
	}
</style>