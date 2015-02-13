/*****************************************************************************************
    Name    : VehicleRalationTriggerHandler_Test
    Desc    : To Test the VehicleRalation Trigger Handler
    Approach:
    Author  : Rajavel Baskaran (RNTBCI)
    Project : Rforce
******************************************************************************************/
@isTest
public with sharing class VehicleRelationTriggerHandler_Test {
  //create test data
    private static testMethod void testAccountInsert() {
     Country_Info__c ctr = new Country_Info__c (Name = 'France', Country_Code_2L__c = 'FR', Language__c = 'Français');
        insert ctr;

        User usr = new User (LastName = 'Rotondo', RecordDefaultCountry__c = 'France', alias = 'lro', Email = 'lrotondo@rotondo.com', BypassVR__c = true, EmailEncodingKey = 'UTF-8', UserType__c='SRC', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = Label.PROFILE_SYSTEM_ADMIN, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'lrotondo@lrotondo.com');
        System.runAs(usr) {

         
            Test.startTest();
            List<VRE_VehRel__c> vList = new List<VRE_VehRel__c>();
            Id RTID_COMPANY = [select Id from RecordType where sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' limit 1].Id;
            Account Acc = new Account(FirstName = 'Test1', LastName = 'Acc', Phone = '0000', RecordTypeId = RTID_COMPANY, ProfEmailAddress__c = 'addr1@mail.com', ShippingCity = 'city', ShippingCountry = 'cntry', ShippingState = 'state', ShippingPostalCode = '75013', ShippingStreet = 'my street', ComAgreemt__c = 'Yes');
            insert Acc;
            VEH_Veh__c veh = new VEH_Veh__c(Name='VF1KMRF0533061370',VehicleBrand__c='Renault');
            insert veh;
            VRE_VehRel__c vre = new VRE_VehRel__c(Account__c=Acc.Id,VIN__c=veh.id,Status__c='Active',TypeRelation__c='Owner');
            insert vre;
            vList.add(vre);
 
            VehicleRelationTriggerHandler.onBeforeUpdate(vList, true, null);
            VehicleRelationTriggerHandler.onAfterUpdate(vList, true, null);
            VehicleRelationTriggerHandler.onAfterInsert(vList, true, null);
            VehicleRelationTriggerHandler.onBeforeInsert(vList, true, null);

            VehicleRelationTriggerHandler.onBeforeDelete(true,vList);
          
          delete vre;
            Test.stopTest();
        }
    }
    
    private static testMethod void testAccountDacia() {
     Country_Info__c ctr = new Country_Info__c (Name = 'France', Country_Code_2L__c = 'FR', Language__c = 'Français');
        insert ctr;

        User usr = new User (LastName = 'Rotondo', RecordDefaultCountry__c = 'France', alias = 'lro', Email = 'lrotondo@rotondo.com', BypassVR__c = true, EmailEncodingKey = 'UTF-8', UserType__c='SRC', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = Label.PROFILE_SYSTEM_ADMIN, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'lrotondo@lrotondo.com');
        System.runAs(usr) {

         
            Test.startTest();
            List<VRE_VehRel__c> vList = new List<VRE_VehRel__c>();
            Id RTID_COMPANY = [select Id from RecordType where sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' limit 1].Id;
            Account Acc = new Account(FirstName = 'Test1', LastName = 'Acc', Phone = '0000', AccountBrand__c='Dacia',RecordTypeId = RTID_COMPANY, ProfEmailAddress__c = 'addr1@mail.com', ShippingCity = 'city', ShippingCountry = 'cntry', ShippingState = 'state', ShippingPostalCode = '75013', ShippingStreet = 'my street', ComAgreemt__c = 'Yes');
            insert Acc;
            VEH_Veh__c veh = new VEH_Veh__c(Name='VF1KMRF0533061370',VehicleBrand__c='Dacia');
            insert veh;
            VRE_VehRel__c vre = new VRE_VehRel__c(Account__c=Acc.Id,VIN__c=veh.id,Status__c='Active',TypeRelation__c='Owner');
            insert vre;
            vList.add(vre);
 
            VehicleRelationTriggerHandler.onBeforeUpdate(vList, true, null);
            VehicleRelationTriggerHandler.onAfterUpdate(vList, true, null);
            VehicleRelationTriggerHandler.onAfterInsert(vList, true, null);
            VehicleRelationTriggerHandler.onBeforeInsert(vList, true, null);

            VehicleRelationTriggerHandler.onBeforeDelete(true,vList);
          
          delete vre;
            Test.stopTest();
        }
    }
   
   
    /* BEGIN Rforce QuickRabbit */
    
    /** Test the count of relations **/
    private static testMethod void testCountRelation() {
        //----- 1. Prepare the datasets
        Id rtPersAcc = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' LIMIT 1].Id;
        List<Account> listAcc = new List<Account>();
        Account acc1 = new Account();
        acc1.FirstName = 'Test1';
        acc1.LastName = 'Acc';
        acc1.Phone = '0000';
        acc1.RecordTypeId = rtPersAcc; 
        acc1.ProfEmailAddress__c = 'addr1@mail.com';
        acc1.ShippingCity = 'city';
        acc1.ShippingCountry = 'cntry';
        acc1.ShippingState = 'state';
        acc1.ShippingPostalCode = '75013';
        acc1.ShippingStreet = 'my street';
        acc1.ComAgreemt__c = 'Yes';
        listAcc.add(acc1);
        Account acc2 = new Account();
        acc2.FirstName = 'Test2';
        acc2.LastName = 'Acc';
        acc2.Phone = '0000';
        acc2.RecordTypeId = rtPersAcc; 
        acc2.ProfEmailAddress__c = 'addr1@mail.com';
        acc2.ShippingCity = 'city';
        acc2.ShippingCountry = 'cntry';
        acc2.ShippingState = 'state';
        acc2.ShippingPostalCode = '75013';
        acc2.ShippingStreet = 'my street';
        acc2.ComAgreemt__c = 'Yes';
        listAcc.add(acc2);
        insert listAcc;
        VEH_Veh__c veh1 = new VEH_Veh__c(Name='VF1KMRF0533061370',VehicleBrand__c='Renault');
        insert veh1;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id = :veh1.Id];
        system.assertEquals(0, veh1.CountRelationV2__c);
        VEH_Veh__c veh2 = new VEH_Veh__c(Name='VF1KMRF0533061371',VehicleBrand__c='Renault');
        insert veh2;
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        system.assertEquals(0, veh2.CountRelationV2__c);
        
        //----- 2. Test the count of vehicles after inserting of relation
        VRE_VehRel__c vre1 = new VRE_VehRel__c(Account__c=acc1.Id, VIN__c=veh1.Id, Status__c='Active', TypeRelation__c='Owner');
        insert vre1;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        system.assertEquals(1, veh1.CountRelationV2__c);
        VRE_VehRel__c vre2 = new VRE_VehRel__c(Account__c=acc2.Id, VIN__c=veh1.Id, Status__c='Active', TypeRelation__c='User'); 
        insert vre2;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        system.debug('>>>>> VIN VEH 1' + veh1.Id);
        system.assertEquals(2, veh1.CountRelationV2__c);
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        system.assertEquals(0, veh2.CountRelationV2__c);
        system.debug('>>>>> VIN VEH 2' + veh1.Id);
        
        //----- 3. Test the count of vehicles after updating the relation
        if( VRE_VehRel__c.VIN__c.getDescribe().isUpdateable() ) { //crash on master-detail version because the M/D is not reparentable. But we need this test for lookup relationship
            vre1 = [SELECT Id, VIN__c FROM VRE_VehRel__c WHERE Id = :vre1.Id];
            vre1.VIN__c = veh2.Id;
            update vre1; 
            veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
            system.assertEquals(1, veh1.CountRelationV2__c);
            veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
            system.assertEquals(1, veh2.CountRelationV2__c);
        }
        
        //----- 4. Test the count of vehicles after deleting the relation
        delete vre2;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        if( VRE_VehRel__c.VIN__c.getDescribe().isUpdateable() ) {
            system.assertEquals(0, veh1.CountRelationV2__c);
            system.assertEquals(1, veh2.CountRelationV2__c);
        } else {
            //otherwise nto updated above, so it remains 1 relation
            system.assertEquals(1, veh1.CountRelationV2__c);
            system.assertEquals(0, veh2.CountRelationV2__c);
        }     
        
        //----- 5. Test the count of vehicles after undeleting the relation
        undelete vre2;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        if( VRE_VehRel__c.VIN__c.getDescribe().isUpdateable() ) {
            system.assertEquals(1, veh1.CountRelationV2__c);
            system.assertEquals(1, veh2.CountRelationV2__c);
        } else {
            system.assertEquals(2, veh1.CountRelationV2__c);
            system.assertEquals(0, veh2.CountRelationV2__c);
        }
        
    }
    
    /** Test more that one relation inserted to count the number of relations **/
    private static testMethod void testCountRelationVolume_1() {
        //----- 1. Prepare the datasets
        Id rtPersAcc = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' LIMIT 1].Id;
        List<Account> listAcc = new List<Account>();
        for( Integer i = 0; i < 300; i++ ) {
            Account acc = new Account();
            acc.FirstName = 'Test' + String.valueOf(i+1);
            acc.LastName = 'Acc';
            acc.Phone = '0000';
            acc.RecordTypeId = rtPersAcc; 
            acc.ProfEmailAddress__c = acc.FirstName + '.' + acc.LastName + '@mail.com';
            acc.ShippingCity = 'city';
            acc.ShippingCountry = 'cntry';
            acc.ShippingState = 'state';
            acc.ShippingPostalCode = '75013';
            acc.ShippingStreet = 'my street';
            acc.ComAgreemt__c = 'Yes';
            listAcc.add(acc);
        }
        insert listAcc;
        VEH_Veh__c veh1 = new VEH_Veh__c(Name='VF1KMRF0533061370',VehicleBrand__c='Renault');
        insert veh1;
        List<VRE_VehRel__c> listVREs = new List<VRE_VehRel__c>(); 
        for( Account acc : listAcc) {
            VRE_VehRel__c vre = new VRE_VehRel__c(Account__c=acc.Id, VIN__c=veh1.Id, Status__c='Active', TypeRelation__c='Owner');
            listVREs.add(vre);
        }
        insert listVREs;
        
        //----- 2. Check the number of relations 
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        system.assertEquals(listAcc.size(), veh1.CountRelationV2__c);
    }
    
    /** Test more that one relation inserted to count the number of relations **/
    private static testMethod void testCountRelationVolume_2() {
        //----- 1. Prepare the datasets
        Id rtPersAcc = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' LIMIT 1].Id;
        List<Account> listAcc = new List<Account>();
        for( Integer i = 0; i < 200; i++ ) {
            Account acc = new Account();
            acc.FirstName = 'Test' + String.valueOf(i+1);
            acc.LastName = 'Acc';
            acc.Phone = '0000';
            acc.RecordTypeId = rtPersAcc; 
            acc.ProfEmailAddress__c = acc.FirstName + '.' + acc.LastName + '@mail.com';
            acc.ShippingCity = 'city';
            acc.ShippingCountry = 'cntry';
            acc.ShippingState = 'state';
            acc.ShippingPostalCode = '75013';
            acc.ShippingStreet = 'my street';
            acc.ComAgreemt__c = 'Yes';
            listAcc.add(acc);
        }
        insert listAcc;
        List<VEH_Veh__c> listVehs = new List<VEH_Veh__c>();
        for( Integer i = 0; i < listAcc.size(); ++i ) {
            VEH_Veh__c veh1 = new VEH_Veh__c(
                Name='VF1KMRF0533061' + ((i <= 10) ? '00' : ((i<=99) ? '0' : '') )+ String.valueOf(i),
                VehicleBrand__c='Renault');
            listVehs.add(veh1);
        }
        insert listVehs;
        
        List<VRE_VehRel__c> listVREs = new List<VRE_VehRel__c>(); 
        for( Integer i = 0; i < listAcc.size(); ++i) {
            VRE_VehRel__c vre = new VRE_VehRel__c(Account__c=listAcc[i].Id, VIN__c=listVehs[i].Id, Status__c='Active', TypeRelation__c='Owner');
            listVREs.add(vre);
        }
        insert listVREs;
        
        //----- 2. Check the number of relations 
        listVehs = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id IN :listVehs];
        for( VEH_Veh__c veh : listVehs) {
            system.assertEquals(1, veh.CountRelationV2__c); 
        }
    }
    
    /** Test that the count relation properly works for community users **/
    private static testmethod void testCountRelationCommunityUsers() {
        //----- 1. Prepare the datasets
        Id rtPersAcc = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' and DeveloperName = 'CORE_ACC_Personal_Account_RecType' LIMIT 1].Id;
        List<Account> listAcc = new List<Account>();
        Account acc1 = new Account();
        acc1.FirstName = 'Test1';
        acc1.LastName = 'Acc';
        acc1.Phone = '0000';
        acc1.RecordTypeId = rtPersAcc; 
        acc1.ProfEmailAddress__c = 'addr1@mail.com';
        acc1.ShippingCity = 'city';
        acc1.ShippingCountry = 'cntry';
        acc1.ShippingState = 'state';
        acc1.ShippingPostalCode = '75013';
        acc1.ShippingStreet = 'my street';
        acc1.ComAgreemt__c = 'Yes';
        listAcc.add(acc1);
        Account acc2 = new Account();
        acc2.FirstName = 'Test2';
        acc2.LastName = 'Acc';
        acc2.Phone = '0000';
        acc2.RecordTypeId = rtPersAcc; 
        acc2.ProfEmailAddress__c = 'addr1@mail.com';
        acc2.ShippingCity = 'city';
        acc2.ShippingCountry = 'cntry';
        acc2.ShippingState = 'state';
        acc2.ShippingPostalCode = '75013';
        acc2.ShippingStreet = 'my street';
        acc2.ComAgreemt__c = 'Yes';
        listAcc.add(acc2);
        insert listAcc;
        VEH_Veh__c veh1 = new VEH_Veh__c(Name='VF1KMRF0533061370',VehicleBrand__c='Renault');
        insert veh1;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id = :veh1.Id];
        system.assertEquals(0, veh1.CountRelationV2__c);
        VEH_Veh__c veh2 = new VEH_Veh__c(Name='VF1KMRF0533061371',VehicleBrand__c='Renault');
        insert veh2;
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        system.assertEquals(0, veh2.CountRelationV2__c);
        
        //----- 2. Test the count of vehicles after inserting of relation
        VRE_VehRel__c vre1 = new VRE_VehRel__c(Account__c=acc1.Id, VIN__c=veh1.Id, Status__c='Active', TypeRelation__c='Owner');
        insert vre1;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        system.assertEquals(1, veh1.CountRelationV2__c);
        VRE_VehRel__c vre2 = new VRE_VehRel__c(Account__c=acc2.Id, VIN__c=veh1.Id, Status__c='Active', TypeRelation__c='User'); 
        insert vre2;
        veh1 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh1.Id];
        system.assertEquals(2, veh1.CountRelationV2__c);
        
        //----- 3. Prepare a community user
        Profile profileCustCommunity = [SELECT Id FROM Profile WHERE Profile.Name =  'HeliosCommunity'];
        acc2 = [SELECT PersonContactId FROM Account WHERE Id = :acc2.Id];
        User u = new User();
        u.ContactId = acc2.PersonContactId;
        u.ProfileId = profileCustCommunity.Id;
        u.FirstName = 'testCountRelation';
        u.LastName = 'Vehicle';
        u.Email = u.FirstName + u.LastName + '@example.com';
        u.Username = u.FirstName + u.LastName + '@example.com.renault.countrelation';
        u.Alias = u.FirstName.left(1) + u.LastName.left(7);
        u.CommunityNickName = u.FirstName + u.LastName;
        u.RecordDefaultCountry__c = 'France' ;
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'fr_FR_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'fr';
        insert u;
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        system.assertEquals(0, veh2.CountRelationV2__c);
        VRE_VehRel__c vre3 = new VRE_VehRel__c(Account__c=acc2.Id, VIN__c=veh2.Id, Status__c='Active', TypeRelation__c='User');
        system.runAs(u) {
            insert vre3;
        }
        veh2 = [SELECT Id, CountRelationV2__c FROM VEH_Veh__c WHERE Id=:veh2.Id];
        system.assertEquals(1, veh2.CountRelationV2__c);
    }
    
    /* END Rforce QuickRabbit */
    
}