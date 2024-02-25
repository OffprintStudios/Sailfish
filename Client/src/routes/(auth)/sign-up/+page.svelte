<script lang="ts">
    import { TextField } from "$lib/ui/forms";
    import { Button } from "$lib/ui/util";
    import { onMount } from "svelte";
    import { auth } from "$lib/state/auth.state";
    import { RiUserAddLine, RiUserForbidLine } from "svelte-remixicon";
	import type { ActionData } from "./$types";
    import toast from "svelte-french-toast";
	import { enhance } from "$app/forms";

    export let form: ActionData;
    let showUnavailableActionPrompt = false;

    onMount(() => {
        if ($auth.account) {
            showUnavailableActionPrompt = true;
        }
    });

    $: {
        if (form?.error) {
            toast.error(form!.error.message, { duration: 5000 });
        }
    }
</script>

<svelte:head>
	<title>Sign Up &mdash; Offprint</title>
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

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
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
            <h1 class="text-3xl">Welcome to Offprint!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                Let's get started, shall we?
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
                required
                autocomplete="email"
                value={null}
            />
            <div class="my-1"></div>
            <TextField
                name="password"
                label="Password"
                type="password"
                placeholder="••••••••••"
                required
                autocomplete="new-password"
                value={null}
            />
            <div class="my-1"></div>
            <TextField
                name="repeat-password"
                label="Repeat Password"
                type="password"
                placeholder="••••••••••"
                required
                autocomplete="new-password"
                value={null}
            />
            <label class="flex mt-4 mb-2">
                <input
                    id="age-check"
                    name="age-check"
                    type="checkbox"
                    required
                    class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                />
                <span class="text-sm align-top select-none">I am 13 years of age or older</span>
            </label>
            <label class="flex mt-2 mb-4">
                <input
                    id="terms-agree"
                    name="terms-agree"
                    type="checkbox"
                    required
                    class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                />
                <!--TODO: replace these with real links-->
                <span class="text-sm align-top select-none">
                    I agree to the <a href="/docs/terms-of-service">Terms of Service</a>, <a href="/docs/privacy-policy">Privacy Policy</a>, and <a href="/docs/constitution">Offprint Constitution</a></span>
            </label>
            <Button
                id="sign-up"
                title="Sign Up"
                type="submit"
                kind="primary"
                fullWidth
            >
                <span class="button-icon"><RiUserAddLine /></span>
                <span class="button-text">Sign Up</span>
            </Button>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                Already have an account?
            </a>
        </form>
    {/if}
</div>
