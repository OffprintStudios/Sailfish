<script lang="ts">
	import { page, navigating } from "$app/stores";
	import {
		Compass3Fill,
		Compass3Line,
		Home5Fill,
		Home5Line,
		SearchEyeFill,
		SearchEyeLine,
		TeamFill,
		TeamLine,
		BookOpenFill,
		Book2Line,
	} from "svelte-remixicon";
	import { guide, openGuide, closeGuide } from "../guide";

	const iconSize = "24px";

	$: {
		if ($navigating !== null) {
			closeGuide();
		}
	}
</script>

<nav>
	{#if $guide.routing.length > 0}
		<button
			class="link"
			class:active={$guide.routing.length > 0}
			on:click={closeGuide}
		>
			<span class="link-icon"><BookOpenFill size={iconSize} /></span>
			<span class="link-name">Close</span>
		</button>
	{:else}
		<button
			class="link"
			on:click={openGuide}
		>
			<span class="link-icon"><Book2Line size={iconSize} /></span>
			<span class="link-name">Guide</span>
		</button>
	{/if}
	<div class="w-10/12 mx-auto border-b border-white my-2"><!--separator--></div>
	<a
		class="link"
		class:active={$page.url.pathname === '/' && $guide.open === false}
		href="/"
	>
      	<span class="link-icon">
        	{#if $page.url.pathname === '/'}
          		<Home5Fill size={iconSize} />
        	{:else}
          		<Home5Line size={iconSize} />
        	{/if}
      	</span>
		<span class="link-name">Home</span>
	</a>
	<a
		class="link"
		class:active={$page.url.pathname.startsWith('/search') && $guide.open === false}
		href="/search"
	>
      	<span class="link-icon">
        	{#if $page.url.pathname === '/search'}
          		<SearchEyeFill size={iconSize} />
        	{:else}
          		<SearchEyeLine size={iconSize} />
        	{/if}
      	</span>
		<span class="link-name">Search</span>
	</a>
	<a
		class="link"
		class:active={$page.url.pathname.startsWith('/explore') && $guide.open === false}
		href="/explore"
	>
      	<span class="link-icon">
        	{#if $page.url.pathname === '/explore'}
          		<Compass3Fill size={iconSize} />
        	{:else}
          		<Compass3Line size={iconSize} />
			{/if}
      	</span>
		<span class="link-name">Explore</span>
	</a>
	<a
		class="link"
		class:active={$page.url.pathname.startsWith('/social') && $guide.open === false}
		href="/social"
	>
      	<span class="link-icon">
        	{#if $page.url.pathname === '/social'}
				<TeamFill size={iconSize} />
        	{:else}
          		<TeamLine size={iconSize} />
        	{/if}
      	</span>
		<span class="link-name">Social</span>
	</a>
</nav>

<style lang="scss">
	nav {
		@apply flex lg:flex-col items-center w-full lg:w-[75px] z-50 relative lg:h-full py-2;
		background: var(--accent);
		box-shadow: var(--dropshadow);

		a.link,
		button.link {
			@apply p-2 mx-2 mb-1 border-2 border-transparent rounded-lg transition transform text-white flex flex-col items-center justify-center w-[61px] h-[61px] relative;
			&:hover {
				@apply no-underline;
				box-shadow: var(--dropshadow);
				background: var(--accent-light);
				color: white;
				border-color: white;
			}

			&:active {
				@apply scale-95;
			}

			&.active {
				@apply no-underline shadow-xl;
				background: var(--accent-light);
				color: white;
				border-color: white;
			}

			span.link-name {
				@apply text-[0.6rem] uppercase font-bold tracking-wider;
			}
		}
	}
</style>