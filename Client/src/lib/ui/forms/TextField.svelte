<script lang="ts">
    export let name: string;
    export let label: string;
    export let type: "text" | "email" | "password" = "text";
    export let placeholder: string = 'Enter text here';
    export let errorMessage: string | undefined = undefined;
    export let autocomplete: string = 'off';
    export let required: boolean = false;
    export let value: string | null;
</script>

<div>
    <label for={name} class="all-small-caps font-bold tracking-wide relative left-2 select-none">
        {label}<span class="text-red-600 text-xl relative top-0.5 ml-1">{required ? '*' : ''}</span>
    </label>
    <input
        id={name}
        {name}
        {...{ type }}
        {placeholder}
        {autocomplete}
        {required}
        bind:value
        class="text-field border-zinc-400 dark:border-zinc-500 bg-zinc-300 dark:bg-zinc-600"
    />
    {#if errorMessage}
    <div class="flex pt-1">
        <span class="flex-1"><!--spacer--></span>
        <span class="w-full text-right text-red-600 text-xs relative mr-2">{{ errorMessage }}</span>
    </div>
    {/if}
</div>

<style lang="scss">
    .text-field {
        @apply transition w-full rounded-xl border-2 border-x-transparent border-t-transparent focus:ring-0;
    }

    .text-field:focus {
        border-bottom-color: rgb(var(--accent));
    }
</style>
