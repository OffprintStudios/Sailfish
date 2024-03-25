<script lang="ts">
	import type { Blog } from "$lib/models/blogs";
	import { slugify } from "$lib/util/functions";
    import truncate from 'truncate-html';

    export let blog: Blog;
    export let width: string | 'auto' = '380px';

    $: console.log(blog);
</script>

<a
    href="/profile/{blog.author.id}/{slugify(blog.author.name)}/blog/{blog.id}/{slugify(blog.title)}"
    class="flex flex-col min-h-[256px] max-h-[256px] rounded-xl overflow-hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border border-zinc-600/25 dark:border-zinc-300/25 hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 transition"
    style="box-shadow: var(--dropshadow);"
    style:width={width === 'auto' ? '100%' : width}
>
    <div class="flex items-center w-full h-[54px]" style="background: rgb(var(--accent));">
        <div class="avatar-box">
            <img src={blog.author.avatar} class="object-cover w-full h-full" alt="{blog.author.name}'s Avatar" title="{blog.author.name}'s Avatar" />
        </div>
        <h3 class="text-xl text-white">{blog.title}</h3>
    </div>
    <div class="blog-body text-xs px-2 py-4 h-[256px]">
        {@html truncate(blog.body, 100, { byWords: true })}
    </div>
</a>

<style lang="scss">
    div.avatar-box {
        @apply w-[75px] h-[75px] z-10 rounded-full -left-2.5 top-0.5 overflow-hidden relative;
    }
</style>
