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
		
		main.pack(new TextButton(onClick, "Connexion",  1));
		
		l = new ListView(afficherEleves);
		main.pack(l);
		
		Screen.display(main);		
	}
	
	function onClick(w : Control) {
		var r = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user");
		
		r.onData = function(data : String) {
			
	/*		var g : Grid = new Grid([240, 80]);
			g.pack(new Title("Libelle"));
			g.pack(new Title("Prix")); 
	*/
	
			var eleves : Array<Eleves> = Json.parse(data);
			
	/*		trace(data);
			for(a in articles) {
				g.pack(new Label(a.libelle));
				g.pack(new Label(Std.string(a.prix)));
			}
			main.pack(g);  
	*/
			l.source = eleves;
	    } 
	    r.request();
	}
	
	function afficherEleves(e : Eleves) : Widget {
		return new Label(e.nom + " " + e.prenom);
	}
}
