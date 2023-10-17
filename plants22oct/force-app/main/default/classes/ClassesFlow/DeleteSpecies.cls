public with sharing class DeleteSpecies {
    
    public static void DeleteSpecies(String Deleter){

        Species__c speciesToDelete = [SELECT Id FROM Species__c WHERE Name = :Deleter LIMIT 1];
            if (speciesToDelete != null) {
                delete speciesToDelete;
            }
    }
}

// SOLO APLICA SI ENCUENTA UNA CUENTA/SPECIE IGUAL.