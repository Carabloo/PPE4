package buw;

class TextSpinBox extends SpinBox {
	public function new(listener : Control -> Void, text : String, ?value : Int = 1, ?minVal : Int = 1, ?maxVal : Int = 99, ?step : Int = 1, ?digits : Int = 2) {
		minus = new TextButton(dec_value, "  - ", 0);
		plus = new TextButton(inc_value, " + ", 0);
		super(listener, text, value, minVal, maxVal, step, digits); //plus & minus must be set before
	}
}
