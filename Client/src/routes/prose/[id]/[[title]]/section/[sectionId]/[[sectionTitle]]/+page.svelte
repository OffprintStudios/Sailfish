<script lang="ts">
	import { afterNavigate } from "$app/navigation";
	import type { Work, Section } from "$lib/models/content/works";
	import SectionContainer from "./SectionContainer.svelte";
	import EditSection from "./EditSection.svelte";
	import { slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";

	export let data: { work: Work; section: Section; allSections: Section[] };

	let containerTop;
	let editMode = false;

	afterNavigate(() => {
		containerTop.scrollIntoView({ behavior: "smooth" });
	});

	function toggleEditMode() {
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id === data.work.author.id
		) {
			editMode = !editMode;
		}
	}
</script>

<svelte:head>
	<title>{data.work.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.work.title} />
	<meta name="description" content={data.work.shortDesc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta
		property="og:url"
		content="https://offprint.net/prose/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="og:title" content={data.work.title} />
	<meta property="og:description" content={data.work.shortDesc} />
	<meta property="og:image" content={data.work.coverArt ?? data.work.author.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta
		property="twitter:url"
		content="https://offprint.net/prose/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="twitter:title" content={data.work.title} />
	<meta property="twitter:description" content={data.work.shortDesc} />
	<meta property="twitter:image" content={data.work.coverArt ?? data.work.author.avatar} />
</svelte:head>

<div bind:this={containerTop} />
<div class="max-w-4xl mx-auto my-6">
	{#if editMode}
		<EditSection
			work={data.work}
			bind:section={data.section}
			on:cancel={toggleEditMode}
			on:save={toggleEditMode}
		/>
	{:else}
		{#key data.section}
			<SectionContainer
				work={data.work}
				section={data.section}
				allSections={data.allSections}
				on:edit={toggleEditMode}
			/>
		{/key}
	{/if}
</div>
