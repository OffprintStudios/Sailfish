import { ActivatedRouteSnapshot, ResolveFn, RouterStateSnapshot } from "@angular/router";
import { Profile } from "$models/accounts";
import { Observable } from "rxjs";
import { ProfileService } from "$util/services/profile/profile.service";
import { inject } from "@angular/core";

export const ProfileResolver: ResolveFn<Profile> = (
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot,
    service = inject(ProfileService)
): Observable<Profile> => {
    return service.fetchOne(route.params["id"]);
}
