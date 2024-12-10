use leptos::prelude::*;
use leptos::either::Either;
use leptos_icons::*;
use icondata as TablerIcon;

pub enum ButtonType {
    Default,
    Submit,
    Reset,
}

pub enum ButtonKind {
    Normal,
    Primary,
}

#[component]
pub fn Button(
    #[prop(into)] id: String,
    #[prop(into)] title: String,
    #[prop(default = ButtonType::Default)] type_of: ButtonType,
    #[prop(default = ButtonKind::Normal)] kind: ButtonKind,
    #[prop(default = false)] active: bool,
    #[prop(default = false)] loading: bool,
    #[prop(into, default = String::from(""))] loading_text: String,
    #[prop(default = false)] disabled: bool,
    #[prop(default = false)] full_width: bool,
    children: Children
) -> impl IntoView {
    let type_of_button = match type_of {
        ButtonType::Default => "button",
        ButtonType::Submit => "submit",
        ButtonType::Reset => "reset",
    };
    
    view! {
        <button
            id=id
            title=title
            type=type_of_button
            class="btn"
            class:primary=move || matches!(kind, ButtonKind::Primary)
            class:active=active
            class:w-full=full_width
            disabled=move || { disabled || loading }
        >
            {if loading {
                Either::Left(
                    view! {
                        <span class="button-icon animate-spin"><Icon icon=TablerIcon::TbLoader2 /></span>
                        <span class="button-text">{loading_text}</span>
                    }
                )
                
            } else {
                Either::Right(children())
            }}
        </button>
    }
}