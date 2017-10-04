import { Component, AfterViewInit, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
	template: '<canvas id="canvas" [width]="viewportWidth" [height]="viewportHeight"></canvas>'
})

export class main_c {
	private viewportWidth: number = 500;
	private viewportHeight: number = 250;

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
		
	}
}

declare var window: any;