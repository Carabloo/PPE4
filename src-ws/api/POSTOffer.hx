package api;

typedef POSTOffer = {
    @:optional var idOffer : String;
    public var heure : Date;
    public var km : Float;
    public var date : Date;
    public var isFrom : Bool;
    public var jour : String;
    public var type : Bool;
    public var idUser : String;
}
