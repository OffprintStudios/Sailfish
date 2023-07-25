<script lang="ts">
	import { Button } from "$lib/ui/util";
	import {
		ArrowLeftSLine,
		ArrowRightSLine,
		InformationLine,
		EarthLine,
		FilterLine,
		PaletteLine,
		UserSettingsLine,
		Window2Line,
		ShieldUserLine,
		LinksLine,
		UserSmileLine,
		NotificationBadgeLine,
		GroupLine
	} from "svelte-remixicon";
	import { popPanel, pushPanel } from "$lib/ui/user/guide/guide.state";
	import { AboutPanel, FiltersPanel, LocalizationPanel, ThemesPanel } from "./general";
	import {
		AccountInfoPanel,
		SessionsPanel,
		SecurityAndPrivacyPanel,
		ConnectionsPanel
	} from "./account";
	import { ProfileInfoPanel, NotificationsPanel, SocialPanel } from "./profile";
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Back</span>
	</Button>
</div>
<h5 class="guide-section-header">General</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(AboutPanel)}>
		<InformationLine size="24px" class="mr-2" />
		<span>About</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(LocalizationPanel)}>
		<EarthLine size="24px" class="mr-2" />
		<span>Localization</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(FiltersPanel)}>
		<FilterLine size="24px" class="mr-2" />
		<span>Filters</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(ThemesPanel)}>
		<PaletteLine size="24px" class="mr-2" />
		<span>Themes</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
<h5 class="guide-section-header">Account</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(AccountInfoPanel)}>
		<UserSettingsLine size="24px" class="mr-2" />
		<span>Account Info</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SessionsPanel)}>
		<Window2Line size="24px" class="mr-2" />
		<span>Sessions</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SecurityAndPrivacyPanel)}>
		<ShieldUserLine size="24px" class="mr-2" />
		<span>Security & Privacy</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(ConnectionsPanel)}>
		<LinksLine size="24px" class="mr-2" />
		<span>Connections</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
<h5 class="guide-section-header">Profile</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(ProfileInfoPanel)}>
		<UserSmileLine size="24px" class="mr-2" />
		<span>Profile Info</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(NotificationsPanel)}>
		<NotificationBadgeLine size="24px" class="mr-2" />
		<span>Notifications</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SocialPanel)}>
		<GroupLine size="24px" class="mr-2" />
		<span>Social</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
