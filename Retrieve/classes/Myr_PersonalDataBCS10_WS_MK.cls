/**
 * Mock Test Class to test the BCS WebService 
 */
@isTest
global class Myr_PersonalDataBCS10_WS_MK implements WebServiceMock {

	/** @constructor **/
    global Myr_PersonalDataBCS10_WS_MK() {
    	buildBCSResponse();
    }
    
    /** Simulates invokation of the webservice **/
    global void doInvoke( Object stub, Object request, Map<String, Object> response,
           					String endpoint, String soapAction, String requestName,
           					String responseNS, String responseName, String responseType) {
        system.debug('#### Myr_PersonalDataBCS10_WS_MK - doInvoke - BEGIN request=' + request);
        response.put('response_x', buildBCSResponse());
    	system.debug('#### Myr_PersonalDataBCS10_WS_MK - doInvoke - END');         						
    }
    
    /** Build the BCS response
     * @return Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Output_element
    **/
    private Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Output_element buildBCSResponse() {
    	
    	Myr_PersonalDataBCS10_WS.description descrip = new Myr_PersonalDataBCS10_WS.description();
        descrip.type_x='test';
        descrip.typeCode='test';
        descrip.subType='test';
        descrip.subTypeCode='test';
        
        Myr_PersonalDataBCS10_WS.wsInfos wsInfos = new Myr_PersonalDataBCS10_WS.wsInfos();
        wsInfos.wsVersion='test';
        wsInfos.wsEnv='test';
        
        Myr_PersonalDataBCS10_WS.survey survey = new Myr_PersonalDataBCS10_WS.survey();
        survey.surveyOK='test';
        survey.value='test';
        survey.loyMessage='test';
        
        /*Myr_PersonalDataBCS10_WS.dealerList dealerList = new Myr_PersonalDataBCS10_WS.dealerList();
        Myr_PersonalDataBCS10_WS.birId birId1 = new Myr_PersonalDataBCS10_WS.birId();
        dealerList.birId.add(birId1);*/
    	
    	Myr_PersonalDataBCS10_WS.servicePrefs servPref = new Myr_PersonalDataBCS10_WS.servicePrefs();
        servPref.irn='test';
        servPref.sia='test';
        servPref.reqid='test';
        servPref.userid='test';
        servPref.language='test';
        servPref.country='test';
        
        Myr_PersonalDataBCS10_WS.custDataRequest custDataRequest = new Myr_PersonalDataBCS10_WS.custDataRequest();
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
        custDataRequest.idMyr='test';
        custDataRequest.firstRegistrationDate='test';
        custDataRequest.registration='test';
        custDataRequest.email='test';
        custDataRequest.ownedVehicles='test';
        custDataRequest.nbReplies='test';
        
        Myr_PersonalDataBCS10_WS.request request = new Myr_PersonalDataBCS10_WS.request();
        request.servicePrefs = servPref;
        request.custDataRequest = custDataRequest;
        
        Myr_PersonalDataBCS10_WS.getCustData getCustData = new Myr_PersonalDataBCS10_WS.getCustData();
        getCustData.request = request;
    	
    	Myr_PersonalDataBCS10_WS.getCustDataTopElmt getCustDataTopElmt = new Myr_PersonalDataBCS10_WS.getCustDataTopElmt();
        getCustDataTopElmt.getCustData = getCustData;
        
        Myr_PersonalDataBCS10_WS.BCScommAgreement BCScommAgreement = new Myr_PersonalDataBCS10_WS.BCScommAgreement();
        BCScommAgreement.Global_Comm_Agreement='test';
        BCScommAgreement.Preferred_Communication_Method='test';
        BCScommAgreement.Post_Comm_Agreement='test';
        BCScommAgreement.Tel_Comm_Agreement='test';
        BCScommAgreement.SMS_Comm_Agreement='test';
        BCScommAgreement.Fax_Comm_Agreement='test';
        BCScommAgreement.Email_Comm_Agreement='test';
    	
    	Myr_PersonalDataBCS10_WS.contact contact = new Myr_PersonalDataBCS10_WS.contact();
        contact.phoneCode1='test';
        contact.phoneNum1='test';
        contact.phoneCode2='test';
        contact.phoneNum2='test';
        contact.phoneCode3='test';
        contact.phoneNum3='test';
        contact.email='test';
        contact.preferredCom='test';
        contact.optin='test';
        
        Myr_PersonalDataBCS10_WS.workshopList workshop = new Myr_PersonalDataBCS10_WS.workshopList();
        workshop.date_x='test';
        workshop.km='test';
        workshop.birId='test';
        workshop.description = descrip;
        
        Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Input_element getCustData_Input_element = new Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Input_element();
        getCustData_Input_element.getCustData = getCustData;
            	
    	Myr_PersonalDataBCS10_WS.response pDataResponse = new Myr_PersonalDataBCS10_WS.response();
		
		Myr_PersonalDataBCS10_WS.clientList client = new Myr_PersonalDataBCS10_WS.clientList();
		client.IdClient = '13553167';
		client.LastName = 'DURAND';	
		client.FirstName = 'RAYNALD';
		client.Lang = 'FRA';
		client.address = new Myr_PersonalDataBCS10_WS.address();
		client.address.strName = '13 RUE FELIX TERRIER';
		client.address.countryCode = 'FR';
		client.address.zip = '75020';
		client.address.city = 'PARIS';
		Myr_PersonalDataBCS10_WS.vehicleList vehicle = new Myr_PersonalDataBCS10_WS.vehicleList();
		vehicle.vin = 'VF1C4050500764359';
		vehicle.brandCode = 'RENAULT';
		vehicle.modelCode = 'XX';
		vehicle.modelLabel = 'OTHER';
		vehicle.registrationDate = '1991-09-10';
		vehicle.firstRegistrationDate = '1987-05-01';
		vehicle.registration = '381JNK75';
		vehicle.possessionBegin = '1991-09-10';
		
		pDataResponse.clientList = new List<Myr_PersonalDataBCS10_WS.clientList>();
		client.vehicleList = new List<Myr_PersonalDataBCS10_WS.vehicleList>();
		client.vehicleList.add(vehicle);
		pDataResponse.clientList.add(client);
		Myr_PersonalDataBCS10_WS.getCustDataResponse getCustDataResponse = new Myr_PersonalDataBCS10_WS.getCustDataResponse();
		getCustDataResponse.response = pDataResponse;
		Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Output_element response = new Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService_getCustData_Output_element();
		response.getCustDataResponse = getCustDataResponse;
		
		Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService BCS_spcCrmGetCustDataService = new Myr_PersonalDataBCS10_WS.BCS_spcCrmGetCustDataService();
		Myr_PersonalDataBCS10_WS.getCustDataResponseTopElmt getCustDataResponseTopElmt = new Myr_PersonalDataBCS10_WS.getCustDataResponseTopElmt();
        getCustDataResponseTopElmt.getCustDataResponse = getCustDataResponse;

    	return response;
    }
}