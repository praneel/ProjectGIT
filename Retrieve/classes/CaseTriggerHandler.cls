public with sharing class CaseTriggerHandler {


    //Before Insert method start
    public static void onBeforeInsert(list <Case> listCase, boolean isInsert, Map <Id, Case> oldMap){
        
    Id vehid;
    Id accid;
    Id entid;
    Id entidins, bhrsid;
    Date enddt, srtdt;
    String actname;
    List<Entitlement> ent = new List<Entitlement>();
    List<Account> a = new List<Account>();
    List<Account> conflictsAcc = new List<Account>();
    Account chkMidCEAcc;
    Contact chkCon;
    String IKRUserId = System.Label.IKRUserId;
    User u = [Select Id, RecordDefaultCountry__c, Division, Department from User Where Id = : UserInfo.getUserId()];

    for (Case cas : listCase) {
        if (cas.Status =='Closed'){
            cas.Closed_by__c=UserInfo.getUserId();
            cas.Case_Closed_Department__c=u.Division;
            cas.Case_Closed_Division__c=u.Department;
            if(cas.Resolved_by__c==null){
                cas.Resolved_by__c=UserInfo.getUserId();
            }
            if(cas.Opened_by__c==null){
                cas.Opened_by__c=UserInfo.getUserId();
            }
        }
        if (cas.Status =='Resolved'){
            cas.Resolved_by__c=UserInfo.getUserId();
            cas.Case_Resolved_Department__c=u.Division;
            cas.Case_Resolved_Division__c=u.Department;
            if(cas.Opened_by__c==null){
                cas.Opened_by__c=UserInfo.getUserId();
            }
        }
        if (cas.Status =='New'){
            cas.New_by__c=UserInfo.getUserId();
        }
        if (cas.Status =='Open'){
            cas.Opened_by__c=UserInfo.getUserId();
        }
        if (cas.Status =='Waiting for reply'){
            cas.Waited_by__c=UserInfo.getUserId();
            if(cas.Opened_by__c==null){
                cas.Opened_by__c=UserInfo.getUserId();
            }
        }
        if (cas.Status =='Answered'){
            cas.Answered_by__c=UserInfo.getUserId();
            if(cas.Opened_by__c==null){
                cas.Opened_by__c=UserInfo.getUserId();
            }
        }
    }

    for (Case cas : listCase) {
        //added for MIdCE
        /*if (u.RecordDefaultCountry__c == 'MidCE'||u.RecordDefaultCountry__c == 'UK-IE') {
            Try {
                chkMidCEAcc = [select Country__c, MIDCE_Country__c From account where id = :cas.AccountId];
            }
            Catch (exception e) {
                System.debug('NullPointer' + e.getmessage());
            }
           
           if (chkMidCEAcc != null) {
                if (cas.CountryCase__c == chkMidCEAcc.Country__c) {
                    cas.CountryCase__c = chkMidCEAcc.MIDCE_Country__c;
                } else {
                    //     cas.CountryCase__c = cas.CountryCase__c;
                }
            }
        }*/
        
        /*Functionality 1 */
        if (cas.SuppliedEmail != null) {
            try {
                System.debug('cas.SuppliedEmail>>>>>>' + cas.SuppliedEmail);
                a = [select Id, Name, PersonContactId from Account where RecordtypeId = '012b0000000awv8AAA' and PersEmailAddress__c = : cas.SuppliedEmail limit 1];
                if (a.size() > 0) {
                    cas.AccountId = a[0].Id;
                    cas.contactId = a[0].PersonContactId;
                }
            } catch (Exception e) {
                System.debug('case Error' + e);
            }

        }


        /*Functionality 2 */
        if (cas.VIN_Web__c != null) {
            try {
                Id VINId = [select Id from VEH_Veh__c where Name = :cas.VIN_Web__c].id;
                cas.VIN__c = VINId;
                cas.SuppliedName = cas.FirstName_Web__c + ' ' + cas.LastName_Web__c;
            } catch (Exception e) {}
        }



        /*Functionality 2 */
        if (cas.AccountId != null && cas.SuppliedEmail != null) {
            try {
                conflictsAcc = [Select Id, Name, PersEmailAddress__c, PersMobPhone__c, Phone, BillingStreet, BillingCity, BillingState From account where id = :cas.AccountId];

                if (conflictsAcc.size() > 0) {
                    if ((conflictsAcc[0].phone == cas.SuppliedPhone) && (conflictsAcc[0].PersEmailAddress__c == cas.SuppliedEmail) && (conflictsAcc[0].BillingStreet == cas.Address_Web__c) && (conflictsAcc[0].BillingCity == cas.City_Web__c) && (conflictsAcc[0].BillingState == cas.State_Web__c)) {
                        cas.AccountConflicts_web__c = false;
                    } else {
                        cas.AccountConflicts_web__c = true;
                    }
                }
            } catch (Exception e) {}
        }

/*
        if (u.RecordDefaultCountry__c == 'MidCE') {
            system.debug('Inside MIDCE LOOP CASEBEFORE INSERT');


            if (!String.isBlank(cas.AccountId)) {
                Try {
                    chkMidCEAcc = [select Country__c, MIDCE_Country__c From account where id = :cas.AccountId];
                }
                Catch(Exception e1) {
                    System.debug('Null Pointer' + e1.getmessage());
                }
                if (chkMidCEAcc != null) {
                    if (cas.CountryCase__c == chkMidCEAcc.Country__c) {
                        cas.CountryCase__c = chkMidCEAcc.MIDCE_Country__c;

                    } else {
                        // cas.CountryCase__c = cas.CountryCase__c;

                    }
                }
            }
        }
*/

        if (u.RecordDefaultCountry__c == 'MidCE'||u.RecordDefaultCountry__c == 'UK-IE'||u.RecordDefaultCountry__c == 'Nordic'||u.RecordDefaultCountry__c == 'Poland') {

            if (!String.isBlank(cas.ContactId)) {
                try {
                    chkCon = [select Country__c From contact where id = :cas.ContactId];
                } catch (Exception e) {
                    system.debug('Nullpointer' + e.getmessage());
                }

                if (chkCon.Country__c != null) {
                    if (cas.CountryCase__c == null) {
                        cas.CountryCase__c = chkCon.Country__c;
                        system.debug('IF for===' + cas.CountryCase__c);
                    } else {
                        // cas.CountryCase__c = cas.CountryCase__c;
                        system.debug('ELSE for===' + cas.CountryCase__c);
                    }
                }
            }
        }

        /*Functionality 3 for SLA Process added by sumanth*/
        if (cas.EntitlementId == null) {
            if (cas.AccountId != null) {
                try {
                    entid = [SELECT Id from Entitlement where AccountId = :cas.AccountId LIMIT 1].Id;
                    bhrsid = [SELECT Id FROM BusinessHours where Name = :cas.CountryCase__c].Id;
                    system.debug('entitlementid' + entid);
                } catch (Exception entide) {
                    system.debug('entide' + entide);
                }
                if (entid != null) {
                    cas.EntitlementId = entid;
                } else {
                    if (bhrsid != null) {
                        srtdt = system.today() - 1;
                        enddt = srtdt.addYears(30);
                        ent.add(new Entitlement
                                (AccountId = cas.AccountId,
                                 Name = 'EntName',
                                 Type = 'Web Support',
                                 BusinessHoursId = bhrsid,
                                 StartDate = srtdt,
                                 EndDate = enddt,
                                 SlaProcessId = System.Label.RForce_SlaProcessId));
                    } else {
                        srtdt = system.today() - 1;
                        enddt = srtdt.addYears(30);
                        ent.add(new Entitlement
                                (AccountId = cas.AccountId,
                                 Name = 'EntName',
                                 Type = 'Web Support',
                                 BusinessHoursId = '01mb0000000Kr1w',
                                 StartDate = srtdt,
                                 EndDate = enddt,
                                 SlaProcessId = System.Label.RForce_SlaProcessId));
                    }
                    try {
                        insert ent;
                        system.debug('enttitlement insert' + ent);
                        entidins = [SELECT Id FROM Entitlement WHERE AccountId = :cas.AccountId].Id;
                        cas.EntitlementId = entidins;
                    } catch (Exception Ex) {
                        system.debug('Ex' + Ex);
                    }
                }
                if (bhrsid != null) {
                    cas.BusinessHoursId = bhrsid;
                } else {
                    cas.BusinessHoursId = '01mb0000000Kr1w' ;
                }
            }//END OF ACCOINTID NULL
        }


        //fonctionnality for IKR user
        if (cas.AccountId != null) {
            Account persoacc = [Select Id, RecordtypeId, personcontactID from Account where Id = : cas.AccountId];
            System.debug('### Case Account Id' + cas.AccountID);
            RecordType recType = [Select Name,DeveloperName, Id From RecordType where SobjectType = 'Account' and Id = :persoacc.RecordtypeId];
            if (recType.DeveloperName == 'CORE_ACC_Personal_Account_RecType' && (String)cas.OwnerId == IKRUserId) {
                System.debug('### Case in Trigger UpdateContactOnCase');
                System.debug('### Case person account  Id' + persoacc.personcontactID);
                cas.ContactId = persoacc.personcontactID;
            }
        }



        /*Added by sumanth for kilometers update of vehicle from case kilometers*/

        if (cas.VIN__c != null) {
            vehid = cas.VIN__c;
            try {
                VEH_Veh__c veh = [SELECT KmCheck__c FROM VEH_Veh__c WHERE Id = :vehid];
                if (veh.KmCheck__c == null && cas.Kilometer__c == null) {
                    veh.KmCheck__c = 0;
                    veh.KmCheckDate__c = system.today();
                } else if (veh.KmCheck__c == null || (veh.KmCheck__c < cas.Kilometer__c)) {
                    veh.KmCheck__c = cas.Kilometer__c;
                    veh.KmCheckDate__c = system.today();
                }
                update veh;
            } catch (Exception vehe) {
                system.debug(vehe);
            }
        }

    }
    
    
     //Added for community to add the delaer details to case 17/06/2014
    //Set<Id> csids=new Set<Id>();
    //List<Case> caslist=new List<Case>();
    for (Case cas : listCase) {
        User usr=[Select Id,Profile.Name from user where id=: UserInfo.getUserId()];
        System.debug('#### Rforce - USERID ###' + userInfo.getUserId());
        System.debug('### Mehdi 1' + usr.Id);
        if(usr.Id!=null && usr.Profile.Name=='Core-Service Profile Community'){
            User us=[Select Id,ContactId from user where id=: UserInfo.getUserId()];
            System.debug('### Mehdi 2' + us.Id);
                if(us.ContactId!=null){
                    Contact con=[Select Id,AccountId FROM Contact Where Id=:us.ContactId];
                    Account acc=[Select DealershipStatus__c from Account where Id=:con.AccountId];
                    System.debug('### Mehdi 3' + con.Id);
                    System.debug('### Mehdi 4' + acc.Id);
                    if(con.Id!=null && con.AccountId!=null && acc.DealershipStatus__c=='Active'){            
                        cas.DealerContactLN__c=con.Id;
                        cas.Dealer__c=con.AccountId;
                    }
                }           
        }    
    }

    
    
    }
    //Before Insert method end
    
    

    //Before update method start
    public static void onBeforeUpdate(list < Case > listCase, boolean isInsert, Map < Id, Case > oldMap){
        
    Id vehid;
    Id accid;
    Id entid;
    Id entidins, bhrsid;
    Date enddt, srtdt;
    List<Entitlement> ent = new List<Entitlement>();
    List<Task> TasksList = new List<Task>();
    List<Task> tasksListToClose = new List<Task>();
    set<id>  taskList = new set <id>();    
    Account chkMidCEAcc;
    Contact chkCon;
    RecordType rt=null;
    String IKRUserId = System.Label.IKRUserId; 
    User u = [Select Id, profile.id , RecordDefaultCountry__c, Division, Department from User Where Id = : UserInfo.getUserId()];  
    
    // Added by Moctar for CS
    try {
    String cinfo = Country_Info__c.getInstance(u.RecordDefaultCountry__c).Case_RecordType__c;
    rt = [select Id from RecordType where DeveloperName = : cinfo limit 1];
    } catch(Exception e) {}
    // End Code Added by Moctar for CS

for (Case cas : listCase) {
        Case oldCase = (Case)Trigger.oldMap.get(cas.ID);
        if (cas.Status =='Closed' && cas.Status!=oldCase.Status){
            cas.Closed_by__c=UserInfo.getUserId();
            cas.Case_Closed_Department__c=u.Division;
            cas.Case_Closed_Division__c=u.Department;
            if(cas.Resolved_by__c==null){
                cas.Resolved_by__c=UserInfo.getUserId();
            }
        }
        if (cas.Status =='Resolved' && cas.Status!=oldCase.Status){
            cas.Resolved_by__c=UserInfo.getUserId();
            cas.Case_Resolved_Department__c=u.Division;
            cas.Case_Resolved_Division__c=u.Department;
        }
        if (cas.Status =='New' && cas.Status!=oldCase.Status){
            cas.New_by__c=UserInfo.getUserId();
        }
        if (cas.Status =='Open' && cas.Status!=oldCase.Status){
            cas.Opened_by__c=UserInfo.getUserId();
        }
        if (cas.Status =='Waiting for reply' && cas.Status!=oldCase.Status){
            cas.Waited_by__c=UserInfo.getUserId();
        }
        if (cas.Status =='Answered' && cas.Status!=oldCase.Status){
            cas.Answered_by__c=UserInfo.getUserId();
        }
        if (oldCase.Status=='New' && cas.Status!=oldCase.Status && cas.Opened_by__c==null){
            cas.Opened_by__c=UserInfo.getUserId();
        }
        if (cas.Spam__c == true){
            cas.Status = 'Closed';
            cas.Closure_reason__c = 'Standard closure';
        } 
        // Added by Moctar for CS
        if (u.RecordDefaultCountry__c == 'CS') {
            if (cas.Origin.contains('@')) {
                cas.EmailOrigine__c = cas.Origin;
                cas.Origin = 'Email';
            }
        }
        if (cas.RecordTypeId != rt.id && u.profile.id != System.Label.PROFILE_SYSTEM_ADMIN && u.profile.id != System.Label.PROFILE_INTEGRATION) {
             cas.RecordTypeId = rt.id;
        }
        // End code added by Moctar
    }
      
    for (Case cas : listCase) {
        // Added for MIDCE countries by Rajavel
        if (u.RecordDefaultCountry__c == 'MidCE') {
            Try {
                chkMidCEAcc = [select Country__c, MIDCE_Country__c From account where id = :cas.AccountId];
            }
            catch (Exception e) {
                system.debug('Nullpointer' + e.getmessage());
            }
            if (chkMidCEAcc != null) {
                if (cas.CountryCase__c == chkMidCEAcc.Country__c) {
                    cas.CountryCase__c = chkMidCEAcc.MIDCE_Country__c;
                } else {
                    cas.CountryCase__c = cas.CountryCase__c;
                    system.debug('===' + cas.CountryCase__c);
                }
            }
        }
    }
    
    



    for (Case cas : listCase) {

        // Added for MIDCE countries by Rajavel
        if (u.RecordDefaultCountry__c == 'MidCE') {

            try {
                chkCon = [select Country__c, MIDCE_Country__c From contact where id = :cas.ContactId];
            } catch (Exception e) {
                system.debug('Nullpointer' + e.getmessage());
            }

            if (chkCon != null) {
                if (cas.CountryCase__c == null) {
                    cas.CountryCase__c = chkCon.MIDCE_Country__c;
                } else {
                    cas.CountryCase__c = cas.CountryCase__c;
                }
            }
        }
    }

     /*it is used for E2C in order to not link case/Acc when country case et Acc country are differents, except for multi country*/   
     for (Case caseRec : listCase) {
            if (caseRec.AccountId != null && caseRec.SuppliedEmail != null){
            System.debug('IDAccount' + caseRec.AccountId);
            Account accCheck = [select id, Country__c,MIDCE_Country__c, NR_country__c from Account where Id = : caseRec.AccountId];
                if (accCheck.NR_country__c==null && accCheck.MIDCE_Country__c==null){
            System.debug('CountryCase' + caseRec.CountryCase__c );
            System.debug('CountryAccount' + accCheck.Country__c);     
                if (caseRec.CountryCase__c != accCheck.Country__c){
                    caseRec.AccountId = null;
                    caseRec.contactId = null;
                }
            }
        }
    }
    
    
    /* It is not possible to close Case with tasks not completed Global rule*/
    /*for (Case caseRec : listCase) {
        if (caseRec.Status == 'Closed'){
            TasksList = [select Id, Status from Task where WhatId = :caseRec.Id];
            System.debug('TaskList' + TasksList.size());
            if (TasksList.size() > 0) {
                for (Task tsk : TasksList) {
                    if (tsk.Status != 'Completed'){
                    System.debug('TaskStatus' + tsk.Status);
                    tsk.Status='Completed';
                    tasksListToClose.add(tsk);
                    }
                }               
            }
        }  
    }
    
    if (tasksListToClose.size() >0){
    update tasksListToClose;
    }
    */
    
    /* It is not possible to close Case with tasks not completed, use WithoutSharing to update it*/
        Rforce_withoutSharing.runCode(listCase);
    
     /*Permit to do not allow update case from IKR where status is different to Draft*/   
     for (Case caseRec : listCase) {
         Case oldCase = (Case)Trigger.oldMap.get(caseRec.ID);
         if ((String)u.Id == IKRUserId){
         System.debug('IKR : STEP 1');
             if (caseRec.Status!=oldCase.Status && caseRec.Status=='NEW' && oldCase.Status !='Draft'){
             caseRec.addError('ERROR: IKR TRY TO CHANGE STATUS!!!');
             }        
         }
     }  


    /*Functionality 3 for SLA Process added by sumanth*/
    for (Case cas : listCase) {
        if (cas.EntitlementId == null) {
            if (cas.AccountId != null) {
                try {
                    entid = [SELECT Id from Entitlement where AccountId = :cas.AccountId LIMIT 1].Id;
                    bhrsid = [SELECT Id FROM BusinessHours where Name = :cas.CountryCase__c].Id;
                    system.debug('entitlementid' + entid);
                } catch (Exception entide) {
                    system.debug('entide' + entide);
                }
                if (entid != null) {
                    cas.EntitlementId = entid;
                } else {
                    if (bhrsid != null) {
                        srtdt = system.today() - 1;
                        enddt = srtdt.addYears(30);
                        ent.add(new Entitlement
                                (AccountId = cas.AccountId,
                                 Name = 'EntName',
                                 Type = 'Web Support',
                                 BusinessHoursId = bhrsid,
                                 StartDate = srtdt,
                                 EndDate = enddt,
                                 SlaProcessId = System.Label.RForce_SlaProcessId));
                    } else {
                        srtdt = system.today() - 1;
                        enddt = srtdt.addYears(30);
                        ent.add(new Entitlement
                                (AccountId = cas.AccountId,
                                 Name = 'EntName',
                                 Type = 'Web Support',
                                 BusinessHoursId = '01mb0000000Kr1wAAC',
                                 StartDate = srtdt,
                                 EndDate = enddt,
                                 SlaProcessId = System.Label.RForce_SlaProcessId));
                    }
                    try {
                        insert ent;
                        system.debug('enttitlement insert' + ent);
                        entidins = [SELECT Id FROM Entitlement WHERE AccountId = :cas.AccountId].Id;
                        cas.EntitlementId = entidins;
                    } catch (Exception Ex) {
                        system.debug('Ex' + Ex);
                    }
                }
                if (bhrsid != null) {
                    cas.BusinessHoursId = bhrsid;
                } else {
                    cas.BusinessHoursId = '01mb0000000Kr1wAAC' ;
                }
            }//END OF ACCOINTID NULL
        }

    }
    
    }
    //Before update method end
    
    
       
     //After Insert method start
    public static void onAfterInsert(list <Case> listCase, boolean isInsert, Map <Id, Case> oldMap){
        
       //CAS : request REQ-00290
    List<Account> AccountList = new List<Account>();
    List<Account> AccountCase = new List<Account>();
    
    for (Case cas : listCase) {
        System.debug('Type = ' + cas.Type);
        System.debug('AccountId = ' + cas.AccountId);
        if (cas.Type=='Complaint' && cas.AccountId != null) {
            AccountCase = [Select StopComRCFrom__c,StopComRCTo__c from Account where Id = : cas.AccountId];
            System.debug('Size of the list to be updated = ' + AccountCase.size());
            if (AccountCase.size() > 0) {
                for (Account Ac : AccountCase) {
                    Ac.StopComRCFrom__c = cas.CreatedDate;
                    Ac.StopComRCTo__c = null;
                    AccountList.add(Ac);
                }
            }
        }
    }
    update AccountList;
    /*
 //Added for community to add the delaer details to case 17/06/2014
    Set<Id> csids=new Set<Id>();
    List<Case> caslist=new List<Case>();
    for (Case cas : listCase) {
        User usr=[Select Id,Profile.Name from user where id=: cas.CreatedById];
        if(usr.Id!=null && usr.Profile.Name=='Core-Service Profile Community'){
            csids.add(cas.id);
        }
    }
    for (Case c : [Select DealerContactLN__c,Dealer__c,CreatedById from Case where id IN : csids]) { 
        User u=[Select Id,ContactId from user where id=: c.CreatedById];
        if(U.ContactId!=null){
            Contact con=[Select Id,AccountId FROM Contact Where Id=:U.ContactId];
            Account acc=[Select DealershipStatus__c from Account where Id=:con.AccountId];
            if(con.Id!=null && con.AccountId!=null&& acc.DealershipStatus__c=='Active'){            
                c.DealerContactLN__c=con.Id;
                c.Dealer__c=con.AccountId;
                caslist.add(c);
            }
        }
    } 
    update caslist;
    */
    }
    
    
    //After Insert method end
    
      //After Update method start
    public static void onAfterUpdate(list <Case> listCase, boolean isInsert, Map <Id, Case> oldMap, list <Case> oldCase){
        
    List<Goodwill__c> gwApproveList = new List<Goodwill__c>();
    List<Goodwill__c> gwRefuseList = new List<Goodwill__c>();
    List<Goodwill__c> goodWillApprove = new  List<Goodwill__c>();
    List<Goodwill__c> goodWillRefuse = new List<Goodwill__c>();

    RecordType[] recType = [Select Name, Id From RecordType where SobjectType = 'Goodwill__c'];

    System.debug('CheckRecursive' + Rforce_CheckRecursive_Utility.hasAlreadyUpdated() );
    
      User u = [Select RecordDefaultCountry__c from User Where Id = : UserInfo.getUserId()];// Code added by Moctar for CS
      
      List <Case> lstCaseTeam = new List<Case> {};

    if (u.RecordDefaultCountry__c == 'CS') {
        for (Integer i = (listCase.size() - 1); i >= 0 ; i--) {
            String NewOwner = listCase[i].OwnerId;
            String OldOwner = oldCase[i].OwnerId;

            if (NewOwner.substring(0, 3) == '005' && OldOwner.substring(0, 3) == '00G')
            lstCaseTeam.add(oldCase[i]);
        }

        if (lstCaseTeam.size() > 0) {
            Rforce_CaseTeam.addToCaseTeam(lstCaseTeam);
        }
    }
    // End Code added by Moctar for CS

    if (!Rforce_CheckRecursive_Utility.hasAlreadyUpdated()) {

        for (Case caseRec : listCase) {
            if (caseRec.GWStatus__c == 'Refused') {
                goodWillRefuse = [select Id, GoodwillStatus__c from Goodwill__c where Case__c = :caseRec.Id];
                if (goodWillRefuse.size() > 0) {
                    for (Goodwill__c gwc : goodWillRefuse) {
                        gwc.GoodwillStatus__c = 'Refused' ;
                        System.debug('Goodwill status to be updated to Rejected' + gwc);
                        gwRefuseList.add(gwc);
                    }
                }
                System.debug('Size of the List to be Updated>>>>>>>' + gwApproveList.size());
                update gwRefuseList;

            }
            if (caseRec.GWStatus__c == 'Approved') {
                goodWillApprove = [select Id, GoodwillStatus__c, DeviationReason__c, SRCDecidedRate__c from Goodwill__c where Case__c = :caseRec.Id and GoodwillStatus__c != 'Refused' ];
                System.debug('GoodWillApproveSize' + goodWillApprove.size());
                if (goodWillApprove.size() > 0) {
                    System.debug('STEP 2');
                    for (Goodwill__c gwc : goodWillApprove) {
                        System.debug('Goodwill status to be updated to Approved' + gwc);
                        if ((gwc.SRCDecidedRate__c != null) && (gwc.DeviationReason__c == null)) {
                            caseRec.addError('You must select the Deviation Reason for all the Goodwill');
                        } else {
                            gwc.GoodwillStatus__c = 'Approved' ;
                            gwApproveList.add(gwc);
                        }
                    }
                }
                try {
                    update gwApproveList;
                    Rforce_CheckRecursive_Utility.setAlreadyUpdated();
                } catch (DMLException e) {
                    System.debug('DML Exception ::::>' + e.getMessage());
                }
            }
        }


        //CAS : request REQ-00290
        List<Account> AccountList = new List<Account>();
        List<Account> AccountCase = new List<Account>();

        for (Case cas : listCase) {
            System.debug('Type = ' + cas.Type);
            System.debug('AccountId = ' + cas.AccountId);
            System.debug('Status = ' + cas.status);
            if (cas.Type == 'Complaint' && cas.AccountId != null) {
                AccountCase = [Select StopComRCFrom__c, StopComRCTo__c from Account where Id = : cas.AccountId];
                System.debug('Size of the list to be updated = ' + AccountCase.size());
                if (AccountCase.size() > 0) {
                    for (Account Ac : AccountCase) {
                        if (cas.status == 'Closed') {
                            Ac.StopComRCTo__c = Datetime.now();
                        } else {
                            Ac.StopComRCTo__c = null;
                        }
                        Ac.StopComRCFrom__c = cas.CreatedDate;
                        AccountList.add(Ac);
                    }
                }
            }
        }
       // update AccountList;

        Set<Id> csids = new Set<Id>();
        for (Case c : listCase) {
            if (c.Live_Chat_Transcript_ID__c != null) {
                csids.add(c.Id);
            }
        }
        for (Case cs : [Select Id, Live_Chat_Transcript_ID__c from case where Id IN  : csids]) {
            try {
                LiveChatTranscript lct = [SELECT CaseId FROM LiveChatTranscript where Id = : cs.Live_Chat_Transcript_ID__c];
                if (lct.CaseId == null) {
                    lct.CaseId = cs.Id;
                }
                update lct;
            } catch (Exception e) {
                system.debug(e);
            }
        }

        Rforce_CheckRecursive_Utility.setAlreadyUpdated();
        }
    }
      //After Update method end    
}