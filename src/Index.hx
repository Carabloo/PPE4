import controller.Listener;
import controller.Request;
import sys.db.TableCreate;
import sys.db.Manager;
import php.db.PDO;
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

<<<<<<< HEAD:src/Index.hx
    private function doUser(?reference : String = null){
=======
    private function doArticles(?reference : String = null){
>>>>>>> 9af5fef68ebaff27a3dfc25a0f6105cfa59b5324:src/index.hx
      UserController.dispatch(request, reference);
    }

    public static function dispatch(request : Request){ //point d'entrée de traitement d'une requête
        //routage
        try {
          Manager.initialize();
          Manager.cnx = PDO.open("mysql:host=localhost;dbname=covoit_afg", "sqlfchevalier", "savary");

          if (! TableCreate.exists(Eleves.manager)) {
              TableCreate.create(Eleves.manager);
              TableCreate.create(Trajet.manager);
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
