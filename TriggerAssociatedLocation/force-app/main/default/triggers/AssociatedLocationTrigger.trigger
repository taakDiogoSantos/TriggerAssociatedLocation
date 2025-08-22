trigger AssociatedLocationTrigger on Associated_Location__c (after insert, after delete, after update) {
    System.debug('AssociatedLocationTrigger__c Trigger Start =>' + Trigger.operationType);
   
    AssociatedLocationTriggerHandler handler = new AssociatedLocationTriggerHandler(
        Trigger.old,
        Trigger.new,
        Trigger.oldMap,
        Trigger.newMap
    );
    if(AssociatedLocationTriggerHandler.isTriggerEnabled()) {
        switch on Trigger.operationType {
            when AFTER_INSERT {
                handler.afterInsert();
            }
            when AFTER_DELETE {
                handler.AfterDelete();
            }
            when AFTER_UPDATE {
                handler.AfterUpdate();
            }  
        }
    }
}