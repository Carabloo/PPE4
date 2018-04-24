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



    if ( Helped.auth(request) != null ) {
      if (reference == "all" && request.method == "GET") {
          retrieveAll(request);
      }else if (request.method != "POST" && reference == null){
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
    var lengthUser : Int = userInDB.length;
    lengthUser = lengthUser - 1;
    for ( i in 0...lengthUser ) {
      res += "{\"idUser\":\"" + userInDB[i].idUser + "\",";
      res += "\"login\":\"" + userInDB[i].login + "\",";
      res += "\"nom\":\"" + userInDB[i].nom + "\",";
      res += "\"prenom\":\"" + userInDB[i].prenom + "\",";
      res += "\"mail\":\"" + userInDB[i].mail + "\",";
      res += "\"telephone\":\"" + userInDB[i].telephone + "\", ";
      res += "\"mdp\":\"" + userInDB[i].mdp + "\"},";
    }
    res += "{\"idUser\":\"" + userInDB[lengthUser].idUser + "\", ";
    res += "\"login\":\"" + userInDB[lengthUser].login + "\", ";
    res += "\"nom\":\"" + userInDB[lengthUser].nom + "\", ";
    res += "\"prenom\":\"" + userInDB[lengthUser].prenom + "\", ";
    res += "\"mail\":\"" + userInDB[lengthUser].mail + "\", ";
    res += "\"telephone\":\"" + userInDB[lengthUser].telephone + "\", ";
    res += "\"mdp\":\"" + userInDB[lengthUser].mdp + "\"}]";
    request.send(res);
  }

  public static function retrieveOne(request : Request, idUser : String){
    request.setHeader('Content-Type','application/json');
    var user : User;
    user = User.manager.get(idUser);
    if (user == null){
      request.setReturnCode(404, 'User not found for idUser ' + idUser);
      return;
    }
    request.send(Json.stringify(user));
  }

  public static function postUser(request : Request, idUser : String){
    if ( Helped.admin(request) ) {
      var data : POSTUser = null;
      var u : User;
      try {
        data = request.data;
      } catch (e : Dynamic) {
        request.setReturnCode(400,'POSTUser type error');
      }
      if (data.login == null || !Helped.checkLogin(data.login)){
        request.setReturnCode(400,'Bad login');
        return;
      };
      if (data.nom == null){
        request.setReturnCode(400,'Bad nom');
        return;
      };
      if (data.prenom == null) {
        request.setReturnCode(400,'Bad prenom');
        return;
      }
      if (data.mail == null || ! ~/^[\w-\.]{2,}@[ÅÄÖåäö\w-\.]{2,}\.[a-z]{2,6}$/.match(data.mail)){
        request.setReturnCode(400,'Bad mail');
        return;
      }
      if (data.telephone == null || ! ~/^[0-9]{10}$/.match(data.telephone)){
        request.setReturnCode(400,'Bad telephone');
        return;
      }
      if (data.mdp == null || data.mdp.length!=64){
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
    var data : PUTUser = null;
    try {
      data = request.data;
    } catch (e : Dynamic) {
      request.setReturnCode(400,'PUTUser type error');
    }
    u = User.manager.get(idUser);
    if ( Helped.admin(request) || Helped.himself(request, u) ) {
      if (u == null){
        request.setReturnCode(404,'Eleve not found');
        return;
      }
      if (data.login == null || !Helped.checkSameLogin(request, data.login)){
        request.setReturnCode(400,'Bad login');
        return;
      };
      u.login = data.login;
      if (data.nom == null){
        request.setReturnCode(400,'Bad nom');
        return;
      };
      u.nom = data.nom;
      if (data.prenom == null) {
        request.setReturnCode(400,'Bad prenom');
        return;
      }
      u.prenom = data.prenom;
      if (data.mail == null || ! ~/^[\w-\.]{2,}@[ÅÄÖåäö\w-\.]{2,}\.[a-z]{2,6}$/.match(data.mail)){
        request.setReturnCode(400,'Bad mail');
        return;
      }
      u.mail = data.mail;
      if (data.telephone == null || ! ~/^[0-9]{10}$/.match(data.telephone)){
        request.setReturnCode(400,'Bad telephone');
        return;
      }
      u.telephone = data.telephone;
      if (data.mdp == null || data.mdp.length!=64){
        request.setReturnCode(400,'Bad mdp');
        return;
      }
      u.mdp = data.mdp;
      u.update();
    } else {
      request.setReturnCode(406, "No Permition");
    }

  }

  public static function deleteUser(request : Request, idUser : String){
    if ( Helped.admin(request) ) {
      var u : User;
      u = User.manager.get(idUser);
      if (u == null){
        request.setReturnCode(404,'Eleve not found');
        return;
      }
      Helped.deleteUserOffer(idUser);
      u.delete();
    } else {
      request.setReturnCode(406, "No Permition");
    }

  }
}
