<script lang="ts">
	import { Roles } from "$lib/models/accounts";
	import {
		RiAuctionLine,
		RiBookReadLine,
		RiBugLine,
		RiChatPrivateLine,
		RiCopperCoinLine,
		RiScales3Line,
		RiServiceLine,
		RiVipDiamondLine
	} from "svelte-remixicon";
	import { intersection } from "$lib/util/functions";

	export let roles: Roles[] = [];
	export let size: 'small' | 'normal' | 'large' = 'normal';

	function determineProminentRole() {
		// this will totally need retooling to figure out a much better way to verify what the top-level
		// role is
		const hasAdmin = intersection<Roles>(roles, [Roles.admin]);
		const hasModerator = intersection<Roles>(roles, [Roles.moderator]);
		const hasChatModerator = intersection<Roles>(roles, [Roles.chatModerator]);
		const hasContributor = intersection<Roles>(roles, [Roles.contributor]);
		const hasWorkApprover = intersection<Roles>(roles, [Roles.workApprover]);

		if (hasAdmin.length > 0) {
			return Roles.admin;
		} else if (hasModerator.length > 0) {
			return Roles.moderator;
		} else if (hasChatModerator.length > 0) {
			return Roles.chatModerator;
		} else if (hasContributor.length > 0) {
			return Roles.contributor;
		} else if (hasWorkApprover.length > 0) {
			return Roles.workApprover;
		} else {
			return Roles.user;
		}
	}
</script>

{#if determineProminentRole() === Roles.admin}
	<div class="role admin" class:small={size === 'small'} title="Admin">
		<RiAuctionLine class="badge-icon {size === 'large' ? 'mr-1.5' : ''}" />
		{#if size === 'large'}
            <span class="text-white font-bold tracking-wider uppercase text-[0.625rem] mr-1">
                Admin
            </span>
		{/if}
	</div>
{:else if determineProminentRole() === Roles.moderator}
	<div class="role moderator" class:small={size === 'small'} title="Moderator">
		<RiScales3Line class="badge-icon {size === 'large' ? 'mr-1.5' : ''}" />
		{#if size === 'large'}
            <span class="text-white font-bold tracking-wider uppercase text-[0.625rem] mr-1">
                Moderator
            </span>
		{/if}
	</div>
{:else if determineProminentRole() === Roles.chatModerator}
	<div class="role chat-moderator" class:small={size === 'small'} title="Chat Moderator">
		<RiChatPrivateLine class="badge-icon {size === 'large' ? 'mr-1.5' : ''}" />
		{#if size === 'large'}
            <span class="text-white font-bold tracking-wider uppercase text-[0.625rem] mr-1">
                Chat Moderator
            </span>
		{/if}
	</div>
{:else if determineProminentRole() === Roles.contributor}
	<div class="role contributor" class:small={size === 'small'} title="Contributor">
		<RiBugLine class="badge-icon {size === 'large' ? 'mr-1.5' : ''}" />
		{#if size === 'large'}
            <span class="text-white font-bold tracking-wider uppercase text-[0.625rem] mr-1">
                Maintainer
            </span>
		{/if}
	</div>
{:else if determineProminentRole() === Roles.workApprover}
	<div class="role work-approver" class:small={size === 'small'} title="Work Approver">
		<RiBookReadLine class="badge-icon {size === 'large' ? 'mr-1.5' : ''}" />
		{#if size === 'large'}
            <span class="text-white font-bold tracking-wider uppercase text-[0.625rem] mr-1">
                Work Approver
            </span>
		{/if}
	</div>
{/if}

<style lang="scss">
	div.role {
		@apply text-white rounded-md p-1 m-0.5 flex items-center w-fit;
		&.admin {
			@apply bg-red-700;
		}

		&.moderator {
			@apply bg-yellow-400;
		}

		&.chat-moderator {
			@apply bg-yellow-700;
		}

		&.contributor {
			@apply bg-blue-500;
		}

		&.work-approver {
			@apply bg-purple-600;
		}
	}
</style>
