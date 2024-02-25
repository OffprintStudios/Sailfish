<script lang="ts">
    import { RiLoginCircleLine, RiArrowLeftRightLine, RiInbox2Line } from "svelte-remixicon";
    import { Library } from "lucide-svelte";
    import { auth } from "$lib/state/auth.state";
    import { page } from "$app/stores";
	import SearchMenu from "./SearchMenu.svelte";
	import Guide from "./guide/Guide.svelte";
</script>

<div class="navbar-container">
    <nav class="flex items-center max-w-[90rem] w-full md:w-11/12 pl-4 pr-2 md:px-0 mx-auto h-full">
        <div class="flex items-center w-1/3 text-white">
            <a href="/"><h3 class="text-2xl font-bold tracking-tighter text-white">Offprint</h3></a>
            <a class="page-link" class:active={$page.url.pathname.startsWith("/explore")} href="/explore">Explore</a>
            <a class="page-link" class:active={$page.url.pathname.startsWith("/social")} href="/social">Social</a>
        </div>
        <div class="w-1/3">
            <SearchMenu />
        </div>
        <div class="flex items-center w-1/3" style="font-family: var(--header-text);">
            <div class="flex-1"><!--spacer--></div>
            {#if $auth.account}
                {#if $auth.currProfile}
                    <button class="navbar-button">
                        <span class="icon"><RiInbox2Line size="24px" /></span>
                        <span class="text">1.2k</span>
                    </button>
                    <button class="navbar-button">
                        <span class="icon"><Library size="24" strokeWidth="2.5" /></span>
                        <span class="text">12</span>
                    </button>
                    <Guide />
                {:else}
                    <a class="navbar-button" href="/switch-profile">
                        <span class="icon"><RiArrowLeftRightLine size="20px" /></span>
                        <span class="link-text">Profiles</span>
                    </a>
                {/if}
            {:else}
                <a class="navbar-button" href="/log-in">
                    <span class="icon"><RiLoginCircleLine size="20px" /></span>
                    <span class="link-text">Log In</span>
                </a>
            {/if}
            <!--@if (isAuthenticated$ | async) {
                @if (currProfile$ | async; as profile) {
                    <button class="navbar-button">
                        <span class="icon"><ng-icon name="remixInbox2Line" size="24px" /></span>
                        <span class="text">1.2k</span>
                    </button>
                    <button class="navbar-button">
                        <span class="icon"><ng-icon name="lucideLibrary" size="24px" strokeWidth="2.5" /></span>
                        <span class="text">12</span>
                    </button>
                    <app-user-menu />
                } @else {
                    <a class="navbar-button" [routerLink]="['/auth/switch-profile']">
                        <span class="icon"><ng-icon name="lucideArrowRightLeft" size="18px" /></span>
                        <span class="link-text">Profiles</span>
                    </a>
                }
            } @else {
                <a class="navbar-button" [routerLink]="['/auth/log-in']">
                    <span class="icon"><ng-icon name="lucideLogIn" size="18px" /></span>
                    <span class="link-text">Log In</span>
                </a>
            }-->

        </div>
    </nav>
</div>

<style lang="scss">
    div.navbar-container {
        @apply sticky top-0 w-full h-[55px] md:h-[65px] z-50 drop-shadow-2xl border-b border-white border-opacity-25 backdrop-blur-lg;
        background-color: rgb(var(--accent));
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);

        &.not-home {
            @apply border-b-transparent;
            /* background-color: rgba(var(--accent), 0.80);*/
        }

        button.navbar-button, a.navbar-button {
            @apply hidden md:flex items-center text-white mx-0.5 px-2 py-2 rounded-xl transition;

            & > span {
                @apply relative;
            }

            & > span.text {
                @apply top-0.5 ml-1.5 hidden lg:block;
            }

            &:hover {
                @apply bg-zinc-300 bg-opacity-25 backdrop-blur;
            }
        }

        a.navbar-button {
            @apply flex text-base px-3 py-2;

            & > span.link-text {
                @apply hidden md:block all-small-caps font-bold tracking-wider ml-1.5;
            }
        }

        a.page-link {
            @apply hidden md:block relative top-0.5 text-white ml-4 all-small-caps text-lg border-b-2 border-transparent transition font-semibold;
            font-family: var(--header-text);

            &.active {
                @apply border-zinc-300 border-opacity-50;
            }
        }
    }
</style>
