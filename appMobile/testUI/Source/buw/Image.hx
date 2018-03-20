package buw;
import openfl.Assets;
import openfl.display.Bitmap;

class Image extends Widget {
	public function new(imagePath : String) {
		super();
		addChild(new Bitmap(Assets.getBitmapData(imagePath)));
	}
}
