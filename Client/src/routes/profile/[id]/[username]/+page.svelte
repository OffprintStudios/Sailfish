<script lang="ts">
	import { slugify } from "$lib/util/functions";
	import { profileState } from "$lib/state/profile.state";
</script>

<svelte:head>
	<title>{$profileState.username}'s Profile &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{$profileState.username}'s Profile" />
	<meta name="description" content="{$profileState.info.bio}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/profile/{$profileState.id}/{slugify($profileState.username)}" />
	<meta property="og:title" content="{$profileState.username}'s Profile" />
	<meta
		property="og:description"
		content="{$profileState.info.bio}"
	/>
	<meta property="og:image" content="{$profileState.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/profile/{$profileState.id}/{slugify($profileState.username)}" />
	<meta property="twitter:title" content="{$profileState.username}'s Profile" />
	<meta
		property="twitter:description"
		content="{$profileState.info.bio}"
	/>
	<meta property="twitter:image" content="{$profileState.avatar}" />
</svelte:head>

{$profileState.username}