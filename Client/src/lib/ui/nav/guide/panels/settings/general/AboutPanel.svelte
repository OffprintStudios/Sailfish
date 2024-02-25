<script lang="ts">
	import { popPanel } from "../../../guide.state";
	import { copyToClipboard } from "$lib/util/functions";
	import { VERSION } from "$lib/util/constants";
	import {
		RiArrowLeftSLine,
		RiArticleLine,
		RiCodeLine,
		RiCupFill,
		RiDiscordFill,
		RiExternalLinkLine,
        RiLink,
		RiFilePaper2Line,
		RiGithubFill,
		RiHeartLine,
		RiLock2Line,
		RiMastodonFill,
		RiNewspaperLine,
		RiPatreonFill,
		RiQuestionLine
	} from "svelte-remixicon";
	import { Button } from "$lib/ui/util";

	const iconSize = "24px";
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button id="back-button" title="Go Back" on:click={popPanel}>
		<span class="button-icon"><RiArrowLeftSLine /></span>
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">Info</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => copyToClipboard(VERSION)}>
		<RiCodeLine size={iconSize} class="mr-2" />
		<span>Version</span>
		<span
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
			style="text-align: right;">{VERSION}</span
		>
	</button>
</div>
<h5 class="guide-section-header">Docs</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<a
		class="guide-button group"
		href="/docs/terms-of-service"
	>
		<RiNewspaperLine size={iconSize} class="mr-2" />
		<span>Terms of Service</span>
		<RiLink
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="/docs/privacy-policy"
	>
		<RiLock2Line size={iconSize} class="mr-2" />
		<span>Privacy Policy</span>
		<RiLink
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="/docs/constitution"
	>
		<RiFilePaper2Line size={iconSize} class="mr-2" />
		<span>Offprint Constitution</span>
		<RiLink
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="/docs/omnibus"
	>
		<RiArticleLine size={iconSize} class="mr-2" />
		<span>Offprint Omnibus</span>
		<RiLink
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="/docs/about"
	>
		<RiQuestionLine size={iconSize} class="mr-2" />
		<span>What is Offprint?</span>
		<RiLink
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
</div>
<h5 class="guide-section-header">Funding</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<a
		class="guide-button group"
		href="https://www.patreon.com/offprintstudios"
		target="_blank"
		rel="noreferrer"
	>
		<RiPatreonFill size={iconSize} class="mr-2" />
		<span>Patreon</span>
		<RiExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://ko-fi.com/offprintstudios"
		target="_blank"
		rel="noreferrer"
	>
		<RiCupFill size={iconSize} class="mr-2" />
		<span>Ko-Fi</span>
		<RiExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
</div>
<h5 class="guide-section-header">Connect</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<a
		class="guide-button group"
		href="https://github.com/OffprintStudios/Sailfish"
		target="_blank"
		rel="noreferrer"
	>
		<RiGithubFill size={iconSize} class="mr-2" />
		<span>GitHub</span>
		<RiExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://mastodon.social/@ofmanyfigments"
		target="_blank"
		rel="noreferrer"
	>
		<RiMastodonFill size={iconSize} class="mr-2" />
		<span>Mastodon</span>
		<RiExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://discord.gg/9cnSwfn"
		target="_blank"
		rel="noreferrer"
	>
		<RiDiscordFill size={iconSize} class="mr-2" />
		<span>Discord</span>
		<RiExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
</div>

<span class="flex items-center justify-center">
	Made with <RiHeartLine class="mx-1.5 relative -top-0.5" size="18px" /> by Offprint Studios
</span>
<span class="flex items-center justify-center">&copy; 2023 Alyx Mote</span>
