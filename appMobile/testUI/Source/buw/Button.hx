package buw;
import openfl.events.MouseEvent;

class Button extends Control {
	function new(listener : Control -> Void) {
		super(listener);
		addEventListener(MouseEvent.CLICK, eventOnClick);		
	}
	
	function eventOnClick(e : MouseEvent) {
		if (listener != null) {
			listener(this);
		}
	}
}
