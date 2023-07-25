<script lang="ts">
	import { popPanel } from "$lib/ui/user/guide/guide.state";
	import { Button } from "$lib/ui/util";
	import { ArrowLeftSLine } from "svelte-remixicon";
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Settings</span>
	</Button>
</div>
<div class="empty mb-12">
	<h3 class="text-lg font-bold">Pardon the dust—</h3>
	<p>
		This feature is still under construction.<br />Keep an eye on our
		<a href="https://github.com/OffprintStudios/Sailfish/releases" target="_blank"
			>GitHub Releases</a
		> for info on when this will become available!
	</p>
</div>
