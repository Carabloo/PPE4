package buw;

class ImgSpinBox extends SpinBox {
	public function new(listener : Control -> Void, text : String, minusImgPath : String, plusImgPath : String, ?value : Int = 1, ?minVal : Int = 1, ?maxVal : Int = 99, ?step : Int = 1, ?digits : Int = 2) {
		minus = new ImgButton(dec_value, minusImgPath);
		plus = new ImgButton(inc_value, plusImgPath);
		super(listener, text, value, minVal, maxVal, step, digits); //plus & minus must be set before
	}
}
