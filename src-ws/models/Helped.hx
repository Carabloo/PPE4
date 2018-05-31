package models;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;
import haxe.ds.StringMap;

class Helped {

  public static function genUUID() : String {
      //copied from https://github.com/ciscoheat/haxelow (based on https://gist.github.com/LeverOne/1308368)
      var uid = new StringBuf();
      var a : Int = 8;
      uid.add(StringTools.hex(Std.int(Date.now().getTime()), 8));
      while ((a++) < 36) {
          uid.add(a*51 & 52 != 0
              ? StringTools.hex(a^15 != 0 ? 8^Std.int(Math.random() * (a^20 != 0 ? 16 : 4)) : 4)
              : "-"
          );
      }
      return uid.toString().toLowerCase();
  }

  // retourne l'utilisareur si le login et le mdp correspond
  public static function auth(request : Request) : User {
    var cookies : StringMap<String> = request.cookies;
    var login = cookies.get("login");
    var mdp = cookies.get("mdp");
    var users = User.manager.all();
    var res : User = null;
    for (u in users) {
      if (u.login == login && mdp == u.mdp) {
        res = u;
      }
    }
    return res;
  }

  // retourne true si l'utilisateur est l'admin
  public static function admin(request : Request) : Bool {
    var res : Bool;
    var u : User = auth(request);
    if ( u != null && u.login == 'admin') {
        res = true;
    } else {
      res = false;
    }
    return res;
  }

  // retourne true les deux utilisateurs sont les mêmes
  public static function himself(request : Request, user : User) : Bool {
    var res : Bool = null;
    var u: User = auth(request);
    if ( u != null && u.idUser == user.idUser ) {
      res = true;
    } else {
      res = false;
    }
    return res;
  }

  // vérifie si le login existe dans la base de données
  public static function checkLogin(login : String) :  Bool {
    var res : Bool = true;
    var users : Array<User> = cast Lambda.array(User.manager.all());
    for ( u in users ) {
      if ( u.login == login) {
        res = false;
      }
    }
    return res;
  }

  public static function checkSameLogin(request : Request, login : String) :  Bool {
    var res : Bool = true;
    var cookies : StringMap<String> = request.cookies;
    var loginCookie = cookies.get("login");
    var users : Array<User> = cast Lambda.array(User.manager.all());
    for ( u in users ) {
      if ( u.login == login && login != loginCookie ) {
        res = false;
      }
    }
    return res;
  }

  public static function deleteUserOffer(idUser : String){
    var offer : Array<Offer> = cast Lambda.array(Offer.manager.all());
    var u : User = null;
    for ( o in offer ) {
      u = o.user;
      if ( u.idUser == idUser) {
        o.delete;
      }
    }
  }

}
