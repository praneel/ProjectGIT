@IsTest
private class LMT_LeadReassign_EXT_TEST
{
	class DataTest{
		
		public LMT_TestUtils_Test.DealerHierarchy[] dh;
		public QueueSObject[] queues;
	}
	
    /**
     * Test re-assignment of a lead by a user plateform.
     * Two assignment rules are created: the first one assigns the lead to a PF1
     * the second one reassigns the lead to a PF2.
     */
    static testMethod void testLeadReAssignment(){
    
        insertSettings();

        QueueSObject[] queues;
        System.runAs(LMT_TestUtils_Test.getCurrentUser()){
            //-- Create queues
            queues = LMT_TestUtils_Test.createQueues(new String[]{'FR_PF2_1_VN', 'FR_PF1_1_VN', 'LEAD_ERROR_QUEUE'});
        }
        
        //-- Create dealer hierarchy
        LMT_TestUtils_Test.DealerHierarchy[] dh = LMT_TestUtils_Test.createDealerHierarchy(1, 1, 2);     
        
        //-- Create platforms
        List<LeadQualificationPlatform__c> platforms = new List<LeadQualificationPlatform__c>();
        platforms.add(new LeadQualificationPlatform__c(Name='FR_PF2_1', Country__c='France', Type__c='PF2'));
        platforms.add(new LeadQualificationPlatform__c(Name='FR_PF1_1', Country__c='France', Type__c='PF1'));
        
        insert platforms;
        
        //-- Create assignment rules
        List<Lead_Assignment_Rule__c> assgnRules = new List<Lead_Assignment_Rule__c>();
        assgnRules.add(new Lead_Assignment_Rule__c( Order__c = 1, Assignment_Stage__c = 1, Active__c = true, Assignment_type__c='PF1', Country__c='France', Brand__c='RENAULT', Lead_Source__c='INTERNET'));
        assgnRules.add(new Lead_Assignment_Rule__c( Order__c = 1, Assignment_Stage__c = 2, Active__c = true, Assignment_type__c='PF2', Country__c='France', Brand__c='RENAULT', Lead_Source__c='INTERNET'));
        
        insert assgnRules;
        
        //-- Create platform-dealer-relation
        List<Platform_Dealer_Relation__c> pfDealerRels = new List<Platform_Dealer_Relation__c>();
        pfDealerRels.add(new Platform_Dealer_Relation__c(Brand__c='RENAULT', Lead_Source__c='INTERNET', Platform__c=platforms[0].Id, Account__c=dh[0].dealer.Id)); 
        pfDealerRels.add(new Platform_Dealer_Relation__c(Brand__c='RENAULT', Lead_Source__c='INTERNET', Platform__c=platforms[1].Id, Account__c=dh[0].dealer.Id));        
        
        insert pfDealerRels;
        
        List<Lead_Platform_Queue__c> pfQueues = new List<Lead_Platform_Queue__c>();
        pfQueues.add(new Lead_Platform_Queue__c(Queue_Name__c='FR_PF2_1_VN', Lead_Qualification_Platform__c=platforms[0].Id));
        pfQueues.add(new Lead_Platform_Queue__c(Queue_Name__c='FR_PF1_1_VN', Lead_Qualification_Platform__c=platforms[1].Id));
        
        insert pfQueues;
        
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead1 = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.leadStatus_NEW,
                LeadSource = 'INTERNET',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        );
		insert lead1;
		
        List<Lead> leadEnfants = new List<Lead>();
        for (Integer i =1; i<= 4; i++){
	    	leadEnfants.add(new Lead(LastName = 'Lead Child' + i, Status = LMT_LeadUtils_CLS.leadStatus_CLOSED, LeadSource = 'INTERNET',
	        		Brand__c='RENAULT', Country__c = 'France', TypeOfInterest__c = 'VN', SubType_Of_Interest__c = 'Brochure Request',
	        		RecordTypeId = leadRecordTypeId, DealerOfInterest__c = dh[0].dealer.Id, Parent_Lead__c = lead1.Id));
        }
        insert leadEnfants;
		        
        //-- retrieve from database
        Lead l1 = [SELECT OwnerId FROM Lead WHERE Id = :lead1.Id];
        
        System.assertEquals(queues[1].QueueId, l1.OwnerId);
        
        Test.startTest();
            
        LMT_LeadReassign_EXT ext = new LMT_LeadReassign_EXT(new ApexPages.StandardController( l1 ));
        PageReference pg = ext.reassign();
            
        Test.stopTest();
        
        System.assertNotEquals(null, pg);

        l1 = [SELECT OwnerId, Status FROM Lead WHERE Id = :lead1.Id];
        System.assertEquals(queues[0].QueueId, l1.OwnerId);
        System.assertEquals(LMT_LeadUtils_CLS.leadStatus_NEW, l1.Status);

        List<Lead> children = [SELECT OwnerId, Status FROM Lead WHERE Id IN :leadEnfants];
        System.assertEquals(4, children.size());
        for (Lead e : children){
	        System.assertEquals(queues[0].QueueId, e.OwnerId);
	        System.assertEquals(LMT_LeadUtils_CLS.leadStatus_CLOSED, e.Status);
        }
    }
    
    /**
     * Checks behavior when an error occured during re-assignment.
     *
     */
    static testMethod void testLeadReAssignmentError(){
    
        insertSettings();

        QueueSObject[] queues;
        System.runAs(LMT_TestUtils_Test.getCurrentUser()){
            //-- Create queues
            queues = LMT_TestUtils_Test.createQueues(new String[]{'FR_PF1_1_VN', 'LEAD_ERROR_QUEUE'});
        }
        
        //-- Create dealer hierarchy
        LMT_TestUtils_Test.DealerHierarchy[] dh = LMT_TestUtils_Test.createDealerHierarchy(1, 1, 2);     
        
        //-- Create platforms
        List<LeadQualificationPlatform__c> platforms = new List<LeadQualificationPlatform__c>();
        platforms.add(new LeadQualificationPlatform__c(Name='FR_PF1_1', Country__c='France', Type__c='PF1'));
        
        insert platforms;
        
        //-- Create assignment rules
        List<Lead_Assignment_Rule__c> assgnRules = new List<Lead_Assignment_Rule__c>();
        assgnRules.add(new Lead_Assignment_Rule__c( Order__c = 1, Assignment_Stage__c = 1, Active__c = true, Assignment_type__c='PF1', Country__c='France', Brand__c='RENAULT', Lead_Source__c='INTERNET'));
        
        insert assgnRules;
        
        //-- Create platform-dealer-relation
        List<Platform_Dealer_Relation__c> pfDealerRels = new List<Platform_Dealer_Relation__c>();
        pfDealerRels.add(new Platform_Dealer_Relation__c(Brand__c='RENAULT', Lead_Source__c='INTERNET', Platform__c=platforms[0].Id, Account__c=dh[0].dealer.Id)); 
        
        insert pfDealerRels;
        
        List<Lead_Platform_Queue__c> pfQueues = new List<Lead_Platform_Queue__c>();
        pfQueues.add(new Lead_Platform_Queue__c(Queue_Name__c='FR_PF1_1_VN', Lead_Qualification_Platform__c=platforms[0].Id));
        
        insert pfQueues;
        
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.leadStatus_NEW,
                LeadSource = 'INTERNET',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        );
        
        insert lead;
        
        //-- retrieve from database
        Lead l1 = [SELECT OwnerId FROM Lead WHERE Id = :lead.Id];
        
        System.assertEquals(queues[0].QueueId, l1.OwnerId);
        
        PageReference pg;

        Test.startTest();
            
        LMT_LeadReassign_EXT ext = new LMT_LeadReassign_EXT(new ApexPages.StandardController( l1 ));
        pg = ext.reassign();

        System.assertEquals(null, pg);
        System.assertEquals(System.Label.LMT_Lead_Trigger_NoLeadAssignmentFound, ext.errMsg);
        
        Test.stopTest();
        
        Lead l2 = [SELECT OwnerId, AssignmentError__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals(queues[0].QueueId, l2.OwnerId); // not reassigned
        System.assertEquals(null, l2.AssignmentError__c);
    }
    
    
    /**
     * Status=Qualified. le changement de statut lors de la reassignation par exemple pour passer de qualifié à qualifié à assigner ne marche pas.
	 *	Le fond du problème est que le statut change deux fois . une fois par l'action de la matrice et une deuxième fois par l'action du trigger.
     */
    static testMethod void testLeadReAssignmentQualified(){
    
    	LMT_LeadReassign_EXT_TEST.DataTest dt = insertDataMisc();
		LMT_TestUtils_Test.DealerHierarchy[] dh = dt.dh;
		QueueSObject[] queues = dt.queues;

        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead2 = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.LEADSTATUS_NEW,
                LeadSource = 'Campaign',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        ); 
        
        insert lead2;
        
        //-- retrieve from database
        Lead l2 = [SELECT OwnerId, Qualification__c, Subqualification__c FROM Lead WHERE Id = :lead2.Id];

        System.assertEquals(queues[1].QueueId, l2.OwnerId);
        
        //-- platform actions
        l2.Qualification__c = LMT_LeadUtils_CLS.QUALIFICATION_INTERESTED_CONTACT;
        l2.Subqualification__c = LMT_LeadUtils_CLS.SUB_QUALIFICATION_LESS_THAN_THREE_MONTHS;
        update l2; 
        
        //-- retrieve from database
        l2 = [SELECT Status, OwnerId, Qualification__c, Subqualification__c FROM Lead WHERE Id = :lead2.Id];
        System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_QUALIFIED, l2.Status);

        Test.startTest();
            
        LMT_LeadReassign_EXT ext = new LMT_LeadReassign_EXT(new ApexPages.StandardController( l2 ));
        PageReference pg = ext.reassign();
            
        Test.stopTest();
        
        System.assertNotEquals(null, pg);

        l2 = [SELECT OwnerId, Status FROM Lead WHERE Id = :lead2.Id];
        System.assertEquals(queues[0].QueueId, l2.OwnerId);
        System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_QUALIFIEDTOASSIGN, l2.Status);
    }
    
    /**
	 * Status=Closed. testing re-assignment to cold queue from platform operator.
     */
    static testMethod void testLeadReAssignmentColdQueue(){
    
    	LMT_LeadReassign_EXT_TEST.DataTest dt = insertDataMisc();
		LMT_TestUtils_Test.DealerHierarchy[] dh = dt.dh;
		QueueSObject[] queues = dt.queues;

        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :LMT_TestUtils_TEST.vn_vo_recType AND sObjectType = 'Lead'].Id;
        Lead lead3 = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.LEADSTATUS_NEW,
                LeadSource = 'Campaign',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        );
        //-- add 2 duplicates
        Lead lead4 = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.LEADSTATUS_NEW,
                LeadSource = 'Campaign',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        );
        Lead lead5 = new Lead(
                LastName = 'Talon',
                Status = LMT_LeadUtils_CLS.LEADSTATUS_NEW,
                LeadSource = 'Campaign',
                Brand__c='RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'VN',
                SubType_Of_Interest__c = 'Brochure Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dh[0].dealer.Id,
                Assignment_Counter__c = 0
        );
        List<Lead> ll = new Lead[]{lead3, lead4, lead5};
        insert ll;
        
        // retrrieve from database
        Map<Id, Lead> mLeads = new Map<Id, Lead>([SELECT OwnerId, Qualification__c, Subqualification__c FROM Lead WHERE Id IN :ll]);
		Lead l3 = mLeads.get(lead3.Id);
		Lead l4 = mLeads.get(lead4.Id);
		Lead l5 = mLeads.get(lead5.Id);
		
		//-- relate duplicates
		l4.Parent_Lead__c = l3.Id;
		l5.Parent_Lead__c = l3.Id;
		l4.Status = LMT_LeadUtils_CLS.LEADSTATUS_CLOSED;
		l5.Status = LMT_LeadUtils_CLS.LEADSTATUS_CLOSED;
		l4.Status2__c = LMT_LeadUtils_CLS.LEADSTATUS_CLOSED;
		l5.Status2__c = LMT_LeadUtils_CLS.LEADSTATUS_CLOSED;
		update new Lead[]{l4, l5};
						        
        System.assertEquals(queues[1].QueueId, l3.OwnerId);
        
        //-- platform actions
        l3.Qualification__c = LMT_LeadUtils_CLS.QUALIFICATION_INTERESTED_CONTACT;
        l3.Subqualification__c = LMT_LeadUtils_CLS.SUB_QUALIFICATION_MORE_THAN_1_YEAR;
        update l3; 
        
        //-- retrieve from database
        mLeads = new Map<Id, Lead>([SELECT OwnerId, Status, Qualification__c, Subqualification__c FROM Lead WHERE Id IN :ll]);
		l3 = mLeads.get(lead3.Id);
		l4 = mLeads.get(lead4.Id);
		l5 = mLeads.get(lead5.Id);
		System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l3.Status);
		System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l4.Status);
		System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l5.Status);
        
        Test.startTest();
            
        LMT_LeadReassign_EXT ext = new LMT_LeadReassign_EXT(new ApexPages.StandardController( l3 ));
        PageReference pg = ext.reassign();
            
        Test.stopTest();
        
        System.assertNotEquals(null, pg);
		
		mLeads = new Map<Id, Lead>([SELECT OwnerId, Status, Qualification__c, Subqualification__c FROM Lead WHERE Id IN :ll]);
		l3 = mLeads.get(lead3.Id);
		l4 = mLeads.get(lead4.Id);
		l5 = mLeads.get(lead5.Id);
        System.assertEquals(queues[3].QueueId, l3.OwnerId);
        System.assertEquals(queues[3].QueueId, l4.OwnerId);
        System.assertEquals(queues[3].QueueId, l5.OwnerId);
        System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l3.Status);
        System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l4.Status);
        System.assertEquals(LMT_LeadUtils_CLS.LEADSTATUS_CLOSED, l5.Status);
    }
    


    private static void insertSettings(){
        System.runAs(LMT_TestUtils_Test.getCurrentUser()){
            //-- fill setting
            CS03_LMT_Settings__c settings = new CS03_LMT_Settings__c(
                LeadSource_SkipCustomAssignmentRules__c = 'SRC;PHONE', LeadSource_CheckCampaign__c = 'RCI',
                Max_number_of_assignments__c = 2, Lead_Global_Error_Queue__c = 'LEAD_ERROR_QUEUE', Export_SFA_page_size__c = 200
            );
            insert settings;
        }
    }
    
    private static LMT_LeadReassign_EXT_TEST.DataTest insertDataMisc(){
        insertSettings();

        QueueSObject[] queues;
        System.runAs(LMT_TestUtils_Test.getCurrentUser()){
            //-- Create queues
            queues = LMT_TestUtils_Test.createQueues(new String[]{'QUEUE_CSMO', 'FR_PF1_1_VN', 'LEAD_ERROR_QUEUE', 'QUEUE_COLD'});
        }
        
        //-- Create dealer hierarchy
        LMT_TestUtils_Test.DealerHierarchy[] dh = LMT_TestUtils_Test.createDealerHierarchy(1, 1, 2);     
        
        //-- Create platforms
        List<LeadQualificationPlatform__c> platforms = new List<LeadQualificationPlatform__c>();
        platforms.add(new LeadQualificationPlatform__c(Name='FR_PF1_1', Country__c='France', Type__c='PF1'));
        
        insert platforms;
        
        //-- Create assignment rules
        List<Lead_Assignment_Rule__c> assgnRules = new List<Lead_Assignment_Rule__c>();
        assgnRules.add(new Lead_Assignment_Rule__c( Order__c = 1, Assignment_Stage__c = 1, Active__c = true, Assignment_type__c='PF1', Country__c='France', Brand__c='RENAULT', Lead_Source__c='Campaign'));
        assgnRules.add(new Lead_Assignment_Rule__c( Order__c = 1, Assignment_Stage__c = 2, Active__c = true, Assignment_type__c='CSMO', Country__c='France', Brand__c='RENAULT', Lead_Source__c='Campaign'));
        
        insert assgnRules;
        
        List<Lead_Dealer_Queue__c> ldQueues = new List<Lead_Dealer_Queue__c>();
        ldQueues.add(new Lead_Dealer_Queue__c(Queue_Name__c='QUEUE_CSMO', Type__c='CSMO', Dealer__c=dh[0].dealer.Id));
        ldQueues.add(new Lead_Dealer_Queue__c(Queue_Name__c='QUEUE_COLD', Type__c='Cold', Dealer__c=dh[0].dealer.Id));
        
        insert ldQueues;

        //-- Create platform-dealer-relation
        List<Platform_Dealer_Relation__c> pfDealerRels = new List<Platform_Dealer_Relation__c>();
        pfDealerRels.add(new Platform_Dealer_Relation__c(Brand__c='RENAULT', Lead_Source__c='Campaign', Platform__c=platforms[0].Id, Account__c=dh[0].dealer.Id)); 
        
        insert pfDealerRels;
        
        List<Lead_Platform_Queue__c> pfQueues = new List<Lead_Platform_Queue__c>();
        pfQueues.add(new Lead_Platform_Queue__c(Queue_Name__c='FR_PF1_1_VN', Lead_Qualification_Platform__c=platforms[0].Id));
        
        insert pfQueues;
        
        LMT_LeadReassign_EXT_TEST.DataTest dt = new LMT_LeadReassign_EXT_TEST.DataTest();
        dt.dh = dh;
        dt.queues = queues;
        return dt;
    }
}