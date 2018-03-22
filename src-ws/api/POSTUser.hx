package api;

typedef POSTUser = {
  public var login : String;
  public var nom : String;
  public var prenom : String;
  public var mail : String;
  public var telephone : String;
  public var mdp : String;
  @:optional var idEleve : String;
}
