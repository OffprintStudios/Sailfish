DEFINE SCOPE user SESSION 4w2d SIGNUP (CREATE accounts CONTENT {
	email: $email,
	email_confirmed: false,
	password: crypto::argon2::generate($password),
	terms_agree: true
}) SIGNIN (SELECT * FROM accounts WHERE email = $email AND crypto::argon2::compare(password, $password));