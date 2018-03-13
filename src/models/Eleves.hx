package models;
import sys.db.Types;
import sys.db.Object;

@:id(idEleves)

class Eleves extends Object {

    public var idEleves(default, null) : SId;
    public var nom : SString<30>;
    public var prenom : SString<30>;
    public var mail : SString<50>;
    public var telephone : SString<10>;
    public var mdp : SString<64>;

    public function new(nom : String, prenom : String, mail : String, telephone : String, mdp : String) {
        super();
        this.nom = nom;
        this.prenom = prenom;
        this.mail = mail;
        this.telephone = telephone;
        this.mdp = mdp;
    }
}
