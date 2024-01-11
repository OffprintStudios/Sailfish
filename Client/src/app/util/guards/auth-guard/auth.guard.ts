import { CanActivateFn } from '@angular/router';
import { inject } from "@angular/core";
import { Store } from "@ngxs/store";

export const authGuard: CanActivateFn = (route, state) => {
    const appState = inject(Store);
    return appState.selectSnapshot<boolean>(state => state.auth.isAuthenticated);
};
