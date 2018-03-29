package;
import openfl.display.Sprite;
import buw.*;
import haxe.Http;
import haxe.Json;
import haxe.crypto.Sha256;

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
	var mainAdmin : VBox;
	var identifiant : Input;
	var motdepasse : Input;
	var l : ListView<Users>;
	
	public function new () {
		
		super();
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
		
		Screen.display(main);

		mainAdmin = new VBox();	
		mainAdmin.pack(new TextButton(onClickDeconnexion, "Deconnexion", 0.30));
		mainAdmin.pack(new Separator());
		mainAdmin.pack(new TextButton(onClickAfficherUsers, "Afficher les utilisateurs",  1));
		mainAdmin.pack(new TextButton(onClickCreateUsers, "Créer un utilisateur",  1));	
		
		l = new ListView(affichageUsers);
		mainAdmin.pack(l);
	} 
	
	function onClickConnexion(w : Control) {
		var login = identifiant.value ;
		var mdp = motdepasse.value ;
		mdp = Sha256.encode(mdp);
		if (Auth(login, mdp)){
			Screen.display(mainAdmin);
		}
	}

	function onClickCreateUsers(w : Control) {
		//
	}

	function onClickAfficherUsers(w : Control) {
		var r = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user/all");
		
		r.onData = function(data : String) {
			var users : Array<Users> = Json.parse(data);
			l.source = users;
	    } 
	    r.request();
	}
	
	function affichageUsers(e : Users) : Widget {
		return new Label(e.nom + " " + e.prenom);
	}

	function onClickDeconnexion(w : Control) {
		Screen.display(main);
	}

	function Auth(login : String, mdp : String) : Bool{
      var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?auth/");
      var user : Users;
	  req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
		  user = Json.parse(data);
		  trace(user);
      }
      req.request(false);
	  if (user != null){
			  return true;
		  } else {
			  return false;
		  }
    }
}
