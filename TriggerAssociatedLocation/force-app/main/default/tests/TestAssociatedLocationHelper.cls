@isTest
public with sharing class TestAssociatedLocationHelper {

    @isTest(SeeAllData=true)
    static void testCreateAccountTeamMember() {
        //create test accounts
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Account ContaNova = new Account(Name = 'contaNova');

        insert ContaNova;

        //select a user
        User testUser = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];

        //create test associated locations
        Associated_Location__c testLocation = new Associated_Location__c(
            Account__c = testAccount.Id,
            User__c = testUser.Id);

             Associated_Location__c testRepeatedLocation = new Associated_Location__c(
            Account__c = testAccount.Id,
            User__c = testUser.Id);

            Associated_Location__c testeContaNova = new Associated_Location__c(Account__c = ContaNova.Id, User__c = testUser.Id);

            List<Associated_Location__c> newALs = new List<Associated_Location__c>{testLocation, testRepeatedLocation, testeContaNova}; 
        Test.startTest();
        insert newALs;
        Test.stopTest();
    }

    @isTest(SeeAllData = true)
    static void testDeleteAssociatedLocation() {
        //inserting test objects
        //create test accounts
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Account ContaNova = new Account(Name = 'contaNova');

        insert ContaNova;

        //select a user
        User testUser = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];

        //create test associated locations
        Associated_Location__c testLocation = new Associated_Location__c(
            Account__c = testAccount.Id,
            User__c = testUser.Id);

        Associated_Location__c testeContaNova = new Associated_Location__c(
            Account__c = ContaNova.Id, 
            User__c = testUser.Id);
            
        List<Associated_Location__c> newALs = new List<Associated_Location__c>{testLocation, testeContaNova}; 
        insert newALs;

        Test.startTest();
        delete newALs;
        Test.stopTest();
    }

    @isTest(SeeAllData = true)
    static void testUpdates() {
        //inserting test objects
        //create test accounts
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Account ContaNova = new Account(Name = 'contaNova');

        insert ContaNova;

        //select a user
        User testUser = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];

        User testUser2 = [SELECT Id FROM User WHERE Name = 'Usuario Teste' LIMIT 1];

        //create test associated locations
        Associated_Location__c testLocation = new Associated_Location__c(
            Account__c = testAccount.Id,
            User__c = testUser.Id);

        Associated_Location__c testeContaNova = new Associated_Location__c(
            Account__c = ContaNova.Id, 
            User__c = testUser.Id);
            
        List<Associated_Location__c> newALs = new List<Associated_Location__c>{testLocation, testeContaNova}; 
        insert newALs;

        //changing the user on the testLocation AL
        testLocation.User__c = testUser2.Id;

        //changing the account on the testeContaNova AL
        testeContaNova.Account__c = testAccount.Id;

        Test.startTest();
        update testLocation;
        update testeContaNova;
        Test.stopTest();
        
    }

}