import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent }  from './app.component';
import { engine_m }         from './engine/engine.m';
import { routing, appRoutingProviders }  from './app.routing';

@NgModule({
  imports:      [ BrowserModule, engine_m, routing ],
  declarations: [ AppComponent ],
  providers: [ appRoutingProviders ],
  bootstrap:    [ AppComponent ]
})
export class AppModule {}