// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:

List<User> userDiogo = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];
List<User> userTeste = [SELECT Id FROM User WHERE Name = 'Usuario teste' LIMIT 1];
List<Account> AccountTest = [SELECT Id FROM Account WHERE Name = 'Sr Test' LIMIT 1];

List<Associated_Location__c> AL = [SELECT Id, User__c from Associated_Location__c WHERE User__c = :userDiogo LIMIT 1] ;

Al[0].Account__c = AccountTest[0].Id;

update AL;
