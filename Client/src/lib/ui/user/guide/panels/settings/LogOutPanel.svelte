<script lang="ts">
	import Button from "$lib/ui/util/Button.svelte";
	import { ArrowLeftSLine, CheckLine, CloseLine } from "svelte-remixicon";
	import { guide, popPanel } from "$lib/ui/user/guide/guide.state";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";
	import { activity } from "$lib/state/activity.state";

	async function logOut() {
		const response = await fetch(`/api/auth/log-out?accountId=${$account.account?.id}`, {
			method: "POST"
		});
		if (response.status === 200) {
			toast.success("See you later!");
			$account.account = null;
			$account.currProfile = null;
			$account.profiles = [];
			$account.token = null;
			$activity.markAsRead = [];
			$activity.count = 0;
			$guide.open = false;
			$guide.routing = [];
		} else {
			toast.error(`Something went wrong! Try again in a little bit.`);
		}
	}
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Back</span>
	</Button>
</div>
<div class="mb-1"><!--spacer--></div>
<h2 class="text-2xl text-center">Log Out</h2>
<p class="text-center" style="font-family: var(--body-text); color: var(--text-color);">
	Are you sure you want to log out?
</p>
<div class="flex items-center justify-center mb-6">
	<Button kind="primary" classes="text-center" on:click={logOut}>
		<CheckLine class="button-icon" />
		<span class="button-text">Yes</span>
	</Button>
	<div class="mx-0.5"><!--spacer--></div>
	<Button classes="text-center" on:click={popPanel}>
		<CloseLine class="button-icon" />
		<span class="button-text">No</span>
	</Button>
</div>
