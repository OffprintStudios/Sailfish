<script lang="ts">
	import { ArrowLeftSLine, OpenArmLine, DiscussLine, ArrowRightSLine } from "svelte-remixicon";
	import { abbreviate } from '$lib/util/functions';
	import type { SectionList } from '$lib/models/content/works';
	import { account } from '$lib/state/account.state';
	import { goto } from '$app/navigation';

	export let authorId: string;
	export let sectionId: string;
	export let tableOfContents: SectionList[];
	export let cheers: number;
	export let comments: number;
	export let iconSize = "22px";

	const published = tableOfContents.filter((section) => section.publishedOn !== undefined);

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
</script>

<div class="section-nav">
	<button class="section-button" on:click={goBack}>
		<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
		<span class="hidden lg:block">Prev</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" title="Cheers">
		<OpenArmLine size={iconSize} class="mr-1" />
		<span class="text-xs" style="top: 0.03rem;">
			{abbreviate(cheers)}
		</span>
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
