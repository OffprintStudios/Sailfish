<script lang="ts">
	import {
		ArrowRightSLine,
		ArrowLeftSLine,
		ListUnordered,
		StickyNoteLine,
		DiscussLine,
		BookmarkLine,
		OpenArmLine
	} from "svelte-remixicon";
	import FormattingDropdown from "./FormattingDropdown.svelte";
	import { onMount } from "svelte";
	import { section } from "$lib/state/section.state";
	import { ParagraphStyle, Theme, WidthSettings } from "$lib/util/constants/sections";
	import { Guide } from "$lib/ui/user/guide";
	import { account } from "$lib/state/account.state";
	import AccountDropdown from "$lib/ui/user/AccountDropdown.svelte";

	const iconSize = "22px";
	let scrollY = 0;
	let sectionContainer: HTMLDivElement;
	let sectionContainerHeight = 0;

	onMount(() => {
		const themeColor = document.querySelector("meta[name='theme-color']");
		themeColor.setAttribute("content", "rgb(247, 241, 228)");

		/* theme */
		const sectionPage = document.getElementById("section-page");
		sectionPage.classList.remove(
			Theme.white,
			Theme.paper,
			Theme.slate,
			Theme.dimmed,
			Theme.ink
		);
		sectionPage.classList.add($section.theme);

		/* font family */
		sectionPage.style.setProperty("--section-font-family", $section.font as string);

		/* width */
		switch ($section.width) {
			case WidthSettings.Normal:
				sectionPage.style.setProperty("--section-width", WidthSettings.Normal);
				break;
			case WidthSettings.Narrow:
				sectionPage.style.setProperty("--section-width", WidthSettings.Narrow);
				break;
			case WidthSettings.Wide:
				sectionPage.style.setProperty("--section-width", WidthSettings.Wide);
				break;
		}

		/* font size */
		let size = 16;
		let lineHeight = 24;
		if ($section.fontSize < 1) {
			size = Math.floor(size * $section.fontSize + 2);
			lineHeight = Math.floor(lineHeight * $section.fontSize + 2);
		} else if ($section.fontSize > 1) {
			size = Math.floor(size * $section.fontSize - 2);
			lineHeight = Math.floor(lineHeight * $section.fontSize - 2);
		}
		sectionPage.style.setProperty("--section-font-size", `${size}px`);
		sectionPage.style.setProperty("--section-line-height", `${lineHeight}px`);

		/* paragraph style */
		switch ($section.paragraphs) {
			case ParagraphStyle.original:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.indented:
				sectionPage.style.setProperty("--section-paragraph-margins", "0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
			case ParagraphStyle.doubleSpaced:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.both:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
		}

		const themeColorValue =
			getComputedStyle(sectionPage).getPropertyValue("--section-background");
		themeColor.setAttribute("content", themeColorValue);

		getSectionHeight();
	});

	function getSectionHeight() {
		sectionContainerHeight = sectionContainer.scrollHeight + 100;
	}
</script>

<svelte:window bind:scrollY />

<div id="section-page" class="section-page paper">
	<div
		class="section-tools pinned"
		class:in-content={scrollY < sectionContainerHeight}
		class:out-of-content={scrollY >= sectionContainerHeight}
	>
		<div class="flex items-center w-1/3">
			<button class="section-button">
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Back</span>
			</button>
			<div class="hidden lg:block mx-0.5"><!--spacer--></div>
			<button class="section-button no-text hide-this" title="Table of Contents">
				<ListUnordered size={iconSize} />
			</button>
			{#if $account.account && $account.currProfile}
				<button
					class="section-button no-text hide-this"
					title="Notes & Highlights"
					style="margin-right: 0.25rem;"
				>
					<StickyNoteLine size={iconSize} />
				</button>
			{/if}
			<FormattingDropdown {iconSize} />
		</div>
		<div
			class="w-1/3 flex flex-col items-center justify-center"
			style="color: var(--section-tool-header-color); font-family: var(--header-text);"
		>
			<span class="font-bold text-base relative top-1 truncate max-w-[194px]"
				>A Work Unlike Any Other</span
			>
			<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate"
				>II: The Start Of Something New</span
			>
		</div>
		<div class="w-1/3 flex items-center justify-end">
			<button class="section-button hide-this" title="Cheers">
				<OpenArmLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">4.87</span>
				<span>k</span>
			</button>
			<button class="section-button hide-this" title="Comments">
				<DiscussLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">1.23</span>
				<span>k</span>
			</button>
			{#if $account.account && $account.currProfile}
				<button class="section-button no-text" title="Bookmark Chapter">
					<BookmarkLine size={iconSize} />
				</button>
			{/if}
			{#if $account.account}
				<div class="hidden lg:block">
					<Guide mode="section" />
				</div>
				<div class="lg:hidden">
					<AccountDropdown mode="section" />
				</div>
			{/if}
		</div>
	</div>
	<div bind:this={sectionContainer}>
		<div class="section-container">
			<h1 class="text-4xl mb-16 text-center">II: The Start Of Something New</h1>
			<div class="section-body">
				<p>
					Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
					incididunt ut labore et dolore magna aliqua. Bibendum at varius vel pharetra vel
					turpis. Dictum at tempor commodo ullamcorper a lacus vestibulum. Mauris vitae
					ultricies leo integer malesuada. Tortor id aliquet lectus proin. Velit sed
					ullamcorper morbi tincidunt ornare. Aliquam sem fringilla ut morbi tincidunt
					augue interdum velit euismod. Sed arcu non odio euismod lacinia at. Ut consequat
					semper viverra nam libero. Facilisis magna etiam tempor orci eu lobortis.
					Facilisi morbi tempus iaculis urna id volutpat lacus.
				</p>
				<p>
					Lectus urna duis convallis convallis tellus id. Sed ullamcorper morbi tincidunt
					ornare massa. Nibh praesent tristique magna sit amet purus gravida quis blandit.
					Gravida rutrum quisque non tellus orci. Ut etiam sit amet nisl purus in mollis
					nunc sed. Maecenas pharetra convallis posuere morbi. Egestas erat imperdiet sed
					euismod. Porta lorem mollis aliquam ut porttitor leo a diam. Vulputate dignissim
					suspendisse in est ante in nibh. Malesuada proin libero nunc consequat. Viverra
					suspendisse potenti nullam ac tortor vitae purus faucibus ornare. Nunc pulvinar
					sapien et ligula ullamcorper malesuada. Ullamcorper a lacus vestibulum sed arcu
					non. Viverra adipiscing at in tellus integer feugiat. Volutpat maecenas volutpat
					blandit aliquam etiam. Praesent elementum facilisis leo vel fringilla est
					ullamcorper. Morbi tristique senectus et netus et malesuada fames ac.
				</p>
				<p>
					Urna nunc id cursus metus aliquam eleifend mi in. Tincidunt vitae semper quis
					lectus nulla. Etiam dignissim diam quis enim. Ut placerat orci nulla
					pellentesque dignissim enim sit amet. Id ornare arcu odio ut sem nulla.
					Fringilla phasellus faucibus scelerisque eleifend donec pretium vulputate
					sapien. Posuere sollicitudin aliquam ultrices sagittis orci a. Consequat ac
					felis donec et odio pellentesque diam. Ipsum a arcu cursus vitae congue. Sapien
					nec sagittis aliquam malesuada bibendum arcu. Ornare arcu dui vivamus arcu
					felis. Egestas sed sed risus pretium quam vulputate dignissim. Mattis vulputate
					enim nulla aliquet porttitor lacus luctus accumsan tortor. Sed risus pretium
					quam vulputate dignissim suspendisse in est. Non pulvinar neque laoreet
					suspendisse interdum consectetur libero id. Nisi quis eleifend quam adipiscing
					vitae proin sagittis nisl rhoncus. Scelerisque mauris pellentesque pulvinar
					pellentesque habitant morbi tristique senectus.
				</p>
				<p>
					Pellentesque sit amet porttitor eget dolor morbi non arcu. Nulla facilisi morbi
					tempus iaculis urna id volutpat lacus. Duis ultricies lacus sed turpis tincidunt
					id aliquet. Purus ut faucibus pulvinar elementum integer enim neque volutpat ac.
					Maecenas pharetra convallis posuere morbi leo. Tellus in metus vulputate eu
					scelerisque felis imperdiet. Mi tempus imperdiet nulla malesuada pellentesque
					elit eget gravida. Vitae justo eget magna fermentum iaculis eu non diam. Purus
					faucibus ornare suspendisse sed nisi lacus sed viverra tellus. Adipiscing enim
					eu turpis egestas pretium aenean pharetra magna. Cras pulvinar mattis nunc sed.
					Tempor orci dapibus ultrices in iaculis nunc sed. In nibh mauris cursus mattis
					molestie a iaculis at erat. Malesuada pellentesque elit eget gravida cum sociis
					natoque penatibus et.
				</p>
				<p>
					Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi.
					Sit amet justo donec enim diam vulputate ut. Praesent elementum facilisis leo
					vel fringilla est. Gravida rutrum quisque non tellus orci ac auctor augue. Magna
					ac placerat vestibulum lectus mauris ultrices eros. Eget dolor morbi non arcu
					risus. Feugiat nibh sed pulvinar proin gravida hendrerit lectus. Ultrices dui
					sapien eget mi proin sed libero. Massa tempor nec feugiat nisl pretium.
					Suspendisse potenti nullam ac tortor vitae purus faucibus ornare suspendisse.
					Massa tempor nec feugiat nisl pretium fusce id. Orci a scelerisque purus semper
					eget. Maecenas sed enim ut sem viverra aliquet eget. Dui id ornare arcu odio ut
					sem. Vitae semper quis lectus nulla at volutpat. Nunc sed velit dignissim
					sodales ut. Magna ac placerat vestibulum lectus mauris. Eget mauris pharetra et
					ultrices neque ornare aenean euismod. Tortor pretium viverra suspendisse potenti
					nullam ac tortor vitae purus.
				</p>
			</div>
			<div class="section-authors-note">
				<div class="flex items-center">
					<h3 class="text-2xl">From the author—</h3>
				</div>
				<div class="authors-note">
					<p>
						Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
						tempor incididunt ut labore et dolore magna aliqua. Sit amet consectetur
						adipiscing elit pellentesque. Condimentum vitae sapien pellentesque habitant
						morbi. Egestas fringilla phasellus faucibus scelerisque. Suspendisse
						ultrices gravida dictum fusce ut placerat orci. Accumsan lacus vel facilisis
						volutpat est. Justo laoreet sit amet cursus. Risus at ultrices mi tempus
						imperdiet.
					</p>
				</div>
			</div>
		</div>
		<div class="section-nav">
			<button class="section-button">
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Prev</span>
			</button>
			<div class="mx-2"><!--spacer--></div>
			<button class="section-button" title="Cheers">
				<OpenArmLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">4.87</span>
				<span>k</span>
			</button>
			<button class="section-button" title="Comments">
				<DiscussLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">1.23</span>
				<span>k</span>
			</button>
			<div class="mx-2"><!--spacer--></div>
			<button class="section-button">
				<span class="hidden lg:block">Next</span>
				<ArrowRightSLine class="lg:ml-1" size={iconSize} />
			</button>
		</div>
	</div>
	<div class="section-comments" />
</div>
