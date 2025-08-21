// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:

List<User> userDiogo = [SELECT Id FROM User WHERE Name = 'Diogo Santos Rodrigues' LIMIT 1];
List<Account> AccountTest = [SELECT Id FROM Account WHERE Name = 'United Oil & Gas Corp.' LIMIT 1];

Associated_Location__c AL = new Associated_Location__c();
    AL.Name = 'Test Location 5';
    AL.Account__c = AccountTest[0].Id;
    AL.User__c = userDiogo[0].Id;

insert AL;
