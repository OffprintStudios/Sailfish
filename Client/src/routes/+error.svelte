<script lang="ts">
    import { page } from "$app/stores";
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

    enum ErrorMessages {
        NotFound = "The page you're looking for ain't 'round here, friend",
        Unauthorized = "You shouldn't toy with fate like that",
        Forbidden = "The ancient ways shall remain unknown to you, traveler",
        ServerError = "Look, this page isn't a bug—it's a feature",
        ServiceUnavailable = "Cleaning the espresso machines, be back soon"
    }
</script>

<div
    class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0"
    style="background-image: url('/images/backpacker.jpg')"
>
    <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">{$page.status}: {$page.error?.message}</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                {#if $page.error}
                    {#if $page.status === 404}
                        {ErrorMessages.NotFound}
                    {:else if $page.status === 401}
                        {ErrorMessages.Unauthorized}
                    {:else if $page.status === 403}
                        {ErrorMessages.Forbidden}
                    {:else if $page.status === 500}
                        {ErrorMessages.ServerError}
                    {:else if $page.status === 503}
                        {ErrorMessages.ServiceUnavailable}
                    {:else}
                        {$page.error.message}
                    {/if}
                {/if}
            </span>
        </div>
    </div>
</div>