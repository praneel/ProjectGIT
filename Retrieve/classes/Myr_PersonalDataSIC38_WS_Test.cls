@isTest

global class Myr_PersonalDataSIC38_WS_Test{
    static testMethod void test010() 
    {  
    	Test.setMock(WebServiceMock.class, new Myr_PersonalDataSIC38_WS_MK());
   	}
}