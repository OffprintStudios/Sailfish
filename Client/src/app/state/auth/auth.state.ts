import { Injectable } from "@angular/core";
import { State, Action, StateContext, Selector } from "@ngxs/store";
import { AuthActions } from "./auth.actions";
import { AuthModel } from "./auth.model";
import { AuthService } from "./auth.service";
import { tap } from 'rxjs/operators';
import { Profile } from "$models/accounts";

@State<AuthModel>({
    name: 'auth',
    defaults: {
        account: undefined,
        token: undefined,
        profiles: [],
        currProfile: undefined,
    },
})
@Injectable({ providedIn: 'root' })
export class AuthState {
    @Selector()
    static isAuthenticated(state: AuthModel): boolean {
        return !!state.token;
    }

    @Selector()
    static profiles(state: AuthModel): Profile[] {
        return state.profiles;
    }

    @Selector()
    static currProfile(state: AuthModel): Profile | undefined {
        return state.currProfile;
    }

    constructor(private readonly auth: AuthService) {}

    @Action(AuthActions.LogIn)
    logIn(ctx: StateContext<AuthModel>, action: AuthActions.LogIn) {
        return this.auth.logIn(action.payload.email, action.payload.password).pipe(
            tap(result => {
                if (result.emailConfirmed) {
                    ctx.setState({
                        account: result,
                        token: result.token,
                        profiles: [],
                        currProfile: undefined,
                    });
                }
            }),
        );
    }

    @Action(AuthActions.Register)
    register(_ctx: StateContext<AuthModel>, action: AuthActions.Register) {
        return this.auth.register(action.payload);
    }

    @Action(AuthActions.LogOut)
    logOut(ctx: StateContext<AuthModel>) {
        ctx.setState({
            account: undefined,
            token: undefined,
            profiles: [],
            currProfile: undefined,
        });
    }

    @Action(AuthActions.FetchProfiles)
    fetchProfiles(ctx: StateContext<AuthModel>) {
        const state = ctx.getState();
        return this.auth.fetchProfiles(state.token!).pipe(
            tap(result => {
                ctx.setState({
                    ...state,
                    profiles: result,
                });
            }),
        );
    }

    @Action(AuthActions.CreateProfile)
    createProfile(ctx: StateContext<AuthModel>, action: AuthActions.CreateProfile) {
        const state = ctx.getState();
        return this.auth.createProfile(action.payload, state.token!).pipe(
            tap(result => {
                ctx.patchState({
                    profiles: [...state.profiles, result]
                });
            }),
        );
    }

    @Action(AuthActions.SelectProfile)
    selectProfile(ctx: StateContext<AuthModel>, action: AuthActions.SelectProfile) {
        const state = ctx.getState();
        ctx.patchState({
            ...state,
            currProfile: state.profiles.find((profile) => profile.id === action.payload),
        });
    }
}
