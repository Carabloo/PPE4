package api;
import models.*;

typedef GETOffer = {
    public var idOffer : String;
    public var heure : String;
    public var km : Float;
    public var date : Date;
    public var isFrom : Bool;
    public var jour : String;
    public var type : Bool;
    public var user : User;
}
