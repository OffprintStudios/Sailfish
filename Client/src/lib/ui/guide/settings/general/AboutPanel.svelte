<script lang="ts">
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
		NewspaperLine,
		PatreonFill,
		QuestionLine,
		TwitterFill,
		MastodonFill
	} from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import { prevPage } from "$lib/ui/guide";
	import { copyToClipboard } from "$lib/util/functions";
	import { VERSION } from "$lib/util/constants";

	const iconSize = "24px";
</script>

<div class="panel-container">
	<div class="topbar">
		<div class="left-button">
			<Button on:click={prevPage}>
				<ArrowLeftSLine class="button-icon" />
				<span class="button-text">Settings</span>
			</Button>
		</div>
	</div>
	<div class="content-container">
		<div class="panel-section">
			<h3>Info</h3>
			<div>
				<button class="nav-button" on:click={() => copyToClipboard(VERSION)}>
					<CodeLine size={iconSize} />
					<span>Version</span>
					<span class="text-zinc-400" style="text-align: right;">{VERSION}</span>
				</button>
			</div>
		</div>
		<div class="panel-section">
			<h3>Docs</h3>
			<div>
				<a
					href="https://docs.google.com/document/d/1qYEhhRVknvT9qw6cwZQ5JP72rKQgPpdM449hxP2PG3w/edit?usp=share_link"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<NewspaperLine size={iconSize} />
					<span>Terms of Service</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://docs.google.com/document/d/1CaO3WEW4HWaKF2p_KPZmtCONDWB04dvgBD3k-kCDklI/edit?usp=share_link"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<Lock2Line size={iconSize} />
					<span>Privacy Policy</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://docs.google.com/document/d/1i_YMayX0p61_nJGkUsT_BsHwHo-5NyV_QovcGKZr2e0/edit?usp=share_link"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<FilePaper2Line size={iconSize} />
					<span>Offprint Constitution</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://docs.google.com/document/d/17WFSgBsJ7GoNVYStY1Z5XUGSEXWaMUzCA4uAU4d1beA/edit?usp=share_link"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<ArticleLine size={iconSize} />
					<span>Offprint Omnibus</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://docs.google.com/document/d/1zEEmR-tppI2oLE7wP2S0n_Yogtc7GUw7fANCYzYMbsA/edit?usp=share_link"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<QuestionLine size={iconSize} />
					<span>What is Offprint?</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
			</div>
		</div>
		<div class="panel-section">
			<h3>Funding</h3>
			<div>
				<a
					href="https://www.patreon.com/offprintstudios"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<PatreonFill size={iconSize} />
					<span>Patreon</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://ko-fi.com/offprintstudios"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<CupFill size={iconSize} />
					<span>Ko-Fi</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
			</div>
		</div>
		<div class="panel-section">
			<h3>Connect</h3>
			<div>
				<a
					href="https://github.com/OffprintStudios/Sailfish"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<GithubFill size={iconSize} />
					<span>GitHub</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://social.offprint.net/@offprintstudios"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<MastodonFill size={iconSize} />
					<span>Mastodon</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
				<a
					href="https://discord.gg/9cnSwfn"
					class="nav-button"
					target="_blank"
					rel="noreferrer"
				>
					<DiscordFill size={iconSize} />
					<span>Discord</span>
					<ExternalLinkLine class="text-zinc-400" />
				</a>
			</div>
		</div>
		<span class="flex items-center justify-center"
			>Made with <HeartLine class="mx-1.5" size="20px" /> by Offprint Studios</span
		>
		<span class="flex items-center justify-center">&copy; 2023 Alyx Mote</span>
	</div>
</div>

<style lang="scss">
	@use "../../Guide";
</style>
