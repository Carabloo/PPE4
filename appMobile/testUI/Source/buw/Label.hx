package buw;

class Label extends Text {
	public function new(text : String) {
		super(text, Widget.controlsFontSize, Widget.controlsTextColor);
		textField.selectable = false;
	}
}
