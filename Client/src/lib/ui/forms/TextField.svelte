<script lang="ts">
    export let name: string;
    export let label: string;
    export let type: 'text' | 'email' | 'password' = 'text';
    export let placeholder: string = "Enter text here"
    export let hint: string = "";
    export let errorMsg: string = "";
    export let autocomplete: string = 'off';
    export let required: boolean = false;
</script>

<div>
    <label for={name} class="flex items-center all-small-caps font-bold tracking-wide relative left-2 select-none">
        {label}<span class="text-red-600 text-xl relative top-0.5 ml-1">{required ? "*" : ""}</span>
        <span class="flex-1"></span>
        <span class="italic text-zinc-500 dark:text-zinc-400 relative right-4">{hint}</span>
    </label>
    <input
        id={name}
        {name}
        {type}
        {placeholder}
        {autocomplete}
        {required}
        class="transition w-full rounded-xl border-2 border-x-transparent border-t-transparent focus:border-x-transparent focus:border-t-transparent focus:ring-0 border-zinc-400 dark:border-b-zinc-500 bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-lg focus:border-b-accent dark:focus:border-b-accent"
    />
    <div class="flex pt-1">
        <span class="flex-1"></span>
        <span class="w-full text-right text-red-600 text-xs relative mr-2">{errorMsg}</span>
    </div>
</div>
