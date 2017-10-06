import { Component, AfterViewInit, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

interface IGameObjects {
	[id: number]: any;
}

interface IGameTextures {
	[id: string]: IGameTexturesItem
}

interface IGameTexturesItem {
	isLoaded?: boolean;
	img: any;
	url: string;
}

@Component({
	template: '<canvas id="canvas" controls (p_controls_e)="controls($event)" [width]="viewportWidth * factor" [height]="viewportHeight * factor"></canvas>'
})

export class main_c {
	private debug: boolean = false;
	private viewportWidth: number = 20;
	private viewportHeight: number = 10;
	private mapWidth: number = null;
	private mapHeight: number = null;
	private factor: number = 32;

	private canvas: any = null;
	private ctx: CanvasRenderingContext2D = null;

	private map: number[] = null;
	private gameObjects: IGameObjects = null;
	private gameTextures: IGameTextures = null;

	constructor(private route: ActivatedRoute){}

	public ngOnInit(): void {
		window.scope = this;
		this.route.data.forEach((data: any ) => {
			this.map = data.mapData.json();
			this.mapHeight = this.mapWidth = Math.sqrt(this.map.length);
		});
	}

	public ngAfterViewInit(): void {		
		this.canvas = document.querySelector('#canvas');
		this.ctx = this.canvas.getContext('2d');
		this.defineGameObjects();
		this.loadGameTextures(() => {
			this.drawViewport();
		});		
	}

	public isAllDataLoaded(): boolean {
		for(let item in this.gameTextures) 
			if(!this.gameTextures[item].isLoaded) return false;
		return true;
	}	

	public loadGameTextures(callback: () => void): void {
		for(let id in this.gameTextures){
			this.gameTextures[id].img.src = this.gameTextures[id].url;
			this.gameTextures[id].img.onload = () => {
				this.gameTextures[id].isLoaded = true;
			}
		}

		let chkAssetsTimer = setInterval(() => {
			if(this.isAllDataLoaded()){
				clearInterval(chkAssetsTimer);
				callback();
			}
		},250);		
	}

	public defineGameObjects(): void {

		this.gameObjects = {
			1: 'player',
			10: 'strongwall',
			20: 'easywall',
			30: 'lockeddoor',
			40: 'key',
			50: 'item1',
			51: 'item2',
			52: 'item3',
			53: 'mana_potion',
			60: 'portal',
			101: 'horde_mage',
			102: 'horde_grunt',
			201: 'allience_vendor'
		}

		this.gameTextures = {
			'brick1': {
				img: (new Image(32,32)),
				url: '/assets/current/brick1.jpg'
			},
			'wall1': {
				img: (new Image(32,32)),
				url: '/assets/current/wall1.jpg'
			},
			'player1': {
				img: (new Image(16,24)),
				url: '/assets/current/player1.gif'
			},
			'player2': {
				img: (new Image(32,32)),
				url: '/assets/current/player2.png'
			},
			'horde_grunt': {
				img: (new Image(21,32)),
				url: '/assets/current/horde_grunt.png'
			},
			'mana_potion': {
				img: (new Image(32,32)),
				url: '/assets/current/mana_potion.png'
			}
		}
	}

	public drawObject(j,j2,i2): void {
		if(this.map[j] !== 0){
			if(this.gameObjects[this.map[j]] === 'player'){
				//draw brick then image
				// this.ctx.fillStyle = 'red';
				// this.ctx.fillRect(j2,i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['brick1'].img, j2, i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['player2'].img, j2, i2,32,32);
			}
			else if(this.gameObjects[this.map[j]] === 'horde_grunt'){
				//draw brick then image
				// this.ctx.fillStyle = 'green';
				// this.ctx.fillRect(j2,i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['brick1'].img, j2, i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['horde_grunt'].img, j2 + 4, i2,21,32);
			}
			else if(this.gameObjects[this.map[j]] === 'mana_potion'){
				//draw brick then image
				// this.ctx.fillStyle = 'blue';
				// this.ctx.fillRect(j2,i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['brick1'].img, j2, i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['mana_potion'].img, j2, i2,32,32);
			}
			else if(this.gameObjects[this.map[j]] === 'strongwall' || this.gameObjects[this.map[j]] === 'easywall'){
				this.ctx.drawImage(this.gameTextures['wall1'].img, j2, i2,this.factor, this.factor);
				// this.ctx.fillStyle = '#000';
				// this.ctx.fillRect(j2,i2,this.factor, this.factor);
			}
		}
		else {
			this.ctx.drawImage(this.gameTextures['brick1'].img, j2, i2,this.factor, this.factor);
		}		
	}

	public controls(direction: string): void {
		let curplayerPos: number = this.map.indexOf(1),
			curplayerLine: number = Math.floor(curplayerPos/this.mapWidth),
			newPlayerPos: number = null,
			newPlayerLine: number = null;

		if(direction === 'left'){
			newPlayerPos = curplayerPos - 1;
			newPlayerLine = Math.floor(newPlayerPos/this.mapWidth);
			if(curplayerLine !== newPlayerLine) return;
		} 
		else if(direction === 'right'){
			newPlayerPos = curplayerPos + 1;
			newPlayerLine = Math.floor((newPlayerPos + 1)/this.mapWidth);
			if(curplayerLine !== newPlayerLine) return;			
		} 
		else if(direction === 'up'){
			newPlayerPos = curplayerPos - this.mapWidth;
			if(newPlayerPos < 0) return;

		} 
		else if(direction === 'down'){
			newPlayerPos = curplayerPos + this.mapWidth;
			newPlayerLine = Math.floor(newPlayerPos/this.mapWidth);
			if(newPlayerLine + 2 > this.mapHeight) return;	
		} 

		if(this.map[newPlayerPos] === 0){
			this.map[curplayerPos] = 0;
			this.map[newPlayerPos] = 1;
			this.clearViewport();
			this.drawViewport();
		}
	}

	public clearViewport(): void {
		this.ctx.clearRect(0,0,this.viewportWidth,this.viewportHeight);
	}

	public drawViewport(): void {
		//calc pre-render staff
		let extendX2: boolean = false,
			extendUpLines: boolean = false,
			y: number = this.map.indexOf(1),
			curLine: number = Math.floor(y/this.mapWidth),
			x1: number = y - Math.floor(this.viewportWidth/2),
			x2: number = y + Math.floor(this.viewportWidth/2),
			nDownLines: number = null,
			nUpLines: number = null;

		if(Math.floor(x1/this.mapWidth) !== curLine){
			x1 = this.mapWidth * curLine;
			extendX2 = true;
		}
		if(Math.floor(x2/this.mapWidth) !== curLine){
			x2 = this.mapWidth * (curLine + 1);
			x1 -= (Math.floor(this.viewportWidth/2) - (x2 - y));
		}
		if(extendX2){
			x2 += (Math.floor(this.viewportWidth/2) - (y - x1));
		}
		if((curLine + Math.floor(this.viewportHeight/2)) * this.mapWidth < this.map.length){
			nDownLines = Math.floor(this.viewportHeight/2);
		}
		else {
			extendUpLines = true;
			nDownLines = this.mapHeight - curLine;

		}
		if(Math.floor(this.viewportHeight/2) < curLine){
			nUpLines = Math.floor(this.viewportHeight/2);
		}
		else {
			nUpLines = curLine;
			nDownLines += Math.floor(this.viewportHeight/2) - nUpLines;
		}
		if(extendUpLines){
			nUpLines += Math.floor(this.viewportHeight/2) - nDownLines;
		}

		if(this.debug) console.log(curLine,y,x1,x2,nDownLines,nUpLines);

		//start rendering
		for(let i: number = nUpLines, i2: number = 0; i >= -nDownLines; i--, i2 += this.factor){
			let start: number = x1 - (this.mapWidth * i);
			let end: number = x2 - (this.mapWidth * i);
			for(let j: number = start, j2: number = 0; j <= end; j++, j2 += this.factor){
				this.drawObject(j,j2,i2);
			}
		}
	}
}

declare let window: windowplus;

interface windowplus extends Window {
	scope: main_c;
}