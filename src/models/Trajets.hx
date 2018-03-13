package models;

import sys.db.Types;
import sys.db.Object;

@:id(idTrajet)

class Trajets extends Object {

    @:relation(idEleves) public var idEleve : Eleves;

    public var idTrajet : SId;
    public var heure : SString<30>;
    public var km : Float;
    public var date : Date;
    public var jour : SString<5>;
    public var type : Bool;

    public function new(heure : String, km : Float, date : Date, jour : String, type : Bool, idEleves : Eleves) {
        super();
        this.heure = heure;
        this.km=km;
        this.date=date;
        this.jour=jour;
        this.type=type;
        this.idEleves=idEleves;
    }
}
