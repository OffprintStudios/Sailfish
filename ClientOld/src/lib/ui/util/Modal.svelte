<script lang="ts">
    import { clickOutsideAction } from 'svelte-legos';

    export let id: string;
    export let open: boolean = false;

    let dialog: HTMLDialogElement;
    let div: HTMLDivElement;

    function close() {
        dialog.close();
    }

    $: {
        if (open) {
            dialog.showModal();
        }
    }
</script>

<dialog
    {id}
    class="backdrop:bg-zinc-900/50 backdrop:backdrop-blur-lg open:backdrop:animate-[modal-show_200ms_ease_normal] bg-transparent rounded-xl"
    style="box-shadow: var(--dropshadow);"
    on:close={() => open = false}
    bind:this={dialog}
>
    <div
        class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur animate-modalf rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 overflow-hidden"
        style="color: var(--text-color);"
        use:clickOutsideAction
        bind:this={div}
        on:clickoutside={close}
    >
        <slot />
    </div>
</dialog>