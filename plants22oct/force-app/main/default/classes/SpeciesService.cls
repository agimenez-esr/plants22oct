public with sharing class SpeciesService {
    @AuraEnabled(cacheable=true)
    public static List<Species__c> getAllSpecies(){
        return [SELECT Id, Name, Description__c, Location__c, Image_URL__c, Ideal_Max_Temperature__c
        FROM Species__c];
    }
}