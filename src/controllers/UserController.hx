package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;

class UserController {

  public static function dispatch(request : Request, reference : String){


    if (reference == 'all' && request.method == "GET") {
        retrieveAll(request);
    }else if(request.method != "POST" && reference == null){
        request.setReturnCode(406, "Not Acceptable\nmissing reference");
    }else {
        switch (request.method) {
                //case "GET" : retrieveOne (request, reference, collection);
                //case "POST" : postArticle (request, collection);
                //case "DELETE" : deleteArticle (request, collection , reference);
                //case "PUT" : updateArticle (request, collection , reference);
                default : request.setReturnCode(501, "Not implement");
        }
    }
  }

  public static function retrieveAll(request : Request){
    var elevesInDB : Array<GETEleves> = cast Lambda.array(Eleves.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(elevesInDB));
  }
}
