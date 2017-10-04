import { Component, AfterViewInit } from '@angular/core';

@Component({
	template: '<canvas id="canvas" width="500" height="250"></canvas>'
})

export class main_c {
	private canvas: any = null;
	private ctx: CanvasRenderingContext2D = null;

	public ngAfterViewInit(): void {
		this.canvas = document.querySelector('#canvas');
		this.ctx = this.canvas.getContext('2d');
	}
}