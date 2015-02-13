/*	Test class for manageAccount WS. Test cases are :
 - Mandatory parameter missing : all, accountBrand, accountSource, accountSubSource, country, emailAdress, firstName, lastName, generalOptin, 
 - VIN format KO
 - Account was already existing, and an associated community user exists too. This user is yet activated
 - Account was already existing, and an associated community user exists too. This user is NOT activated
 - SFDC Account is existing yet, community user NOT existing, user existing
 - SFDC Account is existing yet, community user NOT existing, user NOT existing
 - SFDC Account NOT existing yet, client founded
 - SFDC Account NOT existing yet, client NOT founded
*************************************************************************************************************
25 August 2014  : Creation
*************************************************************************************************************
29 Octuber 2014 : New parameters : accountSource, accountSubSource, accountSubSubSource
************************************************************************************************************/
@isTest
private class Myr_ManageAccount_WS_Test{
  //Mandatory parameter missing : all
  static testMethod void test010() 
  {  
    Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('','','','','','','','','','','','','','','','','');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('accountBrand'));
    system.assertEquals(true,res.info.message.contains('accountSource'));
    system.assertEquals(true,res.info.message.contains('accountSubSource'));
    system.assertEquals(true,res.info.message.contains('country'));
	system.assertEquals(true,res.info.message.contains('emailAdress'));
	system.assertEquals(true,res.info.message.contains('firstName'));
	system.assertEquals(true,res.info.message.contains('lastName'));
	system.assertEquals(true,res.info.message.contains('generalOptin'));
  }

  //Mandatory parameter missing : accountBrand
  static testMethod void test011() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('','France','MYR','STANDARD','','','','','paul.durandet@atos.net','','','Paul','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('accountBrand'));
  }

  //Mandatory parameter missing : accountSource
  static testMethod void test012() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('','France','','STANDARD','','','','','paul.durandet@atos.net','','','Paul','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('accountSource'));
  }
  	
  //Mandatory parameter missing : accountSubSource
  static testMethod void test013() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('','France','MYR','','','','','','paul.durandet@atos.net','','','Paul','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('accountSubSource'));
  }
  
  //Mandatory parameter missing : country
  static testMethod void test014() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','','MYR','STANDARD','','','','','paul.durandet@atos.net','','','Paul','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('country'));
  }
  
  //Mandatory parameter missing : emailAdress
  static testMethod void test015() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','','','','','Paul','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('emailAdress'));
  }
  
  //Mandatory parameter missing : firstName
  static testMethod void test016() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','','paul.durandet@atos.net','','','','Durandet','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('firstName'));
  }
  
  //Mandatory parameter missing : lastName
  static testMethod void test017() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','','paul.durandet@atos.net','','','Paul','','','','','Y');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('lastName'));
  }
  
  //Mandatory parameter missing : generalOptin
  static testMethod void test018() 
  {
  	Myr_Datasets_Test.prepareRequiredCustomSettings();    
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;  
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','','paul.durandet@atos.net','','','Paul','Durandet','','','','');
    }
    system.assertNotEquals(null,res);
    system.assertEquals(null,res.accountSfdcId);
    system.assertEquals('WS01MS501',res.info.code);
    system.assertEquals(true,res.info.message.contains('Value(s) missing : Parameter(s)'));
    system.assertEquals(true,res.info.message.contains('generalOptin'));
  }
  
  //VIN incorrect format (17 long characters, no 0,Q or I)
  static testMethod void test020()
  {  	
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    system.assertNotEquals( Myr_Users_Utilities_Class.getPersonalAccountRecordType() , null);       
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
	system.runAs(techUser){
		res=Myr_ManageAccount_WS.manageAccount('RENAULT','France','MYR','STANDARD','','PARIS','','','test.raynald.durand@atos.net','','','RAYNALD','DURAND','','','badVIN','Y');
	}
    system.AssertNotEquals(null, res);
    system.assertEquals('WS01MS505',res.info.code);
    system.assertEquals('VIN format KO. Format must be a 17-character-long String, with no letter O, Q and I',res.info.message);
  }

  //Account was already existing, and an associated community user exists too. This user is yet activated
  static testMethod void test030()
  {
    Myr_Datasets_Test.prepareRequiredCustomSettings();    
    Account acc = Myr_Datasets_Test.insertPersonalAccounts(1, Myr_Datasets_Test.UserOptions.ACTIVE_USERS)[0];
    Id [] fixedSearchResults= new Id[1];
    fixedSearchResults[0] = acc.Id;
    Test.setFixedSearchResults(fixedSearchResults);
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null; 
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','', acc.PersEmailAddress__c,'','',acc.FirstName,acc.LastName,'','','','Y');
    }
    system.AssertNotEquals(null, res);
    system.assertNotEquals(null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname FROM account where id=:res.accountSfdcId];
    String myLastName=listAccount[0].lastname;
    String myFirstName=listAccount[0].firstname;
    system.assertEquals(acc.LastName + acc.FirstName, myLastName + myFirstName);
    system.assertEquals( 'WS01MS002', res.info.code );
    system.assertEquals( 'Account was already existing, and an associated community user exists too. This user is yet activated', res.info.message);
  }

  //Account was already existing, and an associated community user exists too. This user is NOT activated
  static testMethod void test040()
  {
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    Account acc = Myr_Datasets_Test.insertPersonalAccounts(1, Myr_Datasets_Test.UserOptions.INACTIVE_USERS)[0];
    Id [] fixedSearchResults= new Id[1];
    fixedSearchResults[0] = acc.Id;
    Test.setFixedSearchResults(fixedSearchResults);
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','', acc.PersEmailAddress__c, '','',acc.FirstName,acc.LastName,'','','','Y');
    }
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname FROM account where id=:res.accountSfdcId];
    String myLastName=listAccount[0].lastname;
    String myFirstName=listAccount[0].firstname;
    system.assertEquals(acc.LastName + acc.FirstName, myLastName + myFirstName);
    system.assertEquals( 'WS01MS502', res.info.code );
    system.assertEquals( 'Account was already existing, and an associated community user exists too. This user is NOT activated', res.info.message );
  }
  
  //SFDC Account is existing yet, community user NOT existing, user existing
  static testMethod void test050()
  {
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    Account acc = Myr_Datasets_Test.insertPersonalAccounts(1, Myr_Datasets_Test.UserOptions.ACTIVE_USERS_BADPROFILE)[0];
    Id [] fixedSearchResults= new Id[1];
    fixedSearchResults[0] = acc.Id;
    Test.setFixedSearchResults(fixedSearchResults);
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','', acc.PersEmailAddress__c, '','',acc.FirstName,acc.LastName,'','','','Y');
    }
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname FROM account where id=:res.accountSfdcId];
    String myLastName=listAccount[0].lastname;
    String myFirstName=listAccount[0].firstname;
    system.assertEquals(acc.LastName + acc.FirstName, myLastName + myFirstName);
    system.assertEquals('WS01MS503',res.info.code);
    system.assertEquals('Account was already existing, and an associated user exists too. This user is not a community one',res.info.message);
  }
  
  //SFDC Account is existing yet, community user NOT existing, user NOT existing
  static testMethod void test060()
  {
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    Account acc = Myr_Datasets_Test.insertPersonalAccounts(1, Myr_Datasets_Test.UserOptions.NO_USERS)[0];
    Id [] fixedSearchResults= new Id[1];
    fixedSearchResults[0] = acc.Id;
    Test.setFixedSearchResults(fixedSearchResults);
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
    system.runAs( techUser ) {
        res=Myr_ManageAccount_WS.manageAccount('Renault','France','MYR','STANDARD','','','','', acc.PersEmailAddress__c, '','', acc.FirstName, acc.LastName, '','','','Y');
    }
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname FROM account where id=:res.accountSfdcId];
    String myLastName=listAccount[0].lastname;
    String myFirstName=listAccount[0].firstname;
    system.assertEquals(acc.LastName + acc.FirstName, myLastName + myFirstName);
    system.assertEquals( 'WS01MS001', res.info.code );
    system.assertEquals( 'Account was already existing, but there is no associated SFDC user', res.info.message );
  }

  //-> SFDC Account NOT existing yet, PERSONAL DATA OK FOR MDM 
  static testMethod void test070()
  {  	
  	//For France, the default data system is MDM. The test below is done with this assumption and 
  	//the custom settings prepared accordingly
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    system.assertNotEquals( Myr_Users_Utilities_Class.getPersonalAccountRecordType() , null);
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
	Test.setMock( WebServiceMock.class, new Myr_PersonalDataMDM00_WS_MK(true));
	system.runAs( techUser ) { 
		//France is linked to MDM
		Test.startTest();
			res=Myr_ManageAccount_WS.manageAccount( 'RENAULT','France','MYR','STANDARD','EDR','PARIS','32, boulevard richelieu','','test.raynald.durand@atos.net','','','RAYNALD','DURAND','','','','Y' );
		Test.stopTest();
	}
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname, PersEmailAddress__c,
    								 PersonBirthdate, Sex__c, PersMobPhone__c, HomePhone__c, AccountSource, AccSubSource__c, Account_Sub_Sub_Source__c
    								FROM Account where id=:res.accountSfdcId];
    system.assertEquals(1, listAccount.size());
    Account acc = listAccount[0];
    //Ok we searched for different values but this is only used to check that we have really used MDM ...
    system.assertEquals('LAMBERT' + 'JONATHAN',acc.lastname + acc.firstname);
    system.assertEquals( 'mag.perrin21@free.fr',acc.PersEmailAddress__c);
    system.assertEquals( '+33685290996',acc.PersMobPhone__c);
    system.assertEquals( '+33329665342',acc.HomePhone__c);
    system.assertEquals( 'MYR',acc.AccountSource);
    system.assertEquals( 'STANDARD',acc.AccSubSource__c);
    system.assertEquals( 'EDR',acc.Account_Sub_Sub_Source__c);
    system.assertEquals( 'WS01MS000',res.info.code);
    system.assertEquals( 'Account created',res.info.message);
  }
  
  //SFDC Account NOT existing yet, PERSONAL DATA OK FOR SIC
  static testMethod void test080()
  {  	
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    system.assertNotEquals( Myr_Users_Utilities_Class.getPersonalAccountRecordType() , null);
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
	Test.setMock(WebServiceMock.class, new Myr_PersonalDataSIC38_WS_MK());
	system.runAs( techUser ) {
		//Italy is linked to SIC 
		Test.startTest();
			res=Myr_ManageAccount_WS.manageAccount( 'RENAULT','Italy','MYR','STANDARD','','PARIS','','','test.raynald.durand@atos.net','','','RAYNALD','DURAND','','','','Y' );
		Test.stopTest();
	}
    
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname, PersEmailAddress__c, CustomerIdentificationNbr__c,
    								 PersonBirthdate, Sex__c, PersMobPhone__c, HomePhone__c,
    								 ShippingStreet, ShippingCountry, ShippingPostalCode, ShippingCity
    								FROM Account where id=:res.accountSfdcId];
    system.assertEquals(1, listAccount.size());
    Account acc = listAccount[0];
    //Ok we searched for different values 
    system.assertEquals('FERRONI' + 'ANTONIO', acc.lastname + acc.firstname);
    system.assertEquals(true, acc.PersEmailAddress__c.equalsIgnoreCase('ROSY.PARLAPARLA@GMAIL.COM') );
    system.assertEquals('7026526', acc.customerIdentificationNbr__c);
    system.assertEquals('34 VLE FAMAGOSTA', acc.ShippingStreet );
    system.assertEquals('ITA', acc.ShippingCountry);
    system.assertEquals('20142', acc.ShippingPostalCode );
    system.assertEquals('MILANO', acc.ShippingCity );
    //birth day 1948-12-17
    //system.assertEquals( '+33685290996',  acc.PersMobPhone__c);
    //system.assertEquals( '+33329665342', acc.HomePhone__c);
    system.assertEquals('WS01MS000', res.info.code );
    system.assertEquals('Account created', res.info.message );
  }
  
  //SFDC Account NOT existing yet, PERSONAL DATA OK FOR BCS
  static testMethod void test090()
  {  	
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    system.assertNotEquals( Myr_Users_Utilities_Class.getPersonalAccountRecordType() , null);
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
	
	Test.setMock(WebServiceMock.class, new Myr_PersonalDataBCS10_WS_MK());
	
	//Turkey is configured on BCS
	system.runAs( techUser ) {
		Test.startTest(); //Used to avoid exception on uncommitted work while calling Mock WebService 
			res=Myr_ManageAccount_WS.manageAccount('RENAULT','Turkey','MYR','STANDARD','','PARIS','','','test.raynald.durand@atos.net','','','RAYNALD','DURAND','','','','Y' );
		Test.stopTest();
	}
	
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT firstname, lastname, PersEmailAddress__c, customerIdentificationNbr__c,
    								 PersonBirthdate, Sex__c, PersMobPhone__c, HomePhone__c,
    								 ShippingStreet, ShippingCountry, ShippingPostalCode, ShippingCity
    								FROM Account where id=:res.accountSfdcId];
    system.assertEquals(1, listAccount.size());
    Account acc = listAccount[0];
    //Ok we searched for different values
    system.assertEquals('DURAND' + 'RAYNALD', acc.lastname + acc.firstname);
    //system.assertEquals( true, acc.PersEmailAddress__c.equalsIgnoreCase('ROSY.PARLAPARLA@GMAIL.COM') );
    system.assertEquals( '13553167', acc.customerIdentificationNbr__c);
    system.assertEquals( '13 RUE FELIX TERRIER', acc.ShippingStreet );
    system.assertEquals( 'FR', acc.ShippingCountry);
    system.assertEquals( '75020', acc.ShippingPostalCode );
    system.assertEquals( 'PARIS', acc.ShippingCity );
    //birth day 1948-12-17
    //system.assertEquals( '+33685290996',  acc.PersMobPhone__c);
    //system.assertEquals( '+33329665342', acc.HomePhone__c);
    system.assertEquals( 'WS01MS000', res.info.code );
    system.assertEquals( 'Account created', res.info.message );
  }
  
   
  //SFDC Account NOT existing yet, PERSONAL DATA KO
  static testMethod void test100()
  {  	
    Myr_Datasets_Test.prepareRequiredCustomSettings();
    User techUser = Myr_Datasets_Test.getReadOnlyTechnicalUser();
    system.assertNotEquals( Myr_Users_Utilities_Class.getPersonalAccountRecordType() , null);
    Myr_ManageAccount_WS.Myr_ManageAccount_WS_Response res = null;
	
	system.runAs( techUser ) {
		//PaysAuHasard is not a country, used to fail the call to Personal Data Webservices enforces by the fact that no mock have been configured
		Test.startTest(); 
			res=Myr_ManageAccount_WS.manageAccount('RENAULT','PaysAuHasard','MYR','STANDARD','','PARIS','white street','75000','don.veron@atos.net','0299753080','0699753080','VERON','DON','Lawyer','','','Y');
		Test.stopTest();
	}
	
    system.AssertNotEquals(null, res);
    system.assertNotEquals( null, res.accountSfdcId);
    List<Account> listAccount = [SELECT lastname, firstname, Title__c, ShippingPostalCode, RefAddressStreet__c, PersLandline__c, PersMobPhone__c FROM Account where id=:res.accountSfdcId];
    system.assertEquals(1, listAccount.size());
    Account acc = listAccount[0];
    system.assertEquals('DONVERON',acc.lastname + acc.firstname);
    system.assertEquals('Lawyer',acc.Title__c);
    system.assertEquals('75000',acc.ShippingPostalCode);
    system.assertEquals('white street',acc.RefAddressStreet__c);
    system.assertEquals('0299753080',acc.PersLandline__c);
    system.assertEquals('0699753080',acc.PersMobPhone__c);
    system.assertEquals('WS01MS000',res.info.code);
    system.assertEquals('Account created', res.info.message);
  }  
}