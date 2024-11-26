<script lang="ts">
    import type { ActionData } from "./$types";
    import { TextField } from "$lib/ui/forms";
    import { Button, Metatags } from "$lib/ui/util";
    import { IconLogin2, IconInfoCircle } from "@tabler/icons-svelte";
	import { enhance } from "$app/forms";
    import { slide } from "svelte/transition";

    export let form: ActionData;
</script>

<Metatags
    title="Log In — Offprint"
    desc="Welcome back, we missed you lots"
    url="https://offprint.cafe/log-in"
/>

<div class="flex flex-col justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit">
    <div class="flex flex-col items-center justify-center pb-4">
        <h1 class="text-3xl">Welcome back!</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
            We're so glad you're here.
        </span>
    </div>
    {#if form?.message}
        <div class="text-sm flex flex-col bg-red-600/25 border border-red-600/75 rounded-xl p-4 mb-4" transition:slide>
            <div class="flex items-center mb-1">
                <span class="mr-1"><IconInfoCircle size="20px" /></span>
                <span class="font-bold">Head's Up!</span>
            </div>
            <span>{form?.message}</span>
        </div>
    {/if}
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
        />
        <div class="my-1.5"></div>
        <TextField
            name="password"
            label="Password"
            type="password"
            placeholder="•••••••••••"
            autocomplete="current-password"
            required
        />
        <a class="text-zinc-500 dark:text-zinc-400 text-sm pt-2 hover:underline" href="/forgot-password">Forgot your password?</a>
        <label class="flex mt-4">
            <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
            />
            <span class="text-sm align-top select-none">
                Remember me for 30 days
            </span>
        </label>
        <div class="my-3"></div>
        <Button
            id="login-button"
            title="Log In"
            type="submit"
            kind="primary"
            fullWidth
        >
            <span class="button-icon"><IconLogin2 /></span>
            <span class="button-text">Log In</span>
        </Button>
        <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/sign-up">
            Looking to join? Sign up today!
        </a>
    </form>
</div>