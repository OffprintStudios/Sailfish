<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import { navigating } from "$app/stores";
	import { slide } from "svelte/transition";
	import { throttle, clickOutside } from "$lib/util/functions";
	import { Notification2Line, CheckLine } from "svelte-remixicon";
	import { activity } from "$lib/state/activity.state";
	import { Button, CountBadge } from "$lib/ui/util";
	import { NotificationCard } from "$lib/ui/content";
	import { account } from "$lib/state/account.state";
	import type { Paginate } from "$lib/util/types";
	import type { MarkAsRead, Notification } from "$lib/models/notifications";
	import { getReq, postReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	export let open = false;

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
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

	async function fetchActivity(newPage: number) {
		loading = true;
		const response = await getReq<Paginate<Notification>>(
			`/notifications/fetch-activity?profileId=${$account.currProfile?.id}&page=${newPage}&per=20`
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

	async function switchState() {
		open = !open;
		if (open) {
			await fetchActivity(1);
		}
	}

	let throttled = throttle(switchState, 150);

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom-end",
				middleware: [offset({ mainAxis: 23 }), flip(), shift()]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}
</script>

<div class="relative z-[2]">
	<Button
		on:click={throttled}
		bind:thisButton={button}
		isActive={open}
		disabled={!$account.currProfile}
		kind="primary"
	>
		{#if $activity.count > 0}
			<CountBadge value={$activity.count} />
		{/if}
		<Notification2Line class="button-icon no-text" size="22px" />
	</Button>
	{#if open}
		<div
			class="activity-dropdown bg-zinc-200 dark:bg-zinc-700"
			transition:slide={{ delay: 0, duration: 150, x: 200 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={throttled}
		>
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
				</div>
			{/if}
		</div>
	{/if}
</div>

<style lang="scss">
	div.activity-dropdown {
		@apply absolute rounded-2xl z-50 max-h-[calc(100vh-80px)] p-1 w-[calc(100vw-50px)] lg:w-[375px] overflow-hidden overflow-y-scroll;
	}
</style>
