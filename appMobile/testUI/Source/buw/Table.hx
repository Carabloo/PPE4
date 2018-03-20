package buw;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class Table<T> extends Grid {
	public var source(default, set) : Array<T>;
	var listener : T -> Void;
	
	public function new(?listener : T -> Void = null, ?relativeWidth : Float = 1, columns : Array<TableColumn>) {
		super(relativeWidth, cast columns);
		this.listener = listener;
		addEventListener(MouseEvent.MOUSE_OVER, function(e : MouseEvent) {
			Mouse.cursor = MouseCursor.BUTTON;
		});
		addEventListener(MouseEvent.MOUSE_OUT, function(e : MouseEvent) {
			Mouse.cursor = MouseCursor.AUTO;
		});
	}

	function set_source(source : Array<T>) : Array<T> {
		removeChildren();
        for (c in columns) {
            pack(new Title(cast(c, TableColumn).title));
        }
        widgetsCount = 0;
		this.source = source;
		if (source != null) {
			for (item in source) {
                for (c in columns) {
                    if (cast(c, TableColumn).renderer != null) {
                        pack(cast(c, TableColumn).renderer(Reflect.field(item, cast(c, TableColumn).fieldName)));
                    } else {
                        pack(new Label(Std.string(Reflect.field(item, cast(c, TableColumn).fieldName))));
                    }
                }
                var w : HBox = cast(widgetsList[widgetsList.length-1], HBox);
				w.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) { onItemClick(w); });
			}
		}
		return this.source;
	}

	function onItemClick(w : Widget) {
		if (listener != null) {
			listener(source[getChildIndex(w)-1]); //-1 : titles
		}
	}
}
