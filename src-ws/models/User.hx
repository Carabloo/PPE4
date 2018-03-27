package models;
import sys.db.Types;
import sys.db.Object;
import models.*;

@:id(idUser)

class User extends Object {
    public var idUser(default, null) : SString<36>;
    public var login : SString<30>;
    public var nom : SString<30>;
    public var prenom : SString<30>;
    public var mail : SString<50>;
    public var telephone : SString<10>;
    public var mdp : SString<64>;

    public function new(login : String,nom : String, prenom : String, mail : String, telephone : String, mdp : String, ?id : String = null) {
        super();
        this.login = login;
        this.nom = nom;
        this.prenom = prenom;
        this.mail = mail;
        this.telephone = telephone;
        this.mdp = mdp;
        if( id == null ) {
          this.idUser = Helped.genUUID();
        } else {
          this.idUser = id;
        }
    }
}
