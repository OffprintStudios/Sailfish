<script lang="ts">
	import Button from "$lib/ui/util/Button.svelte";
	import { RiArrowLeftSLine, RiCheckLine, RiCloseLine } from "svelte-remixicon";
	import { guide, popPanel } from "../../guide.state";
	import { auth } from "$lib/state/auth.state";
	import toast from "svelte-french-toast";
	import { goto } from "$app/navigation";

	async function logOut() {
        toast.success("See you later!");
        $auth.account = undefined;
        $auth.currProfile = undefined;
        $auth.profiles = [];
        $auth.token = undefined;
        $guide.open = false;
        $guide.routing = [];
        await goto("/");
	}
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button id="back-button" title="Go Back" on:click={popPanel}>
		<span class="button-icon"><RiArrowLeftSLine /></span>
		<span class="button-text">Back</span>
	</Button>
</div>
<div class="mb-1"><!--spacer--></div>
<h2 class="text-2xl text-center">Log Out</h2>
<p class="text-center mt-4 mb-16" style="font-family: var(--body-text); color: var(--text-color);">
	Are you sure you want to log out?
</p>
<div class="flex items-center justify-center mb-6">
	<Button id="yes-button" title="Log Out" kind="primary" on:click={logOut}>
        <span class="button-icon"><RiCheckLine /></span>
		<span class="button-text">Yes</span>
	</Button>
	<div class="mx-0.5"><!--spacer--></div>
	<Button id="no-button" title="Cancel" on:click={popPanel}>
        <span class="button-icon"><RiCloseLine /></span>
		<span class="button-text">No</span>
	</Button>
</div>
