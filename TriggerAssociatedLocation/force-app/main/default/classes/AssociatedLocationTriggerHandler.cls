public with sharing class AssociatedLocationTriggerHandler {

    public static void whenInsert(List<Associated_Location__c> newALs) {
        AssociatedLocationTriggerHelper.verifyAccount(newALs);
    }

   
}