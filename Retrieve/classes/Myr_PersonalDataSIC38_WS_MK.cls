/**
 * Mock Test Class to test the BCS WebService 
 */
@isTest
global class Myr_PersonalDataSIC38_WS_MK implements WebServiceMock {

    /** @constructor **/
    global Myr_PersonalDataSIC38_WS_MK() {
        buildSICResponse();
    }
    
    /** Simulates invokation of the webservice **/
    global void doInvoke( Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        system.debug('#### Myr_PersonalDataSIC38_WS_MK - doInvoke - BEGIN request=' + request);
        response.put('response_x', buildSICResponse());
        system.debug('#### Myr_PersonalDataSIC38_WS_MK - doInvoke - END');                                  
    }
    
    
    private Myr_PersonalDataSIC38_WS.getCustDataResponse_element buildSICResponse() {
    	
    	Myr_PersonalDataSIC38_WS.wsInfos wsInfos = new Myr_PersonalDataSIC38_WS.wsInfos();
        wsInfos.wsVersion='Test';
        wsInfos.wsEnv='Test';
        wsInfos.wsDb='Test';
    	
    	Myr_PersonalDataSIC38_WS.Survey pSurveyTest = new Myr_PersonalDataSIC38_WS.Survey();
        pSurveyTest.surveyOK='Test';
        pSurveyTest.value='Test';
        pSurveyTest.loyMessage='Test';
    	
        Myr_PersonalDataSIC38_WS.GetCustDataResponse pTestData = new Myr_PersonalDataSIC38_WS.GetCustDataResponse();
        pTestData.clientList = new List<Myr_PersonalDataSIC38_WS.PersonnalInformation>();
        
        Myr_PersonalDataSIC38_WS.LogsCustData logsCust =  new Myr_PersonalDataSIC38_WS.LogsCustData();
        logsCust.brand='Renault';
        logsCust.mode=1;
        logsCust.country='test';
        logsCust.brand='test';
        logsCust.demander='test';
        logsCust.vin='test';
        logsCust.lastName='test';
        logsCust.firstName='test';
        logsCust.city='test';
        logsCust.zip='test';
        logsCust.ident1='test';
        logsCust.idClient='test';
        logsCust.idMyr='test';
        logsCust.firstRegistrationDate='test';
        logsCust.registration='test';
        logsCust.email='test';
        logsCust.logDate='test';
        logsCust.ownedVehicles='test';
        logsCust.nbReplies='test';
        logsCust.wsVersion='test';
        logsCust.ipAdress='test';
        logsCust.codErreur='test';
        logsCust.dbCible='test';
        logsCust.wsHostname='test';
        logsCust.wsTexec=200001;
        
        Myr_PersonalDataSIC38_WS.RepDynamic repDynamic = new Myr_PersonalDataSIC38_WS.RepDynamic();
        repDynamic.repCode='test';
        repDynamic.pkm='test';
        repDynamic.pan='test';
        repDynamic.dipkm='test';
        repDynamic.dipan='test';
        repDynamic.dlc='test';
        repDynamic.ddo='test';
        repDynamic.kdo='test';
        repDynamic.ddp='test';
        repDynamic.kdp='test';
        repDynamic.dap='test';
        repDynamic.kap='test';
        repDynamic.kac0='test';
        repDynamic.kac='test';
        repDynamic.dp1='test';
        repDynamic.dp2='test';
        repDynamic.dp3='test';
        
        Myr_PersonalDataSIC38_WS.Dealer dealer = new Myr_PersonalDataSIC38_WS.Dealer();
        String birId1 = 'test1';
        String birId2 = 'test2';
        dealer.birId = new List<String>();
        dealer.birId.add(birId1);
        dealer.birId.add(birId2);
        
        Myr_PersonalDataSIC38_WS.CustDataRequest custDataRequest = new Myr_PersonalDataSIC38_WS.CustDataRequest();
        custDataRequest.mode='test';
        custDataRequest.country='test';
        custDataRequest.brand='test';
        custDataRequest.demander='test';
        custDataRequest.vin='test';
        custDataRequest.lastName='test';
        custDataRequest.firstName='test';
        custDataRequest.city='test';
        custDataRequest.zip='test';
        custDataRequest.ident1='test';
        custDataRequest.idClient='test';
        custDataRequest.typeperson='test';
        custDataRequest.idMyr='test';
        custDataRequest.firstRegistrationDate='test';
        custDataRequest.registration='test';
        custDataRequest.email='test';
        custDataRequest.sinceDate='test';
        custDataRequest.ownedVehicles='test';
        custDataRequest.nbReplies='test';
        
        Myr_PersonalDataSIC38_WS.ServicePreferences servPref = new Myr_PersonalDataSIC38_WS.ServicePreferences();
        servPref.irn='test';
        servPref.sia='test';
        servPref.reqid='test';
        servPref.userid='test';
        servPref.language='test';
        servPref.country='test';
        
        Myr_PersonalDataSIC38_WS.GetCustDataRequest getCustData = new Myr_PersonalDataSIC38_WS.GetCustDataRequest();
        getCustData.custDataRequest = custDataRequest;
        getCustData.servicePrefs = servPref;
        
        Myr_PersonalDataSIC38_WS.getCustData_element custDataElement = new Myr_PersonalDataSIC38_WS.getCustData_element();
        custDataElement.request = getCustData;        
        
        Myr_PersonalDataSIC38_WS.GetCustDataError custDataError = new Myr_PersonalDataSIC38_WS.GetCustDataError();
        custDataError.fault='test';
        
        Myr_PersonalDataSIC38_WS.Desc_x descrip = new Myr_PersonalDataSIC38_WS.Desc_x();
        descrip.type_x='test';
        descrip.typeCode='test';
        descrip.subType='test';
        descrip.subTypeCode='test';
        
        Myr_PersonalDataSIC38_WS.WorkShop workshop = new Myr_PersonalDataSIC38_WS.WorkShop();
        workshop.date_x='test';
        workshop.km='test';
        workshop.birId='test';
        workshop.origin='test';
        workshop.description=descrip;
        
        Myr_PersonalDataSIC38_WS.contract contract = new Myr_PersonalDataSIC38_WS.contract();
        contract.idContrat='test';
        contract.type_x='test';
        contract.techLevel='test';
        contract.serviceLevel='test';
        contract.productLabel='test';
        contract.initKm='test';
        contract.maxSubsKm='test';
        contract.subsDate='test';
        contract.initContractDate='test';
        contract.endContractDate='test';
        contract.status='test';
        contract.updDate='test';
        contract.idMandator='test';
        contract.idCard='test';
        
        Myr_PersonalDataSIC38_WS.PersonnalInformation client = new Myr_PersonalDataSIC38_WS.PersonnalInformation();
        client.IdClient = '7026526';
        client.LastName = 'FERRONI';
        client.FirstName = 'ANTONIO';
        client.Lang = 'ITA';
        client.sex = '1';
        client.birthDay = '1948-12-17';
        client.typeperson = 'P';
        client.typeIdent1 = '1';
        client.ident1 = 'FRRNTN48T17F156W';
        client.contact = new Myr_PersonalDataSIC38_WS.Contact();
        client.contact.phoneNum1 = '8136853';
        client.contact.phoneNum2 = '8136853';
        client.contact.phoneNum3 = '4858210';
        client.contact.email = 'ROSY.PARLAPARLA@GMAIL.COM';
        client.contact.optin = '0';
        client.address = new Myr_PersonalDataSIC38_WS.Address();
        client.address.strName = 'FAMAGOSTA';
        client.address.strType = 'VLE';
        client.address.strTypeLabel = 'VIALE';
        client.address.strNum = '34';
        client.address.countryCode = 'ITA';
        client.address.zip = '20142';
        client.address.city = 'MILANO';
        client.address.qtrCode = '015';
        client.address.dptCode = '146';
        client.address.sortCode = '0003332';
        client.address.areaCode = 'MI';
        client.vehicleList = new List<Myr_PersonalDataSIC38_WS.Vehicle>();
        Myr_PersonalDataSIC38_WS.Vehicle vehicle = new Myr_PersonalDataSIC38_WS.Vehicle();
        vehicle.vin = 'VF17R5A0H48447489';
        vehicle.brandCode = 'RENAULT';
        vehicle.modelCode = 'CK4';
        vehicle.modelLabel = 'CLIO SPORTER';
        vehicle.firstRegistrationDate = '2013-09-26';
        vehicle.registration = 'ES847JH';
        vehicle.possessionBegin = '2013-09-30';
        vehicle.paymentMethod = 'F';
        vehicle.purchaseNature = 'POS';
        vehicle.capacity = '898';
        vehicle.doorNum = '4';
        vehicle.versionLabel = 'DYR 09S E5';
        client.vehicleList.add(vehicle);
        pTestData.clientList.add(client);
        Myr_PersonalDataSIC38_WS.getCustDataResponse_element sicResponse = new Myr_PersonalDataSIC38_WS.getCustDataResponse_element();
		
		Myr_PersonalDataSIC38_WS.CrmGetCustData crm = new Myr_PersonalDataSIC38_WS.CrmGetCustData();
		Myr_PersonalDataSIC38_WS.GetCustDataResponse res = new Myr_PersonalDataSIC38_WS.GetCustDataResponse();
		//sicResponse = crm.getCustData(getCustData);
		sicResponse.response = pTestData;

        return sicResponse; 
    }
}