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
	var mainAdminCreateUser : VBox;
	var identifiant : Input;
	var motdepasse : Input;
	var l : ListView<Users>;
	var login : String;
	var mdp : String;
	var loginNewUser : Input;
	var nomNewUser : Input;
	var prenomNewUser : Input;
	var mailNewUser : Input;
	var telephoneNewUser : Input;
	var mdpNewUser : Input;
	
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
		mainAdmin.pack(new TextButton(formCreateUsers, "Créer un utilisateur",  1));	
		
		l = new ListView(affichageUsers);
		mainAdmin.pack(l);

		mainAdminCreateUser = new VBox();
		//mainAdminCreateUser.pack();

		loginNewUser = new Input("", 50, 1);
		nomNewUser = new Input("", 50, 1);
		prenomNewUser = new Input("", 50, 1);
		mailNewUser = new Input("", 50, 1);
		telephoneNewUser = new Input("", 50, 1);
		mdpNewUser = new Input("", 50, 1);

		mainAdminCreateUser.pack(new Title("Créer un utilisateur"));
		mainAdminCreateUser.pack(new Separator());
		mainAdminCreateUser.pack(new Label ("Login :")); 
		mainAdminCreateUser.pack(loginNewUser);
		mainAdminCreateUser.pack(new Label ("Nom d'utilisateur :"));
		mainAdminCreateUser.pack(nomNewUser);
		mainAdminCreateUser.pack(new Label ("Prénom :")); 
		mainAdminCreateUser.pack(prenomNewUser);
		mainAdminCreateUser.pack(new Label ("Adresse Mail :"));
		mainAdminCreateUser.pack(mailNewUser);
		mainAdminCreateUser.pack(new Label ("Téléphone :")); 
		mainAdminCreateUser.pack(telephoneNewUser);
		mainAdminCreateUser.pack(new Label ("Mot de passe :"));
		mainAdminCreateUser.pack(mdpNewUser);
		mainAdminCreateUser.pack(new Separator());
		mainAdminCreateUser.pack(new TextButton(onClickCreateUsers, "Créer", 0.30));
		mainAdminCreateUser.pack(new TextButton(returnAccueil, "Accueil", 0.50));
	} 
	
	function onClickConnexion(w : Control) {
		var login = identifiant.value ;
		var mdp = motdepasse.value ;
		mdp = Sha256.encode(mdp);
		if (Auth(login, mdp)){
			Screen.display(mainAdmin);
		}
	}

	function onClickAfficherUsers(w : Control) {
		var r = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user/all");
		r.addHeader("Cookie", "login="+ this.login +"; mdp=" + this.mdp);
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
		this.login = null;
		this.mdp = null;
		//this.identifiant.value = "";
		//this.motdepasse.value = "";
		//main.clear;
	}

	function Auth(login : String, mdp : String) : Bool{
      var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?auth/");
      var user : Users;
	  req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
		  user = Json.parse(data);
		  if (user != null) {
			this.login = user.login;
		  	this.mdp = user.mdp;
		  } 
		  trace(user);
      }
      req.request(false);
	  if (user != null){
			  return true;
		  } else {
			  return false;
		  }
    }

	function returnAccueil(w : Control) {
		Screen.display(mainAdmin);
	}

	function formCreateUsers(w : Control) {
		Screen.display(mainAdminCreateUser);
	}

	function onClickCreateUsers(w : Control) {
		//
	}
}
