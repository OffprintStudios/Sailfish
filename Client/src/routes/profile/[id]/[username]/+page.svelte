<script lang="ts">
	import { slugify } from "$lib/util/functions";
	import type { Profile } from "$lib/models/accounts";

	export let data: Profile;
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

{data.username}