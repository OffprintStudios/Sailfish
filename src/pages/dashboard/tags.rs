use leptos::prelude::*;

use crate::errors::{AppError, ErrorTemplate};
use crate::models::content::{Tag, TagKind};
use crate::ui::misc::MetaTags;

#[server(prefix = "/api/dashboard/tags", endpoint = "all")]
pub async fn load_tags(kind: TagKind, page: i64, per: i64) -> Result<Vec<Tag>, AppError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Role};

    let state = expect_context::<AppState>();
    if Session::authorize(vec![Role::Admin, Role::Moderator], &state.db).await.is_none() {
        Err(AppError::Forbidden)
    } else {
        let tags = Tag::fetch(kind, page, per, &state.db).await?;
        Ok(tags)
    }
}

#[component]
pub fn DashboardTagsPage() -> impl IntoView {
    let (curr_type, _set_curr_type) = signal(TagKind::Genre);
    let (page, _set_page) = signal(1);
    let (per, _set_per) = signal(15);

    let derived = Memo::new(move |_| (curr_type(), page(), per()));

    let tags = Resource::new(derived, move |_| load_tags(curr_type(), page(), per()));

    view! {
        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>


            <Suspense>
                {move || Suspend::new(async move {
                    tags.await.map(|tags| {
                        let (active_id, _set_active_id) = signal::<Option<String>>(None);
                        let (parents, _set_parents) = signal::<Vec<Tag>>(tags.iter().filter(|t| t.parent_id.is_none()).cloned().collect::<Vec<Tag>>());
                        let (children, set_children) = signal::<Vec<Tag>>(Vec::new());

                        Effect::new(move |_| {
                            if active_id().is_some() {
                                set_children(tags.iter().filter(|t| t.parent_id == active_id()).cloned().collect::<Vec<Tag>>());
                            }
                        });

                        view! {
                            <MetaTags
                                url="https://offprint.cafe/dashboard/tags"
                                title="Tags — Offprint"
                                description="For The Stories Left Untold"
                                image_url="/images/beatriz.png"
                            />

                            <div class="grid grid-cols-5 gap-4 max-w-6xl mx-auto w-full">
                                <div class="flex col-span-2 bg-zinc-200/25 dark:bg-zinc-700/25 backdrop-blur rounded-xl border border-white/25 default-shadow">
                                    <For
                                        each=move || parents()
                                        key=|parent| parent.id.clone()
                                        children=move |_parent| {
                                            view! {
                                                "hi"
                                            }
                                        }
                                    />
                                </div>
                                <div class="flex flex-col items-center justify-center col-span-1">
                                    ">"
                                </div>
                                <div class="flex col-span-2 bg-zinc-200/25 dark:bg-zinc-700/25 backdrop-blur rounded-xl border border-white/25 default-shadow">
                                    <For
                                        each=move || children()
                                        key=|child| child.id.clone()
                                        children=move |_child| {
                                            view! {
                                                "hi"
                                            }
                                        }
                                    />
                                </div>
                            </div>
                        }
                    })
                })}
            </Suspense>
        </ErrorBoundary>
    }
}
