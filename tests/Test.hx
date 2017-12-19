import haxe.unit.TestCase;
import haxe.Http;
import api.*;
import haxe.Json;
import models.*;
import sys.db.Manager;

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
        var req = new Http(wsuri + "?/user/all");
        req.onData = function (data : String){
            var retrieveUsers : Array<GETEleves> = Json.parse(data);
            var userDB : Array<GETEleves> = cast Lambda.array(Eleves.manager.all());
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());
            assertEquals(userDB.length, retrieveUsers.length);
            for(i in 0...userDB.length)
            {
            assertEquals(retrieveUsers[i].idEleves, userDB[i].idEleves);
            assertEquals(retrieveUsers[i].nom, userDB[i].nom);
            assertEquals(retrieveUsers[i].prenom, userDB[i].prenom);
            assertEquals(retrieveUsers[i].mail, userDB[i].mail);
            assertEquals(retrieveUsers[i].telephone, userDB[i].telephone);
            assertEquals(retrieveUsers[i].mdp, userDB[i].mdp);
            }
        }
        req.onError = function(msg:String){
        assertEquals(406,extractErrorCode(msg));
        }
        req.request(false);
    }

    public function test04RetrieveOffers(){
        var req = new Http(wsuri + "?/offer/all");
        req.onData = function (data : String){
            var retrieveOffers : Array<GETTrajets> = Json.parse(data);
            var offersDB : Array<GETTrajets> = cast Lambda.array(Trajet.manager.all());
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());
            assertEquals(offersDB.length, retrieveOffers.length);
            for(i in 0...offersDB.length)
            {
            assertEquals(retrieveOffers[i].idTrajet, offersDB[i].idTrajet);
            assertEquals(retrieveOffers[i].heure, offersDB[i].heure);
            assertEquals(retrieveOffers[i].km, offersDB[i].km);
            assertEquals(retrieveOffers[i].dte, offersDB[i].dte);
            assertEquals(retrieveOffers[i].jour, offersDB[i].jour);
            assertEquals(retrieveOffers[i].type, offersDB[i].type);
            }
        }
        req.onError = function(msg:String){
        assertEquals(406,extractErrorCode(msg));
        }
        req.request(false);
    }

}