package buw;
import openfl.events.MouseEvent;

class TextButton extends Button {
	public var text(get, set) : String;
	var label : Label;
	var h : Float;
	var w : Float;
	
	public function new(listener : Control -> Void, text : String, ?relativeWidth : Float = 1) {
		super(listener);
		this.relativeWidth = relativeWidth;
		label = new Label("");
		h = label.textField.height + Widget.verticalPadding * 2;
		label.y = Widget.verticalPadding;
		this.text = text;
		label.mouseEnabled = true;
		label.textField.selectable = false;
		addChild(label);
		addEventListener(MouseEvent.MOUSE_OVER, eventMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, eventMouseOut);
	}
	
	function get_text() : String {
		return label.textField.text;
	}
	
	function set_text(text : String) : String {
		label.textField.text = text;
		draw();
		return this.label.textField.text;
	}
	
	override public function draw() {
		if (relativeWidth == 0) {
			w = label.textField.width + Widget.horizontalPadding * 2;
		} else {
			w = getWidth() - 2 * Widget.borderWidth;
		}
		graphics.clear();
		graphics.beginFill(Widget.controlsBackground1);
		graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		graphics.drawRect(Widget.borderWidth, Widget.borderWidth, w, h);
		graphics.endFill();
		label.x = (w - label.getWidth()) / 2;
	}

	function eventMouseOver(event : MouseEvent) {
		graphics.beginFill(Widget.controlsBackground2);
		graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		graphics.drawRect(Widget.borderWidth, Widget.borderWidth, w, h);
		graphics.endFill();
	}
	
	function eventMouseOut(event : MouseEvent) {
		graphics.beginFill(Widget.controlsBackground1);
		graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		graphics.drawRect(Widget.borderWidth, Widget.borderWidth, w, h);
		graphics.endFill();
	}
}
