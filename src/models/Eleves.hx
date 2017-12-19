package models;
import sys.db.Types;
import sys.db.Object;

@:id(idEleve)

class Eleves extends Object {

    public var idEleves : SId;
    public var nom : SString<30>;
    public var prenom : SString<30>;
    public var mail : SString<50>;
    public var telephone : SString<10>;
    public var mdp : Char<64>;

    function new(nom : String, prenom : String, mail : String, telephone : String, mdp : Char) {
        super();
        this.nom = nom;
        this.prenom = prenom;
        this.mail = mail;
        this.telephone = telephone;
        this.mdp = mdp;
    }
}
