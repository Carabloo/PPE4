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
      var uid = new StringBuf(), a = 8;
      uid.add(StringTools.hex(Std.int(Date.now().getTime()), 8));
      while((a++) < 36) {
          uid.add(a*51 & 52 != 0
              ? StringTools.hex(a^15 != 0 ? 8^Std.int(Math.random() * (a^20 != 0 ? 16 : 4)) : 4)
              : "-"
          );
      }
      return uid.toString().toLowerCase();
  }

  public static function auth(request : Request) : User {
    var cookies : StringMap<String> = request.cookies;
    var login = cookies.get("login");
    var mdp = cookies.get("mdp");
    var users : Array<User> = cast Lambda.array(User.manager.all());
    for( u in users ) {
      if( u.login == login && mdp == u.mdp) {
        return u;
      }
    }
    return null;
  }

  public static function admin(request : Request) : Bool {
    var u : User = auth(request);
    if( u != null && u.login == 'admin') {
        return true;
    } else {
      return false;
    }
  }

  public static function himself(request : Request, user : User) : Bool {
    var u: User = auth(request);
    if( u != null && u.idUser == user.idUser ) {
      return true;
    } else {
      return false;
    }
  }

}
