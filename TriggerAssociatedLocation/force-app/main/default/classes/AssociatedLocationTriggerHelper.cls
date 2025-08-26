public with sharing class AssociatedLocationTriggerHelper {    

    
    //method that verify if the user is already in the account team, if not it adds the user to the account team
    public static void VerifyUserAlreadyInAccount(List<Associated_Location__c> listNewRecords) {
        
        //get AccountId from the Records to insert
        Set<Id> setAccountIds = new Set<Id>();
        
        
        for(Associated_Location__c iAssociatedLocation : listNewRecords) {
            setAccountIds.add(iAssociatedLocation.Account__c);
        }

        //Get all the AccountTeamMembers related to the AccountIds
        List<AccountTeamMember> accountTeamMemberList = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN : setAccountIds];
        map<String, AccountTeamMember> mapAccountTeamMember = new Map<String, AccountTeamMember>();
        for(AccountTeamMember iAtm : accountTeamMemberList) {
            //defining the key of the map with the combination of a AccountId and UserId creating a unique code
            string chaveMapa = String.valueOf(iAtm.AccountId) + String.valueOf(iAtm.userId);
            mapAccountTeamMember.put(chaveMapa, iAtm);
        }

        //variables to suport the insert validation
        List<AccountTeamMember> accountTeamMembersToInsert = new List<AccountTeamMember>();
        Boolean repeated;

        //loop verify if the Associated Location already has a Account Team Member
        for(Associated_Location__c iAssociatedLocation : listNewRecords) {
            repeated = false;
            string userToAccountId = String.valueOf(iAssociatedLocation.Account__c) + String.valueOf(iAssociatedLocation.User__c);
            if(mapAccountTeamMember.containsKey(userToAccountId)) {
                repeated = true;
                break;
            }
            
            if(!repeated) {//creating a new Account Team Member for the new Associated Location
                AccountTeamMember newAccountTeamMember = new AccountTeamMember();
                newAccountTeamMember.AccountId = iAssociatedLocation.Account__c;
                newAccountTeamMember.UserId = iAssociatedLocation.User__c;
                accountTeamMembersToInsert.add(newAccountTeamMember);
            }
        }

        
        

        if(!accountTeamMembersToInsert.isEmpty()) {
            //generate a list with the log results for every account team member inserted no the database
            List<Database.SaveResult> results = Database.insert(accountTeamMembersToInsert ,  false);

            //returns all the cases qhere the Account Team Member couldnt be inserted and why
            for(Database.SaveResult iResult : results) {
                if(!iResult.isSuccess()) {
                    System.debug('failed to insert: '+ iResult.getErrors());
                    System.debug('Object Id:  '+ iResult.getId());
                }
            }
        }
    }


    //method that verify if the associated location is deleted, if so it removes the user from the account team
    public static void associatedLocationHaveAccountTeamMember(List<Associated_Location__c> oldRecordList) {
        //gets all the userId and Account ids that needs to be deleted
        Set<Id> accountIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(Associated_Location__c al : oldRecordList) {           
             accountIds.add(al.Account__c);
             userIds.add(al.User__c);
        }

        List<AccountTeamMember> accountTeamMembersSameAccountSameId = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN :accountIds AND UserId IN :userIds];

        List<AccountTeamMember> accountTeamMembersToDelete = new List<AccountTeamMember>();
        //loop in the accounts Team Members and delete if they have the same AccountId and UserId related to the Associated Locations that were deleted
        for(AccountTeamMember atm : accountTeamMembersSameAccountSameId) {
            if(accountIds.contains(atm.AccountId) && userIds.contains(atm.UserId)) {
                accountTeamMembersToDelete.add(atm);
            }
        }
        if(!accountTeamMembersToDelete.isEmpty()){
        //generate a list with the log results for every account team member inserted no the database
            List<Database.DeleteResult> deleteResults = Database.delete(accountTeamMembersToDelete ,  false);

            //returns all the cases qhere the Account Team Member couldnt be inserted and why
            for(Database.DeleteResult iResult : deleteResults) {
                if(!iResult.isSuccess()) {
                    System.debug('failed to delete: '+ iResult.getErrors());
                    System.debug('Object Id:  '+ iResult.getId());
                }
            }
        }
    }

    //method that executes when user updates
    public static void userWasUpdated(Map<Id, Associated_Location__c> oldRecordMap, Map<Id, Associated_Location__c> newRecordMap) {
        //create a new Account Team Member for every alteration that was made
        List<AccountTeamMember> accountTeamMembersToinsert = new List<AccountTeamMember>();
        for(Associated_Location__c al : newRecordMap.values()) {
            if(al.User__c != oldRecordMap.get(al.Id).User__c) {
                AccountTeamMember newAccountTeamMember = new AccountTeamMember();
                newAccountTeamMember.AccountId = al.Account__c;
                newAccountTeamMember.userId = al.User__c;
                accountTeamMembersToinsert.add(newAccountTeamMember);
            }
        }

        if(accountTeamMembersToinsert.size() > 0){
            List<Database.SaveResult> results = Database.insert(AccountTeamMembersToinsert ,  false);

            //returns all the cases qhere the Account Team Member couldnt be inserted and why
            for(Database.SaveResult iResult : results) {
                if(!iResult.isSuccess()) {
                    System.debug('failed to insert: '+ iResult.getErrors());
                    System.debug('Object Id:  '+ iResult.getId());
                }
            }
        } else return;

        //looping through the Associated Locations before the update gathering the old Accounts And Users
        set<Id> accIds = new Set<Id>();
        set<Id> userIds = new Set<Id>();
        for(Associated_Location__c oldAls : oldRecordMap.values()) {
            if(newRecordMap.get(oldAls.Id)?.User__c == oldAls.User__c && newRecordMap.get(oldAls.Id)?.Account__c == oldAls.Account__c) {} 
            else {
                accIds.add(oldAls.Account__c);
                userIds.add(oldAls.User__c);}
            
        }

        //deleting the Account Team Members that references the old Associated Locations
        if(!userIds.isEmpty()) {
            List<AccountTeamMember> accountTeamMembersToDelete = [SELECT Id from AccountTeamMember where AccountId IN :accIds AND UserId IN :userIds];

            List<Database.DeleteResult> deleteResults = Database.delete(accountTeamMembersToDelete ,  false);
            
            for(Database.deleteResult iResults : deleteResults) {
                if(!iResults.isSuccess()) {
                    System.debug('failed to delete: '+ iResults.getErrors());
                    System.debug('object Id: ' + iResults.getId());
                }
            }
        }
    }

    //method that executes when account updates
    public static void accountWasUpdated(Map<Id, Associated_Location__c> oldRecordMap, Map<Id, Associated_Location__c> newRecordMap) {
        //Same code as before but the condition on the if before insert is now checking the same account instead of user
        //need fix later, to reduce code
        List<AccountTeamMember> AccountTeamMembersToinsert = new List<AccountTeamMember>();
        for(Associated_Location__c al : newRecordMap.values()) {
            if(al.Account__c != oldRecordMap.get(al.Id).Account__c) {//if theres a change on the accounts create nem ATMs for the user on the account
                AccountTeamMember newAccountTeamMember = new AccountTeamMember();
                newAccountTeamMember.AccountId = al.Account__c;
                newAccountTeamMember.userId = al.User__c;
                AccountTeamMembersToinsert.add(newAccountTeamMember);
            }
        }

        if(accountTeamMembersToinsert.size() > 0){
            List<Database.SaveResult> results = Database.insert(AccountTeamMembersToinsert ,  false);

            //returns all the cases qhere the Account Team Member couldnt be inserted and why
            for(Database.SaveResult iResult : results) {
                if(!iResult.isSuccess()) {
                    System.debug('failed to insert: '+ iResult.getErrors());
                    System.debug('Object Id:  '+ iResult.getId());
                }
            }
        } else return;

        set<Id> accIds = new Set<Id>();
        set<Id> userIds = new Set<Id>();
        for(Associated_Location__c oldAls : oldRecordMap.values()) {// get and delete the old ones
            if(newRecordMap.get(oldAls.Id)?.User__c == oldAls.User__c && newRecordMap.get(oldAls.Id)?.Account__c == oldAls.Account__c) {} 
            else {
                accIds.add(oldAls.Account__c);
                userIds.add(oldAls.User__c);}
            
        }

        if(!userIds.isEmpty()) {
            List<AccountTeamMember> accountTeamMembersToDelete = [SELECT Id from AccountTeamMember where AccountId IN :accIds AND UserId IN :userIds];

            List<Database.DeleteResult> deleteResults = Database.delete(accountTeamMembersToDelete ,  false);
            
            for(Database.deleteResult iResults : deleteResults) {
                if(!iResults.isSuccess()) {
                    System.debug('failed to delete: '+ iResults.getErrors());
                    System.debug('object Id: ' + iResults.getId());
                }
            }
        }
    }
}