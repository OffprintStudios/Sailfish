use lettre::{AsyncSmtpTransport, AsyncTransport, Message, Tokio1Executor};
use lettre::message::header::ContentType;
use crate::error_template::SailfishError;

/// Sends an account confirmation email
pub async fn send_confirmation(email_address: String, token: String, mailer: &AsyncSmtpTransport<Tokio1Executor>) -> Result<(), SailfishError> {
    let base_url = std::env::var("SITE_BASE_URL")
        .expect("No SITE_BASE_URL set! Are you sure the environment is configured correctly?");

    let html = leptos::ssr::render_to_string(move || leptos::view! {
        <div>
            <h1>"Welcome to Offprint!"</h1>
            <p>
                "On behalf of all of us on the dev team, we're so glad that you're here."
            </p>
            <p>
                "But first, we're gonna need to confirm your account. To get started, click the link below to verify your email address. Won't take more than a few seconds."
            </p>
            <a href=format!("{base_url}/confirm-email?token={token}")>"Verify Your Email Address"</a>
            <p>
                "Just a reminder: this code expires in one hour. And with that, we hope you enjoy!"
            </p>
        </div>
    }).into_owned();

    let email = Message::builder()
        .from("Beatriz <beatriz@offprint.cafe>".parse().unwrap())
        .to(email_address.as_str().parse().unwrap())
        .subject("Welcome to Offprint!")
        .header(ContentType::TEXT_HTML)
        .body(html)
        .map_err(|_| SailfishError::ServerError)?;

    match mailer.send(email).await {
        Ok(_) => {
            Ok(())
        },
        Err(_) => Err(SailfishError::ServerError)
    }
}

/// Sends a password reset email
pub async fn send_password_reset(email_address: String, token: String, mailer: &AsyncSmtpTransport<Tokio1Executor>) -> Result<(), SailfishError> {
    let base_url = std::env::var("SITE_BASE_URL")
        .expect("No SITE_BASE_URL set! Are you sure the environment is configured correctly?");

    let html = leptos::ssr::render_to_string(move || leptos::view! {
        <div>
            <h1>"Reset your Offprint password"</h1>
            <p>
                "Hey there! We've gotten word that you want to reset your Offprint password. If that's what you want, hit the link below to get started."
            </p>
            <a href=format!("{base_url}/reset-password?token={token}")>"Reset Your Password"</a>
            <p>
                "Otherwise, feel free to ignore this message. It'll expire after 1 hour."
            </p>
        </div>
    }).into_owned();

    let email = Message::builder()
        .from("Beatriz <beatriz@offprint.cafe>".parse().unwrap())
        .to(email_address.as_str().parse().unwrap())
        .subject("Reset your Offprint password")
        .header(ContentType::TEXT_HTML)
        .body(html)
        .map_err(|_| SailfishError::ServerError)?;

    match mailer.send(email).await {
        Ok(_) => Ok(()),
        Err(_) => Err(SailfishError::ServerError)
    }
}

