import { Component, AfterViewInit, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
	template: '<canvas id="canvas" [width]="viewportWidth" [height]="viewportHeight"></canvas>'
})

export class main_c {
	private viewportWidth: number = 500;
	private viewportHeight: number = 250;
	private mapWidth: number = 2500;
	private mapHeight: number = 250;
	private factor: number = 25;

	private canvas: any = null;
	private ctx: CanvasRenderingContext2D = null;

	private map: number[] = null;

	constructor(private route: ActivatedRoute){}

	public ngOnInit(): void {
		this.route.data.forEach((data: any ) => {
			this.map = data.mapData.json();
		});
	}

	public ngAfterViewInit(): void {
		window.scope = this;
		this.canvas = document.querySelector('#canvas');
		this.ctx = this.canvas.getContext('2d');
	}

	public clearField(): void {
		this.ctx.clearRect(0,0,this.viewportWidth,this.viewportHeight);
	}

	public drawViewport(): void {
		//get y
		let y: number = this.map.indexOf(1);
		//get curLine
		let curLine: number = Math.floor(y/(this.mapWidth/this.factor));
		//get x1
		let x1: number = y - Math.floor(this.viewportWidth/this.factor/2);
		if(Math.floor(x1/(this.mapWidth/this.factor)) !== curLine){
			x1 = (this.mapWidth/this.factor) * curLine;
		}
		//get x2
		let x2: number = y + Math.floor(this.viewportWidth/this.factor/2);
		if(Math.floor(x2/(this.mapWidth/this.factor)) !== curLine){
			x2 = (this.mapWidth/this.factor) * (curLine + 1) - 1;
			//extend x1
			x1 -= (Math.floor(this.viewportWidth/this.factor/2) - (x2 - y));
		}
		//extend x2
		if(Math.floor(x1/(this.mapWidth/this.factor)) !== curLine){
			//extend x2
			x2 += (Math.floor(this.viewportWidth/this.factor/2) - (y - x1));
		}
		//get nDownLines
		let nDownLines: number = null;
		if(curLine + Math.floor(this.viewportHeight/this.factor/2) * this.mapWidth/this.factor <= this.map.length){
			nDownLines = Math.floor(this.viewportHeight/this.factor/2);
		}
		else nDownLines = this.mapWidth/this.factor - curLine;
		//get nUpLines
		let nUpLines: number = null;
		if(Math.floor(this.viewportHeight/this.factor/2) < curLine){
			nUpLines = Math.floor(this.viewportHeight/this.factor/2);
		}
		else nUpLines = curLine;

		console.log(curLine,y,x1,x2,nDownLines,nUpLines);

		//start rendering
		for(let i: number = nUpLines, i2: number = 0; i >= -nDownLines ;i--,i2+=this.factor){
			let start: number = x1 - ((this.mapWidth/this.factor) * i);
			let end: number = x2 - ((this.mapWidth/this.factor) * i);
			for(let j: number = start, j2: number = 0; j <= end; j++,j2+=this.factor){
				//console.log('draw',i,j);
				//define is there obj?
				if(this.map[j] !== 0){
					if(this.map[j] === 2) this.ctx.fillStyle = 'black';
					else if(this.map[j] === 1) this.ctx.fillStyle = 'red';
				}
				else this.ctx.fillStyle = 'white';				
				this.ctx.fillRect(j2,i2,this.factor, this.factor);
			}
		}
	}
}

declare var window: any;