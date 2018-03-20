package;
import openfl.display.Sprite;
import buw.*;
import haxe.Http;
import haxe.Json;

typedef Eleves = {
	var idEleves : String;
	var nom : String;
	var prenom : String;
	var mail : String;
	var telephone : String;
	var mdp : String;
}

class Main extends Sprite {
	var main : VBox;
	var identifiant : Input;
	var motdepasse : Input;
	var l : ListView<Eleves>;
	
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
		main.pack(new TextButton(onClickEleves, "Afficher les élèves",  1));
		
		l = new ListView(afficherEleves);
		main.pack(l);
		
		Screen.display(main);		
	}
	
	function onClickConnexion(w : Control) {
		//
	}

	function onClickEleves(w : Control) {
		var r = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user/all");
		
		r.onData = function(data : String) {
			var eleves : Array<Eleves> = Json.parse(data);
			l.source = eleves;
	    } 
	    r.request();
	}
	
	function afficherEleves(e : Eleves) : Widget {
		return new Label(e.nom + " " + e.prenom);
	}
}
