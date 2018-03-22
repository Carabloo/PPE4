package controllers;

import controller.Listener;
import controller.Request;
import sys.db.Manager;
import models.*;
import haxe.Json;
import api.*;

class OfferController {

  public static function dispatch(request : Request, reference : String){


    if( Helped.auth(request) != null ) {
      if (reference == "all" && request.method == "GET") {
          retrieveAllOffer(request);
      }else if(request.method != "POST" && reference == null){
          request.setReturnCode(406, "Not Acceptable\nmissing reference");
      }else {
          switch (request.method) {
                  case "GET" : retrieveOneOffer (request, reference);
                  case "POST" : postOffer (request, reference);
                  case "DELETE" : deleteOffer (request, reference);
                  default : request.setReturnCode(501, "Not implement");
          }
      }
    } else {
      request.setReturnCode(406, "Authentification fail");
    }

  }

  public static function retrieveAllOffer(request : Request){
    var offerInDB : Array<GETOffer> = cast Lambda.array(Offer.manager.all());
    request.setHeader('Content-Type','application/json');
    request.send(Json.stringify(offerInDB));
  }

  public static function retrieveOneOffer(request : Request, idOffer : String){
    request.setHeader('Content-Type','application/json');
    var trajet : Offer;
    trajet = Offer.manager.get(idOffer);
    if(trajet == null){
      request.setReturnCode(404, 'Offer not found for ifOffer ' + idOffer);
      return;
    }
    request.send(Json.stringify(trajet));
  }

  public static function postOffer(request : Request, idOffer : String){
    var data : POSTOffer = request.data;
    if(data.user == null || !Std.is(data.user, User)){
      request.setReturnCode(400,'Bad User');
      return;
    }
    if( Helped.admin(request) || Helped.himself(request,data.user) ) {
      var data : POSTOffer = request.data;
      var o : Offer;
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
      o = new Offer(data.heure,data.km,data.date,data.jour,data.type,data.user,idOffer);
      o.insert();
      request.setHeader("Content-Type", "application/json");
      request.send("{\"idOffer\":\"" + o.idOffer + "\"}");
    } else {
      request.setReturnCode(406, "No Permition");
    }
  }

  public static function deleteOffer(request : Request, idOffer : String){
    var o : Offer;
    o = Offer.manager.get(idOffer);
    if( Helped.admin(request) || Helped.himself(request,o.user) ) {
      if(o == null){
        request.setReturnCode(404,'Offer not found');
        return;
      }
      o.delete();
    } else {
      request.setReturnCode(406, "No Permition");
    }
  }
}
