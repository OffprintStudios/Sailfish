<script lang="ts">
    import { enhance } from "$app/forms";
    import { TextField, TextArea } from "$lib/ui/forms";
    import { Button, LinkBlock, Metatags } from "$lib/ui/util";
    import { IconPlus, IconX, IconInfoCircle } from "@tabler/icons-svelte";
	import type { ActionData } from "./$types";
	import { goto } from "$app/navigation";
	import { slide } from "svelte/transition";

    export let form: ActionData;

    $: {
        if (form?.success) {
            goto("/switch-profile");
        }
    }
</script>

<Metatags
    title="Create a Profile — Offprint"
    desc="Let's make a whole new you"
    url="https://offprint.cafe/create-profile"
    image="/images/beatriz.png"
/>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
    <div class="flex flex-col items-center justify-center pb-4">
        <h1 class="text-3xl">Create a Profile</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
            Let's make a whole new you
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
    <form class="flex flex-col w-full" method="post" use:enhance>
        <div class="flex items-center justify-center w-full mb-4">
            <img src="https://images.offprint.net/avatars/avatar.png" class="w-[150px] h-[150px] rounded-full object-cover" />
        </div>
        <TextField
            name="username"
            label="Username"
            placeholder="Somebody New"
            required
        />
        <div class="flex items-center mt-4">
            <div class="w-1/2">
                <LinkBlock
                    id="cancel-action"
                    title="Cancel"
                    href="/switch-profile"
                    fullWidth
                >
                    <span class="link-icon"><IconX /></span>
                    <span class="link-text">Cancel</span>
                </LinkBlock>
            </div>
            <div class="mx-2"></div>
            <div class="w-1/2">
                <Button
                    id="add-profile"
                    title="Add Profile"
                    type="submit"
                    kind="primary"
                    fullWidth
                >
                    <span class="button-icon"><IconPlus /></span>
                    <span class="button-text">Add Profile</span>
                </Button>
            </div>
        </div>
    </form>
</div>