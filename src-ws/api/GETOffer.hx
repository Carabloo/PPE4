package api;
import models.*;

typedef GETOffer = {
    public var idOffer : String;
    public var heure : Date;
    public var km : Float;
    public var date : Date;
    public var isFrom : Bool;
    public var jour : String;
    public var type : Bool;
    public var user : User;
}
