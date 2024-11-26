<script lang="ts">
    import type { ActionData } from "./$types";
    import { enhance } from "$app/forms";
    import { TextField } from "$lib/ui/forms";
    import { Button } from "$lib/ui/util";
	import { IconRestore } from "@tabler/icons-svelte";

    export let form: ActionData;
</script>

<div class="flex flex-col justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
    <div class="flex flex-col items-center justify-center">
        <h1 class="text-3xl">Reset Your Password</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-4" style="font-family: var(--header-text);">
            Enter your new password below
        </span>
    </div>
    <form class="flex flex-col" method="post" use:enhance>
        <TextField
            name="new-password"
            label="New Password"
            type="password"
            placeholder="•••••••••••"
            autocomplete="new-password"
            required
        />
        <div class="my-1.5"></div>
        <TextField
            name="repeat-password"
            label="Repeat Password"
            type="password"
            placeholder="•••••••••••"
            autocomplete="new-password"
            required
        />
        <div class="my-2"></div>
        <Button
            id="send-request-button"
            title="Send Reset Request"
            type="submit"
            kind="primary"
            fullWidth
        >
            <span class="button-icon"><IconRestore /></span>
            <span class="button-text">Reset Password</span>
        </Button>
    </form>
</div>