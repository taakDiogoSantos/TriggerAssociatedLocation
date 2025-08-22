public with sharing class AssociatedLocationTriggerHelper {    

    
//trigger that verify if the user is already in the account team, if not it adds the user to the account team
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

//trigger that verify if the associated location is deleted, if so it removes the user from the account team
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

    //trigger that verify if the user from the AL was update, if so create new accountTeamMember
    public static void userWasUpdated(Map<Id, Associated_Location__c> oldRecordMap, Map<Id, Associated_Location__c> newRecordMap) {
        List<AccountTeamMember> AccountTeamMembersToinsert = new List<AccountTeamMember>();
        for(Associated_Location__c al : newRecordMap.values()) {
            if(al.User__c != oldRecordMap.get(al.Id).User__c) {
                AccountTeamMember newAccountTeamMember = new AccountTeamMember();
                newAccountTeamMember.AccountId = al.Account__c;
                newAccountTeamMember.userId = al.User__c;
                AccountTeamMembersToinsert.add(newAccountTeamMember);

            }
        }

        if(AccountTeamMembersToinsert.size() > 0) {
            insert AccountTeamMembersToinsert;}

            
            set<Id> accIds = new Set<Id>();
            set<Id> userIds = new Set<Id>();
        for(Associated_Location__c oldAls : oldRecordMap.values()) {
            if(newRecordMap.get(oldAls.Id)?.User__c == oldAls.account__c && newRecordMap.get(oldAls.Id)?.Account__c == oldAls.Account__c) {} 
            else {
                accIds.add(oldAls.Account__c);
                userIds.add(oldAls.User__c);}
            
        }


        if(!userIds.isEmpty()) {
            List<AccountTeamMember> accounttemMembersToDelete = [SELECT Id from AccountTeamMember where AccountId IN :accIds AND UserId IN :userIds];
            delete accounttemMembersToDelete;
        }
    }
}