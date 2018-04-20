package api;
import models.*;

typedef GETOffer = {
    public var idOffer : String;
    public var heure : String;
    public var km : Float;
    public var date : String;
    public var isFrom : String;
    public var jour : String;
    public var type : String;
    public var user : User;
}
