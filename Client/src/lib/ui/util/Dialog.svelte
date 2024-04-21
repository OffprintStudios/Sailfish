<script lang="ts">
	import { RiCloseLine } from "svelte-remixicon";
    import { clickOutsideAction } from "svelte-legos";
    import Button from "./Button.svelte";

    export let dialog: HTMLDialogElement;
    export let id: string;
    export let title: string;
</script>

<dialog
    {id}
    class="backdrop:bg-zinc-900/50 backdrop:backdrop-blur-lg bg-transparent rounded-xl"
    style="box-shadow: var(--dropshadow);"
    bind:this={dialog}
    on:close
>
    <div
        class="p-4 md:min-w-[400px] bg-zinc-200/50 dark:bg-zinc-700/50 animate-modalf backdrop-blur rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 overflow-hidden"
        style="color: var(--text-color);"
        use:clickOutsideAction
        on:clickoutside={() => dialog.close()}
    >
        <div class="flex items-center pb-2 mb-4">
            <h3 class="text-2xl">{title}</h3>
            <div class="flex-1"></div>
            <Button id="{id}-close-button" title="Close" on:click={() => dialog.close()}>
                <span class="button-icon no-text"><RiCloseLine size="20px" /></span>
            </Button>
        </div>
        <slot />
    </div>
</dialog>
