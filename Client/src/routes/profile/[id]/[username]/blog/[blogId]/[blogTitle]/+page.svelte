<script lang="ts">
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import { slugify } from "$lib/util/functions";
	import BlogContainer from "./BlogContainer.svelte";
	import Thread from "$lib/ui/comments/Thread.svelte";

	export let data: Blog;

	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 25;
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

<BlogContainer blog="{data}" />

{#if data.publishedOn}
	<div class="max-w-4xl mx-auto">
		<Thread threadId={data.id} kind="content" page={pageNum} per={per} />
	</div>
{/if}
