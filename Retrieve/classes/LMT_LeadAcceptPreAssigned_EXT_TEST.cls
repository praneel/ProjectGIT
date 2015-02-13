@IsTest
private class LMT_LeadAcceptPreAssigned_EXT_TEST
{
	
	public static testMethod void testAcceptPreassignation()
	{
		LMT_LeadAcceptPreAssigned_EXT ext;
		// create dealer
		Account accDealer = LMT_TestUtils_Test.createPartnerAccount('My Concession', 'my.concession@test.com');
		// create CSMO and Dealers
		User usrCsmo = LMT_TestUtils_Test.createPartnerUser('Jules', 'Cesar', accDealer); // ??
		User usrEmp1 = LMT_TestUtils_Test.createPartnerUser('Rene', 'Goscinny', accDealer);
		User usrEmp2 = LMT_TestUtils_Test.createPartnerUser('Albert', 'Uderzo', accDealer); 
		// create person account for customer
		Account acc = LMT_TestUtils_Test.createPersonAccount('Achille', 'Talon', 'a.talon@test.com', '', '', '', '3 rue des Fleurs', 'Paris', '75001', 'France');
    	// create opportunities
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        
        Integer nbLeads = 5;
        List<Lead> leads = new List<Lead>();
        for( Integer i = 0; i < nbLeads; i++ )
        {
        	Id preassignedSeller;
        	if( i == 1 || i == 4 )
        	{
        		preassignedSeller = usrEmp1.Id;
        	}
        	else
        	if( i == 2 )
        	{
        		preassignedSeller = usrEmp2.Id;
        	}
        	else
        	{
        		preassignedSeller = null;
        	}
        	
        	Lead lead = new Lead(
            		LastName = 'Lead'+(i+1),
            		Status = LMT_LeadUtils_CLS.leadStatus_TOASSIGN,
            		LeadSource = 'INTERNET',
            		Brand__c='RENAULT',
            		Country__c = 'France',
            		TypeOfInterest__c = 'APVA',
            		SubType_Of_Interest__c = 'Used Vehicle Request',
            		RecordTypeId = leadRecordTypeId,
            		DealerOfInterest__c = accDealer.Id,
            		OwnerId = usrCsmo.Id,
            		Preassigned_Seller__c = PreassignedSeller
            );
            
            leads.add( lead );
        }
    	insert leads;
    	
    	// dispatch
    	String[] assignableIds    = new String[]{ leads[1].Id, leads[2].Id, leads[4].Id };
    	String[] notAssignableIds = new String[]{ leads[0].Id, leads[3].Id };
    	
    	// sets current page
    	String retUrl = EncodingUtil.urlEncode( '/00Q?&page=1&rolodexIndex=-1', 'UTF-8' );
    	PageReference p = Page.LMT_LeadAcceptPreAssigned;
    	p.getParameters().put( 'retURL', retUrl );
    	Test.setCurrentPage( p );
    	
		// run test
		Test.startTest();
		System.runAs( usrCsmo )
		{
			// creates standard set controller
			ApexPages.StandardSetController sc = new ApexPages.Standardsetcontroller( leads );
			sc.setSelected( leads ); 
			// creates controller
			ext = new LMT_LeadAcceptPreAssigned_EXT( sc );
			// assertions
			System.assertNotEquals( null, ext.assignableLeads );
			System.assertEquals( 3, ext.assignableLeads.size() );
			LMT_TestUtils_Test.assertListContainsIds( assignableIds, ext.assignableLeads );
			System.assertNotEquals( null, ext.notassignableLeads );
			System.assertEquals( 2, ext.notassignableLeads.size() );
			LMT_TestUtils_Test.assertListContainsIds( notAssignableIds, ext.notassignableLeads );
			// accepts assignation
			PageReference ret = ext.accept();
			System.assertNotEquals( null, ret );
			System.assertEquals( retUrl, ret.getUrl() );
		}
		Test.stopTest();
		
		// check test
		List<Lead> leadRecords = [SELECT OwnerId FROM Lead WHERE Id IN :leads];
		System.assertEquals( nbLeads, leadRecords.size() );
		for( Lead o : leadRecords )
		{
			if( o.Id == leads[0].Id || o.Id == leads[3].Id )
			{
				System.assertEquals( usrCsmo.Id, o.OwnerId );
			}
			else
			if( o.Id == leads[1].Id || o.Id == leads[4].Id )
			{
				System.assertEquals( usrEmp1.Id, o.OwnerId );
			}
			else
			if( o.Id == leads[2].Id )
			{
				System.assertEquals( usrEmp2.Id, o.OwnerId );
			}
			else
			{
			}
		}
	}
	
	public static testMethod void testAcceptPreassignationWithCustomIds()
	{
		LMT_LeadAcceptPreAssigned_EXT ext;
		// create dealer
		Account accDealer = LMT_TestUtils_Test.createPartnerAccount('My Concession', 'my.concession@test.com');
		// create CSMO and Dealers
		User usrCsmo = LMT_TestUtils_Test.createPartnerUser('Jules', 'Cesar', accDealer); // ??
		User usrEmp1 = LMT_TestUtils_Test.createPartnerUser('Rene', 'Goscinny', accDealer);
		User usrEmp2 = LMT_TestUtils_Test.createPartnerUser('Albert', 'Uderzo', accDealer); 
		// create person account for customer
		Account acc = LMT_TestUtils_Test.createPersonAccount('Achille', 'Talon', 'a.talon@test.com', '', '', '', '10 rue de la Vie', 'Paris', '75001', 'France');
    	// create opportunities
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        
        Integer nbLeads = 5;
        List<Lead> leads = new List<Lead>();
        for( Integer i = 0; i < nbLeads; i++ )
        {
        	Id preassignedSeller;
        	if( i == 1 || i == 4 )
        	{
        		preassignedSeller = usrEmp1.Id;
        	}
        	else
        	if( i == 2 )
        	{
        		preassignedSeller = usrEmp2.Id;
        	}
        	else
        	{
        		preassignedSeller = null;
        	}
        	
        	Lead lead = new Lead(
            		LastName = 'Lead'+(i+1),
            		Status = LMT_LeadUtils_CLS.leadStatus_TOASSIGN,
            		LeadSource = 'INTERNET',
            		Brand__c='RENAULT',
            		Country__c = 'France',
            		TypeOfInterest__c = 'APVA',
            		SubType_Of_Interest__c = 'Used Vehicle Request',
            		RecordTypeId = leadRecordTypeId,
            		DealerOfInterest__c = accDealer.Id,
            		OwnerId = usrCsmo.Id,
            		Preassigned_Seller__c = PreassignedSeller
            );
            
            leads.add( lead );
        }
    	insert leads;
    	
    	// dispatch
    	String[] assignableIds    = new String[]{ leads[1].Id, leads[2].Id, leads[4].Id };
    	String[] notAssignableIds = new String[]{ leads[0].Id, leads[3].Id };
    	
    	// sets current page
    	String retUrl = EncodingUtil.urlEncode( '/00Q?&page=1&rolodexIndex=-1', 'UTF-8' );
    	PageReference p = Page.LMT_LeadAcceptPreAssigned;
    	p.getParameters().put( 'retURL', retUrl );
    	Test.setCurrentPage( p );
    	
		// run test
		Test.startTest();
		System.runAs( usrCsmo )
		{
			// creates standard set controller
			ApexPages.StandardSetController sc = new ApexPages.Standardsetcontroller( leads );
			//sc.setSelected( leads ); 
			
			String customIds = '';
			for( Lead lead : leads )
			{
				if( !String.isEmpty( customIds ) )
				{
					customIds += ',';
				}
				customIds += lead.Id;
			}
			p.getParameters().put( 'customids', customIds );
			
			// creates controller
			ext = new LMT_LeadAcceptPreAssigned_EXT( sc );
			// assertions
			System.assertNotEquals( null, ext.assignableLeads );
			System.assertEquals( 3, ext.assignableLeads.size() );
			LMT_TestUtils_Test.assertListContainsIds( assignableIds, ext.assignableLeads );
			System.assertNotEquals( null, ext.notassignableLeads );
			System.assertEquals( 2, ext.notassignableLeads.size() );
			LMT_TestUtils_Test.assertListContainsIds( notAssignableIds, ext.notassignableLeads );
			// accepts assignation
			PageReference ret = ext.accept();
			System.assertNotEquals( null, ret );
			System.assertEquals( retUrl, ret.getUrl() );
		}
		Test.stopTest();
		
		// check test
		List<Lead> leadRecords = [SELECT OwnerId FROM Lead WHERE Id IN :leads];
		System.assertEquals( nbLeads, leadRecords.size() );
		for( Lead o : leadRecords )
		{
			if( o.Id == leads[0].Id || o.Id == leads[3].Id )
			{
				System.assertEquals( usrCsmo.Id, o.OwnerId );
			}
			else
			if( o.Id == leads[1].Id || o.Id == leads[4].Id )
			{
				System.assertEquals( usrEmp1.Id, o.OwnerId );
			}
			else
			if( o.Id == leads[2].Id )
			{
				System.assertEquals( usrEmp2.Id, o.OwnerId );
			}
			else
			{
			}
		}
	}
	
	public static testMethod void testDuplicateLeadsPreassignation()
	{
        Country_Info__c cs = new Country_Info__c(Name='France', Language__c='French', Do_not_mass_assign_duplicate_leads__c=false);
        insert cs;
		
		LMT_LeadAcceptPreAssigned_EXT ext;
		// create dealer
		Account accDealer = LMT_TestUtils_Test.createPartnerAccount('My Concession', 'my.concession@test.com');
		// create CSMO and Dealers
		User usrCsmo = LMT_TestUtils_Test.createPartnerUser('Jules', 'Cesar', accDealer, LMT_TestUtils_Test.csmo_profile); 
		User usrEmp1 = LMT_TestUtils_Test.createPartnerUser('Rene', 'Goscinny', accDealer, LMT_TestUtils_Test.dealer_profile);
		// create person account for customer
		Account acc = LMT_TestUtils_Test.createPersonAccount('Achille', 'Talon', 'a.talon@test.com', '', '', '', '3 rue des Fleurs', 'Paris', '75001', 'France');
    	// create opportunities
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        
        Lead[] leads = new List<Lead>();
        List<Id> lleadIds = new List<Id>();
        for (Integer i = 1; i <= 3; i++){
	    	leads.add(new Lead(LastName = 'Lead Father', Status = LMT_LeadUtils_CLS.leadStatus_TOASSIGN, LeadSource = 'INTERNET',
	        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request',
	        		RecordTypeId = leadRecordTypeId, DealerOfInterest__c = accDealer.Id, OwnerId = usrCsmo.Id, Preassigned_Seller__c = usrEmp1.Id));
        }    
    	insert leads;
    	
    	for (Lead l : leads){
    		l.OwnerId = usrCsmo.Id;
    		lleadIds.add(l.Id);
    	}
    	update leads;
    	
        List<Lead> leadEnfants = new List<Lead>();
        for (Integer i =1; i<= 4; i++){
	    	leadEnfants.add(new Lead(LastName = 'Lead Child' + i, Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET',
	        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request',
	        		RecordTypeId = leadRecordTypeId, DealerOfInterest__c = accDealer.Id, OwnerId = usrCsmo.Id, Parent_Lead__c = leads[0].Id));
        }
        insert leadEnfants;
        
    	for (Lead l : [SELECT Id, OwnerId FROM Lead WHERE Id = :leadEnfants]){
    		l.OwnerId = usrCsmo.Id;
    	}
    	update leadEnfants;
        
        //-- a child lead owned by current user that should not be seen by the csmo
    	Lead unreadableLead = new Lead(LastName = 'Lead Child Unredeable', Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET',
        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request',
        		RecordTypeId = leadRecordTypeId, DealerOfInterest__c = accDealer.Id, OwnerId = UserInfo.getUserId(), Parent_Lead__c = leads[0].Id);
        insert unreadableLead;
        
        unreadableLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :unreadableLead.Id];
        
    	// sets current page
    	String retUrl = EncodingUtil.urlEncode( '/00Q?&page=1&rolodexIndex=-1', 'UTF-8' );
    	PageReference p = Page.LMT_LeadAcceptPreAssigned;
    	p.getParameters().put( 'retURL', retUrl );
    	Test.setCurrentPage( p );
    	
		// run test
		Test.startTest();
		System.runAs( usrCsmo )
		{
			// creates standard set controller
			ApexPages.StandardSetController sc = new ApexPages.Standardsetcontroller( leads );
			sc.setSelected( leads ); 
			// creates controller
			ext = new LMT_LeadAcceptPreAssigned_EXT( sc );
			// assertions
			System.assertNotEquals( null, ext.assignableLeads );
			System.assertEquals( 3, ext.assignableLeads.size() );
			LMT_TestUtils_Test.assertListContainsIds( lleadIds, ext.assignableLeads );
			// accepts assignation
			PageReference ret = ext.accept();
			System.assertNotEquals( null, ret );
			System.assertEquals( retUrl, ret.getUrl() );
		}
		Test.stopTest();
		
		// check test
		List<Lead> leadRecords = [SELECT OwnerId FROM Lead WHERE Id IN :leads];
		for (Lead l : leadRecords){
			System.assertEquals(usrEmp1.Id, l.OwnerId);
		}
		leadRecords = [SELECT OwnerId FROM Lead WHERE Id IN :leadEnfants];
		for (Lead l : leadRecords){
			if (l.Id == unreadableLead.Id){
				System.assertEquals(unreadableLead.OwnerId, l.OwnerId);
			}else{
				System.assertEquals(usrEmp1.Id, l.OwnerId);
			}
		}
	}	
}