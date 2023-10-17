trigger TriggerToUpdateCaring on Species__c (before insert, before update) {

    List<Species__c> speciesToUpdate = new List<Species__c>();

    for (Species__c species : Trigger.new) {
        if (species.Watering_Frequency__c != 'Never' && species.Watering_Frequency__c != null) {
            Integer daysToAdd = 0;
            Date controlWaterDate = species.Last_Watered__c;

            if (species.Watering_Frequency__c == 'Daily') {
                daysToAdd = 1;
            } else if (species.Watering_Frequency__c == 'Weekly') {
                daysToAdd = 7;
            } else if (species.Watering_Frequency__c == 'Mounthly') {
                daysToAdd = 30;
            }

            if (controlWaterDate.addDays(daysToAdd) < Date.today()) {
                species.Next_Watered__c = Date.today();
            }else{
                species.Next_Watered__c = species.Last_Watered__c.addDays(daysToAdd);
            }
            speciesToUpdate.add(species);
        }
    }
}
