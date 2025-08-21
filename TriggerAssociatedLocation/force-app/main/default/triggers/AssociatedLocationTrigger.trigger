trigger AssociatedLocationTrigger on Associated_Location__c (before insert) {
    
   

    if(trigger.isInsert) {
        AssociatedLocationTriggerHandler.whenInsert(Trigger.new);
    }

}