import haxe.unit.TestRunner;
import sys.db.Mysql;
import sys.db.TableCreate;
import sys.db.Manager;
import models.*;


class TestPPE{
    static var WSURI : String = "http://www.sio-savary.fr/fchevalier/PPECovoiturage/";
    static var eleves : Eleves;
    static var trajet : Trajet;

    public static function main(){
        var runner = new TestRunner();
        runner.add(new Test(WSURI));
        setup();
        runner.run();
        tearDown();

    }

    public static function setup(){

        Manager.initialize();
        Manager.cnx = sys.db.Mysql.connect({
            host : "www.sio-savary.fr",
            port : 3306,
            user : "sqlfchevalier",
            pass : "savary",
            socket : null,
            database : "covoit_afg"
        });

        if (! TableCreate.exists(Eleves.manager)) {
              TableCreate.create(Eleves.manager);
              TableCreate.create(Trajet.manager);
          }
        eleves = new Eleves("1","Francois","Chevalier","test@.fr","0215475896","aaa");
        trajet = new Trajet("1","5h10",12,Date.now(),'mardi',true,eleves);

        eleves.insert();
        trajet.insert();
    }

    public static function tearDown(){
        eleves.delete();
        trajet.delete();
        Manager.cleanup();
    }
}
