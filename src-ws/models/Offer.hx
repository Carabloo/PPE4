package models;

import sys.db.Types;
import sys.db.Object;
import models.*;

@:id(idOffer)

class Offer extends Object {

    @:relation(idUser) public var user : User;

    public var idOffer(default, null) : SString<36>;
    public var heure : Date;
    public var km : Float;
    public var date : Date;
    public var isFrom : SString<5>;
    public var jour : SString<5>;
    public var type : SString<5>;

    public function new(heure : String, km : Float, date : String, isFrom : String, jour : String, type : String, user : User, ?id : String = null) {
        super();
        this.heure = Date.fromString(heure);
        this.km=km;
        this.date = Date.fromString(date);
        this.type = type;
        this.jour = jour;
        this.isFrom = isFrom;
        this.user=user;
        if( id == null || id == "" ) {
          this.idOffer = Helped.genUUID();
        } else {
          this.idOffer = id;
        }
    }
}
