public with sharing class CheckIntegrationApiJob implements Schedulable, Database.AllowsCallouts {
    
    public void execute(SchedulableContext SC){
        postNotifications();
    }
    //COMO EJECUTAR EL SCHEDULE CON CÓDIGO PROGRAMADO -->
    //(HAY QUE EJECUTARLO EN LA DEVELOPER CONSOLE Y SE CREA UN JOB QUE SE EJECUTARÁ CUANDO QUIERAS
    // EN SCHEDULE JOBS)
    /*

    String jobID = System.schedule('Nombre inventado', '0 0 9 * * ?', 
    new CheckIntegrationApiJob());
    
    */

    //TEST RÁPIDO DE CONSOLA -> CheckIntegrationApiJob.postNotifications();

    public static void postNotifications(){
        //Realizar las tareas que se tiene que planificar.
        //1- Temperatura de hoy.
        ApiConnectWeather.IntegrationAPI ap = ApiConnectWeather.getTodaysTemperature();
        Integer maxTempToday = ap.temperaturas.max;
        Integer minTempToday = ap.temperaturas.min;

        //2- Mirar que si la temperatura le viene bien a la planta.
        List<Species__c> speciesWithProblems = [
        SELECT Id, Name, Ideal_Max_Temperature__c, Ideal_Min_Temperature__c 
        FROM Species__c 
        WHERE Ideal_Max_Temperature__c <: maxTempToday 
        OR Ideal_Min_Temperature__c >: minTempToday];

        //3- Mandar notificación.
        for (Species__c x : speciesWithProblems) {
            
            // Primero de todo poner tienes que poner en esta query, el nombre de tu alerta.
            // La alerta se crea en tu ORG > Custom Notification
            CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName 
                    FROM CustomNotificationType 
                    WHERE DeveloperName='Temperature_alert'];
            
            // Aquí se crea la notificación que se ha obtenido de la query del sistema (arriba)
            Messaging.CustomNotification notification = new Messaging.CustomNotification();

            //Importante pasar todo parámetro necesario a *setNotificationMessage* para su uso
            setNotificationMessage(notification, x, maxTempToday, minTempToday);

            // CREO*** que esto es para enviar la información al usuario que corresponde.
            // Porque coge la información de la query del sistema.
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(x.Id);
            
            // ENVIAMOS LA INFO (si falla que salte el catch...)
            try {
                notification.send(new Set<String>{UserInfo.getUserId()});
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }

    private static void setNotificationMessage(
        Messaging.CustomNotification notification,
        Species__c mySpecie, 
        Integer maxTempToday, 
        Integer minTempToday){

        if (mySpecie.Ideal_Max_Temperature__c < maxTempToday) {
            notification.setTitle('Demasiado calor para la planta');
            notification.setBody('Tu planta '+mySpecie.Name+' está sufriendo calor');
        } else if (mySpecie.Ideal_Min_Temperature__c > minTempToday) {
            notification.setTitle('Demasiado frio para la planta');
            notification.setBody('Tu planta '+mySpecie.Name+' está pasando frio');
        }
    }
}