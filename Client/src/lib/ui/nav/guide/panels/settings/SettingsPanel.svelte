<script lang="ts">
	import { Button } from "$lib/ui/util";
	import {
		RiArrowLeftSLine,
		RiArrowRightSLine,
		RiInformationLine,
		RiEarthLine,
		RiFilterLine,
		RiPaletteLine,
		RiUserSettingsLine,
		RiWindow2Line,
		RiShieldUserLine,
		RiLinksLine,
		RiUserSmileLine,
		RiNotificationBadgeLine,
		RiGroupLine
	} from "svelte-remixicon";
	import { popPanel, pushPanel } from "../../guide.state";
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
	<Button id="back-button" title="Go Back" on:click={popPanel}>
		<span class="button-icon"><RiArrowLeftSLine /></span>
		<span class="button-text">Back</span>
	</Button>
</div>
<h5 class="guide-section-header">General</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(AboutPanel)}>
		<RiInformationLine size="24px" class="mr-2" />
		<span>About</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(LocalizationPanel)}>
		<RiEarthLine size="24px" class="mr-2" />
		<span>Localization</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(FiltersPanel)}>
		<RiFilterLine size="24px" class="mr-2" />
		<span>Filters</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(ThemesPanel)}>
		<RiPaletteLine size="24px" class="mr-2" />
		<span>Themes</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
<h5 class="guide-section-header">Account</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(AccountInfoPanel)}>
		<RiUserSettingsLine size="24px" class="mr-2" />
		<span>Account Info</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SessionsPanel)}>
		<RiWindow2Line size="24px" class="mr-2" />
		<span>Sessions</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SecurityAndPrivacyPanel)}>
		<RiShieldUserLine size="24px" class="mr-2" />
		<span>Security & Privacy</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(ConnectionsPanel)}>
		<RiLinksLine size="24px" class="mr-2" />
		<span>Connections</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
<h5 class="guide-section-header">Profile</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(ProfileInfoPanel)}>
		<RiUserSmileLine size="24px" class="mr-2" />
		<span>Profile Info</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(NotificationsPanel)}>
		<RiNotificationBadgeLine size="24px" class="mr-2" />
		<span>Notifications</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(SocialPanel)}>
		<RiGroupLine size="24px" class="mr-2" />
		<span>Social</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
