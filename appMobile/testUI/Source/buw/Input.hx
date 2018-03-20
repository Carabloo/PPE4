package buw;
import openfl.text.TextFieldType;

class Input extends Text {
	public var value(get,null) : String;

	public function new(defaultValue : String, maxLength : Int, ?relativeWidth : Float = 1) {
		super(defaultValue, Widget.controlsFontSize, Widget.controlsTextColor);
		this.relativeWidth = relativeWidth;
		textField.type = TextFieldType.INPUT;
		textField.x = Widget.borderWidth + Widget.horizontalPadding;
		textField.y = Widget.borderWidth + Widget.verticalPadding;
		textField.maxChars = maxLength;
		var h = this.height; //hack: prevents changing height by the following instruction
		textField.autoSize = openfl.text.TextFieldAutoSize.NONE;
		mouseEnabled = true;
		draw();
	}
	
	function get_value() : String {
		return textField.text;
	}

	override public function draw() {
		graphics.clear();
		graphics.beginFill(Widget.inputBackground);
		graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		var h = textField.textHeight + Widget.verticalPadding * 2;
		var w : Float;
		if (relativeWidth == 0) {
			w = fontSize * textField.maxChars * 3/4 + Widget.horizontalPadding * 2;
		} else {
			w = getWidth() - 2 * Widget.borderWidth;
		}
		graphics.drawRect(Widget.borderWidth, Widget.borderWidth, w, h);
		graphics.endFill();
		textField.width = w - 2 * (Widget.borderWidth + Widget.horizontalPadding);
	}
}
