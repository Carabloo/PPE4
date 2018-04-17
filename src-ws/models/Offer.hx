package models;

import sys.db.Types;
import sys.db.Object;
import models.*;

@:id(idOffer)

class Offer extends Object {

    @:relation(idUser) public var user : User;

    public var idOffer(default, null) : SString<36>;
    public var heure : SString<30>;
    public var km : Float;
    public var date : Date;
    public var isFrom : Bool;
    public var jour : SString<5>;
    public var type : Bool;

    public function new(heure : String, km : Float, date : Date, isFrom : Bool, jour : String, type : Bool, user : User, ?id : String = null) {
        super();
        this.heure = heure;
        this.km=km;
        this.date=date;
        this.isFrom=isFrom;
        this.jour=jour;
        this.type=type;
        this.user=user;
        if( id == null || id == "" ) {
          this.idOffer = Helped.genUUID();
        } else {
          this.idOffer = id;
        }
    }
}
