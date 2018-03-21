package api;

typedef PUTEleves = {
  public var nom : String;
  public var prenom : String;
  public var mail : String;
  public var telephone : String;
  public var mdp : String;
  @:optional var idEleve : String;
}
