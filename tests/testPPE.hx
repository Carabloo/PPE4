import haxe.unit.TestRunner;
import sys.db.Mysql;
import sys.db.TableCreate;
import sys.db.Manager;
import models.*;


class TestWS{
    static var WSURI : String = "http://www.sio-savary.fr/fchevalier/PPECovoiturage/";
    static var eleves : Eleves;
    static var trajet : Trajet;

    public static function main(){
        var runner = new TestRunner();
        runner.add(new TestArticle(WSURI));
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
        eleves = new Eleves("Processeur Amtel", 100, 4);
        trajet = new Trajet("Installation", 50);

        eleves.insert();
        trajet.insert();
    }

    public static function tearDown(){
        eleves.delete();
        trajet.delete();
        Manager.cleanup();
    }
}
