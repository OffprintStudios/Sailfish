<script lang="ts">
    export let value: boolean = false;
</script>

<div
    class="switch"
    class:active={value}
    on:click={() => value = !value}
    on:keyup={() => value = !value}
    role="switch"
    tabindex=0
    aria-checked={value ? "true" : "false"}
>
    <div class="switch-button"></div>
</div>

<style>
    /* Switch */
    .switch {
        @apply relative inline-block w-[52px] h-[24px] bg-zinc-300 dark:bg-zinc-600 rounded-[11px] cursor-pointer select-none border border-zinc-600/25 dark:border-zinc-300/25;
        box-shadow: inset 0 0 1px 0 rgba(0, 0, 0, 0.05);
        transition: all 0.4s ease;
    }

    .switch-button {
        @apply absolute top-[2px] left-[2px] inline-block w-[18px] h-[18px] rounded-[9px] bg-white;
        box-shadow: 0 1px 4px 0 rgba(0, 0, 0, 0.3),
            inset 0 0 1px 0 rgba(0, 0, 0, 0.05);
        transition: all 0.4s ease;
    }

    .switch.active {
        @apply bg-accent;
    }

    .switch.active .switch-button {
        @apply left-[30px];
    }

    .switch.active:active .switch-button {
        @apply left-[24px];
    }

    .switch:active .switch-button {
        @apply w-[24px];
    }
</style>