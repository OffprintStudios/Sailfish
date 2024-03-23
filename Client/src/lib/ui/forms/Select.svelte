<script lang="ts">
    export let name: string;
    export let title: string;
    export let required = false;
</script>

<select
    id={name}
    {name}
    {title}
    {required}
    class="bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-lg rounded-xl border-0 focus:border-0 active:border-0 w-full"
>
    <slot />
</select>
