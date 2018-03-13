package api;
import models.*;

typedef PUTTrajets = {
  @:optional var heure : String;
  @:optional var km : Float;
  @:optional var date : Date;
  @:optional var jour : String;
  @:optional var type : Bool;
  @:optional var idEleve : Eleves;
}
