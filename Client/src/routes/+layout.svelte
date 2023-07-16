<script lang="ts">
	import "../app.scss";
	import { onMount } from "svelte";
	import { NavSideBar, NavTopBar } from "$lib/ui/nav";
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
	import { ThemePref } from "$lib/util/constants";

	export let data: { token: string | null } = { token: null };
	let loadingTerms = false;
	let loadingConfirm = false;

	onMount(() => {
		if (
			$app.brightness === "dark" ||
			(!($app.brightness === "dark") &&
				window.matchMedia("(prefers-color-scheme: dark)").matches)
		) {
			document.documentElement.classList.add("dark");
		} else {
			document.documentElement.classList.remove("dark");
		}
		document.documentElement.classList.replace(ThemePref.Crimson, $app.theme);
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
<NavTopBar />
<NavSideBar />
<main
	class="relative mt-[50px] lg:mt-[60px] lg:ml-[75px] h-[calc(100%-50px)] lg:h-[calc(100%-60px)] lg:overflow-y-scroll lg:scroll-smooth"
>
	<slot />
	<div class="h-4 lg:hidden"><!--spacer--></div>
</main>
<Toaster />
