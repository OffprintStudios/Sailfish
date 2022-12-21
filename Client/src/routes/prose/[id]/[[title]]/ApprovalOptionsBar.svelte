<script lang="ts">
	import type { ApprovalQueue, ProvideReason } from "$lib/models/admin/approval-queue";
	import { CheckLine, CloseLine, Loader5Line } from "svelte-remixicon";
	import { goto } from "$app/navigation";
	import { NavLink } from "$lib/ui/nav";
	import { Avatar } from "$lib/ui/util";
	import { openPopup } from "$lib/ui/popup";
	import { patchReq } from "$lib/http";
	import { account } from "$lib/state/account.state";
	import type { ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import RejectWorkPrompt from "./RejectWorkPrompt.svelte";

	export let queueItem: ApprovalQueue;
	let loading = false;

	async function approveWork() {
		loading = true;
		const response = await toast.promise(
			patchReq<void>(
				`/approval-queue/approve?itemId=${queueItem.id}&profileId=${$account.currProfile?.id}`,
				{}
			),
			{
				loading: "Registering decision...",
				success: "Decision saved!",
				error: null
			}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await goto(`/dashboard/approval-queue`);
		}
		loading = false;
	}

	async function rejectWork() {
		openPopup(RejectWorkPrompt, {
			onConfirm: async (data: ProvideReason) => {
				loading = true;
				const response = await toast.promise(
					patchReq<void>(
						`/approval-queue/reject?itemId=${queueItem.id}&profileId=${$account.currProfile?.id}`,
						data
					),
					{
						loading: "Registering decision...",
						success: "Decision saved!",
						error: null
					}
				);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					await goto(`/dashboard/approval-queue`);
				}
				loading = false;
			}
		});
	}
</script>

<div
	class="flex items-center rounded-xl p-2 max-w-xl mx-auto mb-6 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<div class="flex-1 flex items-center">
		<Avatar src={queueItem.claimedBy.avatar} size="50px" borderWidth="1px" />
		<span
			class="text-zinc-400 text-2xl relative top-0.5 ml-2"
			style="font-family: var(--header-text);"
		>
			{queueItem.claimedBy.username}
		</span>
	</div>
	{#if loading}
		<NavLink type="button">
			<Loader5Line class="link-icon animate-spin" />
			<span class="link-name">Saving</span>
		</NavLink>
	{:else}
		<NavLink type="button" on:click={approveWork}>
			<CheckLine class="link-icon" />
			<span class="link-name">Approve</span>
		</NavLink>
		<div class="mx-0.5"><!--spacer--></div>
		<NavLink type="button" on:click={rejectWork}>
			<CloseLine class="link-icon" />
			<span class="link-name">Reject</span>
		</NavLink>
	{/if}
</div>
