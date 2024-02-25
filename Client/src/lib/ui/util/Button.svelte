<script lang="ts">
	import { RiLoader5Line } from "svelte-remixicon";

    export let id: string;
    export let title: string;
    export let type: "button" | "submit" | "reset" = "button";
    export let kind: "primary" | "normal" = "normal";
    export let active = false;
    export let loading = false;
    export let loadingText = "";
    export let disabled = false;
    export let fullWidth = false;
    export let thisButton: HTMLButtonElement | null = null;
</script>

<button
    class="btn"
    {id}
    {title}
    {type}
    class:primary={kind === 'primary'}
    class:active={active}
    class:w-full={fullWidth}
    disabled={disabled || loading}
    on:click
    bind:this={thisButton}
>
    {#if loading}
        <RiLoader5Line class="button-icon animate-spin" />
        <span class="button-text">{loadingText}</span>
    {:else}
        <slot />
    {/if}
</button>

<style lang="scss">
    :global(.btn) {
        @apply flex items-center justify-center px-2.5 py-1.5 transition transform focus:ring-0 m-0 text-base rounded-lg select-none relative all-small-caps font-bold z-[5];
        letter-spacing: 1px;
        color: var(--text-color);
        font-family: var(--body-text);

        &:hover {
            @apply text-white no-underline bg-zinc-500/50;
        }

        &:active {
            @apply text-white scale-95 cursor-pointer shadow-inner;
            background: rgb(var(--accent-dark));
        }

        &.primary, &.active {
            @apply text-white;
            background: rgb(var(--accent));
        }

        &.primary:hover, &.active:hover {
            background: rgb(var(--accent-light));
        }

        &.primary.active {
            @apply text-white;
            background: rgb(var(--accent-light));
        }

        & > :global(span.button-icon) {
            @apply mr-1.5 relative;
        }

        & > :global(span.button-icon.no-text) {
            @apply mr-0 py-1;
        }

        & > :global(span.button-icon.variable-text) {
            @apply mr-0 lg:mr-1.5 relative;
        }

        & > :global(span.button-text) {
            @apply relative -top-[0.075rem];
        }

        & > :global(span.button-small-text) {
            @apply text-sm font-medium;
        }
    }
</style>
