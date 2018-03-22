package;
import openfl.display.Sprite;
import buw.*;
import haxe.Http;
import haxe.Json;

typedef Users = {
  public var idUser : String;
  public var login : String;
  public var nom : String;
  public var prenom : String;
  public var mail : String;
  public var telephone : String;
  public var mdp : String;

}

class Main extends Sprite {
	var main : VBox;
	var identifiant : Input;
	var motdepasse : Input;
	var l : ListView<Users>;
	
	public function new () {
		
		super ();
		main = new VBox();
		main.pack(new Title("AFG Covoiturage")); //.pack() permet d'afficher dans un contener (= addChild + placement automatique les uns sur les autres)
		main.pack(new Separator()); //fait un espace
		
		var g : Grid = new Grid(1, [new HBoxColumn(1)]); //grid permet d'aligner des éléments
		identifiant = new Input("", 50, 1);
		motdepasse = new Input("", 50, 1);
		g.pack(new Label ("Identifiant :")); 
		g.pack(identifiant);
		g.pack(new Label ("Mot de passe :"));
		g.pack(motdepasse);
		
		main.pack(g);
		
		main.pack(new TextButton(onClickConnexion, "Connexion",  1));
		main.pack(new TextButton(onClickUsers, "Afficher les élèves",  1));
		
		l = new ListView(afficherUsers);
		main.pack(l);
		
		Screen.display(main);		
	}
	
	function onClickConnexion(w : Control) {
		//
	}

	function onClickUsers(w : Control) {
		var r = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user/all");
		
		r.onData = function(data : String) {
			var users : Array<Users> = Json.parse(data);
			l.source = users;
	    } 
	    r.request();
	}
	
	function afficherUsers(e : Users) : Widget {
		return new Label(e.nom + " " + e.prenom);
	}
}
