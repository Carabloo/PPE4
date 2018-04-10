package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;
import haxe.crypto.Sha256;

class UserController {

  public static function dispatch(request : Request, reference : String){



    if( Helped.auth(request) != null ) {
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
    } else {
      request.setReturnCode(406, "Authentification Fail");
    }

  }

  public static function retrieveAll(request : Request){
    var userInDB : Array<GETUser> = cast Lambda.array(User.manager.all());
    request.setHeader('Content-Type','application/json');
    var res : String = "[";
    var i : Int = 0;
    for( i in 0...userInDB.length-1 ) {
      res += "{\"idUser\":\"" + userInDB[i].idUser + "\",";
      res += "\"login\":\"" + userInDB[i].login + "\",";
      res += "\"nom\":\"" + userInDB[i].nom + "\",";
      res += "\"prenom\":\"" + userInDB[i].prenom + "\",";
      res += "\"mail\":\"" + userInDB[i].mail + "\",";
      res += "\"telephone\":\"" + userInDB[i].telephone + "\", ";
      res += "\"mdp\":\"" + userInDB[i].mdp + "\"},";
    }
    res += "{\"idUser\":\"" + userInDB[userInDB.length-1].idUser + "\", ";
    res += "\"login\":\"" + userInDB[userInDB.length-1].login + "\", ";
    res += "\"nom\":\"" + userInDB[userInDB.length-1].nom + "\", ";
    res += "\"prenom\":\"" + userInDB[userInDB.length-1].prenom + "\", ";
    res += "\"mail\":\"" + userInDB[userInDB.length-1].mail + "\", ";
    res += "\"telephone\":\"" + userInDB[userInDB.length-1].telephone + "\", ";
    res += "\"mdp\":\"" + userInDB[userInDB.length-1].mdp + "\"}]";
    request.send(res);
  }

  public static function retrieveOne(request : Request, idUser : String){
    request.setHeader('Content-Type','application/json');
    var user : User;
    user = User.manager.get(idUser);
    if(user == null){
      request.setReturnCode(404, 'User not found for idUser ' + idUser);
      return;
    }
    request.send(Json.stringify(user));
  }

  public static function postUser(request : Request, idUser : String){
    if( Helped.admin(request) ) {
      var data : POSTUser = request.data;
      var u : User;
      if(data.login == null || !Std.is(data.login, String)){
        request.setReturnCode(400,'Bad login');
        return;
      };
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
      u = new User(data.login,data.nom,data.prenom,data.mail,data.telephone,data.mdp,idUser);
      u.insert();
      request.setHeader("Content-Type", "application/json");
      request.send("{\"idUser\":\"" + u.idUser + "\"}");
    } else {
      request.setReturnCode(406, "No Permition");
    }


  }

  public static function updateUser(request : Request, idUser : String){
    var u : User;
    var data : PUTUser = request.data;
    u = User.manager.get(idUser);
    if( Helped.admin(request) || Helped.himself(request, u) ) {
      if(u == null){
        request.setReturnCode(404,'Eleve not found');
        return;
      }
      if(data.login == null || !Std.is(data.login, String)){
        request.setReturnCode(400,'Bad login');
        return;
      };
      u.login=data.login;
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
      u.mdp = Sha256.encode(data.mdp);
      u.update();
    } else {
      request.setReturnCode(406, "No Permition");
    }


  }

  public static function deleteUser(request : Request, idUser : String){
    if( Helped.admin(request) ) {
      var u : User;
      u = User.manager.get(idUser);
      if(u == null){
        request.setReturnCode(404,'Eleve not found');
        return;
      }
      u.delete();
    } else {
      request.setReturnCode(406, "No Permition");
    }

  }
}
