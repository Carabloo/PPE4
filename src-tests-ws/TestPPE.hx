import haxe.unit.TestRunner;
import sys.db.Mysql;
import sys.db.TableCreate;
import sys.db.Manager;
import models.User;
import models.Offer;


class TestPPE{
    static var WSURI : String = "http://www.sio-savary.fr/covoit_afg/PPECovoiturage/";
    static var user : User;
    static var offer : Offer;
    static var admin : User;

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
        user = new User("fchevalier","François", "Chevalier", "test@mail.fr", "0629352663", "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4");
        admin = new User("admin","Fr","Che","test@mail.fr","0635285698", "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4");
        offer = new Offer(Date.now().toString(), 50, Date.now().toString(), true, "mardi", true, user);


        admin.insert();
        user.insert();
        offer.insert();
    }

    public static function tearDown(){

        admin.delete();
        user.delete();
        offer.delete();
        Manager.cleanup();
    }
}
