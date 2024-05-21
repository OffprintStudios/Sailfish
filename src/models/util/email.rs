use serde::{Deserialize, Serialize};
use apalis::prelude::*;
use lettre::{SmtpTransport, Transport, Message};
use lettre::message::header::ContentType;
use lettre::transport::smtp::authentication::Credentials;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Email {
    pub kind: EmailKind,
    pub from: String,
    pub to: String,
    pub subject: String,
    pub token: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum EmailKind {
    ConfirmEmail,
    PasswordReset,
}

impl Job for Email {
    const NAME: &'static str = "apalis::Email";
}

impl Email {
    pub async fn send_mail(job: Email) {
        let base_url = std::env::var("SITE_BASE_URL")
            .expect("SITE_BASE_URL not set!");

        let smtp_host = std::env::var("SMTP_HOST")
            .expect("SMTP_HOST not set!");

        let smtp_port = std::env::var("SMTP_PORT")
            .expect("SMTP_PORT not set!")
            .parse::<u16>()
            .expect("SMTP_PORT must be an unsigned 16-bit integer!");

        let smtp_username = std::env::var("SMTP_USERNAME")
            .expect("SMTP_USERNAME not set!");

        let smtp_password = std::env::var("SMTP_PASSWORD")
            .expect("SMTP_PASSWORD not set!");

        let message = match job.kind {
            EmailKind::ConfirmEmail => {
                let token = job.token.expect("Token cannot be None.");

                leptos::ssr::render_to_string(move || leptos::view! {
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
                }).into_owned()
            },
            EmailKind::PasswordReset => {
                let token = job.token.expect("Token cannot be None.");

                leptos::ssr::render_to_string(move || leptos::view! {
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
                }).into_owned()
            }
        };

        let email = Message::builder()
            .from(job.from.parse().unwrap())
            .to(job.to.parse().unwrap())
            .subject(job.subject)
            .header(ContentType::TEXT_HTML)
            .body(message)
            .expect("Could not build message!");

        let credentials = Credentials::new(smtp_username, smtp_password);

        let mailer = match SmtpTransport::relay(&smtp_host) {
            Ok(mailer) => mailer.port(smtp_port).credentials(credentials).build(),
            Err(_) => return
        };

        _ = tokio::task::spawn_blocking(move || {
            match mailer.send(&email) {
                Ok(_) => Ok(()),
                Err(e) => Err(e)
            }
        }).await.expect("Something went wrong!");
    }
}