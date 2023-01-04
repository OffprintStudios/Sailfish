<script lang="ts">
	import { EventType, type Notification } from "$lib/models/notifications";
	import {
		CheckLine,
		EyeLine,
		StarLine,
		BookmarkLine,
		DiscussLine,
		ErrorWarningLine,
		VolumeMuteLine,
		ForbidLine,
		CheckboxBlankCircleLine,
		CheckboxCircleLine,
		CloseLine
	} from "svelte-remixicon";
	import { activity } from "$lib/state/activity.state";
	import { slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import { Button } from "$lib/ui/util";

	export let notification: Notification;
	const iconSize = "24px";

	function markToRead() {
		if ($activity.markAsRead.includes(notification.id)) {
			$activity.markAsRead = $activity.markAsRead.filter(
				(value) => value !== notification.id
			);
		} else {
			$activity.markAsRead = [...$activity.markAsRead, notification.id];
		}
	}
</script>

<div
	class="flex flex-col relative rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
>
	{#if notification.from}
		{#if notification.eventType === EventType.follow}
			<a
				class="hidden-link"
				href="/profile/{notification.from.id}/{slugify(notification.from.username)}"
				><!--left intentionally blank--></a
			>
			<div class="flex items-center px-2 py-1">
				<EyeLine size={iconSize} class="mr-2" />
				<span class="activity-title">New Follower</span>
				<div class="flex-1"><!--spacer--></div>
				<Button on:click={markToRead}>
					{#if $activity.markAsRead.includes(notification.id)}
						<CheckboxCircleLine class="button-icon no-text" />
					{:else}
						<CheckboxBlankCircleLine class="button-icon no-text" />
					{/if}
				</Button>
			</div>
			<div class="activity-description">
				{notification.from.username} has followed you!
			</div>
		{:else if notification.eventType === EventType.addFavorite}
			<a
				class="hidden-link"
				href="/profile/{notification.to.id}/{slugify(
					$account.currProfile?.username
				)}/blog/{notification.entityId}/{slugify(notification.context['title'])}"
				><!--left intentionally blank--></a
			>
			<div class="flex items-center px-2 py-1">
				<StarLine size={iconSize} class="mr-2" />
				<span class="activity-title">New Favorite</span>
				<div class="flex-1"><!--spacer--></div>
				<Button on:click={markToRead}>
					{#if $activity.markAsRead.includes(notification.id)}
						<CheckboxCircleLine class="button-icon no-text" />
					{:else}
						<CheckboxBlankCircleLine class="button-icon no-text" />
					{/if}
				</Button>
			</div>
			<div class="activity-description">
				{notification.from.username} has added "{notification.context["title"]}" to their
				favorites!
			</div>
		{:else if notification.eventType === EventType.addToLibrary}
			<a
				class="hidden-link"
				href="/prose/{notification.entityId}/{slugify(notification.context['title'])}"
				><!--left intentionally blank--></a
			>
			<div class="flex items-center px-2 py-1">
				<BookmarkLine size={iconSize} class="mr-2" />
				<span class="activity-title">Added to Library</span>
				<div class="flex-1"><!--spacer--></div>
				<Button on:click={markToRead}>
					{#if $activity.markAsRead.includes(notification.id)}
						<CheckboxCircleLine class="button-icon no-text" />
					{:else}
						<CheckboxBlankCircleLine class="button-icon no-text" />
					{/if}
				</Button>
			</div>
			<div class="activity-description">
				{notification.from.username} has added "{notification.context["title"]}" to their
				library!
			</div>
		{:else if notification.eventType === EventType.newBlogComment || notification.eventType === EventType.newWorkComment}
			<a class="hidden-link" href={notification.context["url"]}>
				<!--left intentionally blank-->
			</a>
			<div class="flex items-center px-2 py-1">
				<DiscussLine size={iconSize} class="mr-2" />
				<span class="activity-title">New Comment</span>
				<div class="flex-1"><!--spacer--></div>
				<Button on:click={markToRead}>
					{#if $activity.markAsRead.includes(notification.id)}
						<CheckboxCircleLine class="button-icon no-text" />
					{:else}
						<CheckboxBlankCircleLine class="button-icon no-text" />
					{/if}
				</Button>
			</div>
			<div class="activity-description">
				{notification.from.username} has commented on "{notification.context["title"]}"!
			</div>
		{/if}
	{:else if notification.eventType === EventType.workApproved}
		<a
			class="hidden-link"
			href="/prose/{notification.entityId}/{slugify(notification.context['title'])}"
			><!--left intentionally blank--></a
		>
		<div class="flex items-center px-2 py-1">
			<CheckLine size={iconSize} class="mr-2" />
			<span class="activity-title">Work Approved</span>
			<div class="flex-1"><!--spacer--></div>
			<Button on:click={markToRead}>
				{#if $activity.markAsRead.includes(notification.id)}
					<CheckboxCircleLine class="button-icon no-text" />
				{:else}
					<CheckboxBlankCircleLine class="button-icon no-text" />
				{/if}
			</Button>
		</div>
		<div class="activity-description">
			Your work, "{notification.context.get("title")}", has been approved!
		</div>
	{:else if notification.eventType === EventType.workRejected}
		<a
			class="hidden-link"
			href="/prose/{notification.entityId}/{slugify(notification.context['title'])}"
			><!--left intentionally blank--></a
		>
		<div class="flex items-center px-2 py-1">
			<CloseLine size={iconSize} class="mr-2" />
			<span class="activity-title">Work Rejected</span>
			<div class="flex-1"><!--spacer--></div>
			<Button on:click={markToRead}>
				{#if $activity.markAsRead.includes(notification.id)}
					<CheckboxCircleLine class="button-icon no-text" />
				{:else}
					<CheckboxBlankCircleLine class="button-icon no-text" />
				{/if}
			</Button>
		</div>
		<div class="activity-description flex flex-col">
			<span
				>Your work, "{notification.context["title"]}", has been rejected for the following
				reason(s):</span
			>
			<span>{notification.context["reason"]}</span>
		</div>
	{:else if notification.eventType === EventType.userWarned}
		<div class="flex items-center p-2">
			<ErrorWarningLine size={iconSize} class="mr-2" />
			<span class="activity-title">Account Warned</span>
		</div>
		<div class="activity-description flex flex-col">
			<span>A member of staff has issued you the following warning:</span>
			<span>{notification.context["reason"]}</span>
		</div>
	{:else if notification.eventType === EventType.userMuted}
		<div class="flex items-center p-2">
			<VolumeMuteLine size={iconSize} class="mr-2" />
			<span class="activity-title">Account Muted</span>
		</div>
		<div class="activity-description flex flex-col">
			<span>Your account has been muted for the following reason:</span>
			<span>{notification.context["reason"]}</span>
			<span>Duration: {notification.context["duration"]}</span>
		</div>
	{:else if notification.eventType === EventType.userBanned}
		<div class="flex items-center p-2">
			<ForbidLine size={iconSize} class="mr-2" />
			<span class="activity-title">Account Banned</span>
		</div>
		<div class="activity-description flex flex-col">
			<span>Your account has been banned for the following reason:</span>
			<span>{notification.context["reason"]}</span>
			<span>Duration: {notification.context["duration"]}</span>
		</div>
	{/if}
</div>

<style lang="scss">
	a.hidden-link {
		@apply absolute h-full w-full no-underline;
	}
	span.activity-title {
		@apply all-small-caps font-bold tracking-wider text-base relative -top-0.5;
	}
	div.activity-description {
		@apply text-xs px-4 pb-2;
	}
</style>
