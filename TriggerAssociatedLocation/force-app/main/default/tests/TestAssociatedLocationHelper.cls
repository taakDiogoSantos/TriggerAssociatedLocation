@isTest
public with sharing class TestAssociatedLocationHelper {

    @isTest(SeeAllData=true)
    static void testCreateAccountTeamMember() {
        //create a test account
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        //create a test user
        User testUser = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];

        //create a test associated location
        Associated_Location__c testLocation = new Associated_Location__c(
            Account__c = testAccount.Id,
            User__c = testUser.Id);
            List<Associated_Location__c> newALs = new List<Associated_Location__c>{testLocation}; 
        Test.startTest();
        AssociatedLocationTriggerHelper.verifyAccount(newALs);
        Test.stopTest();
    }
}