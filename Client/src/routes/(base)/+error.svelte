<script lang="ts">
    import { page } from "$app/stores";
</script>

<div class="flex flex-col items-center justify-center h-[calc(100svh-65px)] w-11/12 mx-auto">
    <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-xl p-4 md:p-12 w-full h-full md:h-fit overflow-y-scroll border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">{$page.status}</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                {$page.error?.message}
            </span>
        </div>
    </div>
</div>
