package buw;
import openfl.events.MouseEvent;
import openfl.display.Sprite;

class Toggle extends Button {
	public var on(default, set): Bool;
	var onSprite : Sprite;
	var offSprite : Sprite;
	
	function new(listener : Control -> Void, onSprite : Sprite, offSprite : Sprite, ?on : Bool = false) {
		super(listener);
		this.onSprite = onSprite;
		this.offSprite = offSprite;
		addChild(onSprite);
		addChild(offSprite);
		this.on = on;
	}
	
	function set_on(on : Bool) : Bool {
		this.on = on;
		onSprite.visible = this.on;
		offSprite.visible = ! this.on;
		return this.on;
	}
	
	override function eventOnClick(e : MouseEvent) {
		super.eventOnClick(e);
		this.on = ! this.on;
	}
}
