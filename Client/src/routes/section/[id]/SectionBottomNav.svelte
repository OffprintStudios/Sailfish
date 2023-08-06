<script lang="ts">
	import {
		ArrowLeftSLine,
		OpenArmLine,
		DiscussLine,
		ArrowRightSLine,
		Loader5Line,
		OpenArmFill
	} from 'svelte-remixicon';
	import { abbreviate } from '$lib/util/functions';
	import type { SectionList } from '$lib/models/content/works';
	import { account } from '$lib/state/account.state';
	import { goto } from '$app/navigation';
	import toast from 'svelte-french-toast';
	import { postReq, type ResponseError } from '$lib/http';
	import type { Cheer } from '$lib/models/content/works';

	export let authorId: string;
	export let sectionId: string;
	export let tableOfContents: SectionList[];
	export let cheer: Cheer | undefined;
	export let cheers: number;
	export let comments: number;
	export let iconSize = "22px";

	const published = tableOfContents.filter((section) => section.publishedOn !== undefined);
	let cheering = false;

	function goBack() {
		let sections = published;
		if ($account.currProfile?.id === authorId) {
			sections = tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === sectionId);
		if (idx >= 1) {
			goto(`/section/${sections[idx - 1].id}`);
		} else {
			goto(`/section/${sectionId}`);
		}
	}

	function goForward() {
		let sections = published;
		if ($account.currProfile?.id === authorId) {
			sections = tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === sectionId);
		if (idx < sections.length - 1) {
			goto(`/section/${sections[idx + 1].id}`);
		} else {
			goto(`/section/${sectionId}`);
		}
	}

	async function toggleCheer() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in and have a profile selected to use this feature.");
			return;
		}
		cheering = true;
		const response = await postReq<{ cheer?: Cheer }>(`/reading/toggle-cheer/${sectionId}?profileId=${$account.currProfile?.id}`, {});
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as { cheer?: Cheer };
			cheer = result.cheer;
			if (result.cheer?.id) {
				cheers = cheers + 1;
			} else {
				cheers = cheers - 1;
			}
		}
		cheering = false;
	}
</script>

<div class="section-nav">
	<button class="section-button" on:click={goBack}>
		<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
		<span class="hidden lg:block">Prev</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" class:active={!!cheer} title="Cheers" on:click={toggleCheer}>
		{#if cheering}
			<Loader5Line size={iconSize} class="mr-1 animate-[spin_2s_linear_infinite]" />
			<span style="top: 0.03rem;">-</span>
		{:else}
			{#if cheer}
				<OpenArmFill size={iconSize} class="mr-1" />
			{:else}
				<OpenArmLine size={iconSize} class="mr-1" />
			{/if}
			<span class="text-xs" style="top: 0.03rem;">
							{abbreviate(cheers)}
						</span>
		{/if}
	</button>
	<div class="mx-0.5"><!--spacer--></div>
	<button class="section-button" title="Comments">
		<DiscussLine size={iconSize} class="mr-1" />
		<span class="text-xs" style="top: 0.03rem;">
			{abbreviate(comments)}
		</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" on:click={goForward}>
		<span class="hidden lg:block">Next</span>
		<ArrowRightSLine class="lg:ml-1" size={iconSize} />
	</button>
</div>
