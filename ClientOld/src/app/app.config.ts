import { ApplicationConfig, importProvidersFrom, isDevMode } from '@angular/core';
import { provideRouter, withComponentInputBinding, withViewTransitions } from '@angular/router';
import { provideHttpClient, withFetch } from "@angular/common/http";
import { routes } from './app.routes';
import { provideClientHydration } from '@angular/platform-browser';
import { NgxsModule } from "@ngxs/store";
import { NgxsStoragePluginModule } from "@ngxs/storage-plugin";
import { AuthState } from "$state/auth";
import { provideAnimations } from "@angular/platform-browser/animations";
import { provideToastr } from "ngx-toastr";
import { AppState } from "$state/app";
import { NgxsDispatchPluginModule } from "@ngxs-labs/dispatch-decorator";
import { NgxsSelectSnapshotModule } from "@ngxs-labs/select-snapshot";
import { NgxTiptapModule } from "ngx-tiptap";

export const appConfig: ApplicationConfig = {
    providers: [
        provideAnimations(),
        provideRouter(routes, withViewTransitions(), withComponentInputBinding()),
        provideHttpClient(
            withFetch()
        ),
        provideClientHydration(),
        importProvidersFrom(
            NgxsModule.forRoot([
                AuthState,
                AppState,
            ], {developmentMode: isDevMode()}),
            NgxsStoragePluginModule.forRoot({
                key: ['auth', 'app']
            }),
            NgxsDispatchPluginModule.forRoot(),
            NgxsSelectSnapshotModule.forRoot(),
        ),
        provideToastr(),
    ],
};
