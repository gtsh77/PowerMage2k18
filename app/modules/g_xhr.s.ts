import { Injectable } from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { Observable } from 'rxjs';

import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/map';

interface IPostParams {
	url: string;
	body?: {};
	header?: string[];
}

@Injectable()
export class g_xhr {
	
	constructor(private http:Http){}
	public headers: Headers = null;

	doGET(obj: IPostParams): Observable<any> {
		this.headers = new Headers({'Content-Type': 'application/json'});
		this.headers.append('Accept', 'application/json, text/plain, */*');
		obj.header && this.headers.append(obj.header[0],obj.header[1]);

		return this.http.get(obj.url, {headers: this.headers});
	}
	doDELETE(obj: IPostParams): Observable<any> {
		this.headers = new Headers({'Content-Type': 'application/json'});
		this.headers.append('Accept', 'application/json, text/plain, */*');
		obj.header && this.headers.append(obj.header[0],obj.header[1]);

		return this.http.delete(obj.url, {headers: this.headers});
	}
	doPOST(obj: IPostParams): Observable<any> {
		this.headers = new Headers({'Content-Type': 'application/json'});
		this.headers.append('Accept', 'application/json, text/plain, */*');
		obj.header && this.headers.append(obj.header[0],obj.header[1]);

		return this.http.post(obj.url, (obj.body)?((typeof obj.body === 'object')?JSON.stringify(obj.body):obj.body):null, {headers: this.headers});
	}
	doXHR(options,callback){
		let req = new XMLHttpRequest();
		req.open(options.method, options.url, true);
		req.setRequestHeader('Accept', 'application/json, text/plain, */*');
        if(options.header){
        	for(var a in options.header){
        		req.setRequestHeader(options.header[a][0],options.header[a][1]);
        	}
        }
		req.send(options.body);
		req.onreadystatechange = function(){
			if(req.readyState === 4) callback(req.status,((req.responseText)?JSON.parse(req.responseText):null));
		}
	}	
}