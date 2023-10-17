public with sharing class ApiConnectGas implements Database.AllowsCallouts {

    public class MunicipioList{
        //Aquí voy a tratar la lista de provincias
        public String IDMunicipio;
        public String NameProv;
    }

    public class GasoilPriceAndLocation {
        public String Direccion;
        public String Municipio;
        public String Rotulo;
        public String Precio_Gasoleo_A;
        public String Precio_Gasolina_95;
        public String IdMunicipio;
        public String IDEESS;
    }

    @AuraEnabled(cacheable=true)
    public static List<MunicipioList> getNameMunicipio(String selectedOptionprov){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/FiltroProvincia/' + selectedOptionprov);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

            // Extraer el cuerpo de la respuesta
            String responseBodyProv = res.getBody();
            List<MunicipioList> resultsProv = processXmlToProv(responseBodyProv);
            
            return resultsProv;
    }

    public static List<GasoilPriceAndLocation> getGasPrices(String municipioCode) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/FiltroMunicipio/' + municipioCode);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            // Extraer el cuerpo de la respuesta
            String responseBody = res.getBody();
            System.debug(responseBody);

            // Procesar datos XML o deserializar si fuera JSON
            List<GasoilPriceAndLocation> results = processXml(responseBody);

            return results;
        } else {
            System.debug('No se ha podido obtener respuesta. Código de estado: ' + res.getStatusCode());
            return null;
        }
    }

    //////////////////////////
    private static List<MunicipioList> processXmlToProv(String xml) {
        List<MunicipioList> resultsProv = new List<MunicipioList>();
        Integer startIndex = 0;
    
        while(startIndex != -1) {
            MunicipioList info = new MunicipioList();
            
            info.IDMunicipio = extractValueFromXML(xml, '<IDMunicipio>', '</IDMunicipio>', startIndex);
            info.NameProv = extractValueFromXML(xml,'<Provincia>', '</Provincia>', startIndex);
            
            if(info.IDMunicipio != null) {
                resultsProv.add(info);
            }
            startIndex = xml.indexOf('<IDMunicipio>', startIndex + 1);
        }
    
        return resultsProv;
    }
    //////////////////////////

    private static List<GasoilPriceAndLocation> processXml(String xml) {
        List<GasoilPriceAndLocation> results = new List<GasoilPriceAndLocation>();
        Integer startIndex = 0;
    
        while(startIndex != -1) {
            GasoilPriceAndLocation info = new GasoilPriceAndLocation();
            
            info.Direccion = extractValueFromXML(xml, '<Dirección>', '</Dirección>', startIndex);
            info.Municipio = extractValueFromXML(xml, '<Municipio>', '</Municipio>', startIndex);
            info.Rotulo = extractValueFromXML(xml, '<Rótulo>', '</Rótulo>', startIndex);
            info.Precio_Gasolina_95 = extractValueFromXML(xml, '<Precio_x0020_Gasolina_x0020_95_x0020_E5>', '</Precio_x0020_Gasolina_x0020_95_x0020_E5>', startIndex);
            info.Precio_Gasoleo_A = extractValueFromXML(xml, '<Precio_x0020_Gasoleo_x0020_A>', '</Precio_x0020_Gasoleo_x0020_A>', startIndex);
            info.IdMunicipio = extractValueFromXML(xml, '<IDMunicipio>', '</IDMunicipio>', startIndex);
            info.IDEESS = extractValueFromXML(xml, '<IDEESS>', '</IDEESS>', startIndex);
            
            if(info.Direccion != null) {
                results.add(info);
            }
    
            // Busca el siguiente inicio basado en una etiqueta que sabes que aparecerá para cada estación. (Por ejemplo, Dirección)
            startIndex = xml.indexOf('<Dirección>', startIndex + 1);
        }
    
        return results;
    }
    //Funcion para obtener el valor del XML
    private static String extractValueFromXML(String xml, String startTag, String endTag, Integer startIndex) {
        Integer sIndex = xml.indexOf(startTag, startIndex);
        Integer eIndex = xml.indexOf(endTag, sIndex);
        if(sIndex != -1 && eIndex != -1) {
            return xml.substring(sIndex + startTag.length(), eIndex);
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static String fetchMunicipios(String provCode) {
        List<MunicipioList> municipios = getNameMunicipio(provCode);
        return JSON.serialize(municipios);
    }


    @AuraEnabled(cacheable=true)
    public static String fetchGasPrices(String municipioCode) {
        List<GasoilPriceAndLocation> prices = getGasPrices(municipioCode);
        return JSON.serialize(prices);
    }


}
