import { NgModule } from '@angular/core'; 
import { CommonModule } from '@angular/common'; 

import { engine_c } from './engine.c'
import { main_c } from './main.c'
import { engine_r } from './engine.r'

import { r_map } from './r_map.s'

@NgModule({
	imports: [CommonModule, engine_r],
	declarations: [engine_c, main_c],
	providers: [r_map]
})

export class engine_m {}