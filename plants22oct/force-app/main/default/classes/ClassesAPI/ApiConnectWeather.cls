public with sharing class ApiConnectWeather implements Database.AllowsCallouts {
 
    public static IntegrationAPI getTodaysTemperature(){

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.el-tiempo.net/api/json/v2/provincias/18/municipios/18087');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);
        String body = res.getBody();
        //DESERIALIZAR
        IntegrationAPI x = (IntegrationAPI)JSON.deserialize(body, IntegrationAPI.class);
        return x;
    }

    public class IntegrationAPI{
        public Temperatures temperaturas;
    }
    public class Temperatures {
        public Integer max;
        public Integer min;
    }
}