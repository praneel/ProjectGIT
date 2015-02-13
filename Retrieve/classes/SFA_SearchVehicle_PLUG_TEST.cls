/**
 * This class contains unit tests for validating SFA_SearchVehicle_PLUG class.
 */
@isTest
private class SFA_SearchVehicle_PLUG_TEST {

    static testMethod void testVehicleFoundInBVM() {
        //-- set mock ws response class
        Test.setMock(WebServiceMock.class, new LMT_BVMComplet_WS_MK());
        Test.startTest();
        //-- launch test... should create a vehicle and return a not null vehicle Id
        SFA_SearchVehicle_PLUG sv = new SFA_SearchVehicle_PLUG();
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('VIN', 'VFxxxx');// no matter the value
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        //-- call plug-in
        Process.PluginResult pr = sv.invoke(request);
        
        Test.stopTest();
        //-- now check values in result
        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr.outputParameters);
        Object sr = pr.outputParameters.get('VehID');
        System.assertNotEquals('', sr);
        String vehID = (String) sr;
        //-- get from database vehicle should have been created
        VEH_Veh__c veh = [SELECT Id, Name, EnergyType__c FROM VEH_Veh__c WHERE Id = :vehID];
        System.assertNotEquals(null, veh);
        //-- check VIN
        sr = pr.outputParameters.get('VIN');
        System.assertNotEquals('', sr);
        System.assertEquals('VFxxxx', (String) sr);
        System.assertEquals('FLEXFL', veh.EnergyType__c);
        //System.assertEquals('VFxxxx', veh.Name);
    }
    
    static testMethod void testVehicleNotFoundInBVM() {
        //-- set mock ws response class
        Test.setMock(WebServiceMock.class, new LMT_BVMComplet_RespNull_WS_MK());
        Test.startTest();
        //-- launch test... should create a vehicle and return a not null vehicle Id
        SFA_SearchVehicle_PLUG sv = new SFA_SearchVehicle_PLUG();
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('RegistrationNumber', '123AAA35');// no matter the value
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        //-- call plug-in
        Process.PluginResult pr = sv.invoke(request);
        
        Test.stopTest();
        //-- now check values in result
        System.assertNotEquals(null, pr);
        System.assertNotEquals(null, pr.outputParameters);
        Object sr = pr.outputParameters.get('VehID');
        System.assertEquals('', sr);
    }    
    
    static testMethod void testDescribe(){
    	SFA_SearchVehicle_PLUG sv = new SFA_SearchVehicle_PLUG();
    	Process.PluginDescribeResult describe = sv.describe();
    	System.assertNotEquals(null, describe);
    	System.assertNotEquals(null, describe.inputParameters);
    	System.assertEquals(2, describe.outputParameters.size());
    	System.assertNotEquals(null, describe.outputParameters);
    	System.assertEquals(2, describe.outputParameters.size());
    }
    
}