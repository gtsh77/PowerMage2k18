import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpModule }    from '@angular/http';

import { AppComponent }  from './app.component';
import { engine_m }         from './engine/engine.m';
import { routing, appRoutingProviders }  from './app.routing';

import { g_xhr }  from './g_xhr.s';

@NgModule({
  imports:      [ BrowserModule, HttpModule, engine_m, routing ],
  declarations: [ AppComponent ],
  providers: [ appRoutingProviders, g_xhr ],
  bootstrap:    [ AppComponent ]
})
export class AppModule {}