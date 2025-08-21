public with sharing class AssociatedLocationTriggerHelper {    

    

    public static void VerifyUserAlreadyInAccount( ) {
        
        List<Associated_Location__c> MapNewRecords = Trigger.new;
        
        //get AccountId from the Records to insert
        Set<Id> SetAccountIds = new Set<Id>();
        for(Associated_Location__c iAssociatedLocation : MapNewRecords) {
            SetAccountIds.add(iAssociatedLocation.Account__c);
        }

        //Get all the AccountTeamMembers related to the AccountIds
        List<AccountTeamMember> AccountTeamMemberList = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN : SetAccountIds];
        Map<Id, AccountTeamMember> MapAccountTeamMember = new Map<Id, AccountTeamMember>();
        for(AccountTeamMember atm : AccountTeamMemberList) {
            MapAccountTeamMember.put(atm.UserId, atm);
        }

        List<AccountTeamMember> AccountTeamMembersToInsert = new List<AccountTeamMember>();

        for(Associated_Location__c iAssociatedLocation : MapNewRecords) {
            //verify if the account team member is already there
            if(MapAccountTeamMember.containsKey(iAssociatedLocation.User__c) && MapAccountTeamMember.get(iAssociatedLocation.User__c).AccountId == iAssociatedLocation.Account__c) {
                // Do nothing                
            } else { //if not create a new account Member
                AccountTeamMember atm = new AccountTeamMember();
                atm.AccountId = iAssociatedLocation.Account__c;
                atm.UserId = iAssociatedLocation.User__c;
                AccountTeamMembersToInsert.add(atm);
            }
        }
        insert accountTeamMembersToInsert;

    }

    public static void accountHaveAnotherAL(Map<Id, Associated_Location__c> oldALs) {
        
        Map<Id, Associated_Location__c> mapAL = new Map<Id, Associated_Location__c>(oldALs);
        if(mapAL.isEmpty()) {
            return;
        }
        
    }
}
