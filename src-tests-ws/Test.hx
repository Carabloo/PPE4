import haxe.unit.TestCase;
import haxe.Http;
import api.*;
import haxe.Json;
import models.*;
import sys.db.Manager;
import haxe.io.BytesOutput;
import haxe.crypto.Sha256;

class Test extends TestCase{
    var wsuri : String;
    var login : String = "admin";
    var mdp : String = "61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4";

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

    public function test03Auth(){
      var req = new Http(wsuri + "?/auth");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          var retrieveUser : User = Json.parse(data);
          assertEquals(retrieveUser.login, login);
          assertEquals(retrieveUser.mdp, mdp);
      }
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.request(false);
    }

    public function test04RetrieveUsers(){
        var req = new Http(wsuri + "?/user/all");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            var retrieveUsers : Array<GETUser> = Json.parse(data);
            var userDB : Array<GETUser> = cast Lambda.array(User.manager.all());
            //var articlesDB : Array<Produit> = cast Lambda.array(Article.manager.all());
            assertEquals(userDB.length, retrieveUsers.length);
            for(i in 0...userDB.length-1)
            {
            assertEquals(retrieveUsers[i].idUser, userDB[i].idUser);
            assertEquals(retrieveUsers[i].login, userDB[i].login);
            assertEquals(retrieveUsers[i].nom, userDB[i].nom);
            assertEquals(retrieveUsers[i].prenom, userDB[i].prenom);
            assertEquals(retrieveUsers[i].mail, userDB[i].mail);
            assertEquals(retrieveUsers[i].telephone, userDB[i].telephone);
            assertEquals(retrieveUsers[i].mdp, userDB[i].mdp);
            }
        }
        req.onError = function(msg:String){
          assertTrue(false);
        }
        req.request(false);
    }

    public function test05RetrieveOffers(){
        var req = new Http(wsuri + "?/offer/all");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            var retrieveOffers : Array<GETOffer> = Json.parse(data);
            var offersDB : Array<GETOffer> = cast Lambda.array(Offer.manager.all());
            assertEquals(offersDB.length, retrieveOffers.length);
            for(i in 0...offersDB.length)
            {
            assertEquals(retrieveOffers[i].idOffer, offersDB[i].idOffer);
            assertEquals(retrieveOffers[i].heure.toString(), offersDB[i].heure.toString());
            assertEquals(retrieveOffers[i].km, offersDB[i].km);
            assertEquals(retrieveOffers[i].date.toString(), offersDB[i].date.toString());
            assertEquals(retrieveOffers[i].isFrom, offersDB[i].isFrom);
            assertEquals(retrieveOffers[i].jour, offersDB[i].jour);
            assertEquals(retrieveOffers[i].type, offersDB[i].type);
            }
        }
        req.onError = function(msg:String){
          assertTrue(false);
        }
        req.request(false);
    }

    public function test06RetrieveUserByReference(){
        var user : GETUser = cast User.manager.all().first();
        var req = new Http(wsuri + "?/user/" + user.idUser);
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onError = function(msg:String){
            assertTrue(false);
        }
        req.onData = function (data : String){

          var retrievedUser : GETUser = Json.parse(data);
          assertEquals(retrievedUser.idUser, user.idUser);
          assertEquals(retrievedUser.login, user.login);
          assertEquals(retrievedUser.nom, user.nom);
          assertEquals(retrievedUser.prenom, user.prenom);
          assertEquals(retrievedUser.mail, user.mail);
          assertEquals(retrievedUser.telephone, user.telephone);
          assertEquals(retrievedUser.mdp, user.mdp);
        }
        req.request(false);
    }

    public function test07RetrieveOfferByReference(){
        var offer : GETOffer = cast Offer.manager.all().first();
        var req = new Http(wsuri + "?/offer/" + offer.idOffer);
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onError = function(msg:String){
            assertTrue(false);
        }
        req.onData = function (data : String){
          var retrievedOffer : GETOffer = Json.parse(data);
          assertEquals(retrievedOffer.idOffer, offer.idOffer);
          assertEquals(retrievedOffer.heure.toString(), offer.heure.toString());
          assertEquals(retrievedOffer.km, offer.km);
          assertEquals(retrievedOffer.date.toString(), offer.date.toString());
          assertEquals(retrievedOffer.isFrom, offer.isFrom);
          assertEquals(retrievedOffer.jour, offer.jour);
          assertEquals(retrievedOffer.type, offer.type);

        }
        req.request(false);
    }

    public function test08PostUser(){
      var postUser : POSTUser = {login:"mpatrick",nom:"Michon", prenom:"Patrick", mail:"test@gmail.fr", telephone:'0215474563', mdp:'61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4'};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function(msg:String){
        trace(msg);
        assertTrue(false);
      }
      req.onData = function(data:String){
        var idUser : String = Json.parse(data).idUser;
        var user : GETUser = cast User.manager.get(idUser);
        assertTrue(user != null);
        assertEquals(user.idUser,idUser);
        assertEquals(user.login,postUser.login);
        assertEquals(user.nom,postUser.nom);
        assertEquals(user.prenom,postUser.prenom);
        assertEquals(user.mail,postUser.mail);
        assertEquals(user.telephone,postUser.telephone);
        assertEquals(user.mdp,postUser.mdp);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test09PostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"true", jour:"jeudi", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function(msg:String){
        assertTrue(false);
      }
      req.onData = function(data:String){
        var idOffer : String = Json.parse(data).idOffer;
        var offer : GETOffer = cast Offer.manager.get(idOffer);
        assertTrue(offer != null);
        assertEquals(offer.idOffer,idOffer);
        assertEquals(offer.heure.toString(),postOffer.heure.toString());
        assertEquals(offer.km,postOffer.km);
        assertEquals(offer.isFrom,postOffer.isFrom);
        assertEquals(offer.date.toString(),postOffer.date.toString());
        assertEquals(offer.jour,postOffer.jour);
        assertEquals(offer.type,postOffer.type);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test10PutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"admin2",nom:"Chevalier",prenom:"Francois",mail:"test@mail.fr",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/" + refUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
          trace( msg );
          assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup();
        user = cast User.manager.get(refUser);
        assertEquals(newUser.login, user.login);
        assertEquals(newUser.nom, user.nom);
        assertEquals(newUser.prenom, user.prenom);
        assertEquals(newUser.mail, user.mail);
        assertEquals(newUser.telephone, user.telephone);
        assertEquals(newUser.mdp, user.mdp);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test11DeleteOffer(){
      var offer : GETOffer;
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup(); //pour vider le cache des requêtes SQL
        offer = cast Offer.manager.all().last();
        var newRefOffer = offer.idOffer;
        if(newRefOffer != "2"){
          assertTrue(true);
        } else {
          assertTrue(false);
        }
      }
      req.customRequest(false, new BytesOutput(), "DELETE");
    }

    public function test12DeleteUser(){
      var user : GETUser;
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.onStatus = function (status : Int) {
        assertEquals(200,status);
        Manager.cleanup(); //pour vider le cache des requêtes SQL
        user = cast User.manager.all().last();
        var newRefUser = user.idUser;
        if(newRefUser != "1"){
          assertTrue(true);
        } else {
          assertTrue(false);
        }
      }
      req.customRequest(false, new BytesOutput(), "DELETE");
    }

    public function test13NotFoundRetrieveUserByReference(){
        var req = new Http(wsuri + "?/user/80000000-e78a-4003-978a-d4066863a485");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            assertFalse(true);
        }
        req.onError = function(msg:String){
            assertEquals(404,extractErrorCode(msg));
        }
        req.request(false);
    }

    public function test14NotFoundRetrieveOfferByReference(){
        var req = new Http(wsuri + "?/offer/80000000-e78a-7854-978a-d4066863a485");
        req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
        req.onData = function (data : String){
            assertFalse(true);
        }
        req.onError = function(msg:String){
            assertEquals(404,extractErrorCode(msg));
        }
        req.request(false);
    }

    public function test15NotFoundPutUser(){
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/80000000-e78a-7854-978a-d4066863a496");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
        assertFalse(true);
      }
      req.onError = function(msg:String){
        assertEquals(404,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test16NotPermittedAuth(){
      var req = new Http(wsuri + "?/auth");
      req.addHeader("Cookie","login="+ login +"; mdp=449de884d8298fbd07c360720b14f5b65fdca217125a7f1eb5fc0e4b64db98e3");
      req.onData = function (data : String){
          var retrieveUser : User = Json.parse(data);
          assertEquals(retrieveUser,null);
      }
      req.onError = function (msg : String) {
        assertTrue(false);
      }
      req.request(false);
    }

    public function test17NotPermittedPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/"+ Std.string(refUser));
      req.addHeader("Cookie","login="+ login +"; mdp=449de884d8298fbd07c360720b14f5b65fdca217125a7f1eb5fc0e4b64db98e3");
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(406,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test18NotPermittedPostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : POSTOffer = {heure:DateTools.format(Date.now(),"%T"), km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"false", jour:"jeudi", type:"false", idUser:user.idUser};
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp=449de884d8298fbd07c360720b14f5b65fdca217125a7f1eb5fc0e4b64db98e3");
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(406,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test19BadheurePostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":"+5+", \"km\":\"12\", \"date\":" + DateTools.format(Date.now(),"%F") +", \"isFrom\":\"true\", \"jour\":\"jeudi\", \"type\":\"false\", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test20BadkmPostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": " + 12 + ", \"date\":" + DateTools.format(Date.now(),"F") + ", \"isFrom\":\"true\", \"jour\":\"jeudi\", \"type\":\"false\", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test21BaddatePostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": \"12\", \"date\":\"Date.now()\", \"isFrom\":\"false\", \"jour\":\"jeudi\", \"type\":" + true +", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test22BadisFromPostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": \"12\", \"date\":\"Date.now()\", \"isFrom\":" + 1 + ", \"jour\":\"jeudi\", \"type\":\"false\", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test23BadjourPostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": \"12\", \"date\":" + DateTools.format(Date.now(),"%F") + ", \"isFrom\":\"true\", \"jour\":" + 9 + ", \"type\":\"true\", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test24BadtypePostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": \"12\", \"date\":" + DateTools.format(Date.now(),"%F") + ", \"isFrom\":\"true\", \"jour\":\"jeudi\", \"type\":" + 1 + ", \"idUser\":" + user.idUser + "}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test25BadiduserPostOffer(){
      var idOffer : String = Helped.genUUID();
      var user : GETUser = cast User.manager.all().first();
      var postOffer : String = "{\"heure\":" + DateTools.format(Date.now(),"%T") + ", \"km\": \"12\", \"date\":" + DateTools.format(Date.now(),"%F") + ", \"isFrom\":\"true\", \"jour\":\"jeudi\", \"type\":\"true\", \"idUser\":\"user.idUser\"}";
      var req = new Http(wsuri + "?/offer/" + idOffer);
      req.addHeader("Cookie","login="+ login +"; mdp" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postOffer);
      req.request(true); //POST
    }

    public function test26BadloginPostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":" + Date.now() + ",\"nom\":\"Michon\", \"prenom\":\"Patrick\", \"mail\":\"test@gmail.fr\", \"telephone\":\"0215474563\", \"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test27BadnomPostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":\"fchevalier\",\"nom\":" + Date.now() + ", \"prenom\":\"Patrick\", \"mail\":\"test@gmail.fr\", \"telephone\":\"0215474563\", \"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test28BadprenomPostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":\"fchevalier\",\"nom\":\"Michon\", \"prenom\":" + 1 + ", \"mail\":\"test@gmail.fr\", \"telephone\":\"0215474563\", \"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test29BadmailPostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":\"fchevalier\",\"nom\":\"Michon\", \"prenom\":\"Patrick\", \"mail\":" + 1 + ", \"telephone\":\"0215474563\", \"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test30BadtelephonePostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":\"fchevalier\",\"nom\":\"Michon\", \"prenom\":\"Patrick\", \"mail\":\"mail@test.fr\", \"telephone\":" + 0 + ", \"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test31BadmdpPostUser(){
      var idUser : String = Helped.genUUID();
      var postUser : String = "{\"login\":\"fchevalier\",\"nom\":\"Michon\", \"prenom\":\"Patrick\", \"mail\":\"mail@test.fr\", \"telephone\":\"0225636985\", \"mdp\":" + 4 + "}";
      var req = new Http(wsuri + "?/user/" + idUser);
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(postUser);
      req.request(true); //POST
    }

    public function test32BadloginPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":" + 1 + ",\"nom\":\"Chevalier\",\"prenom\":\"Francois\",\"mail\":\"test\",\"telephone\":\"0205147568\",\"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test33BadnomPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":\"1\",\"nom\":" + 1 + ",\"prenom\":\"Francois\",\"mail\":\"test\",\"telephone\":\"0205147568\",\"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test34BadprenomPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":\"1\",\"nom\":\"Chevalier\",\"prenom\":" + 1 + ",\"mail\":\"test\",\"telephone\":\"0205147568\",\"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test35BadmailPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":\"1\",\"nom\":\"Chevalier\",\"prenom\":\"Francois\",\"mail\":" + 1 + ",\"telephone\":\"0205147568\",\"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test36BadtelephonePutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":\"1\",\"nom\":\"Chevalier\",\"prenom\":\"Francois\",\"mail\":\"mail@mail.fr\",\"telephone\":"+0+",\"mdp\":\"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4\"}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test37BadmdpPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : String = "{\"login\":\"1\",\"nom\":\"Chevalier\",\"prenom\":\"Francois\",\"mail\":\"test\",\"telephone\":\"0205147568\",\"mdp\":" + 6 + "}";
      var req = new Http(wsuri + "?/user/"+ refUser);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(newUser);
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test38ExistingloginPostUser(){
      var postUser : POSTUser = {login:"admin",nom:"Michon", prenom:"Patrick", mail:"test@gmail.fr", telephone:'0215474563', mdp:'61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4'};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test39BadMailFormatPostUser(){
      var postUser : POSTUser = {login:"mpatrick",nom:"Michon", prenom:"Patrick", mail:"test", telephone:'0215474563', mdp:'61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4'};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test40TelephoneLengthPostUser(){
      var postUser : POSTUser = {login:"mpatrick",nom:"Michon", prenom:"Patrick", mail:"test@gmail.fr", telephone:'02154745', mdp:'61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4'};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test41MdpLengthPostUser(){
      var postUser : POSTUser = {login:"mpatrick",nom:"Michon", prenom:"Patrick", mail:"test@gmail.fr", telephone:'0215474515', mdp:'61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af'};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postUser));
      req.request(true); //POST
    }

    public function test42ExistingLoginPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"admin",nom:"Chevalier",prenom:"Francois",mail:"test@mail.fr",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/1");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test43BadMailFormatPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test44TelephoneLengthPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test@mail.fr",telephone:"020514756",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0b4"};
      var req = new Http(wsuri + "?/user/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test45MpdLengthPutUser(){
      var user : GETUser = cast User.manager.all().first();
      var refUser = user.idUser;
      var newUser : PUTUser = {login:"fchevalier",nom:"Chevalier",prenom:"Francois",mail:"test@mail.fr",telephone:"0205147568",mdp:"61be55a8e2f6b4e172338bddf184d6dbee29c98853e0a0485ecee7f27b9af0"};
      var req = new Http(wsuri + "?/user/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.addHeader("Cookie","login="+ login +"; mdp="+ mdp);
      req.onStatus = function (status : Int) {
        assertEquals(400, status);
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(newUser));
      req.customRequest(false, new BytesOutput(), "PUT");
    }

    public function test46BadHeureFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12-30", km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"true", jour:"jeudi", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test47BadkmFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:-1, date:DateTools.format(Date.now(),"%F"), isFrom:"true", jour:"jeudi", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test48BadDateFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:12, date:"1256:32:22", isFrom:"true", jour:"jeudi", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test49isFormFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"az", jour:"jeudi", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test50jourFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"true", jour:"z", type:"true", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

    public function test51typeFormatPostOffer(){
      var postOffer : POSTOffer = {heure:"12:30", km:12, date:DateTools.format(Date.now(),"%F"), isFrom:"true", jour:"jeudi", type:"oi", idUser:"1"};
      var req = new Http(wsuri + "?/offer/2");
      req.addHeader("Cookie","login="+ login +"; mdp=" + mdp);
      req.onData = function (data : String){
          assertFalse(true);
      }
      req.onError = function(msg:String){
          assertEquals(400,extractErrorCode(msg));
      }
      req.setHeader("Content-Type", "application/json");
      req.setPostData(Json.stringify(postOffer));
      req.request(true); //POST
    }

}
