package buw;
import openfl.Assets;
import openfl.system.Capabilities;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.text.TextField;

class Text extends Widget {
	public var textField(default, null) : TextField;
	var fontSize : Int;
	static var fontRegular : Font = null;
	static var fontBold : Font = null;
	
	public function new(text : String, fontSize : Int, color : Int, ?bold : Bool = false, ?underline : Bool = false) {
		super();
		#if android
		fontSize = Std.int(fontSize * Capabilities.screenDPI / 144);
		#else
		fontSize = Std.int(fontSize * Capabilities.screenDPI / 72);
		#end
		this.fontSize = fontSize;
		textField = new TextField();
		var format : TextFormat;
		if (Widget.font != null) {
			if (fontRegular == null) {
				fontRegular = Assets.getFont("assets/fonts/" + Widget.font + "-regular.ttf");
				fontBold = Assets.getFont("assets/fonts/" + Widget.font + "-bold.ttf");
			}
			if (bold) {
				format = new TextFormat(fontBold.fontName, fontSize, color);
			} else {
				format = new TextFormat(fontRegular.fontName, fontSize, color);
			}
			textField.embedFonts = true;
		} else {
			format = new TextFormat(fontSize, color/*, bold, false(italic), underline*/);
		}
		textField.defaultTextFormat = format;
		textField.text = text; //htmlText
		textField.autoSize = openfl.text.TextFieldAutoSize.LEFT;
		addChild(textField);
		if (underline) {
			graphics.beginFill(Widget.borderColor);
			graphics.lineStyle(Widget.borderWidth, Widget.borderColor);
			graphics.drawRect(0, textField.height, textField.width, bold?1.0:0.5 * Widget.borderWidth);
			graphics.endFill();
		}
		mouseEnabled = false;
	}
}
