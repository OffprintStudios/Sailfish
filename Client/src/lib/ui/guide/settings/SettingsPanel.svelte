<script lang="ts">
	import {
		ArrowRightSLine,
		EarthLine,
		FilterLine,
		InformationLine,
		PaletteLine,
		ShieldUserLine,
		UserSettingsLine,
		Window2Line,
		UserSmileLine,
		NotificationBadgeLine,
		GroupLine,
		LinksLine,
		ArrowLeftSLine
	} from "svelte-remixicon";
	import { nextPage, prevPage } from "../guide.state";
	import { AboutPanel, FiltersPanel, LocalizationPanel, ThemesPanel } from "./general";
	import {
		AccountInfoPanel,
		SecurityPrivacyPanel,
		SessionsPanel,
		ConnectionsPanel
	} from "./account";
	import { ProfileInfoPanel, NotificationsPanel, SocialPanel } from "./profile";
	import { account } from "$lib/state/account.state";
	import { Button } from "$lib/ui/util";

	const iconSize = "24px";
</script>

<div class="panel-container">
	<div class="topbar">
		<div class="left-button">
			<Button on:click={prevPage}>
				<ArrowLeftSLine class="button-icon" />
				<span class="button-text">Account</span>
			</Button>
		</div>
	</div>
	<div class="content-container">
		<!--General Settings-->
		<div class="panel-section">
			<h3>General</h3>
			<div>
				<button class="nav-button" on:click={() => nextPage(AboutPanel)}>
					<InformationLine size={iconSize} />
					<span>About</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
				<button class="nav-button" on:click={() => nextPage(LocalizationPanel)}>
					<EarthLine size={iconSize} />
					<span>Localization</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
				<button class="nav-button" on:click={() => nextPage(FiltersPanel)}>
					<FilterLine size={iconSize} />
					<span>Filters</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
				<button class="nav-button" on:click={() => nextPage(ThemesPanel)}>
					<PaletteLine size={iconSize} />
					<span>Themes</span>
					<ArrowRightSLine class="text-zinc-400" />
				</button>
			</div>
		</div>
		<!--Account Settings-->
		{#if $account.account !== null}
			<div class="panel-section">
				<h3>Account</h3>
				<div>
					<button class="nav-button" on:click={() => nextPage(AccountInfoPanel)}>
						<UserSettingsLine size={iconSize} />
						<span>Account Info</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
					<button class="nav-button" on:click={() => nextPage(SessionsPanel)}>
						<Window2Line size={iconSize} />
						<span>Sessions</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
					<button class="nav-button" on:click={() => nextPage(SecurityPrivacyPanel)}>
						<ShieldUserLine size={iconSize} />
						<span>Security & Privacy</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
					<button class="nav-button" on:click={() => nextPage(ConnectionsPanel)}>
						<LinksLine size={iconSize} />
						<span>Connections</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
				</div>
			</div>
		{/if}
		{#if $account.account !== null && $account.currProfile !== null}
			<div class="panel-section">
				<h3>Profile</h3>
				<div>
					<button class="nav-button" on:click={() => nextPage(ProfileInfoPanel)}>
						<UserSmileLine size={iconSize} />
						<span>Profile Info</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
					<button class="nav-button" on:click={() => nextPage(NotificationsPanel)}>
						<NotificationBadgeLine size={iconSize} />
						<span>Notifications</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
					<button class="nav-button" on:click={() => nextPage(SocialPanel)}>
						<GroupLine size={iconSize} />
						<span>Social</span>
						<ArrowRightSLine class="text-zinc-400" />
					</button>
				</div>
			</div>
		{/if}
	</div>
</div>

<style lang="scss">
	@use "../Guide";
</style>
