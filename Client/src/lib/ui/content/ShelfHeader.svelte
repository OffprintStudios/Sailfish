<script lang="ts">
	import { account } from "../../state/account.state";
	import type { Shelf } from "../../models/content/library";
	import { abbreviate, pluralize, slugify } from "../../util/functions";
	import { Time, Button } from "../util";
	import { BarChart2Line, MoreFill, DeleteBinLine, Edit2Line, LockLine, LockUnlockLine } from "svelte-remixicon";
	import { Dropdown } from "../dropdown";
	import { delReq, patchReq } from "../../http";
	import type { ResponseError } from "../../http";
	import toast from "svelte-french-toast";
	import { openPopup } from "../popup";
	import DeleteShelfPrompt from "./DeleteShelfPrompt.svelte";
	import EditShelfPrompt from "./EditShelfPrompt.svelte";
	import { goto } from "$app/navigation";
	import { page } from "$app/stores";

	export let shelf: Shelf;
	let changingVisibility = false;

	async function changeVisibility() {
		changingVisibility = true;
		const response = await patchReq<Shelf>(`/shelves/update?shelfId=${shelf.id}&profileId=${$account.currProfile.id}`, {
			name: shelf.name,
			desc: shelf.desc,
			isPublic: !shelf.isPublic,
		});
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			shelf = response as Shelf;
		}
		changingVisibility = false;
	}

	function editShelf() {
		openPopup(EditShelfPrompt, {
			onConfirm: (data: Shelf) => {
				shelf = data;
			}
		}, { shelf });
	}

	function deleteShelf() {
		openPopup(DeleteShelfPrompt, {
			onConfirm: async () => {
				let result = await toast.promise<void | ResponseError>(
					delReq<void>(`/shelves/delete?profileId=${$account.currProfile.id}&shelfId=${shelf.id}`),
					{
						loading: 'Deleting...',
						success: 'Shelf deleted!',
						error: null
					}
				);
				if ((result as ResponseError).error) {
					const error = result as ResponseError;
					toast.error(error.message)
				}
				if ($page.url.pathname.includes('/profile')) {
					await goto(`/profile/${$account.currProfile.id}/${slugify($account.currProfile.username)}/shelves`);
				} else {
					await goto(`/library/shelves`);
				}
			}
		})
	}
</script>

<div class="flex items-center bg-zinc-200 dark:bg-zinc-700 p-4 rounded-t-xl dark:highlight-shadowed border-b-4 relative" style="border-color: var(--accent);">
	{#if $account.account && $account.currProfile && $account.currProfile.id}
		<div class="absolute top-2 right-2 flex items-center">
			<Button loading={changingVisibility} loadingText="" on:click={changeVisibility}>
				{#if shelf.isPublic}
					<LockUnlockLine class="button-icon no-text" size="18px" />
				{:else}
					<LockLine class="button-icon no-text" size="18px" />
				{/if}
			</Button>
			<div class="mx-0.5"></div>
			<Dropdown position="bottom-end">
				<svelte:fragment slot="button">
					<MoreFill class="button-icon no-text" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					<button type="button" on:click={editShelf}>
						<Edit2Line size="18px" class="mr-1" />
						<span>Edit shelf</span>
					</button>
					<div class="my-0.5"></div>
					<button type="button" on:click={deleteShelf}>
						<DeleteBinLine size="18px" class="mr-1" />
						<span>Delete shelf</span>
					</button>
				</svelte:fragment>
			</Dropdown>
		</div>
	{/if}
	<div class="p-6 pr-11">
		<BarChart2Line size="48px" />
	</div>
	<div class="flex-1">
		<h1 class="text-4xl text-white">{shelf.name}</h1>
		<div class="flex items-center text-zinc-400 text-lg" style="font-family: var(--header-text)">
			<span>{abbreviate(shelf.works)} work{pluralize(shelf.works)}</span>
			<span class="mx-1">•</span>
			<span>Updated <Time timestamp={shelf.updatedAt} relative /></span>
		</div>
		{#if shelf.desc}
			<div class="mt-4 bg-zinc-300 dark:bg-zinc-600 p-2 rounded-xl w-full">
				{shelf.desc}
			</div>
		{/if}
	</div>
</div>