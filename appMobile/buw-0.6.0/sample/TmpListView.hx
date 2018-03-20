package buw;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class ListView<T> extends VBox {
	public var source(default, set) : Array<T>;
	var renderer : T -> Bool -> Widget;
	var listener : T -> Void;
	var titles : T;
	
	public function new(renderer : T -> Bool -> Widget, ?listener : T -> Void = null, ?source : Array<T> = null,
				?relativeWidth : Float = 1, ?align : Int = 0, ?titles : T = null) {
		super(relativeWidth, align);
		this.renderer = renderer;
		this.listener = listener;
		this.source = source;
		this.titles = titles;
		addEventListener(MouseEvent.MOUSE_OVER, function(e : MouseEvent) {
			Mouse.cursor = MouseCursor.BUTTON;
		});
		addEventListener(MouseEvent.MOUSE_OUT, function(e : MouseEvent) {
			Mouse.cursor = MouseCursor.AUTO;
		});
	}

	function set_source(source : Array<T>) : Array<T> {
		removeChildren();
		if (titles != null) {
			pack(renderer(titles, true));
		}
		this.source = source;
		if (source != null) {
			for (item in source) {
				var w : Widget = renderer(item, false);
				w.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) { onItemClick(w); });
				pack(w);
			}
		}
		return this.source;
	}

	function onItemClick(w : Widget) {
		if (listener != null) {
			listener(source[getChildIndex(w)]);
		}
	}
}
