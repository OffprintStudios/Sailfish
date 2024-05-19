use lettre::{AsyncSmtpTransport, Tokio1Executor};
use lettre::transport::smtp::authentication::Credentials;

pub async fn configure_mailer() -> Option<AsyncSmtpTransport<Tokio1Executor>> {
    let smtp_server = match std::env::var("SMTP_HOST") {
        Ok(server) => server,
        Err(_) => return None
    };
    
    let smtp_port = match std::env::var("SMTP_PORT") {
        Ok(port) => port.parse::<u16>().expect("SMTP_PORT is not valid! Only unsigned 16-bit integers are allowed."),
        Err(_) => return None
    };
    
    let smtp_username = match std::env::var("SMTP_USERNAME") {
        Ok(username) => username,
        Err(_) => return None
    };
    
    let smtp_password = match std::env::var("SMTP_PASSWORD") {
        Ok(password) => password,
        Err(_) => return None
    };
    
    let mailer: AsyncSmtpTransport<Tokio1Executor> = match AsyncSmtpTransport::<Tokio1Executor>::relay(&smtp_server) {
        Ok(mailer) => {
            mailer
                .port(smtp_port)
                .credentials(Credentials::new(smtp_username, smtp_password))
                .build()
        },
        Err(_) => return None
    };

    Some(mailer)
}