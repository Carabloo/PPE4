/*package;
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

class connexion extends Main {
	
	public function new () {	
		super();		
		//main.pack(new TextButton(onClickConnexion, "Connexion",  1));				
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

    function onClickConnexion(w : Control) {
		var login = identifiant.value ;
		var mdp = motdepasse.value ;
		mdp = Sha256.encode(mdp);
		if (Auth(login, mdp)){
			Screen.display(mainAdmin);
		}		
	}
}
*/