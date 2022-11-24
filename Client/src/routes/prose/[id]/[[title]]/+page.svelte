<script lang="ts">
	import type { Work } from "$lib/models/content/works";
	import { slugify } from "$lib/util/functions";
	import { InfoBar } from "$lib/ui/util";
	import WorkHeader from "./WorkHeader.svelte";
	import WorkStats from "./WorkStats.svelte";
	import WorkInfo from "./WorkInfo.svelte";
	import VolumesList from "./VolumesList.svelte";
	import SectionsList from "./SectionsList.svelte";

	export let data: Work;
</script>

<svelte:head>
	<title>{data.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.title}" />
	<meta name="description" content="{data.shortDesc}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/prose/{data.id}/{slugify(data.title)}" />
	<meta property="og:title" content="{data.title}" />
	<meta
		property="og:description"
		content="{data.shortDesc}"
	/>
	<meta property="og:image" content="{data.coverArt ?? data.author.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/prose/{data.id}/{slugify(data.title)}" />
	<meta property="twitter:title" content="{data.title}" />
	<meta
		property="twitter:description"
		content="{data.shortDesc}"
	/>
	<meta property="twitter:image" content="{data.coverArt ?? data.author.avatar}" />
</svelte:head>

<div class="max-w-7xl mx-auto my-6">
	<WorkHeader work={data} />
	{#if !data.publishedOn}
		<InfoBar
			message="<b>This work is a draft.</b> No views will be counted when navigating to
                                this page, and all social features (such as comments and likes/dislikes) are disabled."
		/>
		<div class="mb-6"></div>
	{/if}
	<div class="flex flex-row max-w-4xl mx-auto">
		<WorkStats work={data} />
		<div>
			<WorkInfo work={data} />
			<SectionsList work={data} />
		</div>
	</div>
</div>
