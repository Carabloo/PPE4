package buw;
import openfl.Lib;

class Box extends Widget {
	var widgetsList : Array<Widget>;
	
	function new(? relativeWidth : Float = 1) {
		super();
		this.relativeWidth = relativeWidth;
		widgetsList = new Array();
	}
	
	public function pack(widget : Widget) {
		widgetsList.push(widget);
		addChild(widget);
		widget.draw();
		placeWidgets();
	}
	
	public function clear() {
		removeChildren();
		widgetsList = new Array();
	}

	function placeWidgets() {}

	override public function draw() {
		for (w in widgetsList) {
			w.draw();
		}
		placeWidgets();
	}

	public function drawBorders() {

	}
}
