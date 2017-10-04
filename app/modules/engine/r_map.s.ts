import { Injectable }     from '@angular/core';
import { Resolve, Router, ActivatedRouteSnapshot  } from '@angular/router';
import { g_xhr }  from '../g_xhr.s';
import { Observable } from 'rxjs';

@Injectable()
export class r_map implements Resolve<any> {
	constructor(private router:Router, private xhr: g_xhr){}
	resolve(route: ActivatedRouteSnapshot): Observable<any> {
		let map = route.params['map'];
		return this.xhr.doGET({
			url: `maps/map_${map}.json`,
			header: ['Authorization','Bearer'],
			body: {}
		}).catch(() => {
			this.router.navigateByUrl('/');
			return [null];
		});
	}
}