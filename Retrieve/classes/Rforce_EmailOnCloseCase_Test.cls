/*****************************************************************************************
    Name    : Rforce_EmailOnCloseCase_Test
    Author  : Ashok Muntha
    Description: This testclass is used to test when the case is closed
                 When the customer send an email it will create automaticaly a new case.
    Scrum ID: N/A
    RO Number:N/A
    Release No:R6
    Sprint ID:1
    Version : 1.0
   ******************************************************************************************/
@isTest(seeAllData=true)
public without sharing class Rforce_EmailOnCloseCase_Test {

    static testMethod void emailMessageTest() {
    
        Profile profile=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User (LastName='Rotondo',BypassVR__c=TRUE,alias='lro',Email='lrotondo@rotondo.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=profile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='lrotondo@lrotondo.com');
        insert usr;
     
        System.runAs(usr)
        {
           Test.startTest(); 
           Group grp = new Group(Name='Customer Service English Members');   
           insert grp;
                
           GroupMember grpMember = new GroupMember();
           grpMember.GroupId = grp.id;
           grpMember.UserOrGroupId=usr.id;
       
           insert grpMember;
       
           AssignmentRule assignmentRule = new AssignmentRule();
           assignmentRule=[select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

           Database.DMLOptions dmlOpts = new Database.DMLOptions();
           dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id; 
       
           Account Acc = new Account(Name='Test1',Phone='0000',ProfEmailAddress__c = 'addr1@mail.com');
           insert Acc;
    
           Contact Con = new Contact(LastName='Test Contact',Salutation='Mr.',Email='lro@lro.com',AccountId=Acc.Id);
           insert Con; 
           
           VEH_Veh__c Vehicule = new VEH_Veh__c (Name = '21342312323123456',  VehicleBrand__c = 'Renault', KmCheck__c = 100 , KmCheckDate__c = date.today());
           insert Vehicule; 
           
           system.debug('Vehicule======>'+Vehicule); 
       
           Case cs = new Case(Origin='Phone',Type='Complaint',Status='New',Priority='Normal',Description='Description',Device_Type__c='MEDIA NAV',CountryCase__c='CS',Device_Brand__c='NNG',Subject='Test',From__c='Customer',Language__c='Czech',VIN__c = Vehicule.Id,AccountId=Acc.Id,ContactId=Con.Id,OwnerId=usr.Id);  
          
            cs.setOptions(dmlOpts);
            
           insert cs;
           system.debug('cs========>'+cs);
           system.debug('cs.id========>'+cs.id);
            system.debug('Tech_ExternalID__c=====>'+cs.Tech_ExternalID__c);
           cs.Status = 'Closed';
           cs.Tech_ExternalID__c='500m000000204Uh';
           update cs;
           system.debug('csupdate=======>'+cs);
           
           Case cs1 = new Case(Origin='Phone',Type='Complaint',Status='Open',Priority='Normal',Description='Description',Device_Type__c='MEDIA NAV',CountryCase__c='CS',Device_Brand__c='NNG',Subject='Test',From__c='Customer',Language__c='Czech',VIN__c = Vehicule.Id,Tech_ExternalID__c='500m0000001vFNV',AccountId=Acc.Id,ContactId=Con.Id,OwnerId=usr.Id);
           insert cs1;
           system.debug('cs1========>'+cs1);
           EmailMessage msg= new EmailMessage(ParentId=cs.Id,FromAddress='test@rntbci.com',Incoming=true,ToAddress='testmail@sample.com',Subject=cs.id,TextBody='TextBody',HtmlBody='HtmlBody');
           try{
              insert msg;  
              system.debug('msg======>'+msg);
           }catch(Exception e){}
           EmailMessage msg1= new EmailMessage(ParentId=cs1.Id,FromAddress='test@rntbci.com',Incoming=true,ToAddress='testmail@sample.com',Subject=cs1.id,TextBody='TextBody',HtmlBody='HtmlBody');
           try{
              insert msg1;  
              system.debug('msg1======>'+msg1);
           }catch(Exception e){}
             
           Test.stopTest();
         }                  
    }
}