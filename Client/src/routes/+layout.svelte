<script lang="ts">
	import "../app.scss";
	import { Nav, NavTopBar } from "$lib/ui/nav";
	import { app } from "$lib/state/app.state";
	import { Guide } from "$lib/ui/guide";
	import toast, { Toaster } from "svelte-french-toast";
	import { account } from "$lib/state/account.state";
	import { Popup } from "$lib/ui/popup";
	import { activity } from "$lib/state/activity.state";
	import { CheckLine, CloseCircleLine } from "svelte-remixicon";
	import { getReq, patchReq, type ResponseError } from "$lib/http";
	import Button from "$lib/ui/util/Button.svelte";
	import type { Account } from "$lib/models/accounts";

	export let data: { token: string | null } = { token: null };
	let loadingTerms = false;
	let loadingConfirm = false;

	if (data.token) {
		$account.token = data.token;
	} else {
		$account.account = null;
		$account.currProfile = null;
		$account.profiles = [];
		$account.token = null;
		$activity.count = 0;
		$activity.markAsRead = [];
	}

	async function agreeToTerms() {
		if ($account.account) {
			loadingTerms = true;
			const response = await patchReq<Account>(`/accounts/agree-to-terms`, {});
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				$account.account = response as Account;
			}
			loadingTerms = false;
		} else {
			toast.error(`You must be logged in to use this feature.`);
		}
	}

	async function sendConfirmationEmail() {
		if ($account.account) {
			loadingConfirm = true;
			const response = await getReq<void>(`/accounts/send-confirmation-email`);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				toast.success(`Check your inbox/spam inbox for the confirmation email!`);
			}
			loadingConfirm = false;
		} else {
			toast.error(`You must be logged in to use this feature.`);
		}
	}
</script>

<Popup />
<main
	class="flex flex-col overflow-y-auto {$app.theme}"
	class:light={$app.darkMode === false}
	class:dark={$app.darkMode === true}
>
	<NavTopBar />
	<div
		class="flex overflow-y-hidden lg:h-[calc(100vh-60px)]"
		style="background: var(--background);"
	>
		<Nav />
		<Guide>
			{#if $account.account && !$account.account.termsAgree}
				<div
					class="xl:max-w-4xl w-full flex flex-col lg:flex-row items-center mx-auto p-4 xl:mt-6 xl:rounded-xl bg-red-600 bg-opacity-25 border-y xl:border-x border-red-600"
				>
					<div class="flex-1">
						<div class="flex items-center">
							<CloseCircleLine size="18px" class="mr-2" />
							<span class="font-bold text-lg">Head's Up!</span>
						</div>
						<span>
							You haven't agreed to Offprint's Terms of Service, Privacy Policy, and
							Code of Conduct. Until you do, all features of your account are locked.
							Hit the "I Agree" button to fix this ASAP.
						</span>
					</div>
					<Button on:click={agreeToTerms} loading={loadingTerms} loadingText="Saving...">
						<CheckLine class="button-icon" />
						<span class="button-text">I agree</span>
					</Button>
				</div>
			{/if}
			{#if $account.account && !$account.account.emailConfirmed}
				<div
					class="xl:max-w-4xl w-full flex flex-col lg:flex-row items-center mx-auto p-4 xl:mt-6 xl:rounded-xl bg-red-600 bg-opacity-25 border-y xl:border-x border-red-600"
				>
					<div class="flex-1">
						<div class="flex items-center">
							<CloseCircleLine size="18px" class="mr-2" />
							<span class="font-bold text-lg">Head's Up!</span>
						</div>
						<span>
							You haven't confirmed your email address yet. Until you do, all features
							of your account are locked. Hit the "Confirm" button to fix this ASAP!
						</span>
					</div>
					<Button
						on:click={sendConfirmationEmail}
						loading={loadingConfirm}
						loadingText="Sending..."
					>
						<CheckLine class="button-icon" />
						<span class="button-text">Confirm</span>
					</Button>
				</div>
			{/if}
			<div class="w-full overflow-y-auto lg:h-[calc(100vh-60px)]">
				<slot />
			</div>
		</Guide>
	</div>
	<Toaster />
</main>

<style lang="scss">
	:global(main) {
		color: var(--text-color);
		font-family: var(--body-text);
		background: var(--background);
		@apply transition transform relative;
	}
</style>
