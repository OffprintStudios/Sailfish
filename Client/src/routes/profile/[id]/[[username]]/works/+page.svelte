<script lang="ts">
	import { page } from "$app/stores";
	import { slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import WorksManagement from "./WorksManagement.svelte";
	import WorksList from "./WorksList.svelte";
	import type { Profile } from "$lib/models/accounts";

	export let data: Profile;

	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 10;
</script>

<svelte:head>
	<title>{data.username}'s Works &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Works" />
	<meta name="description" content="The collected works of {data.username}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta
		property="og:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}/works"
	/>
	<meta property="og:title" content="{data.username}'s Works" />
	<meta property="og:description" content="The collected works of {data.username}" />
	<meta property="og:image" content={data.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta
		property="twitter:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}/works"
	/>
	<meta property="twitter:title" content="{data.username}'s Works" />
	<meta property="twitter:description" content="The collected works of {data.username}" />
	<meta property="twitter:image" content={data.avatar} />
</svelte:head>

{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
	<WorksManagement profile={data} />
{:else}
	<WorksList profile={data} page={pageNum} {per} />
{/if}
