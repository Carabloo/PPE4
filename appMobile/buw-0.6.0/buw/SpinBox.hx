package buw;

class SpinBox extends Control {
	public var value(default, null): Int;
	var minus : Button;
	var plus : Button;
	var fontSize : Int;
	var maxVal : Int;
	var minVal : Int;
	var step : Int;
	var digits : Int;
	var display : Label;
	
	function new(listener : Control -> Void, text : String, value : Int, minVal : Int, maxVal : Int, step : Int, digits : Int) {
		super(listener);
		this.maxVal = maxVal;
		this.minVal = minVal;
		this.step = step;
		this.digits = digits;
		this.value = value;
		
		var hbox : HBox = new HBox(-1);
		hbox.pack(minus);
		display = new Label(format_value());
		display.y = (minus.height - display.height) / 2;
		hbox.pack(display);
		hbox.pack(plus);
		if (text != null) {
			var label : Label = new Label(text);
			hbox.pack(label);
		}
		addChild(hbox);
	}
	
	function inc_value(w : Control) {
		if (value + step <= maxVal) {
			value += step;
			display.textField.text = format_value();
			if (listener != null) {
				listener(w);
			}
		}
	}
	
	function dec_value(w : Control) {
		if (value - step >= minVal) {
			value -= step;
			display.textField.text = format_value();
			if (listener != null) {
				listener(w);
			}
		}
	}
	
	function format_value(): String {
		var str: String;
		
		str = Std.string(value);
		while (str.length < digits) {
			str = "0" + str;
		}
		return str;
	}
}
