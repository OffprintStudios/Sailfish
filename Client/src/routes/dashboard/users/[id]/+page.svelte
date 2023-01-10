<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import { RoleBadge, Time, Button } from "$lib/ui/util";
	import { pluralize, hasRoles } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import {
		AlertLine,
		CheckboxCircleLine,
		CriminalLine,
		EmotionLine,
		EmotionNormalLine,
		EmotionUnhappyLine,
		ErrorWarningLine,
		Skull2Line,
		VolumeMuteLine,
		ForbidLine
	} from "svelte-remixicon";
	import ReportLog from "./ReportLog.svelte";
	import Notes from "./Notes.svelte";
	import Profiles from "./Profiles.svelte";
	import AuditLog from "./AuditLog.svelte";
	import { Roles } from "$lib/models/accounts";
	import toast from "svelte-french-toast";
	import { openPopup } from "$lib/ui/popup";
	import WarnPrompt from "./WarnPrompt.svelte";
	import { goto } from "$app/navigation";
	import MutePrompt from "./MutePrompt.svelte";
	import BanPrompt from "./BanPrompt.svelte";

	export let data: AccountWithReports;
	const iconSize = "50px";

	async function warnUser() {
		if (canAction()) {
			openPopup(
				WarnPrompt,
				{ onConfirm: () => goto(`/dashboard/users`) },
				{
					accountId: data.id
				}
			);
		} else {
			toast.error(`Insufficient privileges.`);
		}
	}

	async function muteUser() {
		if (canAction()) {
			openPopup(
				MutePrompt,
				{ onConfirm: () => goto(`/dashboard/users`) },
				{
					accountId: data.id
				}
			);
		} else {
			toast.error(`Insufficient privileges.`);
		}
	}

	async function banUser() {
		if (canAction()) {
			openPopup(
				BanPrompt,
				{ onConfirm: () => goto(`/dashboard/users`) },
				{
					accountId: data.id
				}
			);
		} else {
			toast.error(`Insufficient privileges.`);
		}
	}

	function canAction(): boolean {
		if ($account.account) {
			if (hasRoles(data.roles, [Roles.Admin])) {
				// if the account being actioned is an admin, return false
				return false;
			} else if (
				hasRoles(data.roles, [Roles.Moderator]) &&
				hasRoles($account.account.roles, [Roles.Moderator])
			) {
				// if a moderator is trying to action another moderator, return false
				return false;
			} else {
				// if an action is being done to any other type of account, return true
				return true;
			}
		}
		return false;
	}
</script>

<div class="w-11/12 lg:w-full max-w-6xl mx-auto mb-6">
	<div class="account-header bg-zinc-200 dark:bg-zinc-700">
		<div class="flex items-center mb-4">
			<div class="font-mono text-lg font-bold relative top-0.5">Account ID: {data.id}</div>
			<div class="relative ml-2">
				<RoleBadge roles={data.roles} size="large" />
			</div>
			<div class="flex-1"><!--spacer--></div>
			<Button on:click={warnUser}>
				<ErrorWarningLine class="button-icon" />
				<span class="button-text">Warn</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button on:click={muteUser}>
				<VolumeMuteLine class="button-icon" />
				<span class="button-text">Mute</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button on:click={banUser}>
				<ForbidLine class="button-icon" />
				<span class="button-text">Ban</span>
			</Button>
		</div>
		<div class="flex items-center">
			<div
				class="info-block bg-zinc-300 dark:bg-zinc-600"
				class:good-standing={data.total === 0}
				class:negligible-concern={data.total >= 1 && data.total < 3}
				class:possible-issue={data.total >= 3 && data.total < 5}
				class:brow-raising={data.total >= 5 && data.total < 7}
				class:needs-attention={data.total >= 7}
			>
				{#if data.total >= 7}
					<Skull2Line size={iconSize} class="mr-2" />
					<div style="font-family: var(--header-text);">
						<div class="flex items-end relative top-1">
							<span class="text-3xl relative top-1 mr-1">{data.total}</span>
							<span class="relative -top-[0.075rem]"
								>report{pluralize(data.total)}</span
							>
						</div>
						<div class="relative -top-1 all-small-caps text-xl font-bold">
							Needs Attention
						</div>
					</div>
				{:else if data.total >= 5}
					<CriminalLine size={iconSize} class="mr-2" />
					<div style="font-family: var(--header-text);">
						<div class="flex items-end relative top-1">
							<span class="text-3xl relative top-1 mr-1">{data.total}</span>
							<span class="relative -top-[0.075rem]"
								>report{pluralize(data.total)}</span
							>
						</div>
						<div class="relative -top-1 all-small-caps text-xl font-bold">
							Brow-Raising
						</div>
					</div>
				{:else if data.total >= 3}
					<EmotionUnhappyLine size={iconSize} class="mr-2" />
					<div style="font-family: var(--header-text);">
						<div class="flex items-end relative top-1">
							<span class="text-3xl relative top-1 mr-1">{data.total}</span>
							<span class="relative -top-[0.075rem]"
								>report{pluralize(data.total)}</span
							>
						</div>
						<div class="relative -top-1 all-small-caps text-xl font-bold">
							Possible Issue
						</div>
					</div>
				{:else if data.total >= 1}
					<EmotionNormalLine size={iconSize} class="mr-2" />
					<div style="font-family: var(--header-text);">
						<div class="flex items-end relative top-1">
							<span class="text-3xl relative top-1 mr-1">{data.total}</span>
							<span class="relative -top-[0.075rem]"
								>report{pluralize(data.total)}</span
							>
						</div>
						<div class="relative -top-1 all-small-caps text-xl font-bold">
							Negligible Concern
						</div>
					</div>
				{:else}
					<EmotionLine size={iconSize} class="mr-2" />
					<div style="font-family: var(--header-text);">
						<div class="flex items-end relative top-1">
							<span class="text-3xl relative top-1 mr-1">{data.total}</span>
							<span class="relative -top-[0.075rem]"
								>report{pluralize(data.total)}</span
							>
						</div>
						<div class="relative -top-1 all-small-caps text-xl font-bold">
							Good Standing
						</div>
					</div>
				{/if}
			</div>
			<div class="flex-1"><!--spacer--></div>
			<div class="info-block bg-zinc-300 dark:bg-zinc-600">
				<div>
					<div class="flex items-center text-2xl relative top-1.5">
						{#if data.terms_agree === true}
							<span class="flex-1"> Yes </span>
							<CheckboxCircleLine
								class="text-green-600 relative -top-1"
								size="32px"
							/>
						{:else}
							<span class="flex-1"> No </span>
							<AlertLine class="text-yellow-500 relative -top-1" size="32px" />
						{/if}
					</div>
					<div class="relative -top-0.5 all-small-caps text-xl font-bold">
						Agreed to Terms
					</div>
				</div>
			</div>
			<div class="info-block bg-zinc-300 dark:bg-zinc-600">
				<div>
					<div class="flex items-center text-2xl relative top-1.5">
						{#if data.email_confirmed === true}
							<span class="flex-1"> Yes </span>
							<CheckboxCircleLine
								class="text-green-600 relative -top-1"
								size="32px"
							/>
						{:else}
							<span class="flex-1"> No </span>
							<AlertLine class="text-yellow-500 relative -top-1" size="32px" />
						{/if}
					</div>
					<div class="relative -top-0.5 all-small-caps text-xl font-bold">
						Email Confirmed
					</div>
				</div>
			</div>
			<div class="info-block bg-zinc-300 dark:bg-zinc-600">
				<div>
					<div class="text-2xl relative top-1.5">
						<Time timestamp={data.createdAt} />
					</div>
					<div class="relative -top-0.5 all-small-caps text-xl font-bold">Created</div>
				</div>
			</div>
		</div>
	</div>
	<div class="mb-6">
		<Profiles account={data} />
	</div>
	<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
		<div class="row-span-2">
			<ReportLog account={data} />
		</div>
		<div class="row-span-2">
			<AuditLog account={data} />
		</div>
		<div class="row-span-2">
			<Notes account={data} />
		</div>
	</div>
</div>

<style lang="scss">
	div.account-header {
		@apply rounded-xl p-4 mb-6;
	}
	div.info-block {
		@apply flex items-center rounded-xl h-[70px] px-2 py-0.5 w-fit mx-1 first:ml-0 last:mr-0;
		font-family: var(--header-text);
	}
	div.good-standing {
		@apply text-white bg-green-700;
	}
	div.negligible-concern {
		@apply bg-yellow-700 text-white;
	}
	div.possible-issue {
		@apply bg-orange-700 text-white;
	}
	div.brow-raising {
		@apply bg-rose-700 text-white;
	}
	div.needs-attention {
		@apply bg-red-700 text-white;
	}
</style>
