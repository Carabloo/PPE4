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
}
