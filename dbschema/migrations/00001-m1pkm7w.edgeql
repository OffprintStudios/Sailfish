CREATE MIGRATION m1pkm7w4xvwaoxb5pvb6sp5w2dhrtijrdtmx4jy3okx3rrlppivspa
    ONTO initial
{
  CREATE EXTENSION pgcrypto VERSION '1.3';
  CREATE EXTENSION auth VERSION '1.0';
  CREATE SCALAR TYPE default::Role EXTENDING enum<admin, moderator, chatmoderator, workapprover, contributor, user>;
  CREATE TYPE default::Account {
      CREATE REQUIRED LINK identity: ext::auth::Identity {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY accountRole: default::Role {
          SET default := 'user';
      };
      CREATE PROPERTY createdAt: std::datetime {
          CREATE REWRITE
              INSERT 
              USING (std::datetime_of_statement());
      };
      CREATE REQUIRED PROPERTY email: std::str;
      CREATE REQUIRED PROPERTY emailConfirmed: std::bool;
      CREATE REQUIRED PROPERTY password: std::str;
      CREATE REQUIRED PROPERTY termsAgree: std::bool;
      CREATE PROPERTY updatedAt: std::datetime {
          CREATE REWRITE
              INSERT 
              USING (std::datetime_of_statement());
          CREATE REWRITE
              UPDATE 
              USING (std::datetime_of_statement());
      };
  };
  CREATE GLOBAL default::current_user := (std::assert_single((SELECT
      default::Account
  FILTER
      (.identity = GLOBAL ext::auth::ClientTokenIdentity)
  )));
};
