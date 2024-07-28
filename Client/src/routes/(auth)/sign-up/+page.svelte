<script lang="ts">
    import { TextField } from "$lib/ui/forms";
    import { Button, Metatags } from "$lib/ui/util";
    import { IconUserPlus, IconInfoCircle } from "@tabler/icons-svelte";
	import type { ActionData } from "./$types";
	import { enhance } from "$app/forms";
    import { slide } from "svelte/transition";

    export let form: ActionData;
</script>

<Metatags
    title="Sign Up — Offprint"
    desc="Welcome to Offprint!"
    url="https://offprint.cafe/sign-up"
/>

<div class="flex flex-col justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll">

    <div class="flex flex-col items-center justify-center pb-4">
        <h1 class="text-3xl">Welcome to Offprint!</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
            Let's get started, shall we?
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
            required
            autocomplete="email"
        />
        <div class="my-1"></div>
        <TextField
            name="password"
            label="Password"
            type="password"
            placeholder="••••••••••"
            required
            autocomplete="new-password"
        />
        <div class="my-1"></div>
        <TextField
            name="repeat-password"
            label="Repeat Password"
            type="password"
            placeholder="••••••••••"
            required
            autocomplete="new-password"
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
                I agree to the <a href="/settings/terms-of-service">Terms of Service</a>, <a href="/settings/privacy-policy">Privacy Policy</a>, and <a href="/settings/constitution">Offprint Constitution</a></span>
        </label>
        <Button
            id="sign-up"
            title="Sign Up"
            type="submit"
            kind="primary"
            fullWidth
        >
            <span class="button-icon"><IconUserPlus /></span>
            <span class="button-text">Sign Up</span>
        </Button>
        <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
            Already have an account?
        </a>
    </form>
</div>