<script lang="ts">
	import { onMount } from "svelte";
	import type { Readable } from "svelte/store";
	import { BubbleMenu as BubbleMenuComponent, createEditor, EditorContent, Editor } from "svelte-tiptap";
	import {
		RiAddBoxLine,
		RiAlignCenter,
		RiAlignJustify,
		RiAlignLeft,
		RiAlignRight,
		RiArrowGoBackLine,
		RiArrowGoForwardLine,
		RiBold as BoldIcon,
		RiDoubleQuotesR,
		RiFilmLine,
		RiH1,
		RiH2,
		RiH3,
		RiImageAddLine,
		RiItalic as ItalicIcon,
		RiLink as LinkIcon,
		RiLinkUnlink,
		RiListUnordered,
		RiSeparator,
		RiStrikethrough,
		RiText as TextIcon,
		RiUnderline as UnderlineIcon,
		RiEraserLine,
		RiPaintFill
	} from "svelte-remixicon";
	import Underline from "@tiptap/extension-underline";
	import Typography from "@tiptap/extension-typography";
	import Image from "@tiptap/extension-image";
	import Link from "@tiptap/extension-link";
	import Blockquote from "@tiptap/extension-blockquote";
	import Code from "@tiptap/extension-code";
	import TextAlign from "@tiptap/extension-text-align";
	import Placeholder from "@tiptap/extension-placeholder";
	import Dropcursor from "@tiptap/extension-dropcursor";
	import BubbleMenu from "@tiptap/extension-bubble-menu";
	import Bold from "@tiptap/extension-bold";
	import BulletList from "@tiptap/extension-bullet-list";
	import Document from "@tiptap/extension-document";
	import Gapcursor from "@tiptap/extension-gapcursor";
	import HardBreak from "@tiptap/extension-hard-break";
	import Heading from "@tiptap/extension-heading";
	import History from "@tiptap/extension-history";
	import HorizontalRule from "@tiptap/extension-horizontal-rule";
	import Italic from "@tiptap/extension-italic";
	import ListItem from "@tiptap/extension-list-item";
	import OrderedList from "@tiptap/extension-ordered-list";
	import Paragraph from "@tiptap/extension-paragraph";
	import Strike from "@tiptap/extension-strike";
	import Text from "@tiptap/extension-text";
	import Youtube from "@tiptap/extension-youtube";
	import TextStyle from "@tiptap/extension-text-style";
	import Color from "@tiptap/extension-color";
	import { Dropdown } from "$lib/ui/util";

	let bubbleMenu: HTMLElement;
	let editor: Readable<Editor>;
	let linkText: string | undefined, imgSrc: string | undefined, vidSrc: string | undefined;
	let linkMenuOpen = false;

	export let label: string;
    export let required = false;
    export let hint: string | undefined = undefined;
	export let value: string;
	export let errorMessage: string | null = null;
	export let hasHeader = false;

	onMount(() => {
		editor = createEditor({
			extensions: [
				Bold,
				Italic,
				Underline,
				Strike,
				Paragraph,
				Text,
				BulletList,
				ListItem,
				OrderedList,
				Document,
				Gapcursor,
				HardBreak,
				Heading.configure({ levels: [2, 3, 4] }),
				History,
				HorizontalRule,
				Typography,
				Image.configure({ inline: true }),
				Link.configure({ openOnClick: false }),
				Blockquote,
				Code,
				TextStyle,
				Color,
				Youtube.configure({
					width: 480,
					height: 360,
					inline: true
				}),
				TextAlign.configure({ types: ["paragraph", "heading", "image"] }),
				Placeholder.configure({ placeholder: "Write something here..." }),
				Dropcursor,
				BubbleMenu.configure({ element: bubbleMenu })
			],
			content: value,
			onUpdate: (props) => {
				value = props.editor.getHTML();
			}
		});
	});

	function insertLink() {
		if (linkText) {
			$editor.chain().focus().setLink({ href: linkText }).run();
			linkText = undefined;
			linkMenuOpen = false;
		}
	}

	function insertImage() {
		if (imgSrc) {
			$editor.chain().focus().setImage({ src: imgSrc }).run();
			imgSrc = undefined;
		}
	}

	function insertVideo() {
		if (vidSrc) {
			$editor.chain().focus().setYoutubeVideo({ src: vidSrc }).run();
			vidSrc = undefined;
		}
	}

	$: {
		if ($editor) {
			if (value === "" || value === undefined || value === null) {
				$editor.commands.setContent(value);
			}
		}
	}
</script>

{#if label}
    <label for="offprint-editor" class="flex items-center all-small-caps font-bold tracking-wide relative left-2 select-none">
        {label}<span class="text-red-600 text-xl relative top-0.5 ml-1">*{required ? '*' : ''}</span>
        {#if hint}
            <span class="flex-1"><!--spacer--></span>
            <span class="italic text-zinc-500 dark:text-zinc-400 relative right-4">{hint}</span>
        {/if}
    </label>
{/if}
<div
	id="offprint-editor"
	class="w-full flex flex-col rounded-b-lg bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-lg"
	class:rounded-t-lg={!hasHeader}
>
	{#if $editor}
		<div class="editor-bar">
			<button
				on:click={() => $editor.chain().focus().toggleBold().run()}
				class:active={$editor.isActive("bold")}
				type="button"
				title="Bold"
			>
				<BoldIcon />
			</button>
			<button
				on:click={() => $editor.chain().focus().toggleItalic().run()}
				class:active={$editor.isActive("italic")}
				type="button"
				title="Italic"
			>
				<ItalicIcon />
			</button>
			<button
				on:click={() => $editor.chain().focus().toggleUnderline().run()}
				class:active={$editor.isActive("underline")}
				type="button"
				title="Underline"
			>
				<UnderlineIcon />
			</button>
			<button
				on:click={() => $editor.chain().focus().toggleStrike().run()}
				class:active={$editor.isActive("strike")}
				type="button"
				title="Strikethrough"
			>
				<RiStrikethrough />
			</button>
			<span class="text-lg mx-0.5">|</span>
			<Dropdown title="Text Options">
				<svelte:fragment slot="button">
					<TextIcon class="button-icon" />
					<span class="button-text">Text</span>
				</svelte:fragment>
				<svelte:fragment slot="items">
					<button
						on:click={() => $editor.chain().focus().setParagraph().run()}
						class:active={$editor.isActive("paragraph")}
						type="button"
					>
						<TextIcon class="mr-2" />
						<span>Paragraph</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleHeading({ level: 2 }).run()}
						class:active={$editor.isActive("heading", { level: 2 })}
						type="button"
					>
						<RiH1 class="mr-2" />
						<span>Heading 1</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleHeading({ level: 3 }).run()}
						class:active={$editor.isActive("heading", { level: 3 })}
						type="button"
					>
						<RiH2 class="mr-2" />
						<span>Heading 2</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleHeading({ level: 4 }).run()}
						class:active={$editor.isActive("heading", { level: 4 })}
						type="button"
					>
						<RiH3 class="mr-2" />
						<span>Heading 3</span>
					</button>
				</svelte:fragment>
			</Dropdown>
			<span class="text-lg mx-0.5">|</span>
			<Dropdown title="Alignment Options">
				<svelte:fragment slot="button">
					<RiAlignLeft class="button-icon" />
					<span class="button-text">Align</span>
				</svelte:fragment>
				<svelte:fragment slot="items">
					<button
						on:click={() => $editor.chain().focus().setTextAlign("left").run()}
						class:active={$editor.isActive({ textAlign: "left" })}
						type="button"
					>
						<RiAlignLeft class="mr-2" />
						<span>Align Left</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().setTextAlign("center").run()}
						class:active={$editor.isActive({ textAlign: "center" })}
						type="button"
					>
						<RiAlignCenter class="mr-2" />
						<span>Align Center</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().setTextAlign("right").run()}
						class:active={$editor.isActive({ textAlign: "right" })}
						type="button"
					>
						<RiAlignRight class="mr-2" />
						<span>Align Right</span>
					</button>
					<button
						on:click={() => $editor.chain().focus().setTextAlign("justify").run()}
						class:active={$editor.isActive({ textAlign: "justify" })}
						type="button"
					>
						<RiAlignJustify class="mr-2" />
						<span>Align Justify</span>
					</button>
				</svelte:fragment>
			</Dropdown>
			<span class="text-lg mx-0.5">|</span>
			<Dropdown title="Add Image">
				<svelte:fragment slot="button">
					<RiImageAddLine class="button-icon no-text" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					<form
						class="flex items-center w-[15.75rem]"
						on:submit|preventDefault|stopPropagation={insertImage}
					>
						<input
							class="bg-zinc-300 dark:bg-zinc-600 rounded-lg focus:ring-0 border-transparent py-2"
							type="text"
							placeholder="Paste image link here..."
							bind:value={imgSrc}
						/>
						<button type="submit"><RiAddBoxLine size="24px" class="mr-0" /></button>
					</form>
				</svelte:fragment>
			</Dropdown>
			<Dropdown title="Add YouTube Video">
				<svelte:fragment slot="button">
					<RiFilmLine class="button-icon no-text" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					<form
						class="flex items-center w-[15.75rem]"
						on:submit|preventDefault|stopPropagation={insertVideo}
					>
						<input
							class="bg-zinc-300 dark:bg-zinc-600 rounded-lg focus:ring-0 border-transparent py-2"
							type="text"
							placeholder="Paste YouTube link here..."
							bind:value={vidSrc}
						/>
						<button type="submit"><RiAddBoxLine size="24px" class="mr-0" /></button>
					</form>
				</svelte:fragment>
			</Dropdown>
			<span class="text-lg mx-0.5">|</span>
			<button
				on:click={() => $editor.chain().focus().toggleBlockquote().run()}
				class:active={$editor.isActive("blockquote")}
				type="button"
				title="Quote"
			>
				<RiDoubleQuotesR />
			</button>
			<button
				on:click={() => $editor.chain().focus().setHorizontalRule().run()}
				type="button"
				title="Separator"
			>
				<RiSeparator />
			</button>
			<button
				on:click={() => $editor.chain().focus().toggleBulletList().run()}
				class:active={$editor.isActive("bulletList")}
				type="button"
				title="List"
			>
				<RiListUnordered />
			</button>
			<div class="flex-1"><!--spacer--></div>
			<button
				on:click={() => $editor.chain().focus().undo().run()}
				type="button"
				title="Undo"
			>
				<RiArrowGoBackLine />
			</button>
			<button
				on:click={() => $editor.chain().focus().redo().run()}
				type="button"
				title="Redo"
			>
				<RiArrowGoForwardLine />
			</button>
		</div>
	{/if}
	<EditorContent editor={$editor} on:change />
	{#if $editor}
		<BubbleMenuComponent editor={$editor}>
			<div class="bubble-bar bg-zinc-700 highlight-shadowed">
				<div class="flex items-center p-0.5">
					<button
						on:click={() => $editor.chain().focus().toggleBold().run()}
						class:active={$editor.isActive("bold")}
						type="button"
					>
						<BoldIcon />
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleItalic().run()}
						class:active={$editor.isActive("italic")}
						type="button"
					>
						<ItalicIcon />
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleUnderline().run()}
						class:active={$editor.isActive("underline")}
						type="button"
					>
						<UnderlineIcon />
					</button>
					<button
						on:click={() => $editor.chain().focus().toggleStrike().run()}
						class:active={$editor.isActive("strike")}
						type="button"
					>
						<RiStrikethrough />
					</button>
					<input
						type="color"
						class="color-picker"
						title="Text Color"
						on:change={(event) =>
							$editor.chain().focus().setColor(event.target?.value).run()}
					/>
					<button
						on:click={() => $editor.chain().focus().unsetColor().run()}
						type="button"
						title="Clear Color"
					>
						<RiPaintFill />
					</button>
					<button
						on:click={() => $editor.chain().focus().clearNodes().unsetAllMarks().run()}
						type="button"
						title="Clear Formatting"
					>
						<RiEraserLine />
					</button>
					<span class="text-lg mx-0.5 text-white">|</span>
					{#if $editor.isActive("link")}
						<button
							on:click={() => $editor.chain().focus().unsetLink().run()}
							class:active={$editor.isActive("link")}
							type="button"
						>
							<RiLinkUnlink />
						</button>
					{:else}
						<button
							on:click={() => (linkMenuOpen = !linkMenuOpen)}
							class:active={linkMenuOpen}
							type="button"
						>
							<LinkIcon />
						</button>
					{/if}
				</div>
				{#if linkMenuOpen}
					<div class="border-t border-white">
						<form
							class="flex items-center"
							on:submit|preventDefault|stopPropagation={insertLink}
						>
							<input
								class="bg-zinc-700 w-[14rem] rounded-bl-lg focus:ring-0 border-transparent py-1 text-white"
								type="text"
								placeholder="Paste link here..."
								bind:value={linkText}
							/>
							<button
								class="border-l border-white rounded-none rounded-br-lg"
								type="button"
								on:click={insertLink}
							>
								<RiAddBoxLine />
							</button>
						</form>
					</div>
				{/if}
			</div>
		</BubbleMenuComponent>
	{/if}
</div>

<style lang="scss">
	div.editor-bar {
		@apply flex items-center p-1 relative flex-wrap;
	}
	div.bubble-bar {
		@apply rounded-lg max-w-[18rem] transition transform;
		button {
			@apply text-white;
		}
	}
	:global(.dark button) {
		&:hover,
		&.active {
			@apply bg-zinc-500 bg-opacity-75;
		}
	}
	button {
		@apply p-2 rounded-lg transition transform flex items-center;
		&:hover,
		&.active {
			@apply bg-zinc-400 bg-opacity-75;
		}
	}
	input[type="color"].color-picker {
		@apply rounded-full w-4 h-4 mx-1;
		&::-webkit-color-swatch-wrapper {
			@apply p-0.5;
		}
		&::-webkit-color-swatch {
			border: var(--borders);
			@apply rounded-full;
		}
	}
</style>
