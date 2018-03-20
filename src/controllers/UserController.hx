package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;

class UserController {

  public static function dispatch(request : Request, reference : String){


    if (reference == "all" && request.method == "GET") {
        retrieveAll(request);
    }else if(request.method != "POST" && reference == null){
        request.setReturnCode(406, "Not Acceptable\nmissing reference");
    }else {
        switch (request.method) {
                case "GET" : retrieveOne (request, reference);
                case "POST" : postUser (request, reference);
                case "DELETE" : deleteUser (request, reference);
                case "PUT" : updateUser (request, reference);
                default : request.setReturnCode(501, "Not implement");
        }
    }
  }

  public static function retrieveAll(request : Request){
    var elevesInDB : Array<GETEleves> = cast Lambda.array(Eleves.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(elevesInDB));
  }

  public static function retrieveOne(request : Request, idEleve : String){
    request.setHeader('Content-Type','application/json');
    var user : Eleves;
    user = Eleves.manager.get(idEleve);
    if(user == null){
      request.setReturnCode(404, 'Eleve not found for reference ' + idEleve);
      return;
    }
    request.send(Json.stringify(user));
  }

  public static function postUser(request : Request, idEleve : String){
    var data : POSTEleves = request.data;
    var u : Eleves;
    if(data.nom == null || !Std.is(data.nom, String)){
      request.setReturnCode(400,'Bad nom');
      return;
    };
    if(data.prenom == null || !Std.is(data.prenom, String)) {
      request.setReturnCode(400,'Bad nom');
      return;
    }
    if(data.mail == null || !Std.is(data.mail, String)){
      request.setReturnCode(400,'Bad mail');
      return;
    }
    if(data.telephone == null || !Std.is(data.telephone, String)){
      request.setReturnCode(400,'Bad telephone');
      return;
    }
    if(data.mdp == null || !Std.is(data.mdp, String)){
      request.setReturnCode(400,'Bad mdp');
      return;
    }
    u = new Eleves(data.nom,data.prenom,data.mail,data.telephone,data.mdp);
    u.insert();
    request.setHeader("Content-Type", "application/json");
    request.send("{\"idEleves\":\"" + u.idEleves + "\"}");

  }

  public static function updateUser(request : Request, idEleve : String){
    var data : PUTEleves = request.data;
    var u : Eleves;
    u = Eleves.manager.get(idEleve);
    if(u == null){
      request.setReturnCode(404,'Eleve not found');
      return;
    }
    if(data.nom == null || !Std.is(data.nom, String)){
      request.setReturnCode(400,'Bad nom');
      return;
    };
    u.nom=data.nom;
    if(data.prenom == null || !Std.is(data.prenom, String)) {
      request.setReturnCode(400,'Bad prenom');
      return;
    }
    u.prenom=data.prenom;
    if(data.mail == null || !Std.is(data.mail, String)){
      request.setReturnCode(400,'Bad mail');
      return;
    }
    u.mail=data.mail;
    if(data.telephone == null || !Std.is(data.telephone, String)){
      request.setReturnCode(400,'Bad telephone');
      return;
    }
    u.telephone=data.telephone;
    if(data.mdp == null || !Std.is(data.mdp, String)){
      request.setReturnCode(400,'Bad mdp');
      return;
    }
    u.mdp=data.mdp;
    u.update();

  }

  public static function deleteUser(request : Request, idEleve : String){
    var u : Eleves;
    u = Eleves.manager.get(idEleve);
    if(u == null){
      request.setReturnCode(404,'Eleve not found');
      return;
    }
    u.delete();
  }
}
