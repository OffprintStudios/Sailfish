using extension auth;

module default {
    scalar type Role extending enum<admin, moderator, chatmoderator, workapprover, contributor, user>;

    global current_user := (
        assert_single((
            select Account
            filter .identity = global ext::auth::ClientTokenIdentity
        ))
    );

    type Account {
        required identity: ext::auth::Identity {
            constraint exclusive;
        };

        required email: str;
        required password: str;
        accountRole: Role {
            default := "user";
        };

        required termsAgree: bool;
        required emailConfirmed: bool;

        createdAt: datetime {
            rewrite insert using (datetime_of_statement());
        }
        updatedAt: datetime {
            rewrite insert using (datetime_of_statement());
            rewrite update using (datetime_of_statement());
        }
    }
}
