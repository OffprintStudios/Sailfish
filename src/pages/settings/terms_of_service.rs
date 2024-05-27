use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::error_template::{ErrorTemplate, SailfishError};
use crate::ui::util::{MetaTagOptions, MetaTags, LinkBlock};

#[cfg(feature = "ssr")]
use pulldown_cmark::{Parser, html::push_html};

#[server]
pub async fn render_terms_of_service_page() -> Result<String, ServerFnError> {
    let to_parse = r#"
## 1. Terms

By accessing the website at https://offprint.cafe, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this website are protected by applicable copyright and trademark law.

## 2. Use License

A. Permission is granted to temporarily download one copy of the materials (information or software) on Offprint Studios' website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:
* modify or copy the materials;
* use the materials for any commercial purpose, or for any public display (commercial or non-commercial);
* attempt to decompile or reverse engineer any software contained on Offprint Studios' website;
* remove any copyright or other proprietary notations from the materials; or
* transfer the materials to another person or "mirror" the materials on any other server.

B. This license shall automatically terminate if you violate any of these restrictions and may be terminated by Offprint Studios at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.

## 3. Disclaimer
A. The materials on Offprint Studios' website are provided on an 'as is' basis. Offprint Studios makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.

B. Further, Offprint Studios does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to this site.

## 4. Limitations

In no event shall Offprint Studios or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Offprint Studios' website, even if Offprint Studios or a Offprint Studios authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.

## 5. Accuracy of Materials

The materials appearing on Offprint Studios' website could include technical, typographical, or photographic errors. Offprint Studios does not warrant that any of the materials on its website are accurate, complete or current. Offprint Studios may make changes to the materials contained on its website at any time without notice. However Offprint Studios does not make any commitment to update the materials.

## 6. Links

Offprint Studios has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Offprint Studios of the site. Use of any such linked website is at the user's own risk.

## 7. Modifications

Offprint Studios may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the then current version of these terms of service.

## 8. Governing Law

These terms and conditions are governed by and construed in accordance with the laws of California and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.
    "#;

    let parser = Parser::new(to_parse);
    let mut parsed_str = String::new();
    push_html(&mut parsed_str, parser);
    
    Ok(parsed_str)
}

#[component]
pub fn TermsOfService() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/settings/about/terms-of-service".to_string(),
        title: "Terms of Service — Offprint".to_string(),
        author_url: None,
        description: "Our Terms of Service".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <Await
            future=render_terms_of_service_page
            blocking=true
            children=|data| {
                let page_data = data.clone();
            
                view! {
                    <ErrorBoundary fallback=move|_| {
                        let mut errors = Errors::default();
                        errors.insert_with_default_key(SailfishError::ServerError);
                        view! {
                            <ErrorTemplate outside_errors=errors />
                        }   
                    }>
                        <div class="flex flex-col gap-4 p-6">
                            <div class="flex items-center sticky top-6">
                                <LinkBlock
                                        id="go-back".to_string()
                                    title="Go Back".to_string()
                                    href="/settings/about".to_string()
                                >
                                    <span class="button-icon"><Icon icon=remixicon::RiArrowLeftSArrowsLine /></span>
                                    <span class="button-text">"Back"</span>
                                </LinkBlock>
                            </div>
                            <article class="prose prose-base dark:text-white dark:prose-strong:text-white dark:prose-a:text-accent mx-auto my-12 w-11/12">
                                <div class="text-center">
                                    <h1 class="flex flex-col">
                                        <span>"Terms of Service"</span>
                                        <span class="text-lg text-zinc-600 dark:text-zinc-300">"Platform Concerns"</span>
                                        <span class="text-base text-zinc-600 dark:text-zinc-300 italic">"Edited February 25, 2024"</span>
                                    </h1>
                                </div>
                                
                                <div inner_html=page_data.unwrap_or_default()></div>
                            </article>
                        </div>
                        
                    </ErrorBoundary>
                }
            }
        />
    }
}