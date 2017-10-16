/// <reference path="../../node_modules/@types/core-js/index.d.ts" />
/// <reference path="../../node_modules/@types/mathjs/index.d.ts" />


import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app.module';
import { enableProdMode } from '@angular/core';

//enableProdMode();
const platform = platformBrowserDynamic();
platform.bootstrapModule(AppModule);