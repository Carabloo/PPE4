import haxe.unit.TestCase;
import haxe.Http;
import api.*;
import haxe.Json;
import models.*;
import sys.db.Manager;

class TestArticle extends TestCase{
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

    public function test03RetrieveEleves(){
        var req = new Http(wsuri + "?/user/all");
        req.onData = function (data : String){
            var retrieveUser : Array<GETEleves> = Json.parse(data);
            var userDB : List<Eleves> = cast Eleves.manager.all();
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());            
            assertEquals(userDB.length, retrieveUser.length);
            for(i in 0...userDB.length)
            {
            assertEquals(retrieveUser[i].idEleve, userDB[i].idEleve); 
            assertEquals(retrieveUser[i].nom, userDB[i].nom); 
            assertEquals(retrieveUser[i].prenom, userDB[i].prenom); 
            assertEquals(retrieveUser[i].mail, userDB[i].mail); 
            assertEquals(retrieveUser[i].telephone, userDB[i].telephone); 
            assertEquals(retrieveUser[i].mdp, userDB[i].mdp); 
            }
        }
        req.onError = function(msg:String){
        assertEquals(406,extractErrorCode(msg));
        }
        req.request(false);
    }

}
