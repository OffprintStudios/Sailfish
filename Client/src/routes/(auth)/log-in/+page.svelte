<script lang="ts">
    import { TextField } from "$lib/ui/forms";
    import { Button } from "$lib/ui/util";
	import { onMount } from "svelte";
    import { RiLoginCircleLine, RiUserForbidLine } from "svelte-remixicon";
    import { auth } from "$lib/state/auth.state";

    let showUnavailableActionPrompt = false;

    let emailValue: string;
    let passwordValue: string;

    onMount(() => {
        if ($auth.account) {
            showUnavailableActionPrompt = true;
        }
    });
</script>

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
            <h1 class="text-3xl">Welcome back!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                We're so glad you're here.
            </span>
        </div>
        <form class="flex flex-col">
            <TextField
                id="email"
                label="Email Address"
                type="email"
                placeholder="somebody@example.net"
                autocomplete="email"
                bind:value={emailValue}
            />
            <div class="my-1.5"></div>
            <TextField
                id="password"
                label="Password"
                type="password"
                placeholder="•••••••••••"
                autocomplete="current-password"
                bind:value={passwordValue}
            />
            <a class="text-zinc-500 dark:text-zinc-400 text-sm pt-2 hover:underline" href="/forgot-password">Forgot your password?</a>
            <div class="my-3"></div>
            <Button
                id="login-button"
                title="Log In"
                type="submit"
                kind="primary"
                fullWidth
            >
                <span class="button-icon"><RiLoginCircleLine /></span>
                <span class="button-text">Log In</span>
            </Button>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/sign-up">
                Looking to join? Sign up today!
            </a>
        </form>
    {/if}
</div>
