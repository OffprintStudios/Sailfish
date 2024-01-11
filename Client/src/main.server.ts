import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from '$pages/app.component';
import { config } from './app/app.config.server';

const bootstrap = () => bootstrapApplication(AppComponent, config);

export default bootstrap;
