/*****************************************************************************************
    Name    : Updatevehicle_Batch_Test
    Desc    : This is to test Rforce_UpdateVehicleCallout_WS class
    Approach: WebServiceMock  interface for callout testing
    Project : Rforce

******************************************************************************************/

@istest

public class TriggerAdministration_Test {
    public static testMethod void testFunction() {
        // canTrigger Method Testing
        // Start test
        Test.startTest();
        // setting mockresponse for callout
        Boolean response = TriggerAdministration.canTrigger('Test');
        System.assert(response, true);
        //Stop test
        Test.stopTest();
        System.debug('TESTS ENDED');
    }
}