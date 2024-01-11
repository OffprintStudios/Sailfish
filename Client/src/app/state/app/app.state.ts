import { Action, Selector, State, StateContext } from "@ngxs/store";
import { AppModel } from "./app.model";
import { ModeSwitch, RatingsFilter, Themes } from "$models/util";
import { Injectable } from "@angular/core";
import { AppActions } from "$state/app/app.actions";

@State<AppModel>({
    name: 'app',
    defaults: {
        theme: Themes.crimson,
        mode: ModeSwitch.system,
        showNsfw: false,
        filter: RatingsFilter.restricted,
    }
})
@Injectable({ providedIn: 'root' })
export class AppState {
    @Selector()
    static theme(state: AppModel): Themes {
        return state.theme;
    }

    @Selector()
    static mode(state: AppModel): ModeSwitch {
        return state.mode;
    }

    @Selector()
    static showNsfw(state: AppModel): boolean {
        return state.showNsfw;
    }

    @Selector()
    static filter(state: AppModel): RatingsFilter {
        return state.filter;
    }

    @Action(AppActions.SetTheme)
    setTheme(ctx: StateContext<AppModel>, action: AppActions.SetTheme) {
        const state = ctx.getState();
        ctx.patchState({
            ...state,
            theme: action.theme,
        });
    }

    @Action(AppActions.SetMode)
    setMode(ctx: StateContext<AppModel>, action: AppActions.SetMode) {
        const state = ctx.getState();
        ctx.patchState({
            ...state,
            mode: action.mode,
        });
    }

    @Action(AppActions.SetShowNSFW)
    setShowNsfw(ctx: StateContext<AppModel>) {
        const state = ctx.getState();
        ctx.patchState({
            ...state,
            showNsfw: !state.showNsfw,
        });
    }

    @Action(AppActions.SetRatingsFilter)
    setRatingsFilter(ctx: StateContext<AppModel>, action: AppActions.SetRatingsFilter) {
        const state = ctx.getState();
        ctx.patchState({
            ...state,
            filter: action.filter,
        });
    }
}
