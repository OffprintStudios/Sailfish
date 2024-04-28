use leptos::*;
use leptos_use::on_click_outside;

#[component]
pub fn Modal(
    id: String,
    #[prop(into)] open: ReadSignal<bool>,
    #[prop(into)] set_open: WriteSignal<bool>,
    children: Children
) -> impl IntoView {
    let dialog_ref = create_node_ref::<html::Dialog>();
    let div_ref = create_node_ref::<html::Div>();

    let close_dialog = move || {
        let node = dialog_ref.get().expect("dialog_ref should be loaded by now");
        node.close();
    };

    let _ = on_click_outside(div_ref, move |_| {
        close_dialog();
    });

    create_effect(move |_| {
        let node = dialog_ref.get().expect("dialog_ref should be loaded by now");
        if open.get() {
            let _ = node.show_modal();
        }
    });

    view! {
        <dialog
            id=id
            class="block backdrop:bg-zinc-900/50 backdrop:backdrop-blur-lg open:backdrop:animate-[modal-show_200ms_ease_normal] bg-transparent rounded-xl"
            style="box-shadow: var(--dropshadow)"
            on:close=move |_| set_open.set(false)
            _ref=dialog_ref
        >
            <div
                class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur animate-modalf rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 overflow-hidden"
                style="color: var(--text-color);"
                _ref=div_ref
            >
                {children()}
            </div>
        </dialog>
    }
}