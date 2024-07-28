<script lang="ts">
    export let title: string = "Offprint";
    export let desc: string = "For The Stories Left Untold";
    export let username: string | null = null;
    export let url: string = "https://offprint.cafe/";
    export let image: string = "/images/beatriz.png"
</script>

<svelte:head>
	<title>{title}</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={title} />
	<meta name="description" content={desc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="profile" />
	<meta property="profile:username" content={username} />
	<meta property="og:url" content={url} />
	<meta property="og:title" content={title} />
	<meta property="og:description" content={desc} />
	<meta property="og:image" content={image} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta property="twitter:url" content={url} />
	<meta property="twitter:title" content={title} />
	<meta property="twitter:description" content={desc} />
	<meta property="twitter:image" content={image} />
</svelte:head>