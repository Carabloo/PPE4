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
    var offerInDB : Array<GETOffer> = cast Lambda.array(Offer.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(offerInDB));
  }

  public static function retrieveOne(request : Request, idOffer : String){
    request.setHeader('Content-Type','application/json');
    var trajet : Offer;
    trajet = Offer.manager.get(idOffer);
    if(trajet == null){
      request.setReturnCode(404, 'Offer not found for ifOffer ' + idOffer);
      return;
    }
    request.send(Json.stringify(trajet));
  }

  public static function postArticle(request : Request, idOffer : String){
    var data : POSTOffer = request.data;
    var t : Offer;
    var user : User;
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
    if(data.user == null || !Std.is(data.user, User)){
      request.setReturnCode(400,'Bad Eleve');
      return;
    }
    t = new Offer(data.heure,data.km,data.date,data.jour,data.type,data.user,idOffer);
    t.insert();
    request.setHeader("Content-Type", "application/json");
    request.send("{\"idOffer\":" + t.idOffer + "}");

  }

  public static function deleteArticle(request : Request, idOffer : String){
    var t : Offer;
    t = Offer.manager.get(idOffer);
    if(t == null){
      request.setReturnCode(404,'Offer not found');
      return;
    }
    t.delete();
  }
}
