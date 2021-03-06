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

interface ICoords {
	X: number;
	Y: number;
}

interface IFactors {
	a: number;
	b: number;
	c: number;
	d: number;
	e: number;
	f: number;
	g: number;
	h: number;
}

interface imain_c {
	ngAfterViewInit: () => void;
	calculateFactors: (x1,y1,x2,y2,x3,y3,x4,y4,X1,Y1,X2,Y2,X3,Y3,X4,Y4) => IFactors;
}

@Component({
	template: '<canvas id="canvas" controls (p_controls_e)="controls($event)" [width]="viewportWidth * factor" [height]="viewportHeight * factor"></canvas><canvas id="canvas2" [width]="viewportWidth * factor" [height]="viewportHeight * factor"></canvas>'
})

export class main_c implements imain_c {
	private debug: boolean = false;
	private viewportWidth: number = 20;
	private viewportHeight: number = 10;
	private mapWidth: number = null;
	private mapHeight: number = null;
	private factor: number = 32;

	private canvas: any = null;
	private ctx: CanvasRenderingContext2D = null;

	private canvas2: any = null;
	private ctx3d: CanvasRenderingContext2D = null;

	private map: number[] = null;
	private gameObjects: IGameObjects = null;
	private gameTextures: IGameTextures = null;

	private isPlayerGoLeft: boolean = true;

	constructor(private route: ActivatedRoute){}

	public ngOnInit(): void {
		//debug links
		window.scope = this;
		window.ctx = this.ctx3d;
		//load tiles for current map and set map dimensions
		this.route.data.forEach((data: any ) => {
			this.map = data.mapData.json();
			this.mapHeight = this.mapWidth = Math.sqrt(this.map.length);
		});
	}

	public ngAfterViewInit(): void {
		//init dom objects
		this.canvas = document.querySelector('#canvas');
		this.ctx = this.canvas.getContext('2d');
		this.canvas2 = document.querySelector('#canvas2');
		this.ctx3d = this.canvas2.getContext('2d');
		//define game objects
		this.defineGameObjects();
		//load textures and start 2d & 3d renders
		this.loadGameTextures(() => {
			this.draw2d();
			this.draw3d('down');
		});
		//debug link
		window.ctx = this.ctx3d;
		//test wall rotation
		let deg: number = 0;
		// setInterval(()=>{
		// 	if(deg === 10) deg = 0;
		// 	this.drawTrapezoid(deg);			
		// 	deg++;

		// },250);
	}

	// find x-matrix from A*X = B (perspective homography transformation)
	public calculateFactors(x1,y1,x2,y2,x3,y3,x4,y4,X1,Y1,X2,Y2,X3,Y3,X4,Y4): IFactors {
		let factors: IFactors = {
			a: 0,
			b: 0,
			c: 0,
			d: 0,
			e: 0,
			f: 0,
			g: 0,
			h: 0
		};

		let A: any = math.matrix([
				[x1,y1,1,0,0,0,-x1*X1,-y1*X1],
				[x2,y2,1,0,0,0,-x2*X2,-y2*X2],
				[x3,y3,1,0,0,0,-x3*X3,-y3*X3],
				[x4,y4,1,0,0,0,-x4*X4,-y4*X4],
				[0,0,0,x1,y1,1,-x1*Y1,-y1*Y1],
				[0,0,0,x2,y2,1,-x2*Y2,-y2*Y2],
				[0,0,0,x3,y3,1,-x3*Y3,-y3*Y3],
				[0,0,0,x4,y4,1,-x4*Y4,-y4*Y4]
			]);

		let B: any = math.matrix([X1,X2,X3,X4,Y1,Y2,Y3,Y4]);

		// let A: any = math.matrix([
		// 		[x1, y1, 1, 0,  0,  0, -x1*X1, -x1*Y1],
		// 		[0,  0,  0, x1, y1, 1, -y1*X1, -y1*Y1],
		// 		[x2, y2, 1, 0,  0,  0, -x2*X2, -x2*Y2],
		// 		[0,  0,  0, x2, y2, 1, -y2*X2, -y2*Y2],
		// 		[x3, y3, 1, 0,  0,  0, -x3*X3, -x3*Y3],
		// 		[0,  0,  0, x3, y3, 1, -y3*X3, -y3*Y3],
		// 		[x4, y4, 1, 0,  0,  0, -x4*X4, -x4*Y4],
		// 		[0,  0,  0, x4, y4, 1, -y4*X4, -y4*Y4]
		// 	]);

		// let B: any = math.matrix([X1,Y1,X2,Y2,X3,Y3,X4,Y4]);

		let factorArr: any = math.multiply(math.inv(A),B);

		factors.a = factorArr._data[0].toFixed(15)*1;
		factors.b = factorArr._data[1].toFixed(15)*1;
		factors.c = factorArr._data[2].toFixed(15)*1;
		factors.d = factorArr._data[3].toFixed(15)*1;
		factors.e = factorArr._data[4].toFixed(15)*1;
		factors.f = factorArr._data[5].toFixed(15)*1;
		factors.g = factorArr._data[6].toFixed(15)*1;
		factors.h = factorArr._data[7].toFixed(15)*1;

		return factors;
	}

	// get new coords based on factors from x-matrix
	public calculateCoords(x: number,y: number,factors: IFactors): ICoords {
		let newC: ICoords = {
			X: 0,
			Y: 0
		};

		newC.X = Math.trunc((factors.a * x + factors.b * y + factors.c)/(factors.g * x + factors.h * y + 1));
		newC.Y = Math.trunc((factors.d * x + factors.e * y + factors.f)/(factors.g * x + factors.h * y + 1));

		return newC;
	}

	public drawTextture(): void 
	{
		this.clearViewport3d();
		console.time('texture');
		this.ctx3d.drawImage(this.gameTextures['wall3d'].img,0,0,320,320);
		console.timeEnd('texture');
	}

	//convert square texture to trapezoid using deg val
	public drawTrapezoid(deg: number, a?,b?): void {
		console.time('pixels');
		this.clearViewport3d();
		//pre-transforms
		//this.ctx3d.setTransform(1.2,0,0,1.2,0,0);
		this.ctx3d.drawImage(this.gameTextures['wall3d'].img,0,0,320,320);
		//calculate diff using trigonometry
		let diff: number = Math.floor(320 * Math.tan(deg * (Math.PI/180)));
		//store factors
		let factors: IFactors = this.calculateFactors(320,0,320,320,0,320,0,0,320-diff*2,diff,320-diff*2,320-diff,0,320,0,0);
		//let factors: IFactors = this.calculateFactors(0,0,320,0,0,320,320,320,0,0,315,diff,320-diff,315,0,320);
		//check A,B (new coords) based on a,b
		if(a !== undefined && b !== undefined){
			console.log(factors);
			console.log(this.calculateCoords(a,b,factors));
			return;
		}
		
		//create new image buffer, get pre-transform image buffer
		let newImageData: ImageData = this.ctx3d.createImageData(320,320),
			imageData: ImageData = this.ctx3d.getImageData(0,0,320,320),
			x: number = 0,
			y: number = 0,
			newCoords: ICoords = null;
			
			//start rbga to rbga point-to-point transformation storing into new empty image buffer
			for(let i: number = 0, index: number = 0; i < imageData.data.length; i += 4, index++){
				y = Math.floor(index / 320);
				x = index - y*320;
				newCoords = this.calculateCoords(x,y,factors);

				//debuf 
				// if(newCoords.X === 1){
				// 	console.log(newCoords);
				// }

				newImageData.data[newCoords.X * 4 + newCoords.Y * 320 * 4] = imageData.data[i];
				newImageData.data[newCoords.X * 4 + (newCoords.Y * 320 * 4) + 1] = imageData.data[i + 1];
				newImageData.data[newCoords.X * 4 + (newCoords.Y * 320 * 4) + 2] = imageData.data[i + 2];
				newImageData.data[newCoords.X * 4 + (newCoords.Y * 320 * 4) + 3] = imageData.data[i + 3];
			}

		//clear 3d field
		this.clearViewport3d();
		//draw image from newly created and filled image buffer
		this.ctx3d.putImageData(newImageData,0,0);

		//**old stuff**
		// this.clearViewport3d();
		// for(let i: number = 0, scale: number = 0; i < 320; i++,scale += Math.tan(deg * (Math.PI/180))/320){
		// 	for(let j: number = 0; j < 320; j++){
		// 		//this.ctx3d.drawImage(this.gameTextures['wall3d'].img,x,y,1,1,x+20,y+20,1,1);
		// 		//this.ctx3d.drawImage(this.gameTextures['wall3d'].img,x,y,1,1,x*Math.abs(Math.cos(45))+y*Math.abs(Math.sin(45)),-x*Math.abs(Math.sin(45))+y*Math.abs(Math.cos(45)),1,1);
		// 		//last
		// 		this.ctx3d.drawImage(this.gameTextures['wall3d'].img,i,j,1,1,i,j*(1 - scale),1,1);
		// 		//**		
				
		// 	}
		// }
		//**

		console.timeEnd('pixels');
	}

	public tryTransform(): void {
		console.time('transform');
		this.ctx3d.setTransform(1,0,0,1,20,20);
		//this.ctx3d.setTransform(1,0,0,0,0,0);
		this.ctx3d.drawImage(this.gameTextures['wall3d'].img,0,0,320,320);
		console.timeEnd('transform');
	}

	public getLines(pIndex: number): number {
		let nOfLines: number = 0;
		while(this.map[pIndex] !== 10){
			pIndex += this.mapWidth;
			nOfLines++;
		}
		return nOfLines;		
	}

	//draw 3d world based on looking direction
	public draw3d(direction: string, raySrc?: number): void {
		let pIndex: number = raySrc || this.map.indexOf(1),
			nOfLines: number = this.getLines(pIndex),
			viewFactor: number = nOfLines* 2,
			arrIndexRow: number = Math.floor((pIndex + (this.mapWidth * nOfLines))/this.mapWidth);

		this.clearViewport3d();
		for(let i: number = 0, arrIndex: number = (pIndex + (this.mapWidth * nOfLines) - nOfLines), curArrIndexRow = Math.floor(arrIndex/this.mapWidth); i <= viewFactor; i++,arrIndex++,curArrIndexRow = Math.floor(arrIndex/this.mapWidth)){
			//detect empty space
			if(arrIndexRow !== curArrIndexRow){
				console.log('border');
				continue;
			} 
			else if (this.map[arrIndex] === 0){
				console.log('null');
				this.draw3d('down',pIndex + this.mapWidth *(nOfLines + 1));
				continue;
			}
			
			//draw bricks
			this.ctx3d.drawImage(this.gameTextures['wall3d'].img, -((this.viewportWidth * this.factor)/viewFactor/2) + ((this.viewportWidth * this.factor)/viewFactor)*i, ((this.viewportHeight * this.factor) - (this.viewportWidth * this.factor)/viewFactor)/2, (this.viewportWidth * this.factor)/viewFactor, (this.viewportWidth * this.factor)/viewFactor);
		}
	}

	//check if all assets is loaded completed before starting renders
	public isAllDataLoaded(): boolean {
		for(let item in this.gameTextures) 
			if(!this.gameTextures[item].isLoaded) return false;
		return true;
	}	

	//uni func that sets isLoaded flag to assets struct for each asset after loading complete
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

	//game objects definition
	public defineGameObjects(): void {
		//object names
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
		//textures location
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
			'player2r': {
				img: (new Image(32,32)),
				url: '/assets/current/player2r.png'
			},
			'player2l': {
				img: (new Image(32,32)),
				url: '/assets/current/player2l.png'
			},
			'horde_grunt': {
				img: (new Image(21,32)),
				url: '/assets/current/horde_grunt.png'
			},
			'mana_potion': {
				img: (new Image(32,32)),
				url: '/assets/current/mana_potion.png'
			},
			'wall3d': {
				img: (new Image(320,320)),
				url: '/assets/current/wall3d.png'
			}
		}
	}

	//rules for drawing different game objects
	public drawObject(j,j2,i2): void {
		if(this.map[j] !== 0){
			if(this.gameObjects[this.map[j]] === 'player'){
				//draw brick then image
				 //this.ctx.fillStyle = 'red';
				 //this.ctx.fillRect(j2,i2,this.factor, this.factor);
				this.ctx.drawImage(this.gameTextures['brick1'].img, j2, i2,this.factor, this.factor);
				if(this.isPlayerGoLeft){
					this.ctx.drawImage(this.gameTextures['player2l'].img, j2, i2,32,32);
				}
				else this.ctx.drawImage(this.gameTextures['player2r'].img, j2, i2,32,32);
				
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

	//keyboard controls
	public controls(direction: string): void {
		let curplayerPos: number = this.map.indexOf(1),
			curplayerLine: number = Math.floor(curplayerPos/this.mapWidth),
			newPlayerPos: number = null,
			newPlayerLine: number = null;

		if(direction === 'left'){
			if(!this.isPlayerGoLeft) this.isPlayerGoLeft = true;
			newPlayerPos = curplayerPos - 1;
			newPlayerLine = Math.floor(newPlayerPos/this.mapWidth);
			if(curplayerLine !== newPlayerLine) return;
		} 
		else if(direction === 'right'){
			if(this.isPlayerGoLeft) this.isPlayerGoLeft = false;
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
			this.clearViewport2d();
			this.draw2d();
			this.draw3d(direction);
		}
	}

	//clear 2d view
	public clearViewport2d(): void {
		this.ctx.clearRect(0,0,this.viewportWidth * this.factor,this.viewportHeight * this.factor);
	}

	//clear 3d view
	public clearViewport3d(): void {
		this.ctx3d.clearRect(0,0,this.viewportWidth * this.factor,this.viewportHeight * this.factor);
	}

	//draw 2d world based on tiles array
	public draw2d(): void {
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
	ctx: CanvasRenderingContext2D;
}