<script lang="ts">
    import { page } from "$app/stores";
</script>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-xl p-4 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
    <div class="flex flex-col items-center justify-center">
        <h1 class="text-3xl">{$page.status}</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
            {$page.error?.message}
        </span>
    </div>
</div>
