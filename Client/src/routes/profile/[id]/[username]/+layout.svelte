<script lang="ts">
	import { page } from "$app/stores";
	import { Home5Line, CupLine, QuillPenLine, BarChart2Line, ImageEditLine, ImageAddLine, ServiceLine, AlarmWarningLine, CloseCircleLine, PieChartLine } from "svelte-remixicon";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { Button } from "$lib/ui/util";
	import { profileState } from "$lib/state/profile.state";
	import { account } from "$lib/state/account.state";
	import type { Profile } from "$lib/models/accounts";
	import { NavLink } from "../../../../lib/ui/nav";

	export let data: Profile;

	$profileState = data;

	const iconSize = "24px";
</script>

<div class="w-11/12 mx-auto max-w-7xl mb-6">
	<div class="profile-nav-container">
		{#if data.info.coverPic}
			{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
				<div class="absolute top-2 right-2">
					<Button kind="primary">
						<ImageEditLine class="button-icon no-text" size="20px" />
					</Button>
				</div>
			{/if}
			<div class="profile-cover">
				<img src={data.info.coverPic} alt="{data.username}'s Cover Picture" />
			</div>
		{:else}
			<div class="profile-banner">
				{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
					<div class="absolute top-2 right-2">
						<Button kind="primary">
							<ImageAddLine class="button-icon no-text" size="20px" />
						</Button>
					</div>
				{/if}
			</div>
		{/if}
		<div class="profile-nav bg-zinc-200 dark:bg-zinc-700">
			<Avatar src={data.avatar} size="150px" borderWidth="2px" />
			<div class="lg:ml-4 self-center">
				<div class="flex flex-col lg:flex-row items-center">
					<h3>{data.username}</h3>
					<RoleBadge roles={data.account.roles} size="large" />
				</div>
				<div class="flex items-center mt-2 lg:mt-0 text-xs">
					<a
						class="text-zinc-800 dark:text-white no-underline"
						href="/profile/{data.id}/{slugify(data.username)}/followers"
					>
						0 followers
					</a>
					<span class="text-zinc-800 dark:text-white mx-1">•</span>
					<a
						class="text-zinc-800 dark:text-white no-underline"
						href="/profile/{data.id}/{slugify(data.username)}/following"
					>
						0 following
					</a>
				</div>
			</div>
			<div class="flex-1"><!--spacer--></div>
			<div class="flex items-center justify-center mt-4 lg:mt-0 lg:justify-end">
				<NavLink href="/profile/{data.id}/{slugify(data.username)}">
					<Home5Line class="link-icon" />
					<span class="link-name">Home</span>
				</NavLink>
				<NavLink href="/profile/{data.id}/{slugify(data.username)}/blogs">
					<CupLine class="link-icon" />
					<span class="link-name">Blogs</span>
				</NavLink>
				<NavLink href="/profile/{data.id}/{slugify(data.username)}/works">
					<QuillPenLine class="link-icon" />
					<span class="link-name">Works</span>
				</NavLink>
				<NavLink href="/profile/{data.id}/{slugify(data.username)}/shelves">
					<BarChart2Line class="link-icon" />
					<span class="link-name">Shelves</span>
				</NavLink>
			</div>
			{#if $account.account && $account.currProfile}
				{#if $account.currProfile.id === data.id}
					<div class="h-full mx-1 border border-zinc-300 dark:border-zinc-500"><!--spacer--></div>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><PieChartLine size={iconSize} /></span>
						<span class="link-name">Stats</span>
					</button>
				{:else}
					<div class="h-full mx-1 border border-zinc-300"><!--spacer--></div>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><ServiceLine size={iconSize} /></span>
						<span class="link-name">Follow</span>
					</button>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><CloseCircleLine size={iconSize} /></span>
						<span class="link-name">Block</span>
					</button>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><AlarmWarningLine size={iconSize} /></span>
						<span class="link-name">Report</span>
					</button>
				{/if}
			{/if}
		</div>
	</div>

	<slot />
</div>

<style lang="scss">
	div.profile-nav-container {
		@apply flex flex-col w-full my-6;
		div.profile-banner {
			@apply h-[92px] w-full rounded-t-xl relative;
			background: var(--accent);
		}
		div.profile-cover {
			@apply h-[240px] w-full overflow-hidden rounded-t-xl;
			img {
				@apply object-cover w-full h-full;
			}
		}
		div.profile-nav {
			@apply flex flex-col items-center justify-center lg:flex-row lg:items-end lg:justify-end px-1.5 py-2 rounded-b-xl lg:h-[77px] relative z-10;
			h3 {
				@apply text-3xl lg:text-4xl lg:mr-2;
			}
			a.link, button.link {
				@apply mx-0.5 rounded-lg transition transform;
				@apply flex flex-col items-center justify-center w-[61px] h-[61px] relative;
				color: var(--text-color);
				&:active {
					@apply scale-95;
				}
				&.active {
					@apply no-underline text-white;
					background: var(--accent);
				}
				span.link-name {
					@apply text-[0.6rem] uppercase font-bold tracking-wider;
				}
			}
		}
	}
</style>
