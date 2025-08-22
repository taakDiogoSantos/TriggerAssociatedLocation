public with sharing class AssociatedLocationTriggerHandler {

    private static boolean isEnabled;
    static {
        isEnabled = true;
    }
    public static Boolean isTriggerEnabled() {
        return isEnabled;
    }

    public static Boolean disableTrigger() {
        return isEnabled = false;
    }
    public static Boolean enableTrigger() {
        return isEnabled = true;
    }

    List<Associated_Location__c> oldRecordList{get; set;}
    List<Associated_Location__c> newRecordList{get; set;}
    Map<Id, Associated_Location__c> oldRecordMap{get; set;}
    Map<Id, Associated_Location__c> newRecordMap{get; set;}

    public AssociatedLocationTriggerHandler(
        List<Associated_Location__c> oldRecordList,
        List<Associated_Location__c> newRecordList,
        Map<Id, Associated_Location__c> oldRecordMap,
        Map<Id, Associated_Location__c> newRecordMap
    ) {
        this.oldRecordList = oldRecordList;
        this.newRecordList = newRecordList;
        this.oldRecordMap = oldRecordMap;
        this.newRecordMap = newRecordMap;
    }
    

    public void AfterInsert() {
        AssociatedLocationTriggerHelper.VerifyUserAlreadyInAccount();
    }

   public void AfterDelete() {
        AssociatedLocationTriggerHelper.AssociatedLocationHaveAccountTeamMember(this.oldRecordList);
   }
}