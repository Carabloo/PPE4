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

    public function test03RetrieveEleves(){
        var req = new Http(wsuri + "?/user/all");
        req.onData = function (data : String){
            var userDB : Array<GETEleves> = Json.parse(data);
            var retrieveUser : Array<GETEleves> = cast Lambda.array(Eleves.manager.all());
            assertEquals(userDB.length, retrieveUser.length);
            for(i in 0...retrieveUser.length)
            {
            assertEquals(retrieveUser[i].idEleves, userDB[i].idEleves);
            assertEquals(retrieveUser[i].nom, userDB[i].nom);
            assertEquals(retrieveUser[i].prenom, userDB[i].prenom);
            }
        }
        req.onError = function(msg:String){
        trace(msg);
        assertEquals(406,extractErrorCode(msg));
        }
        req.request(false);
    }
}
