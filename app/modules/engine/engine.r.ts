import { ModuleWithProviders }  from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { engine_c }    from './engine.c';
import { main_c }    from './main.c';
import { r_map }    from './r_map.s';

const e_routes: Routes = [
  {
    path: 'develop',
    component: engine_c,
    children: [ 
	    {
	        path: 'level/:map',
	        component: main_c,
          resolve: {
            mapData: r_map
          }
	    }
    ]
  }
];

export const engine_r: ModuleWithProviders = RouterModule.forChild(e_routes);