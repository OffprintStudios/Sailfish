<script lang="ts">
	import { getReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { EventType, type Notification } from "$lib/models/notifications";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	let loading = false;
	let activity: Paginate<Notification> = {
		items: [],
		metadata: {
			page: 1,
			per: 20,
			total: 0
		}
	};

	async function fetchActivity() {
		loading = true;
		const response = await getReq<Paginate<Notification>>(
			`/notifications/fetch-activity?profileId=${$account.currProfile?.id}&page=1&per=20`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			activity = response as Paginate<Notification>;
		}
		loading = false;
	}
</script>
