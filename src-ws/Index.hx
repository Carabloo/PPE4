import controller.Listener;
import controller.Request;
import sys.db.TableCreate;
import sys.db.Manager;
import sys.db.Mysql;
import haxe.web.Dispatch;
import models.*;
import api.*;
import controllers.*;

class Index {
    var request : Request;

    public static function main(){
      Listener.boot();
    }

    public function new (r : Request){
      request = r;
    }

    private function doUser(?reference : String = null){
      UserController.dispatch(request, reference);
    }

    private function doOffer(?reference : String = null){
      OfferController.dispatch(request, reference);
    }

    private function doAuth(){
      AuthController.dispatch(request);
    }

    public static function dispatch(request : Request){ //point d'entrée de traitement d'une requête
        //routage
        try {
          Manager.initialize();
          Manager.cnx = sys.db.Mysql.connect({
              host : "www.sio-savary.fr",
              port : 3306,
              user : "sqlfchevalier",
              pass : "savary",
              socket : null,
              database : "covoit_afg"
          });

          if (! TableCreate.exists(User.manager)) {
              TableCreate.create(User.manager);
              TableCreate.create(Offer.manager);
          }
        } catch(e:Dynamic){
          request.setReturnCode(503,'Erreur DataBase ');
          return;
        }

        try {
          Dispatch.run(request.query, null, new Index(request));
        } catch(e:DispatchError){
          request.setReturnCode(406,'Not Acceptable');
        } catch(e:Dynamic){
          request.setReturnCode(500,Std.string(e));
        }


        Manager.cleanup();

    }
}
