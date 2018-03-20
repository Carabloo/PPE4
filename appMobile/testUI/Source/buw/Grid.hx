package buw;

class Grid extends VBox {
	var widgetsCount : Int = 0;
	var columns : Array<HBoxColumn>;
	
	public function new(?relativeWidth : Float = 1, columns : Array<HBoxColumn>) {
		super(relativeWidth, -1);
		this.columns = columns;
	}
	
	override public function pack(widget : Widget) {
		var hbox : HBox;
		if (widgetsCount % columns.length == 0) {
			hbox = new HBox(relativeWidth, cast columns);
		} else {
			hbox = cast (widgetsList.pop(), HBox);
		}
		widgetsCount++;
		hbox.pack(widget);
		super.pack(hbox);
	}
}
