<script lang="ts">
    export let id: string;
    export let label: string;
    export let placeholder = "Enter text here";
    export let errorMessage: string | undefined = undefined;
    export let required = false;
    export let value: string;
</script>

<div>
    <label for={id} class="all-small-caps font-bold tracking-wide relative left-2 select-none">
        {label}<span class="text-red-600 text-xl relative top-0.5 ml-1">{required ? '*' : ''}</span>
    </label>
    <textarea
        {id}
        {placeholder}
        {required}
        bind:value
        class="text-area border-zinc-400 dark:border-zinc-500 bg-zinc-300 dark:bg-zinc-600 resize-none"
    ></textarea>
    {#if errorMessage}
    <div class="flex pt-1">
        <span class="flex-1"><!--spacer--></span>
        <span class="w-full text-right text-red-600 text-xs relative mr-2">{{ errorMessage }}</span>
    </div>
    {/if}
</div>
