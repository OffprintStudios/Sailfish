<script lang="ts">
	import { onMount } from "svelte";
	import type { Work, Section } from "$lib/models/content/works";
	import SectionContainer from "./SectionContainer.svelte";
	import EditSection from "./EditSection.svelte";
	import { slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import { getReq, type ResponseError } from "$lib/http";
	import type { ReadingHistory } from "$lib/models/content/library";
	import toast from "svelte-french-toast";
	import type { Paginate } from "$lib/util/types";
	import { type Comment, CommentType } from "$lib/models/comments";
	import { Thread } from "$lib/ui/comments";
	import { page } from "$app/stores";

	export let data: {
		work: Work;
		comments?: Paginate<Comment>;
		section: Section;
		allSections: Section[];
	};

	let editMode = false;
	let history: ReadingHistory;
	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "25");

	onMount(async () => {
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id !== data.work.author.id
		) {
			await fetchHistory();
		}
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

	async function fetchHistory() {
		const response = await getReq<ReadingHistory>(
			`/history/fetch-one?workId=${data.work.id}&profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			history = response as ReadingHistory;
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

<div class="max-w-4xl mx-auto mb-6 lg:mt-6">
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
				{history}
				on:edit={toggleEditMode}
			/>
		{/key}
		{#key data.comments}
			{#if data.work.publishedOn && data.section.publishedOn && data.comments}
				<div class="my-6"><!--spacer--></div>
				<Thread
					type={CommentType.Work}
					threadId={data.work.id}
					content={data.comments}
					sectionId={data.section.id}
					{pageNum}
					{perPage}
				/>
			{/if}
		{/key}
	{/if}
</div>
