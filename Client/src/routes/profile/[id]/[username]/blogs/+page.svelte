<script lang="ts">
	import { page } from "$app/stores";
	import { slugify } from "$lib/util/functions";
	import { profileState } from "$lib/state/profile.state";
	import { account } from "$lib/state/account.state";
	import BlogsManagement from "./BlogsManagement.svelte";
	import BlogsList from "./BlogsList.svelte";
</script>

<svelte:head>
	<title>{$profileState.username}'s Blogs &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{$profileState.username}'s Blogs" />
	<meta name="description" content="From the desk of {$profileState.username}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/profile/{$profileState.id}/{slugify($profileState.username)}/blogs" />
	<meta property="og:title" content="{$profileState.username}'s Blogs" />
	<meta
		property="og:description"
		content="From the desk of {$profileState.username}"
	/>
	<meta property="og:image" content="{$profileState.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/profile/{$profileState.id}/{slugify($profileState.username)}/blogs" />
	<meta property="twitter:title" content="{$profileState.username}'s Blogs" />
	<meta
		property="twitter:description"
		content="From the desk of {$profileState.username}"
	/>
	<meta property="twitter:image" content="{$profileState.avatar}" />
</svelte:head>

{#if $account.account && $account.currProfile && $account.currProfile.id === $profileState.id}
	<BlogsManagement />
{:else}
	<BlogsList
		page={+$page.url.searchParams.get('page') ?? 1}
		per={+$page.url.searchParams.get('per') ?? 10}
	/>
{/if}
