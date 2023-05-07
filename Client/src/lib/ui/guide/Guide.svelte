<script lang="ts">
	import { fade, fly } from "svelte/transition";
	import { closeGuide, guide } from "./guide.state";

	function close() {
		if ($guide.canClose) {
			closeGuide();
		}
	}
</script>

<div class="flex-1 relative">
	{#if $guide.open}
		<div class="absolute z-40 top-0 h-full w-full flex flex-row-reverse">
			<div
				class="absolute z-30 bg-black w-full h-full bg-opacity-50"
				transition:fade|local={{ delay: 0, duration: 100 }}
				on:click={close}
			>
				<!--backdrop-->
			</div>
			<div class="guide" transition:fly|local={{ delay: 0, duration: 200, x: 200 }}>
				<div in:fade|local={{ delay: 0, duration: 200 }}>
					<svelte:component this={$guide.routing[$guide.currPage]} />
				</div>
			</div>
		</div>
	{/if}

	<div class="h-full lg:h-screen lg:overflow-y-auto">
		<slot />
	</div>
</div>

<style lang="scss">
	div.guide {
		@apply h-full lg:h-screen z-40 min-w-full max-w-full lg:min-w-[24rem] lg:max-w-[24rem];
		@apply lg:overflow-hidden lg:overflow-y-auto;
		box-shadow: var(--dropshadow);
		background: var(--background);

		div.guide-nav {
			@apply flex items-center justify-center mb-2 lg:mb-0 lg:pt-2 lg:pb-4 sticky top-0 z-20;
			background: var(--accent);
			@media (min-width: 1024px) {
				background: linear-gradient(
					180.2deg,
					var(--background) 75%,
					rgba(255, 0, 0, 0) 100%
				);
			}
			button {
				@apply relative flex flex-col items-center justify-center w-[60px] h-[62px] lg:w-[70px] lg:h-[62px] relative lg:first:rounded-l-md lg:last:rounded-r-md;
				@apply transition transform text-white border-b-4 border-t-4 border-t-transparent border-b-transparent transition-all;
				background: var(--accent);
				&.active {
					background: var(--accent);
					border-bottom-color: var(--accent-light);
					@apply text-white;
				}
				&.disabled {
					color: var(--accent-dark);
					&:hover {
						color: var(--accent-dark);
						border-bottom-color: transparent;
					}
				}
				&:hover {
					background: var(--accent);
					border-bottom-color: var(--accent-light);
					@apply text-white;
				}
			}
		}
	}
</style>
