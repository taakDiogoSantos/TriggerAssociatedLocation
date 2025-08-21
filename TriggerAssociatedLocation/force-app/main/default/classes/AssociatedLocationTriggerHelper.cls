public with sharing class AssociatedLocationTriggerHelper {    

    public static void verifyAccount(List<Associated_Location__c> newALs) {
        if (newALs == null || newALs.isEmpty()) {
            return;
        }
        List<AccountTeamMember> ListAccountTeamMember = [SELECT AccountId, UserId FROM AccountTeamMember];
        Map<Id, AccountTeamMember> MapAccountTeamMember = new Map<Id, AccountTeamMember>();

        
        for(AccountTeamMember iAccountMember : ListAccountTeamMember) {
            // Create a set of Account IDs that already have team members
            MapAccountTeamMember.put(iAccountMember.AccountId, iAccountMember);
        }

        for(Associated_Location__c iAssociatedLocation : newALs) {
            //verify if the account team member is already there
            if(MapAccountTeamMember.containsKey(iAssociatedLocation.Account__c)) {
                // Do nothing
            } else { //if not create a new account Member
                AccountTeamMember atm = new AccountTeamMember();
                atm.AccountId = iAssociatedLocation.Account__c;
                atm.UserId = iAssociatedLocation.User__c;
                insert atm;
            }
        }

    }
}
