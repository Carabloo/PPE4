package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;
import haxe.ds.StringMap;

class AuthController {

  public static function dispatch(request : Request){


    if (request.method == "GET") {
        connection(request);
    }else{
        request.setReturnCode(406, "Not Acceptable\nmissing reference");
    }
  }

  //retourne user si les cookies sont bon
  public static function connection(request : Request){
    request.setHeader('Content-Type','application/json');
    var user = Helped.auth(request);
    if (user != null) {
      var u : GETUser = {telephone : user.telephone, nom : user.nom, login : user.login, prenom : user.prenom, mail : user.mail, mdp : user.mdp, idUser : user.idUser};
      try {
        request.send(Json.stringify(u));
      } catch(e:Dynamic) {
        var fields = new Array();
        for (f in Reflect.fields(user)) {
          if (f.indexOf("_") == -1) {
            fields.push(f + " - " + Reflect.field(user, f));
          }
        }
        request.send(fields.join(",     "));
      }
    } else {
      request.send(null);
    }
  }
}
