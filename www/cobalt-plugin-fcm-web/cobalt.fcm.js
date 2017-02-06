(function(cobalt){
    var plugin = {
        'name': 'Fcm',
        init: function (settings) {
            // Create shortcuts
            cobalt.getToken = this.getToken.bind(this);
            cobalt.subscribeToTopic = this.subscribeToTopic.bind(this);
            cobalt.unsubscribeFromTopic = this.unsubscribeFromTopic.bind(this);
            cobalt.tokenRegister = this.tokenRegister.bind(this);
            cobalt.getTopics = this.getTopics.bind(this);
            cobalt.saveTopic = this.saveTopic.bind(this);
            cobalt.sendNotification = this.sendNotification.bind(this);

            if (settings) {
                this.config(settings);
            }
        },

        config: function(settings){},

        //Méthode générale pour envoyer les calls ajax
        ajax:function(params, callback){
            var url = 'http://www.build.kristal.io/' + params.url;
            var request = new XMLHttpRequest();
            request.open("POST", url, true);
            request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')

            request.onreadystatechange = function () {
                if (request.readyState != 4 || request.status != 200){
                    
                }
                else{
                    if (typeof callback == 'function'){
                        callback(JSON.parse(request.responseText));
                    }
                    else{
                        retour = request.responseText;
                        cobalt.log('Call à ' + params.url + ' réussi : ', retour);
                    }
                }
            };
            paramsAEnvoyer = this.objectToString(params);
            console.log('Envoi de cette chaine de paramètres : ' + paramsAEnvoyer);
            request.send(paramsAEnvoyer);
        },

        //Récupère un objet de données à envoyer, et le transforme en chaine sous la forme champ=valeur&champ2=valeur2
        objectToString:function(params){
            var str = "";
            for (var key in params) {
                if (str != "") {
                    str += "&";
                }
                str += key + "=" + encodeURIComponent(params[key]);
            }
            return str;
        },


        getToken: function(callback){
            cobalt.log("Sending event getToken to the native side")
            this.send("getToken", {}, function(data){
                if (typeof callback =="function"){
                    callback(data);
                }
                else{
                    cobalt.log('Received infos = ', data, typeof callback);
                }
            });
        },

        subscribeToTopic: function(topic, callback){
            cobalt.log("Sending event subscribeToTopic to the native side")
            var donnees = {'topic': topic};
            this.send("subscribeToTopic", donnees, function(data){
                if (typeof callback == 'function'){
                    callback(data);
                }
                else{
                    cobalt.log('Received infos = ', data, typeof callback);
                }
            });
        },

        unsubscribeFromTopic: function(topic, callback){
            var donnees = {'topic': topic};
            this.send("unsubscribeFromTopic", donnees, function(data){
                if (typeof callback == 'function'){
                    callback(data);
                }
                else{
                    cobalt.log('Received infos = ', data, typeof callback);
                }
            });
        },

        tokenRegister: function(data, callback){
            data.url = 'notifications/register';
            this.ajax(data, function(retour){
                if (typeof callback == 'function'){
                    callback(retour);
                }
                else{
                    cobalt.log('Call tokenRegister réussi, réponse serveur : ', retour);
                }
            });
        },

        getTopics:function(data, callback){
            data.url = 'notifications/topics/get';
            this.ajax(data, function(retour){

                if (typeof callback == 'function'){
                    callback(retour.topics);
                }
                else{
                    cobalt.log('Call getTopics réussi, réponse serveur : ', retour);
                }
            });
        },

        saveTopic:function(data, callback) {
            data.url = 'notifications/topics/save';
            this.ajax(data, function(retour){

                if (typeof callback == 'function'){
                    callback(retour);
                }
                else{
                    cobalt.log('Call saveTopic réussi, réponse serveur : ', retour);
                }
            });
        },

        sendNotification:function(data, callback){
            data.url = 'notifications/push';
            this.ajax(data, function(retour){

                if (typeof callback == 'function'){
                    callback(retour);
                }
                else{
                    cobalt.log('Call saveTopic réussi, réponse serveur : ', retour);
                }
            });
        },

        handleEvent:function(json){
            cobalt.log(this.name, ' plugin : unknown event received :', json)
        },

        send:function(action, data, callback){
            cobalt.send({ type : "plugin", name : this.name, action : action, data : data }, callback);
        }
    };
    cobalt.plugins.register(plugin);
})(cobalt || {});
