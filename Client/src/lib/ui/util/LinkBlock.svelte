<script lang="ts">
    export let id: string;
    export let title: string;
    export let href: string;
    export let kind: "primary" | "normal" = "normal";
    export let fullWidth = false;
</script>

<a
    class="link"
    {id}
    {title}
    {href}
    class:primary={kind === 'primary'}
    class:w-full={fullWidth}
>
    <slot />
</a>

<style lang="scss">
    :global(.link) {
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

        & > :global(span.link-icon) {
            @apply mr-1.5 relative;
        }

        & > :global(span.link-icon.no-text) {
            @apply mr-0 py-1;
        }

        & > :global(span.link-icon.variable-text) {
            @apply mr-0 lg:mr-1.5 relative;
        }

        & > :global(span.link-text) {
            @apply relative -top-[0.075rem];
        }

        & > :global(span.link-small-text) {
            @apply text-sm font-medium;
        }
    }
</style>
