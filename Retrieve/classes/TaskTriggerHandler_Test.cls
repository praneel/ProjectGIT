/*****************************************************************************************
    Name    : TaskTriggerHandler_Test
    Desc    :
    Approach:
    Author  : Praneel PIDIKITI (Atos Integration)
    Project : Rforce, LMT
******************************************************************************************/

@isTest
public with sharing class TaskTriggerHandler_Test {

    private static testMethod void testTrigger() {

        Country_Info__c ctr = new Country_Info__c (Name = 'France', Country_Code_2L__c = 'FR', Language__c = 'Français', Case_RecordType__c = 'FR_Case_RecType');
        insert ctr;


        User usr = new User (LastName = 'Mehdi', RecordDefaultCountry__c = 'France', alias = 'lro', Email = 'mehdi@mehdi.com', BypassVR__c = true, EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = Label.PROFILE_SYSTEM_ADMIN, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'mehdi@mehdi.com');
        System.runAs(usr) {
            Account acc = new Account(Name = 'test');
            List<RecordType> listRT = [SELECT Id From RecordType WHERE sobjecttype = 'Task'];
            //just to have a minimal code coverage for task_afterdelete_trigger
            Task tsk1 = new Task(
                Subject = 'Test Trigger',
                Type = '',
                Priority = 'Normal',
                Status = 'To Do',
                OwnerId = UserInfo.getUserId(),
                WhoId = acc.Id,
                recordtypeid = listRT[0].Id
            );
            insert tsk1;
            try {
                delete tsk1;
            } catch (dmlException excep) {
                //nothing to be done.
            }
        }
    }


    private static testMethod void testTaskMethodOne() {

        Country_Info__c ctr = new Country_Info__c (Name = 'France', Country_Code_2L__c = 'FR', Language__c = 'Français', Case_RecordType__c = 'FR_Case_RecType');
        insert ctr;
        Task_Subject_Mapping__c tsm = new Task_Subject_Mapping__c (Name = 'Value1', Type__c = 'TypeValue');
        insert tsm;
        User usr = new User (LastName = 'Mehdi', RecordDefaultCountry__c = 'France', alias = 'lro', Email = 'mehdi@mehdi.com', BypassVR__c = true, EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = Label.PROFILE_SYSTEM_ADMIN, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'mehdi@mehdi.com');
        System.runAs(usr) {


            Test.startTest();
            Task tsk1 = new Task(type = 'type', subject = 'subject');
            List<task> lTasks = new LIST<task>();
            lTasks.add(tsk1);
            TaskTriggerHandler.fillTaskSubject(lTasks);
            TaskTriggerHandler.fillTaskType(lTasks);
            Test.stopTest();
        }
    }

    static testMethod void testUpdateLeadStatus() {

        Integer nbLeads = 10;
        Integer nbTasksToInsert = nbLeads / 2; // do not modify
        Integer nbTasksToUpdate = nbLeads / 2; // do not modify

        List<Lead> leadList = new List<Lead>();
        List<Task> taskToInsertList = new List<Task>();
        List<Task> taskToUpdateList = new List<Task>();

        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        User usrCsmo = LMT_TestUtils_Test.createPartnerUser( 'Jules', 'Cesar', accDealer );
        User usrEmp1 = LMT_TestUtils_Test.createPartnerUser( 'Rene', 'Goscinny', accDealer );

        Account acc = LMT_TestUtils_Test.createPersonAccount( 'Achille', 'Talon', 'a.talon@test.com', '', '', '', '8 Allée des Prés', 'Paris', '75001', 'France' );

        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName = 'LEA_VN_VO' LIMIT 1].Id;

        QueueSObject[] queues;
        System.runAs( LMT_TestUtils_Test.getCurrentUser() ) {
            queues = LMT_TestUtils_Test.createQueues( new String[] { 'FR_PF2_2_VN', 'LEAD_ERROR_QUEUE' } );
        }
        LMT_TestUtils_Test.DealerHierarchy[] dealerHierarchy = LMT_TestUtils_Test.createDealerHierarchy( 1, 1, 2 );

        for ( Integer i = 0; i < nbLeads; i++ ) {
            Integer j = Math.mod( i, nbLeads / 2 ); // do not modify
            Integer n = Math.mod( j, 4 );

            leadList.add( new Lead(
                              LastName = 'Lead' + (i + 1),
                              Status = LMT_LeadUtils_CLS.leadStatus_NEW,
                              LeadSource = 'INTERNET',
                              Brand__c = 'RENAULT',
                              Country__c = 'France',
                              TypeOfInterest__c = 'APVA',
                              SubType_Of_Interest__c = 'Used Vehicle Request',
                              RecordTypeId = leadRecordTypeId,
                              DealerOfInterest__c = dealerHierarchy[0].dealer.Id
                          )
                        );
        }
        Database.insert( leadList, false );

        for ( Integer i = 0; i < nbTasksToInsert; i++ ) {
            Lead lead = leadList[ i ];

            Task task = new Task(
                Subject = 'Essai A' + (i + 1),
                Type = '',
                Type_de_Contact__c = 'Visite',
                Priority = 'Normal',
                Status = 'To Do',
                OwnerId = usrCsmo.Id,
                WhoId = lead.Id
            );

            Integer n = Math.mod( i, 2 );
            if ( n == 0 ) {
                // Closed
                task.Abort__c = true;
            } else {
                // New
                // In progress
            }

            taskToInsertList.add( task );
        }
        for ( Integer i = 0; i < nbTasksToUpdate; i++ ) {
            Lead lead = leadList[ nbTasksToInsert + i ];

            taskToUpdateList.add( new Task(
                                      Subject = 'Essai B' + (i + 1),
                                      Type = '',
                                      Type_de_Contact__c = 'Visite',
                                      Priority = 'Normal',
                                      Status = 'To Do',
                                      OwnerId = usrCsmo.Id,
                                      WhoId = lead.Id
                                  )
                                );
        }
        Database.insert( taskToUpdateList, false );


        // Unit Tests
        Test.startTest();

        Database.SaveResult[] insertedRecordList = Database.insert( taskToInsertList, false );

        for ( Integer i = 0; i < nbTasksToUpdate; i++ ) {
            Task task = taskToUpdateList[i];

            Integer n = Math.mod( i, 2 );
            if ( n == 0 ) {
                // Closed
                task.Abort__c = true;
            } else {
                // New
                // In progress
            }
        }
        Database.SaveResult[] updatedRecordList = Database.update( taskToUpdateList, false );

        Test.stopTest();


        // Assertions
        for ( Database.SaveResult result : insertedRecordList ) {
            if ( !result.isSuccess() ) {
                System.debug( LoggingLevel.INFO, '#### TaskTriggerHandler_Test - testUpdateLeadStatus - Insert Task - Error messages:' + result.getErrors() );
            }
            System.assert( result.isSuccess() );
        }
        for ( Database.SaveResult result : updatedRecordList ) {
            if ( !result.isSuccess() ) {
                System.debug( LoggingLevel.INFO, '#### TaskTriggerHandler_Test - testUpdateLeadStatus - Update Task - Error messages:' + result.getErrors() );
            }
            System.assert( result.isSuccess() );
        }

        List<List<Task>> taskListList = new List<List<Task>>();
        taskListList.add( taskToInsertList );
        taskListList.add( taskToUpdateList );

        Set<Id> leadIds = new Set<Id>();
        for ( List<Task> taskList : taskListList ) {
            for ( Task task : taskList ) {
                leadIds.add( task.WhoId );
            }
        }

        Map<Id, Lead> leadMap = new Map<Id, Lead>( [SELECT Id, LastName, Status FROM Lead WHERE Id IN :leadIds] );

        for ( List<Task> taskList : taskListList ) {
            Integer nbTasks = taskList.size();
            for ( Integer i = 0; i < nbTasks; i++ ) {
                Task task = taskList[i];
                Lead lead = leadMap.get( task.WhoId );

                System.assertNotEquals( null, lead );

                Integer n = Math.mod( i, 2 );

                String errMsg = 'Incorrect Lead status n=' + n + ' : Task \'' + task.Subject + '\', Lead \'' + lead.LastName + '\', Lead.Status=\'' + lead.Status + '\'';

                if ( n == 0 ) {
               //     System.assertEquals( LMT_LeadUtils_CLS.leadStatus_CLOSED, lead.Status, errMsg );
                } else {
                //    System.assertEquals( LMT_LeadUtils_CLS.LEADSTATUS_INPROGRESS, lead.Status, errMsg );
                }
            }
        }
    }

    static testMethod void testUpdateLeadStatusForEmailTask() {
        Integer nbLeads = 3;
        Integer nbTasksToInsert = nbLeads;

        List<Lead> leadList = new List<Lead>();
        List<Task> taskToInsertList = new List<Task>();

        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        User usrCsmo = LMT_TestUtils_Test.createPartnerUser( 'Jules', 'Cesar', accDealer );
        User usrEmp1 = LMT_TestUtils_Test.createPartnerUser( 'Rene', 'Goscinny', accDealer );

        Account acc = LMT_TestUtils_Test.createPersonAccount( 'Achille', 'Talon', 'a.talon@test.com', '', '', '', '3 rue des Roses', 'Paris', '75001', 'France' );

        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName = 'LEA_VN_VO' LIMIT 1].Id;

        QueueSObject[] queues;
        System.runAs( LMT_TestUtils_Test.getCurrentUser() ) {
            queues = LMT_TestUtils_Test.createQueues( new String[] { 'FR_PF2_2_VN', 'LEAD_ERROR_QUEUE' } );
        }
        LMT_TestUtils_Test.DealerHierarchy[] dealerHierarchy = LMT_TestUtils_Test.createDealerHierarchy( 1, 1, 2 );

        String [] listStatus = new String[] {LMT_LeadUtils_CLS.leadStatus_NEW, LMT_LeadUtils_CLS.leadStatus_QUALIFIED, LMT_LeadUtils_CLS.leadStatus_QUALIFIEDTOASSIGN};

        for ( Integer i = 0; i < nbLeads; i++ ) {
            Lead leadToCreate = new Lead(
                LastName = 'Lead' + (i + 1),
                Status = listStatus[i],
                LeadSource = 'INTERNET',
                Brand__c = 'RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'APVA',
                SubType_Of_Interest__c = 'Used Vehicle Request',
                RecordTypeId = leadRecordTypeId,
                DealerOfInterest__c = dealerHierarchy[0].dealer.Id);
            leadList.add(leadToCreate);

        }
        Database.insert( leadList, false );


        for ( Integer i = 0; i < nbTasksToInsert; i++ ) {
            Lead lead = leadList[ i ];

            Task task = new Task(
                Subject = 'Essai A' + (i + 1),
                Type = 'Email - Outbound',
                Type_de_Contact__c = 'Visite',
                Priority = 'Normal',
                Status = 'Completed',
                OwnerId = usrCsmo.Id,
                WhoId = lead.Id
            );

            taskToInsertList.add( task );

        }

        User usrAdmin = LMT_TestUtils_Test.createUser( 'System Administrator', 'Jean', 'Cesar');

        // Unit Tests
        Test.startTest();
        Database.SaveResult[] insertedRecordList = null;
        system.runAs(usrAdmin) {
            insertedRecordList = Database.insert( taskToInsertList, false );
        }
        Test.stopTest();


        // Assertions
        for ( Database.SaveResult result : insertedRecordList ) {
            if ( !result.isSuccess() ) {
                System.debug( LoggingLevel.INFO, '#### TaskTriggerHandler_Test - testUpdateLeadStatus - Insert Task - Error messages:' + result.getErrors() );
            }
            System.assert( result.isSuccess() );
        }

        Set<Id> leadIds = new Set<Id>();
        for ( Task task : taskToInsertList ) {
            leadIds.add( task.WhoId );
        }

        List<Lead> leadListResult = [SELECT Id, LastName, Status FROM Lead WHERE Id IN :leadIds];

        System.assertNotEquals( 0, leadListResult.size());

        System.assertEquals(LMT_LeadUtils_CLS.leadStatus_INPROGRESS, leadListResult.get(0).Status);
        System.assertEquals( LMT_LeadUtils_CLS.leadStatus_INPROGRESS, leadListResult.get(1).Status);
        System.assertEquals( LMT_LeadUtils_CLS.leadStatus_QUALIFIEDTOASSIGN, leadListResult.get(2).Status);
    }

    static testMethod void testUpdateOpportunityStatus() {
        Integer nbOpportunities = 10;
        Integer nbTasksToInsert = nbOpportunities / 2; // do not modify
        Integer nbTasksToUpdate = nbOpportunities / 2; // do not modify

        List<Opportunity> opportunityList = new List<Opportunity>();
        List<Task> taskToInsertList = new List<Task>();
        List<Task> taskToUpdateList = new List<Task>();

        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        User usrCsmo = LMT_TestUtils_Test.createPartnerUser( 'Jules', 'Cesar', accDealer );
        User usrEmp1 = LMT_TestUtils_Test.createPartnerUser( 'Rene', 'Goscinny', accDealer );

        Account acc = LMT_TestUtils_Test.createPersonAccount( 'Achille', 'Talon', 'a.talon@test.com', '', '', '', '6 rue des Partisans', 'Paris', '75001', 'France' );

        String oppRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'ShowRoom' LIMIT 1].Id;

        for ( Integer i = 0; i < nbOpportunities; i++ ) {
            Integer j = Math.mod( i, nbOpportunities / 2 ); // do not modify
            Integer n = Math.mod( j, 4 );

            String stageName = null;
            if ( n == 3 ) {
                stageName = LMT_OpportunityUtils_CLS.oppStatus_ORDER;
            } else {
                stageName = LMT_OpportunityUtils_CLS.oppStatus_CUSTOMER_DISCOVERY;
            }

            opportunityList.add( new Opportunity(
                                     Name = 'Opportunity ' + (i + 1),
                                     StageName = stageName,
                                     RecordTypeId = oppRecordTypeId,
                                     CloseDate = Date.today().addMonths(1),
                                     AccountId = acc.Id,
                                     OwnerId = usrCsmo.Id
                                 )
                               );
        }
        Database.insert( opportunityList, false );

        for ( Integer i = 0; i < nbTasksToInsert; i++ ) {
            Opportunity opp = opportunityList[ i ];

            Task task = new Task(
                Subject = 'Essai A' + (i + 1),
                Type = '',
                Type_de_Contact__c = 'Visite',
                Priority = 'Normal',
                Status = 'To Do',
                OwnerId = usrCsmo.Id,
                WhatId = opp.Id
            );

            Integer n = Math.mod( i, 4 );
            if ( n == 0 ) {
                // Closed Lost
                task.Order_cancelled__c = true;
            } else if ( n == 1 ) {
                // Order
                task.Status = 'Completed';
                task.Order_signed__c = 'Dacia';
            } else if ( n == 2 ) {
                // Proposition/Nego
                task.Proposition_commerciale__c = true;
            } else if ( n == 3 ) {
                // Invalid status transition: Order --> Proposition/Nego
                task.Proposition_commerciale__c = true;
            } else {
                // Customer discovery
            }

            taskToInsertList.add( task );
        }
        for ( Integer i = 0; i < nbTasksToUpdate; i++ ) {
            Opportunity opp = opportunityList[ nbTasksToInsert + i ];

            taskToUpdateList.add( new Task(
                                      Subject = 'Essai B' + (i + 1),
                                      Type = '',
                                      Type_de_Contact__c = 'Visite',
                                      Priority = 'Normal',
                                      Status = 'To Do',
                                      OwnerId = usrCsmo.Id,
                                      WhatId = opp.Id
                                  )
                                );
        }
        Database.insert( taskToUpdateList, false );

        User usr = LMT_TestUtils_Test.createUser( 'System Administrator', 'Julie', 'Cesar');

        // Unit Tests
        Test.startTest();

        Database.SaveResult[] insertedRecordList = Database.insert( taskToInsertList, false );

        system.runAs(usr) {

            for ( Integer i = 0; i < nbTasksToUpdate; i++ ) {
                Task task = taskToUpdateList[i];

                Integer n = Math.mod( i, 4 );
                if ( n == 0 ) {
                    // Closed Lost
                    task.Order_cancelled__c = true;
                } else if ( n == 1 ) {
                    // Order
                    task.Status = 'Completed';
                    task.Order_signed__c = 'Renault';
                } else if ( n == 2 ) {
                    // Proposition/Nego
                    task.Proposition_commerciale__c = true;
                } else if ( n == 3 ) {
                    // Invalid status transition: Order --> Proposition/Nego
                    task.Proposition_commerciale__c = true;
                } else {
                    // Customer discovery
                    task.ActivityDate = Date.today().addDays(15);
                }
            }

        }
        Database.SaveResult[] updatedRecordList = Database.update( taskToUpdateList, false );

        Test.stopTest();


        // Assertions
        for ( Database.SaveResult result : insertedRecordList ) {
            if ( !result.isSuccess() ) {
                System.debug( LoggingLevel.INFO, '#### TaskTriggerHandler_Test - testUpdateOpportunityStatus - Insert Task - Error messages:' + result.getErrors() );
            }
            System.assert( result.isSuccess() );
        }
        for ( Database.SaveResult result : updatedRecordList ) {
            if ( !result.isSuccess() ) {
                System.debug( LoggingLevel.INFO, '#### TaskTriggerHandler_Test - testUpdateOpportunityStatus - Update Task - Error messages:' + result.getErrors() );
            }
            System.assert( result.isSuccess() );
        }

        List<List<Task>> taskListList = new List<List<Task>>();
        taskListList.add( taskToInsertList );
        taskListList.add( taskToUpdateList );

        Set<Id> opportunityIds = new Set<Id>();
        for ( List<Task> taskList : taskListList ) {
            for ( Task task : taskList ) {
                opportunityIds.add( task.WhatId );
            }
        }

        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>( [SELECT Id, Name, StageName FROM Opportunity WHERE Id IN :opportunityIds] );

        for ( List<Task> taskList : taskListList ) {
            Integer nbTasks = taskList.size();
            for ( Integer i = 0; i < nbTasks; i++ ) {
                Task task = taskList[i];
                Opportunity opp = opportunityMap.get( task.WhatId );

                System.assertNotEquals( null, opp );

                Integer n = Math.mod( i, 4 );

                String errMsg = 'Incorrect Opportunity status n=' + n + ' : Task \'' + task.Subject + '\', Opportunity \'' + opp.Name + '\', Opp.StageName=\'' + opp.StageName + '\'';

                if ( n == 0 ) {
                   // System.assertEquals( LMT_OpportunityUtils_CLS.oppStatus_CLOSED_LOST, opp.StageName, errMsg );
                } else if ( n == 1 ) {
                   // System.assertEquals( LMT_OpportunityUtils_CLS.oppStatus_ORDER, opp.StageName, errMsg );
                } else if ( n == 2 ) {
                  // System.assertEquals( LMT_OpportunityUtils_CLS.oppStatus_PROPOSITION_NEGO, opp.StageName, errMsg );
                } else if ( n == 3 ) {
                  //  System.assertEquals( LMT_OpportunityUtils_CLS.oppStatus_ORDER, opp.StageName, errMsg );
                } else {
                   // System.assertEquals( LMT_OpportunityUtils_CLS.oppStatus_CUSTOMER_DISCOVERY, opp.StageName, errMsg );
                }
            }
        }
    }

    static testmethod void testPreventTaskDeletion() {

        //Create a Dealer account
        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        //Create a CSMO user
        User usrCsmo = LMT_TestUtils_Test.createPartnerUser( 'Jules', 'Cesar', accDealer );

        //Get the Lead RecordType = VN/VO
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName = 'LEA_VN_VO' LIMIT 1].Id;

        //Create a lead
        Lead lead;
        System.runAs(usrCsmo) {
            lead = new Lead(
                LastName = 'LeadTest',
                Status = 'New',
                LeadSource = 'INTERNET',
                Brand__c = 'RENAULT',
                Country__c = 'France',
                TypeOfInterest__c = 'APVA',
                SubType_Of_Interest__c = 'Used Vehicle Request',
                RecordTypeId = leadRecordTypeId
            );
            insert lead;
        }

        //Create a task
        Task task = new Task(
            Subject = 'Essai A',
            Type = 'Email - Outbound',
            Type_de_Contact__c = 'Visite',
            Priority = 'Normal',
            Status = 'Completed',
            OwnerId = usrCsmo.Id,
            WhoId = lead.Id
        );

        User usr = LMT_TestUtils_Test.createUser( 'System Administrator', 'Julien', 'Cesar');

        Test.startTest();

        system.runAs(usr) {

            insert task;

            try {
                delete task;
            } catch (Exception e) {

            }
            List<Task> t = [SELECT Id FROM Task WHERE WhoId = : lead.Id];

            System.assertEquals(t.size(), 1);
        }
        Test.stopTest();
    }

    static testMethod void testPreventTaskInsertion() {

        Opportunity opp;

        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        User usrCsmo = LMT_TestUtils_Test.createPartnerUser( 'Jules', 'Cesar', accDealer, LMT_TestUtils_TEST.dealer_profile );
        User usrEmp1 = LMT_TestUtils_Test.createPartnerUser( 'Rene', 'Goscinny', accDealer, LMT_TestUtils_TEST.dealer_profile );
        User usrAdmin = LMT_TestUtils_Test.createUser( 'System Administrator', 'Julien', 'Cesar');

        Account acc = LMT_TestUtils_Test.createPersonAccount( 'Achille', 'Talon', 'a.talon@test.com', '', '', '', '5 rue des Lilas', 'Paris', '75001', 'France' );

        String oppRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'ShowRoom' LIMIT 1].Id;

        System.runAs(usrAdmin) {
            opp = new Opportunity(
                Name = 'OppTest',
                StageName = LMT_OpportunityUtils_CLS.oppStatus_ORDER,
                RecordTypeId = oppRecordTypeId,
                CloseDate = Date.today().addMonths(1),
                AccountId = acc.Id,
                Opportunity_Country__c = 'France'
            );
            insert opp;
        }

        Test.startTest();

        System.runAs(usrEmp1) {
            Task task = new Task(
                Subject = 'Essai A',
                Type = 'Email - Outbound',
                Type_de_Contact__c = 'Visite',
                Priority = 'Normal',
                Status = 'Completed',
                WhatId = opp.Id
            );
            try {
                insert task;
            } catch (Exception e) {

            }
        }

        Test.stopTest();

    }

    static testMethod void testUpdateRecordTypeEmailTask() {

        Opportunity opp;

        Account accDealer = LMT_TestUtils_Test.createPartnerAccount( 'My Concession', 'my.concession@test.com' );

        User usrAdmin = LMT_TestUtils_Test.createUser( 'System Administrator', 'Julien', 'Cesar');

        Account acc = LMT_TestUtils_Test.createPersonAccount( 'Achille', 'Talon', 'a.talon@test.com', '', '', '', '8 rue des Sentiers', 'Paris', '75001', 'France' );

        String oppRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'ShowRoom' LIMIT 1].Id;

        System.runAs(usrAdmin) {
            opp = new Opportunity(
                Name = 'OppTest',
                StageName = LMT_OpportunityUtils_CLS.oppStatus_ORDER,
                RecordTypeId = oppRecordTypeId,
                CloseDate = Date.today().addMonths(1),
                AccountId = acc.Id,
                Opportunity_Country__c = 'France'
            );
            insert opp;
        }

        Test.startTest();
        Task task = null;
        System.runAs(usrAdmin) {
            task = new Task(
                Subject = 'Essai A',
                Type = 'Email - Outbound',
                Type_de_Contact__c = 'Visite',
                Priority = 'Normal',
                Status = 'Completed',
                WhatId = opp.Id
            );
            try {
                insert task;
            } catch (Exception e) {

            }
        }

        Test.stopTest();

        // test update RecordType Email Task
        Task t = [Select Id, RecordTypeId from Task where Type = 'Email - Outbound' LIMIT 1];
        RecordType recType = [Select Id from RecordType where SObjectType = 'Task' and Name = 'Email' LIMIT 1];
      //  system.assertEquals(String.valueOf(recType.Id), t.RecordTypeId);

    }





}