import { Directive, HostListener, EventEmitter } from '@angular/core';

@Directive({
	selector: '[controls]',
	outputs: ['p_controls_e']
})

export class p_ctrl_dr {
	p_controls_e = new EventEmitter();
	@HostListener("document : keydown", ['$event']) onkeypress(e) {  		
			if(e.keyCode === 37){
				e.preventDefault();
				this.p_controls_e.emit('left');
			}
			else if(e.keyCode === 39){
				e.preventDefault();
				this.p_controls_e.emit('right');
			}
			else if(e.keyCode === 38){
				e.preventDefault();
				this.p_controls_e.emit('up');
			}
			else if(e.keyCode === 40){
				e.preventDefault();
				this.p_controls_e.emit('down');
			}
			else return;
	}
}