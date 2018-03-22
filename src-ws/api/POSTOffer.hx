package api;
import models.*;

typedef POSTOffer = {
    @:optional var idOffer : String;
    public var heure : String;
    public var km : Float;
    public var date : Date;
    public var jour : String;
    public var type : Bool;
    public var user : User;
}