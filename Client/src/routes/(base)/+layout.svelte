<script lang="ts">
    import { Navbar } from "$lib/ui/nav";
    import { app } from "$lib/state/app.state";
	import { onMount } from "svelte";
	import { ModeSwitch, Themes } from "$lib/models/util";

    onMount(() => {
        const themes = Object.keys(Themes);
        const modes = Object.keys(ModeSwitch);

        document.body.classList.remove(...themes);
        document.body.classList.remove(...modes);

        /* Dark Mode */
        if ($app.mode !== ModeSwitch.system) {
            document.body.classList.add($app.mode);
        } else {
            if (document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.classList.add(ModeSwitch.dark);
            } else {
                document.body.classList.add(ModeSwitch.light);
            }
        }

        /* Accent Color */
        document.body.classList.add($app.theme);
        const themeColor = document.querySelector("meta[name='theme-color']");
        const accentColor = getComputedStyle(document.body).getPropertyValue("--accent");
        themeColor?.setAttribute("content", `rgba(${accentColor})`);
    });
</script>

<Navbar />
<slot />
