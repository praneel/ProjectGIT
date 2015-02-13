@isTest
public class  Rforce_VehicleAttributes_Test {

    static User getEnvSetup(){
        // Get the context of a user
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'rvtes_1', Email='rvtestuser_1@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr', 
          LocaleSidKey='fr', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='rvtestuser_1@testorg.com', RecordDefaultCountry__c='France');

    
    
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            system.debug('Userlanguage: ' + u.LanguageLocaleKey);
          return u;
    }

static testMethod void testVehicleAttributes(){
    
        // Set up the envioronment 
        User u = getEnvSetup();
     //   User u = getEnvSetup();
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Visit the page so we also run the constructor code
        PageReference pageRef = Page.Rforce_VehicleAttributes;
        Test.setCurrentPage(pageRef);
    
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
      Test.startTest();          
        

   //   System.runAs(u) {

            // Test the methods in the VehicleAttributes class in test mode.
            vehController.WarrantyDataSource.Test = true;
            vehController.MaintDataSource.Test = true;
            vehController.OTSDataSource.Test = true;
            vehController.ContractDataSource.Test = true;
            vehController.WarrantyHistoryDataSource.Test = true;
            vehController.WarrantyHistoryDetailDataSource.Test = true;

            vehController.getWarrantyData();
            // Test it populated wpList
            System.assert(vehController.wpList.size() > 0);
            vehController.getOTSData();
            System.assert(vehController.otsPropList.size() > 0);
            vehController.getMaintenanceData();
            // Test the maint title has something in it, this also tests findMaintLabel()
            System.assert(vehController.maint.MaintTitle1 != null);
            vehController.getContractData();
            System.assert(vehController.contracts.size() > 0);
            vehController.getWarrantyHistoryData();
            System.assert(vehController.whList.size() > 0);
            vehController.getWarrantyHistoryDetailData();
            System.assert(vehController.whd.PandO.size() > 0);

            // Test the methods in the VehicleAttributes class not in test mode which will try to make the WS call.
            vehController.WarrantyDataSource.Test = false;
            vehController.MaintDataSource.Test = false;
            vehController.OTSDataSource.Test = false;
            vehController.ContractDataSource.Test = false;
            vehController.WarrantyHistoryDataSource.Test = false;
            vehController.WarrantyHistoryDetailDataSource.Test = false;
            
            vehController.getWarrantyData();
            // Test it populated wpList
            System.assert(vehController.wpList.size() > 0);
            vehController.getOTSData();
            System.assert(vehController.otsPropList.size() > 0);
            vehController.getMaintenanceData();
            // Test the maint title has something in it, this also tests findMaintLabel()
            System.assert(vehController.maint.MaintTitle1 != null);
            vehController.getContractData();
            System.assert(vehController.contracts.size() > 0);
            vehController.getWarrantyHistoryData();
            System.assert(vehController.whList.size() > 0);
            vehController.getWarrantyHistoryDetailData();
            System.assert(vehController.whd.PandO.size() > 0);
            
            // test showDetail property;
            system.assertNotEquals(vehController.showDetail, null);
            vehController.showDetail = 2;
            system.assertEquals(vehController.showDetail, 2);   
        
  //  }
   Test.stopTest();
 }
 
    static testMethod void testUtils_OTSDataSource(){
    
        // Set up the envioronment
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_otsIcmApvBserviceRenault.ApvGetListOtsResponse results;
        Test.startTest();
           // Test the methods in the VehicleAttributes class
            vehController.OTSDataSource.Test = true;
            //results = vehController.OTSDataSource.getOTSData(VehController);
             vehController.getOTSData();
            vehController.OTSDataSource.Test = false;
            results = vehController.OTSDataSource.getOTSData(VehController);
            
        Test.stopTest();
    }
    
     static testMethod void testUtils_OTSDataSourceWS(){
    
        Rforce_otsIcmApvBserviceRenault.ApvGetListOts sample = new Rforce_otsIcmApvBserviceRenault.ApvGetListOts();
        Rforce_otsIcmApvBserviceRenault.ApvGetListOtsResponse test = new Rforce_otsIcmApvBserviceRenault.ApvGetListOtsResponse();
        Rforce_otsIcmApvBserviceRenault.OtsInfoMsg msg = new Rforce_otsIcmApvBserviceRenault.OtsInfoMsg();
        
        Rforce_BVM_WS.DetVehCritere crit = new Rforce_BVM_WS.DetVehCritere();
    }
 
    static testMethod void testUtils_MaintDataSource(){

        // Set up the envioronment
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_fullRepApvBserviceRenault.ApvGetDonPgmEntVinFullResponse results;
        Test.startTest();
            // Test the methods in the VehicleAttributes class
            vehController.MaintDataSource.Test = true;
            results = vehController.MaintDataSource.getMaintenanceData(VehController);
            vehController.MaintDataSource.Test = false;
            results = vehController.MaintDataSource.getMaintenanceData(VehController);
            
        Test.stopTest();
    }
   
    static testMethod void testUtils_WarrantyDataSource(){

        // Set up the envioronment
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_servicesBcsDfr.ListDetWarrantyCheck results;
        Test.startTest();
            // Test the methods in the VehicleAttributes class
            vehController.WarrantyDataSource.Test = true;
            results = vehController.WarrantyDataSource.getWarrantyData(VehController);
            vehController.WarrantyDataSource.Test = false;
            results = vehController.WarrantyDataSource.getWarrantyData(VehController);
            
        Test.stopTest();
    }
    
    static testMethod void testUtils_ContractDataSource(){

        // Set up the envioronment
        User u = getEnvSetup();
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_CustdataCrmBserviceRenault.GetCustDataResponse results;
        Test.startTest();
    //    System.Runas(u){
            // Test the methods in the VehicleAttributes class
            vehController.ContractDataSource.Test = true;
            system.debug(u.Name);
            results = vehController.ContractDataSource.getContractData(VehController);
            vehController.ContractDataSource.Test = false;
            results = vehController.ContractDataSource.getContractData(VehController);
      //  }    
        Test.stopTest();
    }
    
        static testMethod void testUtils_WarrantyHistoryDataSource(){

        // Set up the envioronment
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_ApvGetDonIran1.ApvGetDonIran1Response results;
        Test.startTest();
            // Test the methods in the VehicleAttributes class
            vehController.WarrantyHistoryDataSource.Test = true;
            results = vehController.WarrantyHistoryDataSource.getWarrantyHistoryData(VehController);
            vehController.WarrantyHistoryDataSource.Test = false;
            results = vehController.WarrantyHistoryDataSource.getWarrantyHistoryData(VehController);
            
        Test.stopTest();
    }
    
    static testMethod void testUtils_WarrantyHistoryDetailDataSource(){

        // Set up the envioronment
        // Create a vehicle
        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        Rforce_iran2BimIcmApvBserviceRenault.ApvGetDonIran2Response results;
        Test.startTest();
            // Test the methods in the VehicleAttributes class
            vehController.WarrantyHistoryDetailDataSource.Test = true;
            vehController.WarrantyHistoryDetailDataSource.modulo = 'ABC';
            vehController.WarrantyHistoryDetailDataSource.numInt = 'ABC';
            results = vehController.WarrantyHistoryDetailDataSource.getWarrantyHistoryDetailData(VehController);
            vehController.WarrantyHistoryDetailDataSource.Test = false;
            results = vehController.WarrantyHistoryDetailDataSource.getWarrantyHistoryDetailData(VehController);
            
        Test.stopTest();
    }

    static testMethod void test_otsIcmApvBserviceRenault(){
        
        Test.startTest();
            Rforce_otsIcmApvBserviceRenault.SiUnavailableException e = new Rforce_otsIcmApvBserviceRenault.SiUnavailableException();
            Rforce_otsIcmApvBserviceRenault.NoDataFoundException e1 = new Rforce_otsIcmApvBserviceRenault.NoDataFoundException();
            Rforce_otsIcmApvBserviceRenault.BadRequestException e2 = new Rforce_otsIcmApvBserviceRenault.BadRequestException();
            Rforce_otsIcmApvBserviceRenault.SiErrorException e3 = new Rforce_otsIcmApvBserviceRenault.SiErrorException();
        Test.stopTest();
    }
   
    static testMethod void test_fullRepApvBserviceRenault(){
        
        Test.startTest();
            Rforce_fullRepApvBserviceRenault.SiUnavailableException e = new Rforce_fullRepApvBserviceRenault.SiUnavailableException();
            Rforce_fullRepApvBserviceRenault.NoDataFoundException e1 = new Rforce_fullRepApvBserviceRenault.NoDataFoundException();
            Rforce_fullRepApvBserviceRenault.BadRequestException e2 = new Rforce_fullRepApvBserviceRenault.BadRequestException();
            Rforce_fullRepApvBserviceRenault.SiErrorException e3 = new Rforce_fullRepApvBserviceRenault.SiErrorException();
            
            // No idea what all the rest of these classes do, assume not needed.
            Rforce_fullRepApvBserviceRenault.PgmEntPrec e4 = new Rforce_fullRepApvBserviceRenault.PgmEntPrec();
            Rforce_fullRepApvBserviceRenault.PgmEntInfoSpecial e5 = new Rforce_fullRepApvBserviceRenault.PgmEntInfoSpecial();
            Rforce_fullRepApvBserviceRenault.PgmEntCapMoy e6 = new Rforce_fullRepApvBserviceRenault.PgmEntCapMoy();
            Rforce_fullRepApvBserviceRenault.PgmEntRefro e7 = new Rforce_fullRepApvBserviceRenault.PgmEntRefro ();
            Rforce_fullRepApvBserviceRenault.PgmEntFrein e8 = new Rforce_fullRepApvBserviceRenault.PgmEntFrein();
            Rforce_fullRepApvBserviceRenault.PgmEntHuile e9 = new Rforce_fullRepApvBserviceRenault.PgmEntHuile();
            Rforce_fullRepApvBserviceRenault.PgmEntRev e10 = new Rforce_fullRepApvBserviceRenault.PgmEntRev();
        Test.stopTest();
    }
 
  
    
    static testMethod void test_CustdataCrmBserviceRenault(){
        
        Test.startTest();
            Rforce_CustdataCrmBserviceRenault.Survey e = new Rforce_CustdataCrmBserviceRenault.Survey();
            Rforce_CustdataCrmBserviceRenault.Contact e1 = new Rforce_CustdataCrmBserviceRenault.Contact();
            Rforce_CustdataCrmBserviceRenault.LogsCustData e2 = new Rforce_CustdataCrmBserviceRenault.LogsCustData();
            Rforce_CustdataCrmBserviceRenault.GetCustDataError e3 = new Rforce_CustdataCrmBserviceRenault.GetCustDataError();
            Rforce_CustdataCrmBserviceRenault.Dealer e4 = new Rforce_CustdataCrmBserviceRenault.Dealer();
            Rforce_CustdataCrmBserviceRenault.Desc_x e5 = new Rforce_CustdataCrmBserviceRenault.Desc_x();
            Rforce_CustdataCrmBserviceRenault.wsInfos e6 = new Rforce_CustdataCrmBserviceRenault.wsInfos();
            Rforce_CustdataCrmBserviceRenault.WorkShop e7 = new Rforce_CustdataCrmBserviceRenault.WorkShop();
           
                         
        Test.stopTest();
    }
    
    
    
        static testMethod void test_getArchives(){

        VEH_Veh__c veh = new VEH_Veh__c(name='VF1BGRG0633285766');
        insert veh;
        
        // Get ready to run the methods
        Rforce_VehicleAttributes vehController = new Rforce_VehicleAttributes(new ApexPages.StandardController(veh));
        
        vehController.toParse='<test><SerialNumber2>123</SerialNumber2></test>';
         //vehController.toParse='<SiebelMessage><FirstName>AA</FirstName><ListOfAction><Action><Type2>AA</Type2><SerialNumber2>123</SerialNumber2></Action></ListOfAction></SiebelMessage>';
        
        Test.setMock(WebServiceMock.class, new  Rforce_RcArch_WebServiceMock_Test());
       
        Test.startTest();

        vehController.IdCase='123';
        vehController.getArchives();
        vehController.getCaseDetailXML();
        vehController.getCaseDetails();
        vehController.getAttachements();
        //vehController.getAttachementData();
        PageReference FinalPage=vehController.OpenXMLPage();
        System.assertEquals('VF1BGRG0633285766',vehController.getVin());
        Test.stopTest();
    }
 
}