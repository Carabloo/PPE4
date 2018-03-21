package models;

import sys.db.Types;
import sys.db.Object;
import models.*;

@:id(idTrajet)

class Trajets extends Object {

    @:relation(idEleves) public var idEleve : Eleves;

    public var idTrajet(default, null) : SString<36>;
    public var heure : SString<30>;
    public var km : Float;
    public var date : Date;
    public var jour : SString<5>;
    public var type : Bool;

    public function new(heure : String, km : Float, date : Date, jour : String, type : Bool, idEleves : Eleves, ?id : String = null) {
        super();
        this.heure = heure;
        this.km=km;
        this.date=date;
        this.jour=jour;
        this.type=type;
        this.idEleve=idEleves;
        if( id == null ) {
          this.idTrajet = Helped.genUUID();
        } else {
          this.idTrajet = id;
        }
    }
}
