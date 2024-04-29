use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;

pub enum TypeOfButton {
    Default,
    Submit,
    Reset,
}

pub enum KindOfButton {
    Primary,
    Normal
}

#[component]
pub fn Button(
    id: String,
    title: String,
    #[prop(default = TypeOfButton::Default)] type_of: TypeOfButton,
    #[prop(default = KindOfButton::Normal)] kind: KindOfButton,
    #[prop(default = false)] active: bool,
    #[prop(default = false)] loading: bool,
    #[prop(default = "".to_string())] loading_text: String,
    #[prop(default = false)] disabled: bool,
    #[prop(default = false)] full_width: bool,
    children: Children
) -> impl IntoView {
    let type_of_button = match type_of {
        TypeOfButton::Default => "button",
        TypeOfButton::Submit => "submit",
        TypeOfButton::Reset => "reset",
    };

    let primary = match kind {
        KindOfButton::Primary => true,
        KindOfButton::Normal => false
    };

    view! {
        <button
            id=id
            title=title
            type=type_of_button
            class="btn"
            class:primary=primary
            class:active=active
            class:w-full=full_width
            disabled=move || { disabled || loading }
        >
            {if loading {
                view! {
                    <span class="button-icon animate-spin"><Icon icon=remixicon::RiLoader2SystemLine /></span>
                    <span class="button-text">{loading_text}</span>
                }
            } else {
                children()
            }}
        </button>
    }
}