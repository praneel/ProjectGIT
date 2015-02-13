@isTest
global class Myr_PersonalDataBCS10_WS_Test{
    static testMethod void test010() 
    {  
		Test.setMock(WebServiceMock.class, new Myr_PersonalDataBCS10_WS_MK());
   	}
}