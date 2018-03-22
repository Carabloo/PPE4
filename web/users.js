$(document).ready(function(){
    $('#btn-click').click({
      source : function(requete,reponse){
        var url = "http://www.sio-savary.fr/covoit_afg/PPECovoiture/?user/all";
          $.ajax({
            url : url,
            dataType : 'json',
            success : function(responseData){
              var array = responseData.map(function(element){
                return {value: element['nom'], id: element['idEleves']}
              });
              
            }
          });
      $('#text').append('<h3>Detail du groupe : ' + nom + '</h3><ul><li> id : ' + id + '</li></ul>');
      }
    });
})
