package api;
import models.*;

typedef GETTrajets = {
    public var idTrajet : Int;
    public var heure : String;
    public var km : Float;
    public var date : Date;
    public var jour : String;
    public var type : Bool;
    public var idEleve : Eleves;
}
