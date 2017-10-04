import { NgModule } from '@angular/core'; 
import { CommonModule } from '@angular/common'; 

import { engine_c } from './engine.c'
import { main_c } from './main.c'
import { engine_r } from './engine.r'

@NgModule({
	imports: [CommonModule, engine_r],
	declarations: [engine_c, main_c],
	providers: []
})

export class engine_m {}