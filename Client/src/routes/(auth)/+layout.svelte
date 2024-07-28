<script lang="ts">
	import { LinkBlock } from "$lib/ui/util";
    import { IconSquareX } from "@tabler/icons-svelte";
    import { app } from "$lib/state/app.state";
	import { onMount } from "svelte";
	import { Brightness, Theme } from "$lib/models/util";

    onMount(() => {
        const themes = Object.keys(Theme);
        const modes = Object.keys(Brightness);

        document.body.classList.remove(...themes);
        document.body.classList.remove(...modes);

        /* Dark Mode */
        if ($app.brightness !== Brightness.System) {
            document.body.classList.add($app.brightness);
        } else {
            if (document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.classList.add(Brightness.Dark);
            } else {
                document.body.classList.add(Brightness.Light);
            }
        }

        /* Accent Color */
        document.body.classList.add($app.theme);
        const themeColor = document.querySelector("meta[name='theme-color']");
        const accentColor = getComputedStyle(document.body).getPropertyValue("--accent");
        themeColor?.setAttribute("content", `rgba(${accentColor})`);

        /* Pattern */
        // document.documentElement.style.setProperty("--pattern", $app.pattern);
    });
</script>

<div
    class="flex flex-col items-center justify-center w-full h-screen bg-cover bg-center relative z-0"
    style="background-image: url('/images/mountains.jpg')"
>
    <div class="absolute top-4 left-4 hidden md:block">
        <LinkBlock
            id="back-button"
            title="Go Back"
            href="/"
        >
            <span class="link-icon no-text text-zinc-300"><IconSquareX size="32px" /></span>
        </LinkBlock>
    </div>

    <slot />
</div>