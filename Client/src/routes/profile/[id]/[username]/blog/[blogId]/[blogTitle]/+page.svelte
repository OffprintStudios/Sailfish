<script lang="ts">
	import type { Blog } from "$lib/models/content";
	import { slugify } from "$lib/util/functions";
	import BlogContainer from "./BlogContainer.svelte";

	export let data: Blog;
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
