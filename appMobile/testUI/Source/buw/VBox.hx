package buw;

class VBox extends Box {
	var align : Int;
	
	//align: -1=left, 0=centered, 1=right
	public function new(?relativeWidth : Float = 1, ?align : Int = 0) {
		super(relativeWidth);
		this.align = align;
	}
	
	override function placeWidgets() {
		var y : Float = 0;
		for (w in widgetsList) {
			w.y = y;
			y += w.height + Widget.verticalPadding;
			if (align == 0) {
				w.x = (getWidth() - w.getWidth()) / 2;
			} else if (align == 1) {
				w.x = getWidth() - w.getWidth() - Widget.horizontalPadding;
			}
		}
	}

	override public function drawBorders() {
		
	}
}
