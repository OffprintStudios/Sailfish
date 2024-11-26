<script lang="ts">
    import { IconLoader2 } from "@tabler/icons-svelte";
	import type { MouseEventHandler } from "svelte/elements";

    interface Props {
        id: string;
        title: string;
        type: 'button' | 'submit' | 'reset';
        kind: 'normal' | 'primary';
        active: boolean;
        loading: boolean;
        loadingText: string;
        disabled: boolean;
        fullWidth: boolean;
        onclick: MouseEventHandler<HTMLButtonElement>;
    }

    let { 
        id, 
        title, 
        type = 'button', 
        kind = 'normal', 
        active = false, 
        loading = false, 
        loadingText = '', 
        disabled = false, 
        fullWidth = false,
        onclick,
        children
    }: Props = $props();
</script>

<button
    {id}
    {title}
    {type}
    class="btn"
    class:primary={kind === 'primary'}
    class:active={active}
    class:w-full={fullWidth}
    {disabled}
    {onclick}
>
    {#if loading}
        <span class="button-icon animate-spin">
            <IconLoader2 />
        </span>
        <span class="button-text">
            {loadingText}
        </span>
    {:else}
        {@render children()}
    {/if}
</button>

<style>
    :global(.btn) {
        @apply flex items-center justify-center px-2.5 py-1.5 transition transform focus:ring-0 m-0 text-base rounded-lg select-none relative all-small-caps font-bold z-[5];
        letter-spacing: 1px;
        color: var(--text-color);
        font-family: var(--body-text), sans-serif;
        
        &:hover {
            @apply text-white no-underline bg-zinc-500/25;
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
    
        & > span.button-icon {
            @apply mr-1.5 relative;
        }
    
        & > span.button-icon.no-text {
            @apply mr-0 py-1;
        }
    
        & > span.button-icon.variable-text {
            @apply mr-0 lg:mr-1.5 relative;
        }
    
        & > span.button-text {
            @apply relative -top-[0.075rem];
        }
    
        & > span.button-small-text {
            @apply text-sm font-medium;
        }
    }
    
    :global(:-moz-any(.btn)) {
        @apply text-sm;
    }
</style>