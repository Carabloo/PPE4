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
    public var date : String;
    public var isFrom : String;	
    public var jour : String;
    public var type : String;
    public var idUser : String;
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
	var idUser : String;
	var loginNewUser : Input;
	var nomNewUser : Input;
	var prenomNewUser : Input;
	var mailNewUser : Input;
	var telephoneNewUser : Input;
	var mdpNewUser : Input;

	var mainUser : VBox;
	var mainUserCreateOfferPermanente : VBox;
	var mainUserCreateOfferPonctuelle : VBox;
	var l2 : ListView<Offers>;
	var heureNewOfferPermanente : Input;
	var kmNewOfferPermanente : Input;
	var dateNewOfferPermanente : Input;
	var isFromNewOfferPermanente : RadioBox;
	var jourNewOfferPermanente : Input;
	var typeNewOfferPermanente : RadioBox;
	
	var heureNewOfferPonctuelle : Input;
	var kmNewOfferPonctuelle : Input;
	var dateNewOfferPonctuelle : Input;
	var isFromNewOfferPonctuelle : RadioBox;
	var jourNewOfferPonctuelle : Input;
	var typeNewOfferPonctuelle : RadioBox;

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

		/*var v : HBox = new Hbox(1, [new HBoxColumn(0.5), new HBoxColumn(0.25), new HBoxColumn(0.25)]);
		v.pack(l)*/

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
		mainUser.pack(new TextButton(formCreateOfferPermanente, "Créer une offre permanente",  1));
		mainUser.pack(new TextButton(formCreateOfferPonctuelle, "Créer une offre ponctuelle",  1));

		l2 = new ListView(affichageOffers);
		mainUser.pack(l2);

		heureNewOfferPermanente = new Input("", 50, 1);
		kmNewOfferPermanente = new Input("", 50, 1);
		dateNewOfferPermanente = new Input("", 50, 1);
		isFromNewOfferPermanente = new RadioBox(false).add(new TextRadioButton("Domicile")).add(new TextRadioButton("Lycée"));
		jourNewOfferPermanente = new Input("", 50, 1);
		typeNewOfferPermanente = new RadioBox(false).add(new TextRadioButton("Permanente")).add(new TextRadioButton("Ponctuelle")); 

		mainUserCreateOfferPermanente = new VBox();

		mainUserCreateOfferPermanente.pack(new Title("Créer une offre permanente"));
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new Label ("Heure (ex : 09:50)* :")); 
		mainUserCreateOfferPermanente.pack(heureNewOfferPermanente);
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new Label ("Kilomètres* :"));
		mainUserCreateOfferPermanente.pack(kmNewOfferPermanente);
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new Label ("Départ depuis* :")); 
		mainUserCreateOfferPermanente.pack(isFromNewOfferPermanente);
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new Label ("Jour (en minuscule)* :"));
		mainUserCreateOfferPermanente.pack(jourNewOfferPermanente);
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new Label ("Type* :")); 
		mainUserCreateOfferPermanente.pack(typeNewOfferPermanente);
		mainUserCreateOfferPermanente.pack(new Separator());
		mainUserCreateOfferPermanente.pack(new TextButton(onClickCreateOfferPermanente, "Créer", 0.30));
		mainUserCreateOfferPermanente.pack(new TextButton(returnAccueil, "Accueil", 0.50));

		heureNewOfferPonctuelle = new Input("", 50, 1);
		kmNewOfferPonctuelle = new Input("", 50, 1);
		dateNewOfferPonctuelle = new Input("", 50, 1);
		isFromNewOfferPonctuelle = new RadioBox(false).add(new TextRadioButton("Domicile")).add(new TextRadioButton("Lycée"));
		jourNewOfferPonctuelle = new Input("", 50, 1);
		typeNewOfferPonctuelle = new RadioBox(false).add(new TextRadioButton("Permanente")).add(new TextRadioButton("Ponctuelle")); 

		mainUserCreateOfferPonctuelle = new VBox();

		mainUserCreateOfferPonctuelle.pack(new Title("Créer une offre ponctuelle"));
		mainUserCreateOfferPonctuelle.pack(new Separator());
		mainUserCreateOfferPonctuelle.pack(new Label ("Heure (ex : 09:50)* :")); 
		mainUserCreateOfferPonctuelle.pack(heureNewOfferPonctuelle);
		mainUserCreateOfferPonctuelle.pack(new Separator());
		mainUserCreateOfferPonctuelle.pack(new Label ("Kilomètres* :"));
		mainUserCreateOfferPonctuelle.pack(kmNewOfferPonctuelle);
		mainUserCreateOfferPonctuelle.pack(new Separator());
		mainUserCreateOfferPonctuelle.pack(new Label ("Date (ex : 2018:09:28)* :"));
		mainUserCreateOfferPonctuelle.pack(dateNewOfferPonctuelle);
		mainUserCreateOfferPonctuelle.pack(new Separator());
		mainUserCreateOfferPonctuelle.pack(new Label ("Départ depuis* :")); 
		mainUserCreateOfferPonctuelle.pack(isFromNewOfferPonctuelle);
		mainUserCreateOfferPonctuelle.pack(new Separator());
		/* mainUserCreateOfferPonctuelle.pack(new Label ("Jour (en minuscule)* :"));
		   mainUserCreateOfferPonctuelle.pack(jourNewOfferPonctuelle);
		   mainUserCreateOfferPonctuelle.pack(new Separator()); */
		mainUserCreateOfferPonctuelle.pack(new Label ("Type* :")); 
		mainUserCreateOfferPonctuelle.pack(typeNewOfferPonctuelle);
		mainUserCreateOfferPonctuelle.pack(new Separator());
		mainUserCreateOfferPonctuelle.pack(new TextButton(onClickCreateOfferPonctuelle, "Créer", 0.30));
		mainUserCreateOfferPonctuelle.pack(new TextButton(returnAccueil, "Accueil", 0.50));
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
		return new Label(e.nom + " " + e.prenom); //hbox de 3 afficher modifier supprimer
	}

	function onClickDeconnexion(w : Control) {
		Screen.display(main);
		this.login = null;
		this.mdp = null;
		this.idUser = null;
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
			this.idUser = user.idUser;
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
		//Screen.display(mainAdmin);
		if (Auth(login, mdp)){
			if(login == "admin") {
				Screen.display(mainAdmin);
			} else {
				Screen.display(mainUser);
			}			
		}
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
		return new Label("heure : " + o.heure + ", kilomètres : " + o.km + ", date : " + o.date + ", jour : " + o.jour + ", type : " + o.type + ", id Utilisateur : " + o.idUser);
	}

	function formCreateOfferPermanente(w : Control) {
		Screen.display(mainUserCreateOfferPermanente);
	}

	function onClickCreateOfferPermanente(w : Control) {
		var isFromRadioBoxPermanente : String = null;
		var typeRadioBoxPermanente : String = null;
		var kmPermanente : Float = Std.parseFloat(this.kmNewOfferPermanente.value);

		if (isFromNewOfferPermanente.selected == 0) {
			isFromRadioBoxPermanente = "false";
		} else {
			isFromRadioBoxPermanente = "true";
		}
		
		if (typeNewOfferPermanente.selected == 0) { 
			typeRadioBoxPermanente = "false";
		} else {
			typeRadioBoxPermanente = "true";
		}

		var createOfferPermanente : POSTOffer = {
			heure: this.heureNewOfferPermanente.value,
			km: kmPermanente, 
			date: this.dateNewOfferPermanente.value,
			isFrom: isFromRadioBoxPermanente,
			jour: this.jourNewOfferPermanente.value,
			type: typeRadioBoxPermanente,
			idUser: this.idUser
		};
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?/offer");
		req.addHeader("Cookie","login="+ this.login +"; mdp=" + this.mdp);	
		req.setHeader("Content-Type", "application/json");
		req.setPostData(Json.stringify(createOfferPermanente));
		req.request(true);
	}

	function formCreateOfferPonctuelle(w : Control) {
		Screen.display(mainUserCreateOfferPonctuelle);
	}

	function onClickCreateOfferPonctuelle(w : Control) {
		var isFromRadioBoxPonctuelle : String = null;
		var typeRadioBoxPonctuelle : String = null;
		var kmPonctuelle : Float = Std.parseFloat(this.kmNewOfferPonctuelle.value);

		if (isFromNewOfferPonctuelle.selected == 0) {
			isFromRadioBoxPonctuelle = "false";
		} else {
			isFromRadioBoxPonctuelle = "true";
		}
		
		if (typeNewOfferPonctuelle.selected == 0) { 
			typeRadioBoxPonctuelle = "false";
		} else {
			typeRadioBoxPonctuelle = "true";
		}

		var createOfferPonctuelle : POSTOffer = {
			heure: this.heureNewOfferPonctuelle.value,
			km: kmPonctuelle, 
			date: this.dateNewOfferPonctuelle.value,
			isFrom: isFromRadioBoxPonctuelle,
			jour: this.jourNewOfferPonctuelle.value,
			type: typeRadioBoxPonctuelle,
			idUser: this.idUser
		};
		var req = new Http("http://www.sio-savary.fr/covoit_afg/PPECovoiturage/?/offer");
		req.addHeader("Cookie","login="+ this.login +"; mdp=" + this.mdp);	
		req.setHeader("Content-Type", "application/json");
		req.setPostData(Json.stringify(createOfferPonctuelle));
		req.request(true);
	}
}
