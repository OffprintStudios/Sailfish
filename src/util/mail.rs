use resend_rs::{Client, Result};
use resend_rs::types::SendEmail;

/// Sends an account confirmation email
pub async fn send_confirmation(email_address: String, token: String, client: &Client) -> Result<()> {
    let base_url = std::env::var("BASE_URL")
        .expect("No BASE_URL set! Are you sure the environment is configured correctly?");
    
    let from = "Beatriz <beatriz@offprint.net>";
    let to = [email_address.as_str()];
    let subject = "Welcome to Offprint!";
    
    let html = leptos::ssr::render_to_string(move || leptos::view! {
        <div>
            <h1>"Welcome to Offprint!"</h1>
            <p>
                "On behalf of all of us on the dev team, we're so glad that you're here."
            </p>
            <p style="margin-bottom: 4rem;">
                "But first, we're gonna need to confirm your account. To get started, click the link below to verify your email address. Won't take more than a few seconds."
            </p>
            <a href=format!("{base_url}/confirm-email?token={token}")>"Verify Your Email Address"</a>
            <p style="margin-top: 4rem;">
                "And with that, we hope you enjoy!"
            </p>
        </div>
    });
    
    let email = SendEmail::new(from, to, subject)
        .with_html(html.as_str())
        .with_tag("Account Confirmation");
    
    let id = client.clone().emails.send(email).await?;
    println!("id: {id}");
    Ok(())
}

/// Sends a password reset email
pub async fn send_password_reset(email_address: String, token: String, client: &Client) -> Result<()> {
    let base_url = std::env::var("BASE_URL")
        .expect("No BASE_URL set! Are you sure the environment is configured correctly?");
    
    let from = "Beatriz <beatriz@offprint.net>";
    let to = [email_address.as_str()];
    let subject = "Reset your Offprint password";
    
    let html = leptos::ssr::render_to_string(move || leptos::view! {
        <div>
            <h1>"Reset your Offprint password"</h1>
            <p style="margin-bottom: 4rem;">
                "Hey there! We've gotten word that you want to reset your Offprint password. If that's what you want, hit the link below to get started."
            </p>
            <a href=format!("{base_url}/reset-password?token={token}")>"Reset Your Password"</a>
            <p style="margin-top: 4rem;">
                "Otherwise, feel free to ignore this message. It'll expire after 1 hour."
            </p>
        </div>
    });
    
    let email = SendEmail::new(from, to, subject)
        .with_html(html.as_str())
        .with_tag("Password Reset");
    
    let id = client.clone().emails.send(email).await?;
    println!("id: {id}");
    Ok(())
}

