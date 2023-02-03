<script lang="ts">
	import { slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import type { Profile } from "$lib/models/accounts";
	import BlogsManagement from "./BlogsManagement.svelte";
	import BlogsList from "./BlogsList.svelte";

	export let data: Profile;
</script>

<svelte:head>
	<title>{data.username}'s Blogs &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Blogs" />
	<meta name="description" content="From the desk of {data.username}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta
		property="og:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}/blogs"
	/>
	<meta property="og:title" content="{data.username}'s Blogs" />
	<meta property="og:description" content="From the desk of {data.username}" />
	<meta property="og:image" content={data.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta
		property="twitter:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}/blogs"
	/>
	<meta property="twitter:title" content="{data.username}'s Blogs" />
	<meta property="twitter:description" content="From the desk of {data.username}" />
	<meta property="twitter:image" content={data.avatar} />
</svelte:head>

{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
	<BlogsManagement profile={data} />
{:else}
	<BlogsList profile={data} />
{/if}
