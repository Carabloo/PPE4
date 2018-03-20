package buw;

class HBox extends Box {
	var columns : Array<HBoxColumn>;

	public function new (?relativeWidth : Float = 1, ?columns : Array<HBoxColumn> = null) {
		this.columns = columns;
		super(relativeWidth);
	}
	
	override function placeWidgets() {
		if (columns != null) {
			var x : Float = 0;
			for (i in 0...widgetsList.length) {
				var widthForWidget : Float = getWidth() * columns[i].relativeWidth;
				if (columns[i].align == -1) {
					widgetsList[i].x = x;
				} else if (columns[i].align == 0) {
					widgetsList[i].x = x + (widthForWidget - widgetsList[i].getWidth()) / 2;
				} else { //columns[i].align == 1
					widgetsList[i].x = x + widthForWidget - widgetsList[i].getWidth() - Widget.horizontalPadding;
				}
				x += widthForWidget + Widget.horizontalPadding;
			}
		} else {
			var x : Float = 0;
			for (w in widgetsList) {
				w.x = x;
				x += w.getWidth() + Widget.horizontalPadding;
			}
		}
		for (w in widgetsList) { //vertical middle
			w.y = (this.height - w.height) / 2;
		}
	}

	override public function pack(widget : Widget) {
		if (columns == null || widgetsList.length != columns.length) {
			super.pack(widget);
		}
	}

	override public function drawBorders() {

	}
}
