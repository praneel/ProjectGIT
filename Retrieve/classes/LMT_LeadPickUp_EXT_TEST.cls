@isTest
public class LMT_LeadPickUp_EXT_TEST
{
	
	public static testMethod void testPickUpOK()
	{
        // create partner account
		String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Network_Site_Acc'].Id;                
        Account partnerAccount1 = new Account(
            Name = 'Garage Répartout', ProfEmailAddress__c = 'repartout@test.com', RecordTypeId = recordTypeId
        );
        Database.insert(partnerAccount1);

		User user1 = LMT_TestUtils_Test.createPartnerUser('Luis', 'Fernandez', partnerAccount1);
		User user2 = LMT_TestUtils_Test.createPartnerUser('Michel', 'Platini', partnerAccount1);
		User user3 = LMT_TestUtils_Test.createPartnerUser('Manuel', 'Amoros', partnerAccount1);
		
        // pick up the lead
        Test.startTest();
        
    	Lead lead1 = createLead(3);
    	
    	LeadShare shr = new LeadShare();
		shr.LeadId = lead1.Id;
		shr.UserOrGroupId = user1.Id;
		shr.LeadAccessLevel = 'Edit';
		insert shr;

  		List<Lead> ldup = [SELECT OwnerId FROM Lead WHERE Parent_Lead__c = :lead1.Id ORDER By Id];
		System.assertEquals(3, ldup.size());
    	List<LeadShare> lshr = new List<LeadShare>();
		lshr.add(new LeadShare(LeadId = ldup[0].Id, UserOrGroupId = user1.Id, LeadAccessLevel = 'Edit'));
		lshr.add(new LeadShare(LeadId = ldup[1].Id, UserOrGroupId = user1.Id, LeadAccessLevel = 'Read'));
		insert lshr;
		// third child is not seen by user1
		String currentOwner = ldup[2].OwnerId;
		
    	System.assertNotEquals(user1.Id, lead1.OwnerId);
    	
        // create a custom controller
        ApexPages.StandardController stdCtr = new ApexPages.StandardController(lead1);
        LMT_LeadPickUp_EXT ctr = new LMT_LeadPickUp_EXT(stdCtr);
        
        System.runAs(user1){
			ctr.pickUp();
			System.assert(!ctr.failed);
        }
        
        Test.stopTest();
        lead1 = [SELECT OwnerId FROM Lead WHERE Id = :lead1.Id];
        System.assertEquals(user1.Id, lead1.OwnerId);
        
        ldup = [SELECT OwnerId FROM Lead WHERE Parent_Lead__c = :lead1.Id ORDER By Id];
        System.assertEquals(3, ldup.size());
        System.assertEquals(user1.Id, ldup[0].OwnerId);
        // second child has not been reassigned and did not caused any error
        System.assertEquals(currentOwner, ldup[1].OwnerId);
        // third child has not been reassigned 
        System.assertEquals(currentOwner, ldup[2].OwnerId);
    }
    
	public static testMethod void testPickUpKO()
	{
        // create partner account
		String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Network_Site_Acc'].Id;                
        Account partnerAccount1 = new Account(
            Name = 'Garage Répartout', ProfEmailAddress__c = 'repartout@test.com', RecordTypeId = recordTypeId
        );
        Database.insert(partnerAccount1);

		User user1 = LMT_TestUtils_Test.createPartnerUser('Luis', 'Fernandez', partnerAccount1);
		User user2 = LMT_TestUtils_Test.createPartnerUser('Michel', 'Platini', partnerAccount1);
		User user3 = LMT_TestUtils_Test.createPartnerUser('Manuel', 'Amoros', partnerAccount1);
		
        // pick up the lead
        Test.startTest();
        
    	Lead lead1 = createLead(0);
    	
    	LeadShare shr = new LeadShare();
		shr.LeadId = lead1.Id;
		shr.UserOrGroupId = user1.Id;
		shr.LeadAccessLevel = 'Read';
		insert shr;

		    	
    	System.assertNotEquals(user1.Id, lead1.OwnerId);
    	
        // create a custom controller
        ApexPages.StandardController stdCtr = new ApexPages.StandardController(lead1);
        LMT_LeadPickUp_EXT ctr = new LMT_LeadPickUp_EXT(stdCtr);
        
        System.runAs(user1){
			ctr.pickUp();
			System.assert(ctr.failed);
        }
        
        Test.stopTest();
        lead1 = [SELECT OwnerId FROM Lead WHERE Id = :lead1.Id];
        System.assertNotEquals(user1.Id, lead1.OwnerId);
        System.assertEquals(UserInfo.getUserId(), lead1.OwnerId);
    }
    
    private static Lead createLead(Integer nbDuplicates)
    {
    	// create an account
    	Account acc = new Account();
    	acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'CORE_ACC_Personal_Account_RecType'].Id;
    	acc.FirstName = 'Paul';
    	acc.LastName = 'Isson';
    	acc.PersEmailAddress__c = 'paul.isson@yopmail.com';
    	acc.Language__c = 'English';
    	insert acc;
    	
    	// create a Lead
    	String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead1 = new Lead(
        		LastName = 'Lead',
        		Status = LMT_LeadUtils_CLS.leadStatus_NEW,
        		LeadSource = 'INTERNET',
        		Brand__c='RENAULT',
        		Country__c = 'France',
        		TypeOfInterest__c = 'APVA',
        		SubType_Of_Interest__c = 'Used Vehicle Request',
        		RecordTypeId = leadRecordTypeId,
        		DealerOfInterest__c = acc.Id
        );
    	insert lead1;
    	
    	List<Lead> ldup = new List<Lead>();
    	for (Integer i =0; i < nbDuplicates; i++){
        	ldup.add(new Lead(LastName = 'Lead', Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET', Brand__c='RENAULT',
        		Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request', RecordTypeId = leadRecordTypeId,
        		DealerOfInterest__c = acc.Id, Parent_Lead__c = lead1.Id));
        }
    	insert ldup;

    	
    	return lead1;
    }
	
}