package buw;

class Control extends Widget {
	var listener : Dynamic;
	
	function new(listener : Control -> Void) {
		super();
		this.listener = listener;
	}
}