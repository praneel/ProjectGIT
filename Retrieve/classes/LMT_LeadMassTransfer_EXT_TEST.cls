@isTest
private class LMT_LeadMassTransfer_EXT_TEST {

    public static testMethod void testLeadMassTransferWithIdList(){
    	testLeadMassTransfer_EXT0(true);
    }
    
    public static testMethod void testLeadMassTransferWithStdControler(){
    	testLeadMassTransfer_EXT0(false);
    }

    public static testMethod void testLeadMassTransferError(){
		Date newdate = Date.today().addYears(1); 
		LMT_LeadMassTransfer_EXT ext;
		//-- create dealer
		Account accDealer = LMT_TestUtils_Test.createPartnerAccount('My Concession', 'my.concession@test.com');
		//-- create CSMO and Dealers
		User usrCsmo = LMT_TestUtils_Test.createPartnerUser('Jules', 'Cesar', accDealer); 
		User usrEmp1 = LMT_TestUtils_Test.createPartnerUser('Rene', 'Goscinny', accDealer);
		//-- create person account for customer
		Account acc = LMT_TestUtils_Test.createPersonAccount('Achille', 'Talon', 'a.talon@test.com', '', '', '', '5 rue des Tulipes', 'Paris', '75001', 'France');
    	//-- create opportunities
        String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead1 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 1', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = UserInfo.getUserId());// will raise an error due to "with sharing" mode
    	insert lead1;
		
		// share lead in Read mode to make the lead readable but not updatable
	    LeadShare jobShr  = new LeadShare();
	    jobShr.LeadId = lead1.Id;
	    jobShr.UserOrGroupId = usrCsmo.Id;
	    jobShr.LeadAccessLevel = 'Read';
	    insert jobShr;
		    	
		System.runAs(usrCsmo){
	    	//-- sets current page
	    	String retUrl = EncodingUtil.urlEncode('/00Q?fcf=00Bb0000003FZ6X&page=1&rolodexIndex=-1', 'UTF-8');
	    	PageReference p = Page.LMT_LeadMassTransfer;
	    	p.getParameters().put('retURL', retUrl);
			p.getParameters().put('customids', lead1.Id);			
	    	Test.setCurrentPage(p);
			//-- runs test
			Test.startTest();
			//-- creates standard set controller
			ApexPages.StandardSetController sc = new ApexPages.Standardsetcontroller(new Lead[]{});
			//-- creates controller
			ext = new LMT_LeadMassTransfer_EXT(sc);
			Lead o = (Lead) sc.getRecord();
			o.Date_Echeance__c = newdate;
			o.OwnerId = usrEmp1.Id;
			//-- transfer
			PageReference ret = ext.save();
			System.assertEquals(null, ret);
			Test.stopTest();
		}
		//-- control execution
		Lead l1 = [SELECT OwnerId, Date_Echeance__c, Is_Assigned__c FROM Lead WHERE Id = :lead1.Id];
		System.assertEquals(UserInfo.getUserId(), l1.OwnerId);
		System.assert(!l1.Is_Assigned__c);
    }

    /**
     * @param idsAsParam	specifies whether the list od ids is set as a param or referenced inside the standard controler
     */
  	private static void testLeadMassTransfer_EXT0(Boolean idsAsParam){
		Date newdate = Date.today().addYears(1); 
		LMT_LeadMassTransfer_EXT ext;
		//-- create dealer
		Account accDealer = LMT_TestUtils_Test.createPartnerAccount('My Concession', 'my.concession@test.com');
		//-- create CSMO and Dealers
		User usrCsmo = LMT_TestUtils_Test.createPartnerUser('Jules', 'Cesar', accDealer); 
		User usrEmp1 = LMT_TestUtils_Test.createPartnerUser('Rene', 'Goscinny', accDealer);
		//-- create person account for customer
		Account acc = LMT_TestUtils_Test.createPersonAccount('Achille', 'Talon', 'a.talon@test.com', '', '', '', '6 rue des Marguerites', 'Paris', '75001', 'France');
    	//-- create opportunities
        String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead1 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 1', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = usrCsmo.Id);
        Lead lead2 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 2', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = usrCsmo.Id);
        Lead lead3 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 3', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = usrCsmo.Id);
        Lead lead4 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 4', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = usrCsmo.Id);
        Lead lead5 = new Lead(RecordTypeId = recordTypeId, Lastname = 'Lead 5', Account__c = acc.Id, Date_Echeance__c = Date.today().addMonths(1), 
        	OwnerId = usrCsmo.Id);
    	Lead[] leads = new Lead[]{lead1, lead2, lead3, lead4, lead5};
    	insert leads;
    	
    	
        List<Lead> leadEnfants = new List<Lead>();
        for (Integer i =1; i<= 2; i++){
	    	leadEnfants.add(new Lead(LastName = 'Lead Child' + i, Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET',
	        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request',
	        		RecordTypeId = recordTypeId, DealerOfInterest__c = accDealer.Id, OwnerId = usrCsmo.Id, Parent_Lead__c = lead5.Id));
        }
        insert leadEnfants;
        
        //-- a child lead owned by current user that should not be seen by the csmo
    	Lead unreadableLead = new Lead(LastName = 'Lead Child Unredeable', Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET',
        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'APVA', SubType_Of_Interest__c = 'Used Vehicle Request',
        		RecordTypeId = recordTypeId, DealerOfInterest__c = accDealer.Id, OwnerId = UserInfo.getUserId(), Parent_Lead__c = lead5.Id);
        insert unreadableLead;
        unreadableLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :unreadableLead.Id];
    	
    	
    	//-- sets current page
    	String retUrl = EncodingUtil.urlEncode('/00Q?fcf=00Bb0000003FZ6X&page=1&rolodexIndex=-1', 'UTF-8');
    	PageReference p = Page.LMT_LeadMassTransfer;
    	p.getParameters().put('retURL', retUrl);
		if (idsAsParam){
			String customIds = '';
			for (Lead l : leads){
				customIds += ',';
				customIds += l.Id;
			}
			p.getParameters().put('customids', customIds.substring(1));			
		}
    	Test.setCurrentPage(p);
		//-- runs test
		Test.startTest();
		System.runAs(usrCsmo){
			//-- creates standard set controller
			ApexPages.StandardSetController sc = new ApexPages.Standardsetcontroller(new Lead[]{});
			if (!idsAsParam){
				sc.setSelected(leads);
			} 
			//-- creates controller
			ext = new LMT_LeadMassTransfer_EXT(sc);
			Lead o = (Lead) sc.getRecord();
			o.Date_Echeance__c = newdate;
			o.OwnerId = usrEmp1.Id;
			//-- transfer
			PageReference ret = ext.save();
			System.assertNotEquals(null, ret);
			System.assertEquals(retUrl, ret.getUrl());
		}
		Test.stopTest();
		//-- control execution
		leads = [SELECT OwnerId, Date_Echeance__c, Is_Assigned__c FROM Lead WHERE Id IN :leads];
		System.assertEquals(5, leads.size());
		for (Lead o : leads){
			System.assertEquals(usrEmp1.Id, o.OwnerId);
			System.assertEquals(newdate, o.Date_Echeance__c);
			System.assert(o.Is_Assigned__c);
		}

		List<Lead> enfants= [SELECT OwnerId, Is_Assigned__c FROM Lead WHERE Parent_Lead__c = :lead5.Id];
		System.assertEquals(3, enfants.size());
		for (Lead o : leads){
			if (o.Id == unreadableLead.Id){
				System.assertEquals(UserInfo.getUserId(), o.OwnerId);
				System.assert(!o.Is_Assigned__c);
			}else{
				System.assertEquals(usrEmp1.Id, o.OwnerId);
				System.assert(o.Is_Assigned__c);
			}
		}
    }
}