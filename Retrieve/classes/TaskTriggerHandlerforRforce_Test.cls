/*****************************************************************************************
    Name    : TaskTriggerHandlerforRforce_Test
    Desc    :
    Approach:
    Author  : Rajavel B(RNTBCI)
    Project : Rforce
******************************************************************************************/
@isTest(SeeAllData=true)

public with sharing class TaskTriggerHandlerforRforce_Test {

    private static testMethod void testTrigger() {
    Account acc = new Account(Name='test');
    List<RecordType> listRT = [SELECT Id From RecordType WHERE sobjecttype='Task'];
    //just to have a minimal code coverage for task_afterdelete_trigger
    Case cs = new case (Type='Complaint', Origin='RENAULT SITE', AccountId=acc.Id, Status='New', Description='Test', CountryCase__c='France');
        insert cs;
        acc.CaseNumber__c = cs.id;
       // update acc;
        
    Task tsk1 = new Task(
          Subject = 'Test Trigger',
          Type = '',
          Priority = 'Normal',
          Status = 'To Do',
          OwnerId = UserInfo.getUserId(),
          WhoId = acc.Id,
          whatId = cs.Id,
          recordtypeid = listRT[0].Id
          );
   // Rforce_CheckRecursive_Utility.hasAlreadyUpdated();      
    insert tsk1;
    
    
         Attachment att = new Attachment();        
        att.Name = 'TestValue';
        att.IsPrivate = False;
        att.OwnerId = UserInfo.getUserId();
        att.ParentId = tsk1.id ;
        att.Body = Blob.valueOf('Test Body');        
        insert att;
        tsk1.Subject = 'TEST 123';
        try{
      //  Rforce_CheckRecursive_Utility.hasAlreadyUpdated();
        update tsk1;
        }catch(Exception e) {                  
              } 
          try {
                  delete att;    
              }
              catch(Exception e) {                  
              }          
    
  }
}