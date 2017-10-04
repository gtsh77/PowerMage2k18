import { ModuleWithProviders }  from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { engine_c }    from './engine.c';
import { main_c }    from './main.c';

const e_routes: Routes = [
  {
    path: 'develop',
    component: engine_c,
    children: [ 
	    {
	        path: '',
	        component: main_c
	    }
    ]
  }
];

export const engine_r: ModuleWithProviders = RouterModule.forChild(e_routes);