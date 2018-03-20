$(document).ready(function(){
    $('#btn-user').onClick({
      source : function(requete,reponse){
        var url = "http://www.sio-savary.fr/covoit_afg/PPECovoiture/?user";
          $.ajax({
            url : url,
            dataType : 'json',
            success : function(responseData){
              var array = responseData.map(function(element){
                return {value: element['nom'], id: element['idEleves']}
              });
              $('#text').append(
              '<h3>Detail du groupe : ' + nom + '</h3><ul><li> id : ' + id + '</li></ul>'
				);
            }
          });
      },
      classes : {
        "ui-autocomplete" : "highlight"
      },
      select : function(event, ui){
        var url = "http://www.sio-savary.fr/fchevalier/festivalSilex/web/index.php/api/infosGroupe/" + ui.item.id;
        $.ajax({
          url : url,
          dataType : 'json',
          success : function(responseData){
            $('#infosGroupe').children().remove();
            var id = responseData[0]['id'];
            var nom = responseData[0]['nom'];
            var nomPays = responseData[0]['nomPays'];
            var nombrePersonnes = responseData[0]['nombrePersonnes'];
            $('#infosGroupe').append(
              '<h3>Detail du groupe : ' + nom + '</h3><ul><li> id : ' + id + '</li><li> nom du Pays : ' + nomPays + '</li><li> nombre de personne dans le groupe : ' + nombrePersonnes + '</li></ul>'
            );
          },
        });
      },
    });
})
