use lettre::SmtpTransport;
use lettre::transport::smtp::authentication::Credentials;

/// Configures the connection to the mail server in an adhoc way so that it can be consumed when it needs to be.
pub fn configure_mailer() -> Option<SmtpTransport> {
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

    let mailer = match SmtpTransport::relay(&smtp_server) {
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