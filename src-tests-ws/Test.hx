import haxe.unit.TestCase;
import haxe.Http;
import api.*;
import haxe.Json;
import models.*;
import sys.db.Manager;
import haxe.io.BytesOutput;
import haxe.crypto.Sha256;

class Test extends TestCase{
    var wsuri : String;

    public function new(wsuri : String){
        super();
        this.wsuri = wsuri;
    }

    public function test01BadUri(){
        var req = new Http(wsuri + "?/baduri");
        req.onData = function (data : String){
            assertFalse(true);
        }
        req.onError = function(msg:String){
            assertEquals(406,extractErrorCode(msg));
        }
        req.request(false /*GET*/);

    }

    public function extractErrorCode(msg:String):Int{
       return Std.parseInt(msg.substring(msg.indexOf("#")+1));
    }

    public function test02DefaultUri(){
       var req = new Http(wsuri + "?/");
        req.onData = function (data : String){
            assertFalse(true);
        }
        req.onError = function(msg:String){
            assertEquals(406,extractErrorCode(msg));
        }
        req.request(false /*GET*/);
    }

    public function test03RetrieveUsers(){
        var login = "admin";
        var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
        var req = new Http(wsuri + "?/user/all");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            var retrieveUsers : Array<GETUser> = Json.parse(data);
            var userDB : Array<GETUser> = cast Lambda.array(User.manager.all());
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());
            assertEquals(userDB.length, retrieveUsers.length);
            for(i in 0...userDB.length)
            {
            assertEquals(retrieveUsers[i].idUser, userDB[i].idUser);
            assertEquals(retrieveUsers[i].login, userDB[i].login);
            assertEquals(retrieveUsers[i].nom, userDB[i].nom);
            assertEquals(retrieveUsers[i].prenom, userDB[i].prenom);
            assertEquals(retrieveUsers[i].mail, userDB[i].mail);
            assertEquals(retrieveUsers[i].telephone, userDB[i].telephone);
            assertEquals(retrieveUsers[i].mdp, userDB[i].mdp);
            }
        }
        req.onError = function(msg:String){
          assertTrue(false);
        }
        req.request(false);
    }

    public function test04RetrieveOffers(){
        var login = "admin";
        var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
        var req = new Http(wsuri + "?/offer/all");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            var retrieveOffers : Array<GETOffer> = Json.parse(data);
            var offersDB : Array<GETOffer> = cast Lambda.array(Offer.manager.all());
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());
            assertEquals(offersDB.length, retrieveOffers.length);
            for(i in 0...offersDB.length)
            {
            assertEquals(retrieveOffers[i].idOffer, offersDB[i].idOffer);
            assertEquals(retrieveOffers[i].heure, offersDB[i].heure);
            assertEquals(retrieveOffers[i].km, offersDB[i].km);
            assertEquals(retrieveOffers[i].date.toString(), offersDB[i].date.toString());
            assertEquals(retrieveOffers[i].jour, offersDB[i].jour);
            assertEquals(retrieveOffers[i].type, offersDB[i].type);
            }
        }
        req.onError = function(msg:String){
          assertTrue(false);
        }
        req.request(false);
    }

    public function test05RetrieveUserByReference(){
        var user = User.manager.all().first();
        var login = "admin";
        var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
        var req = new Http(wsuri + "?/user/" + user.idUser);
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onError = function(msg:String){
            assertTrue(false);
        }
        req.onData = function (data : String){

          var retrievedUser : GETUser = Json.parse(data);
          assertEquals(retrievedUser.idUser, user.idUser);
          assertEquals(retrievedUser.login, user.login);
          assertEquals(retrievedUser.nom, user.nom);
          assertEquals(retrievedUser.prenom, user.prenom);
          assertEquals(retrievedUser.mail, user.mail);
          assertEquals(retrievedUser.telephone, user.telephone);
          assertEquals(retrievedUser.mdp, user.mdp);
        }
        req.request(false);
    }

    public function test06RetrieveOfferByReference(){
        var offer = Offer.manager.all().first();
        var login = "admin";
        var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
        var req = new Http(wsuri + "?/offer/" + offer.idOffer);
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onError = function(msg:String){
            assertTrue(false);
        }
        req.onData = function (data : String){
          var retrievedOffer : GETOffer = Json.parse(data);
          assertEquals(retrievedOffer.idOffer, offer.idOffer);
          assertEquals(retrievedOffer.heure, offer.heure);
          assertEquals(retrievedOffer.km, offer.km);
          assertEquals(retrievedOffer.date.toString(), offer.date.toString());
          assertEquals(retrievedOffer.jour, offer.jour);
          assertEquals(retrievedOffer.type, offer.type);

        }
        req.request(false);
    }

    public function test07PostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : POSTUser = {login:"mpatrick",nom:"Michon", prenom:"Patrick", mail:"test@gmail.fr", telephone:'0215474563', mdp:'aaaa'};
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function(msg:String){
          trace(msg);
        assertTrue(false);


      }
      req.onData = function(data:String){
        var idUser : String = Json.parse(data).idUser;
        var user : User = User.manager.get(idUser);
        assertTrue(user != null);
        assertEquals(user.idUser,idUser);
        assertEquals(user.login,postUser.login);
        assertEquals(user.nom,postUser.nom);
        assertEquals(user.prenom,postUser.prenom);
        assertEquals(user.mail,postUser.mail);
        assertEquals(user.telephone,postUser.telephone);
        assertEquals(user.mdp,postUser.mdp);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test08PostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : User = User.manager.all().first();
      var postOffer : POSTOffer = {heure:"5h10", km:12, date:Date.now(), jour:"jeudi", type:true, idUser:user.idUser};
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function(msg:String){
        trace(msg);
        assertTrue(false);
      }
      req.onData = function(data:String){
        var idOffer : String = Json.parse(data).idOffer;
        var offer : Offer = Offer.manager.get(idOffer);
        assertTrue(offer != null);
        assertEquals(offer.idOffer,idOffer);
        assertEquals(offer.heure,postOffer.heure);
        assertEquals(offer.km,postOffer.km);
        assertEquals(offer.date.toString(),postOffer.date.toString());
        assertEquals(offer.jour,postOffer.jour);
        assertEquals(offer.type,postOffer.type);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test09PutUser(){
      var user = User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test",telephone:"0205147568",mdp:"aaaa"};
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      var req = new Http(wsuri + "?/user/"+ Std.string(refUser));
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
          trace(msg);
          assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup();
        user = User.manager.get(refUser);
        assertEquals(newUser.login, user.login);
        assertEquals(newUser.nom, user.nom);
        assertEquals(newUser.prenom, user.prenom);
        assertEquals(newUser.mail, user.mail);
        assertEquals(newUser.telephone, user.telephone);
        assertEquals(Sha256.encode(newUser.mdp), user.mdp);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test11DeleteUser(){
      var user : User;
      var user = User.manager.all().last();
      var refUser = user.idUser;
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      var req = new Http(wsuri + "?/user/" + Std.string(refUser));
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup(); //pour vider le cache des requêtes SQL
        user = User.manager.all().last();
        var newRefUser = user.idUser;
        if(refUser != newRefUser){
          assertTrue(true);
        } else {
          assertTrue(false);
        }
      }
      req.customRequest(false, new BytesOutput(), "DELETE");
    }

    public function test12DeleteOffer(){
      var offer : Offer;
      var offer = Offer.manager.all().last();
      var refOffer = offer.idOffer;
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      var req = new Http(wsuri + "?/offer/" + Std.string(refOffer));
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
        trace(msg);
        assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup(); //pour vider le cache des requêtes SQL
        offer = Offer.manager.all().last();
        var newRefOffer = offer.idOffer;
        if(refOffer != newRefOffer){
          assertTrue(true);
        } else {
          assertTrue(false);
        }
      }
      req.customRequest(false, new BytesOutput(), "DELETE");
    }

    public function test13Auth(){
      var req = new Http(wsuri + "?/auth/");
      var login = "admin";
      var mdp = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          var retrieveUser : User = Json.parse(data);
          assertEquals(retrieveUser.login, login);
          assertEquals(retrieveUser.mdp, mdp);
      }
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.request(false);
    }

}
