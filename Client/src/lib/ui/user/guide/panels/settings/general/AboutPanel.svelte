<script lang="ts">
	import { popPanel } from "$lib/ui/user/guide/guide.state";
	import { copyToClipboard } from "$lib/util/functions";
	import { VERSION } from "$lib/util/constants";
	import {
		ArrowLeftSLine,
		ArticleLine,
		CodeLine,
		CupFill,
		DiscordFill,
		ExternalLinkLine,
		FilePaper2Line,
		GithubFill,
		HeartLine,
		Lock2Line,
		MastodonFill,
		NewspaperLine,
		PatreonFill,
		QuestionLine
	} from "svelte-remixicon";
	import { Button } from "$lib/ui/util";

	const iconSize = "24px";
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">Info</h5>
<div class="guide-section with-header bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => copyToClipboard(VERSION)}>
		<CodeLine size={iconSize} class="mr-2" />
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
		href="https://docs.google.com/document/d/1qYEhhRVknvT9qw6cwZQ5JP72rKQgPpdM449hxP2PG3w/edit?usp=share_link"
		target="_blank"
		rel="noreferrer"
	>
		<NewspaperLine size={iconSize} class="mr-2" />
		<span>Terms of Service</span>
		<ExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://docs.google.com/document/d/1CaO3WEW4HWaKF2p_KPZmtCONDWB04dvgBD3k-kCDklI/edit?usp=share_link"
		target="_blank"
		rel="noreferrer"
	>
		<Lock2Line size={iconSize} class="mr-2" />
		<span>Privacy Policy</span>
		<ExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://docs.google.com/document/d/1i_YMayX0p61_nJGkUsT_BsHwHo-5NyV_QovcGKZr2e0/edit?usp=share_link"
		target="_blank"
		rel="noreferrer"
	>
		<FilePaper2Line size={iconSize} class="mr-2" />
		<span>Offprint Constitution</span>
		<ExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://docs.google.com/document/d/17WFSgBsJ7GoNVYStY1Z5XUGSEXWaMUzCA4uAU4d1beA/edit?usp=share_link"
		target="_blank"
		rel="noreferrer"
	>
		<ArticleLine size={iconSize} class="mr-2" />
		<span>Offprint Omnibus</span>
		<ExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
	<a
		class="guide-button group"
		href="https://docs.google.com/document/d/1zEEmR-tppI2oLE7wP2S0n_Yogtc7GUw7fANCYzYMbsA/edit?usp=share_link"
		target="_blank"
		rel="noreferrer"
	>
		<QuestionLine size={iconSize} class="mr-2" />
		<span>What is Offprint?</span>
		<ExternalLinkLine
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
		<PatreonFill size={iconSize} class="mr-2" />
		<span>Patreon</span>
		<ExternalLinkLine
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
		<CupFill size={iconSize} class="mr-2" />
		<span>Ko-Fi</span>
		<ExternalLinkLine
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
		<GithubFill size={iconSize} class="mr-2" />
		<span>GitHub</span>
		<ExternalLinkLine
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
		<MastodonFill size={iconSize} class="mr-2" />
		<span>Mastodon</span>
		<ExternalLinkLine
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
		<DiscordFill size={iconSize} class="mr-2" />
		<span>Discord</span>
		<ExternalLinkLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</a>
</div>

<span class="flex items-center justify-center">
	Made with <HeartLine class="mx-1.5 relative -top-0.5" size="18px" /> by Offprint Studios
</span>
<span class="flex items-center justify-center">&copy; 2023 Alyx Mote</span>

<!--


</div>-->
