
// initialisation de Cobalt
cobalt.init({
    debug : true
    //debugInBrowser : true
});


var token = '';
var apiKey = '';
var uid = '';
var listeTopics;


cobalt.getAppInfos(function(infos){
    uid = infos.deviceId;
});



cobalt.getToken(function(infos){
    cobalt.log("TOKEN RECU PAR LE WEB = ", infos.token);
    token = infos.token

    cobalt.sendEvent("getApiKey", {}, function(data){
        apiKey = data.apiKey;

        var donnees = {
            'application': 'FirebaseDemo',
            'token': token,
            'apiKey': apiKey,
            'uid': uid
        };


        cobalt.tokenRegister(donnees, function(data){
            cobalt.log("Enregistrement du token : ", data.message);
        });

        cobalt.getTopics(donnees, function(data){
            cobalt.log("Récupération des topics... Liste des topics = ", data);
            listeTopics = data;

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
        });

        $('div.ligne > div').on('click', function(){
            var id = $(this).attr('id');

            if ($(this).hasClass('abo')){
                cobalt.unsubscribeFromTopic(id, function(){});
                $(this).removeClass('abo');
            }
            else{
                cobalt.subscribeToTopic(id, function(){
                    donnees.topic = id;
                    cobalt.saveTopic(donnees);
                    //On sauvegarde le topic au niveau du serveur : s'il existe déjà, ne fait rien, sinon l'enregistre en BDD
                });
                $(this).addClass('abo');
            }
        });

        donnees.content = JSON.stringify({
            'title': 'Test notif API',
            'body': 'Test envoi de notif a partir de l\'API',
            'sound': 'default'
        });
        cobalt.sendNotification(donnees, function(data){
            cobalt.log("Envoi de notif... ", data);
        });
    });

});





