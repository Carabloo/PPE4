package buw;

class HBoxColumn {
    public var relativeWidth : Float;
    public var align : Int;

    public function new(relativeWidth : Float, ?align : Int = 0) {
        this.relativeWidth = relativeWidth;
        this.align = align;
    }
}