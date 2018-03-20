package buw;

class Separator extends Widget {
	public function new(?vertical : Bool = false) {
		super();
		graphics.beginFill(Widget.stageBackground);
		graphics.lineStyle(0, Widget.stageBackground);
		if (vertical) {
			graphics.drawRect(0, 0, Widget.horizontalPadding * Widget.verticalPadding, 1);
		} else {
			graphics.drawRect(0, 0, 1, Widget.horizontalPadding * Widget.verticalPadding);
		}
		graphics.endFill();
	}
}
