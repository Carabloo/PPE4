package buw;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class ImgButton extends Button {
	var bmp: Bitmap;

	public function new(listener : Control -> Void, imagePath: String) {
		super(listener);
		bmp = new Bitmap(Assets.getBitmapData(imagePath));
		bmp.alpha = 0.85;
		addChild(bmp);
		addEventListener(MouseEvent.MOUSE_OVER, function(event: MouseEvent) { bmp.alpha = 1; });
		addEventListener(MouseEvent.MOUSE_OUT, function(event: MouseEvent) { bmp.alpha = 0.85; });
	}
}
