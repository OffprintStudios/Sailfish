<script lang="ts">
	import { CloseLine, Loader5Line } from "svelte-remixicon";
	import { closePopup, popup } from "../popup";
	import { Button } from "../util";
	import { UploadService, UploadType } from "./upload.service";

	const uploadService = new UploadService(UploadType.BlogBanner, $popup.data.blogId);
</script>

<div class="upload-container bg-zinc-300 dark:bg-zinc-700">
	<div class="upload-header">
		<h3>Upload Cover Art</h3>
		<Button on:click={closePopup}>
			<CloseLine size="20px" class="button-icon no-text" />
		</Button>
	</div>
	{#if uploadService.isUploading}
		<div class="w-96 h-48 flex flex-col items-center justify-center">
			<div class="flex items-center justify-center">
				<Loader5Line class="animate-spin mr-2" size="24px" />
				<span class="text-xs uppercase font-bold tracking-widest">Uploading...</span>
			</div>
		</div>
	{:else}
		<div
			class="body-standby"
			on:drop|preventDefault={(e) => uploadService.handleDrop(e)}
		>
			<h3 class="font-medium text-2xl">Drag & Drop</h3>
			<span class="text-sm">
                or
                <label>
                    <input
						class="hidden"
						type="file"
						accept=".jpg, .jpeg, .png"
						on:change={(e) => uploadService.handleFileSelected(e)}
					/>
                    <span class="file-input">click here</span>
                </label> to pick something awesome
            </span>
		</div>
	{/if}
</div>