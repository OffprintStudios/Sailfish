<script lang="ts">
	import { onMount } from "svelte";
	import { slugify } from "$lib/util/functions";
	import type { Profile } from "$lib/models/accounts";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Blog } from "$lib/models/content";
	import { ApprovalStatus } from "$lib/models/content";
	import { app } from "$lib/state/app.state";
	import toast from "svelte-french-toast";

	export let data: Profile;
	let loadingBlogs = false;
	let blogs: Paginate<Blog> = null;

	onMount(async () => {
		await loadBlogs();
	})

	async function loadBlogs() {
		loadingBlogs = true;
		const response = await getReq<Paginate<Blog>>(
			`/blogs/fetch-blogs?` +
			`authorId=${data.id}&` +
			`status=${ApprovalStatus.published}&` +
			`filter=${$app.filter}&` +
			`page=1&` +
			`per=3`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			blogs = response as Paginate<Blog>;
		}
		loadingBlogs = false;
	}
</script>

<svelte:head>
	<title>{data.username}'s Profile &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Profile" />
	<meta name="description" content="{data.info.bio}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="profile" />
	<meta property="profile:username" content="{data.username}" />
	<meta property="og:url" content="https://offprint.net/profile/{data.id}/{slugify(data.username)}" />
	<meta property="og:title" content="{data.username}'s Profile" />
	<meta
		property="og:description"
		content="{data.info.bio}"
	/>
	<meta property="og:image" content="{data.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta property="twitter:url" content="https://offprint.net/profile/{data.id}/{slugify(data.username)}" />
	<meta property="twitter:title" content="{data.username}'s Profile" />
	<meta
		property="twitter:description"
		content="{data.info.bio}"
	/>
	<meta property="twitter:image" content="{data.avatar}" />
</svelte:head>

<div class="flex flex-col max-w-6xl mx-auto">
	<div class="flex-1 p-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed rounded-xl">
		<h3>About Me</h3>
		<div>
			{data.info.bio}
		</div>
	</div>
	<div class="flex items-center">

	</div>
</div>