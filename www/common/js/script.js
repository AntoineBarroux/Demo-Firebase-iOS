
// initialisation de Cobalt
cobalt.init({
    debug : true
    //debugInBrowser : true
});


var token = '';
var apiKey = '';
var uid = '';
var listeTopics;


function getListeTopics(donnees) {
    var url = 'http://www.build.kristal.io/notifications/topics/get';
        $.ajax({
            url: url,
            type: 'POST',
            data: donnees,
            success: function (data) {
                var message = JSON.stringify(data.message);
                cobalt.log("Récupération des topics...\nLe serveur a renvoyé : " + message);

                //Si message vaut 'vide', alors pas de topics pour l'utilisateur
                listeTopics = data.topics;
                cobalt.log("ListeTopics = \n" + JSON.stringify(listeTopics));

                for (var i = 0; i < listeTopics.length; i++) {
                    switch (listeTopics[i]) {
                        case 'cirque':
                            if (!($('#cirque').hasClass('abo'))) {
                                $('#cirque').addClass('abo');
                            }
                            break;
                        case 'theatre':
                            if (!($('#theatre').hasClass('abo'))) {
                                $('#theatre').addClass('abo');
                            }
                            break;
                        case 'concert':
                            if (!($('#concert').hasClass('abo'))) {
                                $('#concert').addClass('abo');
                            }
                            break;
                        case 'danse':
                            if (!($('#danse').hasClass('abo'))) {
                                $('#danse').addClass('abo');
                            }
                            break;
                        case 'conference':
                            if (!($('#conference').hasClass('abo'))) {
                                $('#conference').addClass('abo');
                            }
                            break;
                        default:
                            break;
                    }
                }
            },
            error: function (xhr, errorType, error) {
                cobalt.log("Erreur dans récupération des topics ! \nErrorType = " + errorType + "\nErreur = " + error);
            }
        });
}


function saveTopic(donnees){
    var url = 'http://www.build.kristal.io/notifications/topics/save'; //URL a modifier selon l'appli, ici FirebaseDemo
    $.ajax({
        url: url,
        type: "POST",
        data: donnees,
        success: function(data){
            cobalt.log('Enregistrement du topic...\nLe serveur a renvoyé : ' + JSON.stringify(data.message));
        },
        error: function(xhr, errorType, error){
            cobalt.log("Erreur dans l'enregistrement du token\nErreurType=" + errorType + "\nErreur=" + error);
        }
    });
}



cobalt.sendEvent('getToken', {}, function(data){

    // Récupération du token côté natif et envoi de la requête HTTP

    token = data['token'];
    apiKey = data['apiKey'];


    cobalt.getAppInfos(function(infos){
        alert("appinfos");
        cobalt.log('uid :', infos.deviceID)
    });


    //Enregistrement du token auprès du serveur
    var url = 'http://www.build.kristal.io/notifications/register'; //URL a modifier selon l'appli, ici FirebaseDemo
    donnees = {
        'token': token,
        'application': 'FirebaseDemo',
        'apiKey': apiKey
    };
    $.ajax({
        url: url,
        type: "POST",
        data: donnees,
        success: function(data){
            cobalt.log('Enregistrement du token...\nLe serveur a renvoyé : ' + JSON.stringify(data.message));
        },
        error: function(xhr, errorType, error){
            cobalt.log("Erreur dans l'enregistrement du token\nErreurType=" + errorType + "\nErreur=" + error);
        }
    });


    //Récupération des topics auxquels on est abonné
    getListeTopics(donnees);


    //Gestion de l'abonnement aux différents topics
    $('div.ligne > div').on('click', function(){
        var id = $(this).attr('id');

        if ($(this).hasClass('abo')){
            cobalt.sendEvent('desabonnement', {'name': id});
            $(this).removeClass('abo');
        }
        else{
            cobalt.sendEvent('abonnement', {'name': id});
            donnees = {
                'topic': id,
                'apiKey': apiKey,
                'application': 'FirebaseDemo'
            };
            saveTopic(donnees);
            //On sauvegarde le topic au niveau du serveur : s'il existe déjà, ne fait rien, sinon l'enregistre en BDD
            $(this).addClass('abo');
        }
    });

});









