<script lang="ts">
	export let src: string;
	export let alt = "avatar";
	export let size = "12rem";
	export let borderWidth = "4px";
	export let title = "avatar";
	export let onAccentBg = false;
</script>

<div
	class="rounded-full dark:border-white bg-zinc-300 dark:bg-white overflow-hidden"
	class:border-zinc-300={!onAccentBg}
	class:border-white={onAccentBg}
	style="width: {size}; height: {size}; border-width: {borderWidth}"
	{title}
>
	<img {src} {alt} class="object-cover w-full h-full" />
</div>
