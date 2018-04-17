package;
import openfl.display.Sprite;
import buw.*;
import haxe.Http;
import haxe.Json;
import haxe.crypto.Sha256;
import api.POSTUser;
import api.POSTOffer;

typedef Users = {
  public var idUser : String;
  public var login : String;
  public var nom : String;
  public var prenom : String;
  public var mail : String;
  public var telephone : String;
  public var mdp : String;
}

typedef Offers = {
    public var idOffer : String;
    public var heure : String;
    public var km : Float;
    public var date : Date;
    public var isFrom : Bool;	
    public var jour : String;
    public var type : Bool;
    public var user : Users;
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

	var mainUser : VBox;
	var mainUserCreateOffer : VBox;
	var l2 : ListView<Offers>;
	var heureNewOffer : Input;
	var kmNewOffer : Input;
	var dateNewOffer : Input;
	var isFromNewOffer : RadioBox;
	var jourNewOffer : Input;
	var typeNewOffer : RadioBox;

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
		mainAdmin.pack(new TextButton(formCreateUser, "Créer un utilisateur",  1));	
		
		l = new ListView(affichageUsers);
		mainAdmin.pack(l);

		mainAdminCreateUser = new VBox();

		loginNewUser = new Input("", 50, 1);
		nomNewUser = new Input("", 50, 1);
		prenomNewUser = new Input("", 50, 1);
		mailNewUser = new Input("", 50, 1);
		telephoneNewUser = new Input("", 50, 1);
		mdpNewUser = new Input("", 50, 1);

		mainAdminCreateUser.pack(new Title("Créer un utilisateur"));
		mainAdminCreateUser.pack(new Separator());
		mainAdminCreateUser.pack(new Label ("Login* :")); 
		mainAdminCreateUser.pack(loginNewUser);
		mainAdminCreateUser.pack(new Label ("Nom* :"));
		mainAdminCreateUser.pack(nomNewUser);
		mainAdminCreateUser.pack(new Label ("Prénom* :")); 
		mainAdminCreateUser.pack(prenomNewUser);
		mainAdminCreateUser.pack(new Label ("Adresse Mail* :"));
		mainAdminCreateUser.pack(mailNewUser);
		mainAdminCreateUser.pack(new Label ("Téléphone* :")); 
		mainAdminCreateUser.pack(telephoneNewUser);
		mainAdminCreateUser.pack(new Label ("Mot de passe* :"));
		mainAdminCreateUser.pack(mdpNewUser);
		mainAdminCreateUser.pack(new Separator());
		mainAdminCreateUser.pack(new TextButton(onClickCreateUser, "Créer", 0.30));
		mainAdminCreateUser.pack(new TextButton(returnAccueil, "Accueil", 0.50));

		mainUser = new VBox();	
		mainUser.pack(new TextButton(onClickDeconnexion, "Deconnexion", 0.30));
		mainUser.pack(new Separator());
		mainUser.pack(new TextButton(onClickAfficherOffers, "Afficher les offres",  1));
		mainUser.pack(new TextButton(formCreateOffer, "Créer une offre",  1));

		l2 = new ListView(affichageOffers);
		mainUser.pack(l2);

		mainUserCreateOffer = new VBox();

		heureNewOffer = new Input("", 50, 1);
		kmNewOffer = new Input("", 50, 1);
		dateNewOffer = new Input("", 50, 1);
		jourNewOffer = new Input("", 50, 1);
		typeNewOffer = new Input("", 50, 1);

		mainUserCreateOffer.pack(new Title("Créer une offre"));
		mainUserCreateOffer.pack(new Separator());
		mainUserCreateOffer.pack(new Label ("Heure* :")); 
		mainUserCreateOffer.pack(heureNewOffer);
		mainUserCreateOffer.pack(new Label ("Kilomètres* :"));
		mainUserCreateOffer.pack(kmNewOffer);
		mainUserCreateOffer.pack(new Label ("Date* :")); 
		mainUserCreateOffer.pack(dateNewOffer);
		mainUserCreateOffer.pack(new Label ("Jour* :"));
		mainUserCreateOffer.pack(jourNewOffer);
		mainUserCreateOffer.pack(new Label ("Type* :")); 
		mainUserCreateOffer.pack(typeNewOffer);
		mainUserCreateOffer.pack(new Separator());
		mainUserCreateOffer.pack(new TextButton(onClickCreateOffer, "Créer", 0.30));
		mainUserCreateOffer.pack(new TextButton(returnAccueil, "Accueil", 0.50));
	} 
	
	function onClickConnexion(w : Control) {
		var login = identifiant.value ;
		var mdp = motdepasse.value ;
		mdp = Sha256.encode(mdp);
		if (Auth(login, mdp)){
			if(login == "admin") {
				Screen.display(mainAdmin);
			} else {
				Screen.display(mainUser);
			}			
		}
	}

	function onClickAfficherUsers(w : Control) {
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?user/all");
		req.addHeader("Cookie", "login="+ this.login +"; mdp=" + this.mdp);
		req.onData = function(data : String) {
			var users : Array<Users> = Json.parse(data);
			l.source = users;
	    } 
	    req.request();
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

	function formCreateUser(w : Control) {
		Screen.display(mainAdminCreateUser);
	}

	function onClickCreateUser(w : Control) {
		var createUser : POSTUser = {
			login: this.loginNewUser.value,
			nom: this.nomNewUser.value, 
			prenom: this.prenomNewUser.value, 
			mail: this.mailNewUser.value, 
			telephone: this.telephoneNewUser.value, 
			mdp: Sha256.encode(this.mdpNewUser.value)
		};
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?/user");
		req.addHeader("Cookie","login="+ this.login +"; mdp=" + this.mdp);	
		req.setHeader("Content-Type", "application/json");
		req.setPostData(Json.stringify(createUser));
		req.request(true); 
	}

	function onClickAfficherOffers(w : Control) {
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?offer/all");
		req.addHeader("Cookie", "login="+ this.login +"; mdp=" + this.mdp);
		req.onData = function(data : String) {
			var offers : Array<Offers> = Json.parse(data);
			l2.source = offers;
	    } 
	    req.request();
	}

	function affichageOffers(o : Offers) : Widget {
		return new Label(o.km + " " + o.date + " " + o.jour + " " + o.type + " " + o.user);
	}

	function formCreateOffer(w : Control) {
		Screen.display(mainUserCreateOffer);
	}

	function onClickCreateOffer(w : Control) {
		var createOffer : POSTOffer = {
			heure: this.heureNewOffer.value,
			km: this.kmNewOffer.value, 
			date: this.dateNewOffer.value, 
			jour: this.jourNewOffer.value, 
			type: this.typeNewOffer.value
		};
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?/offer");
		req.addHeader("Cookie","login="+ this.login +"; mdp=" + this.mdp);	
		req.setHeader("Content-Type", "application/json");
		req.setPostData(Json.stringify(createOffer));
		req.request(true);
	}
}
