package buw;
import openfl.display.Sprite;

class TextCheckBox extends CheckBox {
	public function new(listener : Control -> Void, text : String, ?checked : Bool = false) {
		var wh = new Label(" ").textField.height + Widget.verticalPadding * 2;
		var uncheckedSprite : Sprite = new Sprite();
		uncheckedSprite.graphics.beginFill(Widget.inputBackground);
		uncheckedSprite.graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		uncheckedSprite.graphics.drawRect(Widget.borderWidth, Widget.borderWidth, wh - Widget.borderWidth, wh - Widget.borderWidth);
		uncheckedSprite.graphics.endFill();
		var checkedSprite : Sprite = new Sprite();
		//~ checkedSprite.graphics.beginGradientFill(RADIAL, [Widget.controlsBackground1 * 2, Widget.controlsBackground2 * 2], [1, 1], [0, 255]);
		checkedSprite.graphics.beginFill(Widget.inputBackground * 8);
		checkedSprite.graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
		checkedSprite.graphics.drawRect(Widget.borderWidth, Widget.borderWidth, wh - Widget.borderWidth, wh - Widget.borderWidth);
		checkedSprite.graphics.endFill();
		toggle = new Toggle(listener, checkedSprite, uncheckedSprite, checked);
		super(text, checked); //toggle must be set before
	}	
}
