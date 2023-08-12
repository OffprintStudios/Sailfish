<script lang="ts">
	import type { SectionPage, Cheer } from '$lib/models/content/works';
	import { patchReq, postReq, type ResponseError } from '$lib/http';
	import type { ReadingHistory } from '$lib/models/content/library';
	import { account } from '$lib/state/account.state';
	import toast from 'svelte-french-toast';
	import {
		ArrowDownSLine,
		ArrowUpSLine,
		ArrowLeftSLine,
		Loader5Line,
		OpenArmFill,
		OpenArmLine,
		DiscussLine,
		ArrowRightSLine,
	} from 'svelte-remixicon';
	import { slide } from 'svelte/transition';
	import { abbreviate } from '$lib/util/functions';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';

	export let data: SectionPage;
	const published = data.tableOfContents.filter((section) => section.publishedOn !== undefined);
	const iconSize = "22px";
	let noteTopOpen = false;
	let cheering = false;

	onMount(() => {
		const sectionNav = document.getElementById("section-nav")!;
		const observer = new IntersectionObserver((entries) => {
			entries.forEach(async (entry) => {
				if ($account.account && $account.currProfile && entry.isIntersecting) {
					await markAsRead();
				}
			});
		}, {
			root: null,
			rootMargin: "0px 0px -50% 0px",
			threshold: 0,
		});
		observer.observe(sectionNav);
	});

	async function markAsRead() {
		const response = await patchReq<ReadingHistory>(
			`/history/set-as-read?workId=${data.section.work.id}&sectionId=${data.section.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.readingHistory = response as ReadingHistory;
		}
	}

	function goBack() {
		let sections = published;
		if ($account.currProfile?.id === data.section.author.id) {
			sections = data.tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === data.section.id);
		if (idx >= 1) {
			goto(`/section/${sections[idx - 1].id}`);
		} else {
			goto(`/section/${data.section.id}`);
		}
	}

	function goForward() {
		let sections = published;
		if ($account.currProfile?.id === data.section.author.id) {
			sections = data.tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === data.section.id);
		if (idx < sections.length - 1) {
			goto(`/section/${sections[idx + 1].id}`);
		} else {
			goto(`/section/${data.section.id}`);
		}
	}

	async function toggleCheer() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in and have a profile selected to use this feature.");
			return;
		}
		cheering = true;
		const response = await postReq<{ cheer?: Cheer }>(`/reading/toggle-cheer/${data.section.id}?profileId=${$account.currProfile?.id}`, {});
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as { cheer?: Cheer };
			data.cheer = result.cheer;
			if (result.cheer?.id) {
				data.section.section.cheers = data.section.section.cheers + 1;
			} else {
				data.section.section.cheers = data.section.section.cheers - 1;
			}
		}
		cheering = false;
	}
</script>

<div id="section-container" class="section-container">
	<div class="mb-16">
		<h1 class="text-4xl text-center">{data.section.section.title}</h1>
		{#if data.section.section.noteTop}
			<div class="flex flex-col items-center italic w-11/12 max-w-lg mx-auto">
				{#if noteTopOpen}
					<div class="flex flex-col pt-4 w-full" transition:slide={{ delay: 0, duration: 150 }}>
						<div class="authors-note italic text-justify">
							{@html data.section.section.noteTop}
						</div>
						<span class="w-full my-4 text-right">—A word from the author</span>
					</div>
				{/if}
				<button class="section-button" on:click={() => noteTopOpen = !noteTopOpen}>
					{#if noteTopOpen}
						<ArrowUpSLine size="24px" />
					{:else}
						<ArrowDownSLine size="24px" />
					{/if}
				</button>
			</div>
		{/if}
	</div>
	<div id="section-body" class="section-body">
		{@html data.section.section.body}
	</div>
	{#if data.section.section.noteBottom}
		<div class="section-authors-note">
			<div class="flex items-center">
				<h3 class="text-2xl">From the author—</h3>
			</div>
			<div class="authors-note">
				{@html data.section.section.noteBottom}
			</div>
		</div>
	{/if}
</div>
<div id="section-nav" class="section-nav">
	<button class="section-button" on:click={goBack}>
		<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
		<span class="hidden lg:block">Prev</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" class:active={!!data.cheer} title="Cheers" on:click={toggleCheer}>
		{#if cheering}
			<Loader5Line size={iconSize} class="mr-1 animate-[spin_2s_linear_infinite]" />
			<span style="top: 0.03rem;">-</span>
		{:else}
			{#if data.cheer}
				<OpenArmFill size={iconSize} class="mr-1" />
			{:else}
				<OpenArmLine size={iconSize} class="mr-1" />
			{/if}
			<span class="text-xs" style="top: 0.03rem;">
				{abbreviate(data.section.section.cheers)}
			</span>
		{/if}
	</button>
	<div class="mx-0.5"><!--spacer--></div>
	<button class="section-button" title="Comments" on:click={() => goto(`/section/${data.section.id}/comments`)}>
		<DiscussLine size={iconSize} class="mr-1" />
		<span class="text-xs" style="top: 0.03rem;">
			{abbreviate(data.section.section.comments)}
		</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" on:click={goForward}>
		<span class="hidden lg:block">Next</span>
		<ArrowRightSLine class="lg:ml-1" size={iconSize} />
	</button>
</div>

<style lang="scss">
  :global(div.markdown-text) {
    :global(p) {
      color: var(--text-color);
      margin: 0.5rem 0 0.5rem 0 !important;
      text-align: center !important;
    }
  }
</style>
