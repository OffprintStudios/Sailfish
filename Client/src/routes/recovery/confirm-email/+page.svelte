<script lang="ts">
	import { onMount } from "svelte";
	import { Loader5Line, CheckboxCircleLine, CloseCircleLine } from "svelte-remixicon";
	import { patchReq, type ResponseError } from "$lib/http";
	import { page } from "$app/stores";
	import { account } from "$lib/state/account.state";

	const iconSize = "54px";
	let loadingConfirm = true;
	let isError = false;

	onMount(async () => {
		setTimeout(confirmEmail, 3000);
	});

	async function confirmEmail() {
		if ($account.account && $account.account.emailConfirmed) {
			loadingConfirm = false;
			isError = false;
		} else {
			const formInfo = {
				accountId: $page.url.searchParams.get("userId") ?? "nil",
				confirmCode: $page.url.searchParams.get("token") ?? "nil"
			};
			const response = await patchReq<void>(`/accounts/confirm-email`, formInfo);
			if ((response as ResponseError).statusCode) {
				isError = true;
			}
			loadingConfirm = false;
		}
	}
</script>

<div
	class="w-11/12 max-w-xl my-6 lg:my-0 lg:h-screen mx-auto flex flex-col items-center justify-center"
>
	<div
		class="flex flex-col items-center justify-center h-[300px] rounded-xl w-full p-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
	>
		{#if loadingConfirm}
			<h1 class="text-xl lg:text-3xl">Confirming your email</h1>
		{:else if isError}
			<h1 class="text-xl lg:text-3xl">Whoops!</h1>
		{:else}
			<h1 class="text-xl lg:text-3xl">Email confirmed</h1>
		{/if}
		<div class="my-4"><!--spacer--></div>
		{#if loadingConfirm}
			<Loader5Line size={iconSize} class="text-zinc-400 dark:text-zinc-500 animate-spin" />
		{:else if isError}
			<CloseCircleLine size={iconSize} class="text-red-600" />
			<span>Something went wrong! Try again in a little bit.</span>
		{:else}
			<CheckboxCircleLine size={iconSize} class="text-green-700" />
			<span class="text-center">
				Everything's all set!<br />
				Now open up the Guide to log in and create your first profile!<br />
				Beyond that, you can now safely navigate away from this page.
			</span>
		{/if}
	</div>
</div>
