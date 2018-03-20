package buw;
import openfl.Lib;
import openfl.display.Sprite;

class Widget extends Sprite {
	public static var controlsBackground1 : Int = 0xdddddd;
	public static var controlsBackground2 : Int = 0xaaaaaa;
	public static var inputBackground : Int = 0xeeeeee;
	public static var stageBackground : Int = 0xffffff;
	public static var controlsTextColor : Int = 0x111111;
	public static var paragraphColor : Int = 0x222222;
	public static var titleColor : Int = 0x222222;
	public static var borderColor : Int = 0x888888;
	public static var borderWidth : Int = 1;
	public static var boldTitle : Bool = true;
	public static var underlineTitle : Bool = true;
	public static var font : String = null;
	public static var horizontalPadding : Int = 4;
	public static var verticalPadding : Int = 4;
	public static var controlsFontSize : Int = 16;
	public static var titleFontSize : Int = 18;
	
	function new() {
		super();
	}

	public function draw() {}

	var relativeWidth : Float = 0;
	function getWidth() : Float {
		if (Screen.isRootWidget(this) || parent == null) {
			if (relativeWidth != 0) {
				return Lib.current.stage.stageWidth * relativeWidth;
			} else {
				return Lib.current.stage.stageWidth;
			}
		} else {
			if (relativeWidth != 0) {
				return cast(parent, Widget).getWidth() * relativeWidth;
			} else {
				return this.width;
			}
		}
	}
}
