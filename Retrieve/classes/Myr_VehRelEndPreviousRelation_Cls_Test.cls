@isTest
private class Myr_VehRelEndPreviousRelation_Cls_Test {
  //The deactivation of the user performed OK
  static testMethod void meth010() { 
        
        Account a = new Account();
        a.FirstName = 'toto';
        a.LastName = 'toto';
        a.PersEmailAddress__c = 'toto@toto.com';
        a.CustomerIdentificationNbr__c = '1';
        a.Title__c='title'; 
        a.ShippingPostalCode='1234'; 
        a.RefAddressStreet__c='addressStreet';  
        a.PersLandline__c='1234';
        a.PersMobPhone__c='1234';
        a.AccountSource='ee';
        a.AccSubSource__c='ee';
        a.Account_Sub_Sub_Source__c='ee';
        //a.RecordTypeId = Myr_Users_Utilities_Class.getPersonalAccountRecordType();
        a.ShippingStreet = 'ee';
        a.ShippingCity = 'ddd';
        a.ShippingPostalCode = '12345';
        a.ShippingCountry = 'UK';
        a.PersMobPhone__c = '1234';
        a.HomePhone__c = '1234';
        insert a;
        Account b = new Account();
        b.FirstName = 'titi3';
        b.LastName = 'titi3';
        b.PersEmailAddress__c = 'titi@titi.com';
        b.CustomerIdentificationNbr__c = '2';
        b.Title__c='title3'; 
        b.ShippingPostalCode='12343'; 
        b.RefAddressStreet__c='addressStreet3';  
        b.PersLandline__c='12343';
        b.PersMobPhone__c='12343';
        b.AccountSource='ee'; 
        b.AccSubSource__c='ee';
        b.Account_Sub_Sub_Source__c='ee';
        //b.RecordTypeId = Myr_Users_Utilities_Class.getPersonalAccountRecordType();
        b.ShippingStreet = 'ee3';
        b.ShippingCity = 'ddd3';
        b.ShippingPostalCode = '123453';
        b.ShippingCountry = 'UK';
        b.PersMobPhone__c = '12343';
        b.HomePhone__c = '12343';
        insert b;
        
        Integer nb = [Select count() From Account];
        system.assertEquals(nb, 2); 
        
        VEH_Veh__c v = new VEH_Veh__c();
        v.Name='VF1CR1J0H40046301';
        v.VehicleBrand__c='RENAULT';
        insert v;

        VRE_VehRel__c vr1 = new VRE_VehRel__c();
        vr1.Account__c=a.Id;
        vr1.VIN__c=v.Id;
        insert vr1;
        vr1 = [SELECT Id, EndRelationFlag__c FROM VRE_VehRel__c WHERE Id = :vr1.Id];
        system.AssertEquals(false, vr1.EndRelationFlag__c);
        
        VRE_VehRel__c vr2 = new VRE_VehRel__c();
        vr2.Account__c=b.Id;
        vr2.VIN__c=v.Id;
        insert vr2;
        vr1 = [SELECT Id, EndRelationFlag__c FROM VRE_VehRel__c WHERE Id = :vr1.Id];
        system.AssertEquals(true, vr1.EndRelationFlag__c);
        vr2 = [SELECT Id, EndRelationFlag__c FROM VRE_VehRel__c WHERE Id = :vr2.Id];
        system.AssertEquals(false, vr2.EndRelationFlag__c);
    }      
}