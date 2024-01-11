import { ProfileForm, RegisterForm } from "$models/accounts";

export namespace AuthActions {
    export class LogIn {
        static readonly type = '[Auth] Log In';
        constructor(public payload: { email: string, password: string }) {}
    }

    export class Register {
        static readonly type = '[Auth] Register';
        constructor(public payload: RegisterForm) {}
    }

    export class LogOut {
        static readonly type = '[Auth] Log Out';
    }

    export class FetchProfiles {
        static readonly type = '[Auth] Fetch Profiles';
    }

    export class CreateProfile {
        static readonly type = '[Auth] Create Profile';
        constructor(public payload: ProfileForm) {}
    }

    export class SelectProfile {
        static readonly type = '[Auth] Select Profile';
        constructor(public payload: string) {}
    }
}
