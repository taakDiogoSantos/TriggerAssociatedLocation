public with sharing class AssociatedLocationTriggerHelper {    

    

    public static void VerifyUserAlreadyInAccount( ) {
        
        List<Associated_Location__c> listNewRecords = Trigger.new;
        
        //get AccountId from the Records to insert
        Set<Id> SetAccountIds = new Set<Id>();
        for(Associated_Location__c iAssociatedLocation : listNewRecords) {
            SetAccountIds.add(iAssociatedLocation.Account__c);
        }

        //Get all the AccountTeamMembers related to the AccountIds
        List<AccountTeamMember> AccountTeamMemberList = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN : SetAccountIds];

        //variables to suport the insert validation
        List<AccountTeamMember> AccountTeamMembersToInsert = new List<AccountTeamMember>();
        

        for(Associated_Location__c iAssociatedLocation : listNewRecords) {
            Boolean repetido = false;
            for(AccountTeamMember atm : AccountTeamMemberList) {
                if(atm.UserId == iAssociatedLocation.User__c && atm.AccountId == iAssociatedLocation.Account__c) {
                    repetido = true;
                    break; 
                } 
            }               
            if(!repetido) {
                AccountTeamMember newAccountTeamMember = new AccountTeamMember();
                newAccountTeamMember.AccountId = iAssociatedLocation.Account__c;
                newAccountTeamMember.UserId = iAssociatedLocation.User__c;
                AccountTeamMembersToInsert.add(newAccountTeamMember);
            }
       }
        insert accountTeamMembersToInsert;
}

    public static void AssociatedLocationHaveAccountTeamMember(List<Associated_Location__c> oldRecordList) {
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(Associated_Location__c al : oldRecordList) {           
             accountIds.add(al.Account__c);
             userIds.add(al.User__c);           
        }

        List<AccountTeamMember> accountTeamMembersSameAccountSameId = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN :accountIds AND UserId IN :userIds];

        List<AccountTeamMember> accountTeamMembersToDelete = new List<AccountTeamMember>();
        for(AccountTeamMember atm : accountTeamMembersSameAccountSameId) {
            if(accountIds.contains(atm.AccountId) && userIds.contains(atm.UserId)) {
                accountTeamMembersToDelete.add(atm);
            }
        }

        delete accountTeamMembersToDelete;

        
    }
}
