public with sharing class AssociatedLocationTriggerHelper {    

    

    public static void verifyAccount( ) {
        //Get all the account team members
        List<Associated_Location__c> MapNewRecords = Trigger.new;
        List<AccountTeamMember> AccountTeamMemberList = [SELECT Id, AccountId, UserId FROM AccountTeamMember];
        Map<Id, AccountTeamMember> MapAccountTeamMember = new Map<Id, AccountTeamMember>();
        for(AccountTeamMember atm : AccountTeamMemberList) {
            MapAccountTeamMember.put(atm.UserId, atm);
        }

        for(Associated_Location__c iAssociatedLocation : MapNewRecords) {
            //verify if the account team member is already there
            if(MapAccountTeamMember.containsKey(iAssociatedLocation.User__c) && MapAccountTeamMember.get(iAssociatedLocation.User__c).AccountId == iAssociatedLocation.Account__c) {
                // Do nothing                
            } else { //if not create a new account Member
                AccountTeamMember atm = new AccountTeamMember();
                atm.AccountId = iAssociatedLocation.Account__c;
                atm.UserId = iAssociatedLocation.User__c;
                insert atm;
            }
        }

    }

    public static void accountHaveAnotherAL(Map<Id, Associated_Location__c> oldALs) {
        
        Map<Id, Associated_Location__c> mapAL = new Map<Id, Associated_Location__c>(oldALs);
        if(mapAL.isEmpty()) {
            return;
        }
        
    }
}
