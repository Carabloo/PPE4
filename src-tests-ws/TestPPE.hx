import haxe.unit.TestRunner;
import sys.db.Mysql;
import sys.db.TableCreate;
import sys.db.Manager;
import models.*;


class TestPPE{
    static var WSURI : String = "http://www.sio-savary.fr/covoit_afg/PPECovoiturage/";
    static var user : User;
    static var offer : Offer;

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

        if (! TableCreate.exists(User.manager)) {
              TableCreate.create(User.manager);
              TableCreate.create(Offer.manager);
          }
        user = new User("fchevalier","François", "Chevalier", "test@mail.fr", "0629352663", "aaaa");
        offer = new Offer("4h20", 50, Date.now(), "mardi", true, user);

        user.insert();
        offer.insert();
    }

    public static function tearDown(){
        user.delete();
        offer.delete();
        Manager.cleanup();
    }
}