package buw;

class TableColumn extends HBoxColumn {
    public var title : String;
    public var fieldName : String;
    public var renderer : Dynamic -> Widget;

    public function new(relativeWidth : Float, ?align : Int = 0, ?title : String, ?fieldName : String, ?renderer : Dynamic -> Widget = null) {
        super(relativeWidth, align);
        this.title = title;
        this.fieldName = fieldName;
        this.renderer = renderer;
    }
}