use leptos::prelude::*;
use leptos::html::{Dialog, Div};
use leptos_use::on_click_outside;

#[component]
pub fn Modal(
    #[prop(into)] id: String,
    #[prop(into)] open: ReadSignal<bool>,
    #[prop(into)] set_open: WriteSignal<bool>,
    children: Children
) -> impl IntoView {
    let dialog_ref = NodeRef::<Dialog>::new();
    let container_ref = NodeRef::<Div>::new();
    
    let close_dialog = move || {
        let node = dialog_ref.get().expect("dialog_ref not loaded!");
        node.close();
    };
    
    let _ = on_click_outside(container_ref, move |_| {
        close_dialog();
    });
    
    Effect::new(move |_| {
        let node = dialog_ref.get().expect("dialog_ref should be loaded by now");
        if open.get() {
            let _ = node.show_modal();
        }
    });

    view! {
        <dialog
            id=id
            class="backdrop:bg-zinc-900/50 backdrop:backdrop-blur-lg open:backdrop:animate-[modal-show_200ms_ease_normal] bg-transparent rounded-xl"
            style="box-shadow: var(--dropshadow)"
            on:close=move |_| set_open.set(false)
            node_ref=dialog_ref
        >
            <div
                class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur animate-modalf rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 overflow-hidden"
                style="color: var(--text-color);"
                node_ref=container_ref
            >
                {children()}
            </div>
        </dialog>
    }
}