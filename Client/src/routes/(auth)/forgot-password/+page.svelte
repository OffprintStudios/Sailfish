<script lang="ts">
    import type { ActionData } from "./$types";
    import { TextField } from "$lib/ui/forms";
    import { Button } from "$lib/ui/util";
    import { RiMailSendLine, RiUserForbidLine } from "svelte-remixicon";
    import { onMount } from "svelte";
    import { auth } from "$lib/state/auth.state";
    import { enhance } from "$app/forms";
    import toast from "svelte-french-toast";

    export let form: ActionData;
    let showUnavailableActionPrompt = false;

    onMount(() => {
        if ($auth.account) {
            showUnavailableActionPrompt = true;
        }
    });

    $: {
        if (form?.error) {
            toast.error(form!.error.message);
        }
    }
</script>

<svelte:head>
	<title>Forgot Password &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="Offprint" />
	<meta name="description" content="For The Stories Left Untold" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.cafe/" />
	<meta property="og:title" content="Offprint" />
	<meta
		property="og:description"
		content="For The Stories Left Untold"
	/>
	<meta property="og:image" content="/images/offprint_icon.png" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.cafe/" />
	<meta property="twitter:title" content="Offprint" />
	<meta
		property="twitter:description"
		content="For The Stories Left Untold"
	/>
	<meta property="twitter:image" content="/images/offprint_icon.png" />
</svelte:head>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit">
    {#if showUnavailableActionPrompt}
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">Whoops!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                Looks like you've taken the wrong turn.
            </span>
            <RiUserForbidLine size="150px" />
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                You're already logged in!
            </span>
        </div>
    {:else}
        <div class="flex flex-col items-center justify-center pb-4">
            <h1 class="text-3xl">Forgot your password?</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                No worries&mdash;we can help!
            </span>
        </div>
        <form
            class="flex flex-col"
            method="post"
            use:enhance
        >
            <TextField
                name="email"
                label="Email Address"
                type="email"
                placeholder="somebody@example.net"
                autocomplete="email"
                required
                value={null}
            />
            <div class="my-3 text-center text-sm italic">
                <span>Enter your email, and we'll send a reset link.</span>
            </div>
            <Button
                id="send-recovery-email"
                title="Send Recovery Email"
                type="submit"
                kind="primary"
                fullWidth
            >
                <span class="button-icon"><RiMailSendLine /></span>
                <span class="button-text">Send Recovery Email</span>
            </Button>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                Remembered your password? Log in now!
            </a>
        </form>
    {/if}
</div>
