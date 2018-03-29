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

  public static function connection(request : Request){

    request.setHeader('Content-Type','application/json');
    var user : User = Helped.auth(request);
    request.send(Json.stringify(user));
  }
}
