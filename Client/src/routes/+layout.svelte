<script lang="ts">
	import "../app.scss";
	import { onMount } from "svelte";
	import { NavSideBar, NavTopBar } from "$lib/ui/nav";
	import { app } from "$lib/state/app.state";
	import toast, { Toaster } from "svelte-french-toast";
	import { account } from "$lib/state/account.state";
	import { Popup } from "$lib/ui/popup";
	import { activity } from "$lib/state/activity.state";
	import { Icon } from "svelte-remix";
	import { getReq, patchReq, type ResponseError } from "$lib/http";
	import Button from "$lib/ui/util/Button.svelte";
	import type { Account } from "$lib/models/accounts";
	import { ThemePref } from "$lib/util/constants";
	import { fly, fade } from "svelte/transition";
	import { cubicIn, cubicOut } from "svelte/easing";

	export let data: { token: string | null; pathname: string } = { token: null, pathname: "" };
	let loadingTerms = false;
	let loadingConfirm = false;

	onMount(async () => {
		if (
			$app.brightness === "dark" ||
			(!($app.brightness === "dark") &&
				window.matchMedia("(prefers-color-scheme: dark)").matches)
		) {
			document.documentElement.classList.add("dark");
		} else {
			document.documentElement.classList.remove("dark");
		}
		let theme = document.documentElement.classList.replace(ThemePref.Crimson, $app.theme);
		if (theme) {
			let themeColor = document.querySelector("meta[name='theme-color']");
			let accentColor = getComputedStyle(document.documentElement).getPropertyValue(
				"--accent"
			);
			themeColor?.setAttribute("content", accentColor);
		}

		await fetch(`/api/auth/set-profile?profileId=${$account.currProfile?.id}`, { method: "POST", credentials: "include" })
			.then(res => {
				if (res.status !== 200) {
					toast.error("Could not set profile ID!");
				}
			});
	});

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

	$: basePathname = data.pathname.split("/")[1];

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
{#if basePathname.startsWith("section")}
	<main class="relative h-full" transition:fade>
		<slot />
	</main>
{:else}
	<NavTopBar />
	<NavSideBar />
	{#key basePathname}
		<main
			class="relative mt-[50px] lg:mt-[60px] lg:ml-[75px] h-[calc(100%-50px)] lg:h-[calc(100%-60px)] lg:overflow-y-scroll lg:scroll-smooth"
			in:fly={{ easing: cubicOut, y: 10, delay: 400, duration: 300 }}
			out:fly={{ easing: cubicIn, y: -10, duration: 300 }}
		>
			<div>
				{#if $account.account && !$account.account.termsAgree}
					<div
						class="xl:max-w-4xl w-full flex flex-col lg:flex-row items-center mx-auto p-4 xl:mt-6 xl:rounded-xl bg-red-600 bg-opacity-25 border-y xl:border-x border-red-600"
					>
						<div class="flex-1">
							<div class="flex items-center">
								<Icon name="close-circle-line" width="18px" height="18px" class="mr-2" />
								<span class="font-bold text-lg">Head's Up!</span>
							</div>
							<span>
								You haven't agreed to Offprint's Terms of Service, Privacy Policy,
								and Code of Conduct. Until you do, all features of your account are
								locked. Hit the "I Agree" button to fix this ASAP.
							</span>
						</div>
						<Button
							on:click={agreeToTerms}
							loading={loadingTerms}
							loadingText="Saving..."
						>
							<Icon name="check-line" class="button-icon" />
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
								<Icon name="close-circle-line" width="18px" height="18px" class="mr-2" />
								<span class="font-bold text-lg">Head's Up!</span>
							</div>
							<span>
								You haven't confirmed your email address yet. Until you do, all
								features of your account are locked. Hit the "Confirm" button to fix
								this ASAP!
							</span>
						</div>
						<Button
							on:click={sendConfirmationEmail}
							loading={loadingConfirm}
							loadingText="Sending..."
						>
							<Icon name="check-line" class="button-icon" />
							<span class="button-text">Confirm</span>
						</Button>
					</div>
				{/if}
				<slot />
				<div class="h-4 lg:hidden"><!--spacer--></div>
			</div>
		</main>
	{/key}
{/if}

<Toaster />

<style lang="scss">
	main {
		display: grid;
		grid-template: 1fr / 1fr;
	}

	main > * {
		grid-area: 1 / 1;
	}
</style>
