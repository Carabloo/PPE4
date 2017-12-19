package models;
import sys.db.Types;
import sys.db.Object;

@:id(idTrajet)

class Trajet extends Object {
    
    @:relation(idEleve, cascade) public var idEleve : Eleves

    public var idTrajet : SString<50>;
    public var heure : SString<30>;
    public var km : Float;
    public var dte : Date;
    public var jour : SString<5>;
    public var type : Bool;

    function new(idTrajet : String, heure : String, km : Float, dte : Date, jour : String, type : Bool, idEleve : Eleves) {
        super();
        this.idTrajet = idTrajet;
        this.heure = heure;
        this.km=km;
        this.dte=dte;
        this.jour=jour;
        this.type=type;
        this.idEleve=idEleve
    }
}
