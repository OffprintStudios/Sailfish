<script lang="ts">
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import type { ThreadPage } from "$lib/models/comments";
	import { slugify } from "$lib/util/functions";
	import BlogContainer from "./BlogContainer.svelte";
	import Thread from "$lib/ui/comments/Thread.svelte";
	import { InfoBar } from "$lib/ui/util";

	export let data: { blog: Blog, page?: ThreadPage };

	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 25;
</script>

<svelte:head>
	<title>{data.blog.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.blog.title}" />
	<meta name="description" content="{data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/profile/{data.blog.author.id}/{slugify(data.blog.author.username)}/blog/{data.blog.id}/{slugify(data.blog.title)}" />
	<meta property="og:title" content="{data.blog.title}" />
	<meta
		property="og:description"
		content="{data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}"
	/>
	<meta property="og:image" content="{data.blog.author.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/profile/{data.blog.author.id}/{slugify(data.blog.author.username)}/blog/{data.blog.id}/{slugify(data.blog.title)}" />
	<meta property="twitter:title" content="{data.blog.title}" />
	<meta
		property="twitter:description"
		content="{data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}"
	/>
	<meta property="twitter:image" content="{data.blog.author.avatar}" />
</svelte:head>

{#if !data.blog.publishedOn}
	<InfoBar message="This blog is a draft. Faves and comments are disabled, and views will not be tracked." />
{/if}

<BlogContainer blog="{data.blog}" />

{#if data.blog.publishedOn}
	<div class="max-w-4xl mx-auto">
		<Thread
			thread={data.page.thread}
			content={data.page.page}
			kind="content"
			page={pageNum}
			per={per}
		/>
	</div>
{/if}
