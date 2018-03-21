package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;

class AuthController {

  public static function dispatch(request : Request){


    if (request.method == "GET") {
        connection(request);
    }else{
        request.setReturnCode(406, "Not Acceptable\nmissing reference");
    }
  }

  public static function connection(request : Request){
    var elevesInDB : Array<GETEleves> = cast Lambda.array(Eleves.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(elevesInDB));
  }
}
