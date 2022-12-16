<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { closePopup, closePopupAndConfirm } from "$lib/ui/popup";

	const proceedLines = [
		"Do you wish to proceed?",
		"Wanna go ahead and give it a whirl?",
		"Ready to give it the ol' college try?",
		"Wanna throw it at the wall and see if it sticks?",
		"How about it? Sound good?",
	];
	const currLine = proceedLines[Math.floor(Math.random() * proceedLines.length)];
</script>

<div class="rounded-xl overflow-hidden max-w-2xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Head's Up</h3>
		<p>
			Before your work can be published on Offprint, it must first go through the Offprint Approval Queue, where our team of dedicated approvers will verify that the content within does not violate our Code of Conduct or Posting Guidelines (as detailed in the Offprint Omnibus) before giving their stamp of approval. This includes making sure that:
		</p>
		<ul class="mx-8 list-disc">
			<li>Your chosen cover art and banner art are not NSFW</li>
			<li>Your work is tagged appropriately (most especially its Category and Rating!)</li>
			<li>If your work is a fanwork, its fandoms are tagged accordingly</li>
			<li>Your work is primarily written in comprehensible English</li>
			<li>The combined word count of all published chapters (the total word count) exceeds 750 words</li>
			<li>Your work is not a plagiarized copy of someone else's creation</li>
		</ul>
		<p>
			Should our approval team find your work out of compliance with these rules, it will be rejected with a strike. Should you exceed three strikes, you will no longer be able to submit this work. It's in your best interest to follow all the feedback given by the approval team, so that your work may be approved swiftly.
		</p>
		<p>
			Once your work is approved, it will become available for all to see on the appropriate pages, and all social features—such as likes, dislikes, comments, and adding to libraries—will be enabled.
		</p>
		<p>
			You only need to go through the approval queue once per work.
		</p>
		<p>
			{currLine}
		</p>
	</div>
	<div class="flex items-center justify-center px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={closePopupAndConfirm}>
			<CheckLine class="button-icon" />
			<span class="button-text">Yes</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup}>
			<CloseLine class="button-icon" />
			<span class="button-text">No</span>
		</Button>
	</div>
</div>