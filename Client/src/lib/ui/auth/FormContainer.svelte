<script lang="ts">
	import { Button } from "../util";
	import { CloseLine } from "svelte-remixicon";
	import { closePopup } from "../popup";
	import LoginForm from "./LoginForm.svelte";
	import RegisterForm from "./RegisterForm.svelte";

	enum FormTabs {
		LoginForm,
		RegisterForm,
	}

	let currTab = FormTabs.LoginForm;
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="flex items-center px-2 py-2 bg-zinc-300 dark:bg-zinc-600">
		<button
			class="tab-button"
			on:click={() => currTab = FormTabs.LoginForm}
			class:active={currTab === FormTabs.LoginForm}
		>
			Log in
		</button>
		<button
			class="tab-button"
			on:click={() => currTab = FormTabs.RegisterForm}
			class:active={currTab === FormTabs.RegisterForm}
		>
			Sign up
		</button>
		<div class="flex-1"><!--spacer--></div>
		<Button on:click={closePopup}>
			<CloseLine size="28px" class="button-icon no-text" />
		</Button>
	</div>
	<div>
		{#if currTab === FormTabs.LoginForm}
			<LoginForm />
		{:else}
			<RegisterForm />
		{/if}
	</div>
</div>

<style lang="scss">
	button.tab-button {
		@apply px-4 py-2 flex items-center justify-center border-b-4 border-b-transparent rounded-t-xl font-bold all-small-caps text-lg tracking-wide transition;
		&:hover {
			border-bottom-color: var(--accent-light);
		}
		&.active {
			border-bottom-color: var(--accent);
		}
	}
</style>
