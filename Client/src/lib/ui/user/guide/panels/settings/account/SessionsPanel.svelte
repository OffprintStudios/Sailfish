<script lang="ts">
	import { popPanel } from "$lib/ui/user/guide/guide.state";
	import { Button } from "$lib/ui/util";
	import {
		ArrowLeftSLine,
		AppleFill,
		WindowsFill,
		QuestionFill,
		ChromeFill,
		FirefoxFill,
		SafariFill,
		EdgeFill
	} from "svelte-remixicon";
	import { onMount } from "svelte";
	import type { Session } from "$lib/models/accounts";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	let sessions: Session[] = [];
	let loading = false;
	const iconSize = "32px";

	onMount(async () => {
		await fetchSessions();
	});

	async function fetchSessions() {
		loading = true;
		const response = await getReq<Session[]>(`/sessions/fetch-sessions`);

		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			sessions = response as Session[];
		}
		loading = false;
	}

	function getOS(osStr: string): string {
		if (osStr.includes("mac os")) {
			return "macOS";
		} else if (osStr.includes("Windows")) {
			return "Windows";
		} else {
			return "Unknown";
		}
	}

	function getBrowser(browserStr: string): string {
		if (browserStr.includes("Chrome")) {
			return "Chrome";
		} else if (browserStr.includes("Safari")) {
			return "Safari";
		} else if (browserStr.includes("Firefox")) {
			return "Firefox";
		} else if (browserStr.includes("Edge")) {
			return "Edge";
		} else {
			return "Unknown";
		}
	}
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Settings</span>
	</Button>
</div>
{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else if sessions.length === 0}
	<div class="empty">
		<h3>No sessions found</h3>
		<p>Strange. Shouldn't there be something here?</p>
	</div>
{:else}
	{#each sessions as session}
		<div class="session-block bg-zinc-300 dark:bg-zinc-600">
			<span class="font-mono text-xs text-zinc-400 text-center mb-4">
				<strong>ID:</strong>
				{session.id}
			</span>
			<div class="flex items-center justify-center">
				<div class="flex flex-col items-center mx-2">
					{#if getOS(session.deviceInfo.os) === "macOS"}
						<AppleFill size={iconSize} />
						<span>macOS</span>
					{:else if getOS(session.deviceInfo.os) === "Windows"}
						<WindowsFill size={iconSize} />
						<span>Windows</span>
					{:else}
						<QuestionFill size={iconSize} />
						<span>Unknown</span>
					{/if}
				</div>
				<div class="flex flex-col items-center mx-2">
					{#if getBrowser(session.deviceInfo.browser) === "Chrome"}
						<ChromeFill size={iconSize} />
						<span>Chrome</span>
					{:else if getBrowser(session.deviceInfo.browser) === "Safari"}
						<SafariFill size={iconSize} />
						<span>Safari</span>
					{:else if getBrowser(session.deviceInfo.browser) === "Firefox"}
						<FirefoxFill size={iconSize} />
						<span>Firefox</span>
					{:else if getBrowser(session.deviceInfo.browser) === "Edge"}
						<EdgeFill size={iconSize} />
						<span>Edge</span>
					{:else}
						<QuestionFill size={iconSize} />
						<span>Unknown</span>
					{/if}
				</div>
			</div>
		</div>
	{/each}
{/if}

<style lang="scss">
	div.session-block {
		@apply rounded-lg w-full my-4 first:mt-0 last:mb-0 relative flex flex-col px-4 py-2;
	}
</style>
