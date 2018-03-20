package buw;

class Title extends Text {
	public function new(text : String) {
		super(text, Widget.titleFontSize, Widget.titleColor, Widget.boldTitle, Widget.underlineTitle);
		textField.selectable = false;
	}
}
