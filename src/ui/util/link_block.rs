use leptos::*;

pub enum KindOfLink {
    Primary,
    Normal,
}

#[component]
pub fn LinkBlock(
    id: String,
    title: String,
    href: String,
    #[prop(default = KindOfLink::Normal)] kind: KindOfLink,
    #[prop(default = false)] disabled: bool,
    #[prop(default = false)] full_width: bool,
    children: Children,
) -> impl IntoView {
    let primary = match kind {
        KindOfLink::Primary => true,
        KindOfLink::Normal => false,
    };
    
    view! {
        <a
            id=id
            title=title
            href=href
            class="btn"
            class:primary=primary
            class:w-full=full_width
            disabled=disabled
        >
            {children()}
        </a>
    }
}