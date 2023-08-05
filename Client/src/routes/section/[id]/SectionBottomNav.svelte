<script lang="ts">
	import { ArrowLeftSLine, OpenArmLine, DiscussLine, ArrowRightSLine } from "svelte-remixicon";
	import { abbreviate } from "$lib/util/functions";

	export let cheers: number;
	export let comments: number;
	export let iconSize = "22px";
</script>

<div class="section-nav">
	<button class="section-button">
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
	<button class="section-button">
		<span class="hidden lg:block">Next</span>
		<ArrowRightSLine class="lg:ml-1" size={iconSize} />
	</button>
</div>
