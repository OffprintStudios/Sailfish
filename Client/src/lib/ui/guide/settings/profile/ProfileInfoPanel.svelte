<script lang="ts">
	import { createForm } from "felte";
	import { account } from "$lib/state/account.state";
	import { ArrowLeftSLine, ImageEditLine } from "svelte-remixicon";
	import { Button, Avatar } from "$lib/ui/util";
	import { prevPage } from "$lib/ui/guide";

	const { form } = createForm({
		async onSubmit(values) {
			console.log(values);
		},
		initialValues: {
			username: $account.currProfile.username,
			bio: $account.currProfile.info.bio,
		}
	});
</script>

<div class="panel-container">
	<div class="topbar">
		<div class="left-button">
			<Button on:click={prevPage}>
				<ArrowLeftSLine class="button-icon" />
				<span class="button-text">Settings</span>
			</Button>
		</div>
	</div>
	<div class="content-container">
		<div class="panel-section">
			<h3>Avatar</h3>
			<div class="panel-box">
				<Avatar src={$account.currProfile.avatar} size="100px" borderWidth="1px" />
				<div class="my-1"><!--spacer--></div>
				<Button>
					<ImageEditLine class="button-icon" />
					<span class="button-text">Change Avatar</span>
				</Button>
			</div>
		</div>
		<div class="panel-section">
			<h3>Profile Info</h3>
			<div class="panel-box">
				<form class="w-full" use:form>
					<label class="flex flex-col w-full">
						<span class="font-bold text-[0.7rem] relative left-2 uppercase tracking-wide">Username</span>
						<input
							type="text"
							name="username"
							placeholder="A New Face"
							class="w-full rounded-lg border-transparent py-2.5 bg-zinc-300 dark:bg-zinc-600"
						/>
					</label>
					<div class="my-4"><!--spacer--></div>
					<label class="flex flex-col w-full">
						<span class="font-bold text-[0.7rem] relative left-2 uppercase tracking-wide">Bio</span>
						<textarea
							name="bio"
							placeholder="Just Another Somebody"
							class="w-full rounded-lg border-transparent py-2.5 bg-zinc-300 dark:bg-zinc-600 min-h-[8rem] max-h-[8rem]"
						></textarea>
					</label>
				</form>
			</div>
		</div>
	</div>
</div>

<style lang="scss">
	@use '../../Guide';
</style>