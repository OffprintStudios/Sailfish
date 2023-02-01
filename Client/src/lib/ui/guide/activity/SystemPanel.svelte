<script lang="ts">
	import { onMount } from "svelte";
	import { getReq, postReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { MarkAsRead, Notification } from "$lib/models/notifications";
	import { account } from "$lib/state/account.state";
	import { NotificationCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";
	import Button from "$lib/ui/util/Button.svelte";
	import { CheckLine } from "svelte-remixicon";
	import { Paginator } from "$lib/ui/util";
	import { activity } from "$lib/state/activity.state";

	let loading = false;
	let saving = false;
	let currPage: Paginate<Notification> = {
		items: [],
		metadata: {
			page: 1,
			per: 20,
			total: 0
		}
	};

	onMount(async () => {
		await fetchActivity(1);
	});

	async function fetchActivity(newPage: number) {
		loading = true;
		const response = await getReq<Paginate<Notification>>(
			`/notifications/fetch-system-activity?profileId=${$account.currProfile?.id}&page=${newPage}&per=20`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			currPage = response as Paginate<Notification>;
		}
		loading = false;
	}

	async function markAsRead() {
		saving = true;
		const toMark: MarkAsRead = {
			ids: $activity.markAsRead
		};
		const response = await postReq<void>(
			`/notifications/mark-as-read?profileId=${$account.currProfile?.id}`,
			toMark
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await fetchActivity(1);
		}
		saving = false;
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else if currPage.metadata.total === 0}
	<div class="empty">
		<h3>Nothing's happened yet</h3>
		<p>Check back later once a new notification pops up!</p>
	</div>
{:else}
	<div class="flex flex-col mx-4 mt-2 mb-4 h-full">
		<div class="flex items-center justify-center mb-2">
			<Button
				loading={saving}
				loadingText="Marking..."
				disabled={$activity.markAsRead.length === 0}
				on:click={markAsRead}
			>
				<CheckLine class="button-icon" />
				<span class="button-text">Mark As Read</span>
			</Button>
		</div>
		{#each currPage.items as notification}
			<div class="my-1 first:mt-0 last:mb-0">
				<NotificationCard {notification} />
			</div>
		{/each}
		<div class="flex-1"><!--spacer--></div>
		<Paginator
			currPage={currPage.metadata.page}
			perPage={currPage.metadata.per}
			totalItems={currPage.metadata.total}
			on:change={(event) => fetchActivity(event.detail)}
		/>
	</div>
{/if}
