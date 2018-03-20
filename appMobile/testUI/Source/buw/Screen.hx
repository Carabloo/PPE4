package buw;
import haxe.Timer;
import openfl.Lib;
import openfl.display.DisplayObjectContainer;
import openfl.events.MouseEvent;
import openfl.events.Event;

class Screen {
	static var rootWidget : Box = null;
	static var scrollableWidget : Box = null;
	static var downPos : Float = -1;
	static var currentPos : Float;
	static var downTime : Float;
	
	public static function display(rootWidget : Box) {
		if (rootWidget != null) {
			if (Screen.rootWidget != null) {
				Lib.current.stage.removeChild(Screen.rootWidget);
			}
			Lib.current.stage.removeEventListener(Event.RESIZE, resizeEvent);
			Screen.rootWidget = rootWidget;
			if (Screen.rootWidget != null) {
				Lib.current.stage.addChild(Screen.rootWidget);
				Lib.current.stage.addEventListener(Event.RESIZE, resizeEvent);
			}
			setScrollable(Screen.rootWidget);
		}
	}

	public static function isRootWidget(w : Widget) : Bool {
		return w == rootWidget;
	}

	public static function setScrollable(scrollableWidget : Box) {
		Screen.scrollableWidget = scrollableWidget;
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		if (Screen.scrollableWidget != null) {
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
	}

	static function resizeEvent(e : Event) {
		rootWidget.draw();
	}
	
	static function mouseWheel(e : MouseEvent) {
		doMove(e.delta * 32);
	}
	
	static function mouseDown(e : MouseEvent) {
		downTime = Timer.stamp();
		downPos = e.localY;
		currentPos = downPos;
	}
	
	static function mouseMove(e : MouseEvent) {
		if (downPos != -1) {
			e.stopImmediatePropagation();
			var move = e.localY - currentPos;
			currentPos = e.localY;
			doMove(move);
		}
	}
	
	static function mouseUp(e : MouseEvent) {
		var upTime = Timer.stamp();
		var pressTime = upTime - downTime;
		if (pressTime < 0.5) {
			var speed = (e.localY - downPos) / pressTime;
			autoScroll(speed);
		}
		downPos = -1;
	}
	
	static function autoScroll(speed : Float) {
		doMove(speed / 10);
		if (Math.abs(speed) > 10) {
			Timer.delay(function() { autoScroll(speed * 0.85); }, 10);   
		}
	}
	
	static function doMove(move : Float) {
		scrollableWidget.y += move;
		if (move < 0 && scrollableWidget.y + scrollableWidget.height < Lib.current.stage.stageHeight) {
			var pos = Lib.current.stage.stageHeight - scrollableWidget.height;
			if (pos > 0) {
				scrollableWidget.y = 0;
			} else {
				scrollableWidget.y = pos;
			}
		}
		if (move > 0 && scrollableWidget.y >= 0) { 
			scrollableWidget.y = 0;
		}
	}
}

