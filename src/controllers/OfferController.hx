package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;

class OfferController {

  public static function dispatch(request : Request, reference : String){


    if (reference == "all" && request.method == "GET") {
        retrieveAll(request);
    }else if(request.method != "POST" && reference == null){
        request.setReturnCode(406, "Not Acceptable\nmissing reference");
    }else {
        switch (request.method) {
                case "GET" : retrieveOne (request, reference);
                case "POST" : postArticle (request, reference);
                case "DELETE" : deleteArticle (request, reference);
                default : request.setReturnCode(501, "Not implement");
        }
    }
  }

  public static function retrieveAll(request : Request){
    var trajetsInDB : Array<GETTrajets> = cast Lambda.array(Trajets.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(trajetsInDB));
  }

  public static function retrieveOne(request : Request, idTrajet : String){
    request.setHeader('Content-Type','application/json');
    var trajet : Trajets;
    trajet = Trajets.manager.get(idTrajet);
    if(trajet == null){
      request.setReturnCode(404, 'Trajet not found for reference ' + idTrajet);
      return;
    }
    request.send(Json.stringify(trajet));
  }

  public static function postArticle(request : Request, idTrajet : String){
    var data : POSTTrajets = request.data;
    var t : Trajets;
    var user : Eleves;
    if(data.heure == null || !Std.is(data.heure, String)){
      request.setReturnCode(400,'Bad heure');
      return;
    };
    if(data.km == null || !Std.is(data.km, Float) || data.km<0) {
      request.setReturnCode(400,'Bad km');
      return;
    }
    if(data.date == null || !Std.is(data.date, Date)){
      request.setReturnCode(400,'Bad Date');
      return;
    }
    if(data.jour == null || !Std.is(data.jour, String)){
      request.setReturnCode(400,'Bad jour');
      return;
    }
    if(data.type == null || !Std.is(data.type, Bool)){
      request.setReturnCode(400,'Bad Date');
      return;
    }
    if(data.idEleve == null || !Std.is(data.idEleve, String)){
      request.setReturnCode(400,'Bad Eleve');
      return;
    }
    user = data.idEleve;
    t = new Trajets(data.heure,data.km,data.date,data.jour,data.type,user,idTrajet);
    t.insert();
    request.setHeader("Content-Type", "application/json");
    request.send("{\"idTrajet\":" + t.idTrajet + "}");

  }

  public static function deleteArticle(request : Request, idTrajet : String){
    var t : Trajets;
    t = Trajets.manager.get(idTrajet);
    if(t == null){
      request.setReturnCode(404,'Trajet not found');
      return;
    }
    t.delete();
  }
}
