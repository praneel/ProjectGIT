/*  Create a personal account (Webservice) 
    Error codes :   OK              : WS01MS000 
                    OK WITH WARNING : WS01MS001 -> WS01MS500
                    CRITICAL ERROR  : WS01MS501 -> WS01MS999
*************************************************************************************************************
25 August 2014  : Creation
*************************************************************************************************************/
global class Myr_ManageAccount_WS {
  WebService static Myr_ManageAccount_WS_Response manageAccount (String accountBrand, String country, String accountSource, String accountSubSource, String accountSubSubSource, String city, String addressStreet, String zipCode, String emailAddress, String landLine1, String mobilePhone1, String firstName, String lastName, String title, String customerIdentificationNbr, String vin, String generalOptin) {
     /* IN parameter : accountBrand (mandatory)
        IN parameter : country (mandatory)
        IN parameter : accountSource (mandatory)
        IN parameter : accountSubSource (mandatory)
        IN parameter : accountSubSubSource
        IN parameter : city 
        IN parameter : addressStreet
        IN parameter : zipCode
        IN parameter : emailAddress (mandatory)
        IN parameter : landLine1
        IN parameter : mobilePhone1
        IN parameter : firstName (mandatory)
        IN parameter : lastName (mandatory)
        IN parameter : title
        IN parameter : customerIdentificationNbr
        IN parameter : vin
        IN parameter : generalOptin (mandatory)  */
     Account account;
     //Check mandatory fields value
     String fieldsLabel=missingMandatory(accountBrand, country, emailAddress, firstName, lastName, generalOptin, accountSource, accountSubSource);
     if (fieldsLabel != ''){
        return prepareResponse(account, 'WS01MS501', 'Value(s) missing : Parameter(s) '+ fieldslabel);
     }
     
     //VIN format
     if (vin!=''){
        Pattern p=Pattern.compile('^[0-9a-hA-Hj-nJ-NpPr-zR-Z]{17}$');
        Matcher MyMatcher=p.matcher(vin);
        if (!MyMatcher.matches()){
            return prepareResponse(account,'WS01MS505','VIN format KO. Format must be a 17-character-long String, with no letter O, Q and I');
        }
     }
      
     //Is there any existing SFDC Account that matches with input parameters ?
     account = searchAccount(lastName, firstName, customerIdentificationNbr, emailAddress); 
     if (account != null){
       //Is the found user a customer community one ?
       if (communityUser(account.Id)){
          //Is the community user an activated one?
          if (activatedUser(account.Id)){
             return prepareResponse(account, 'WS01MS002', 'Account was already existing, and an associated community user exists too. This user is yet activated');
          }else{
             return prepareResponse(account, 'WS01MS502', 'Account was already existing, and an associated community user exists too. This user is NOT activated');
          }
       }else{
          //I
          if (simpleUser(account.Id)){
             return prepareResponse(account, 'WS01MS503', 'Account was already existing, and an associated user exists too. This user is not a community one');
          }else{
             return prepareResponse(account, 'WS01MS001', 'Account was already existing, but there is no associated SFDC user');
          }
       }
       return null;
     }else { 
       //Call Personal Data
       Myr_PersonalData_WS.RequestParameters request = new Myr_PersonalData_WS.RequestParameters();
       request.lastname = lastName;
       request.firstname = firstName;
       request.email=emailAddress;
       request.idClient=customerIdentificationNbr;
       request.country=country;
       request.vin=vin; 
       request.brand=accountBrand;
       request.mdmMode = Myr_PersonalData_WS.MDM_MODE.MYRENAULT;
       
       Myr_PersonalDataResponse_Cls response = Myr_PersonalData_WS.getPersonalData(request);
       Account acc = new Account();
       //If we have no response or more than one reponse, we continue without taking into
       //account the personal data answer
       system.debug('>>>> Personal Data count of responses=' + ((response != null) ? response.response.infoClients.size() : 0));
       if( response!= null && response.response.infoClients.size() == 1 ) {
            Myr_PersonalDataResponse_Cls.InfoClient persData = response.response.infoClients[0];
            system.debug('>>>>>> Myr_ManageAccount_WS: PERSONAL DATA OK ! ');
            acc.FirstName = persData.FirstName;
            acc.LastName = persData.LastName;
            acc.PersEmailAddress__c = persData.email;
            acc.CustomerIdentificationNbr__c = persData.IdClient;
            if (title != null){
                acc.Title__c=title; 
            }
            if (zipCode != null){
                acc.ShippingPostalCode=zipCode; 
            }
            if (addressStreet != null){
                acc.RefAddressStreet__c=addressStreet;  
            }
            if (landLine1 != null){
                acc.PersLandline__c=landLine1;
            }
            if (mobilePhone1 != null){
                acc.PersMobPhone__c=mobilePhone1;
            }
            acc.AccountSource=accountSource;
            system.debug('WWWWWWWWWWWWWWWW : '+ accountSubSource + 'WWWWWWWWWWWWWWWWWw');
            if (accountSubSource!= null){
                acc.AccSubSource__c=accountSubSource;
            }
            if (accountSubSubSource != null){
                acc.Account_Sub_Sub_Source__c=accountSubSubSource;
            }
            acc.RecordTypeId = Myr_Users_Utilities_Class.getPersonalAccountRecordType();
            //acc.Salutation = persData.response.infoClients[0].Title; //TODO
            //acc.Sex__c = persData.response.infoClients[0] //TODO not parsed by MDM
            //acc.PersonBirthdate = persData.response.infoClients[0] //TODO not parsed by MDM
            system.debug('>>>>>> street num=' + persData.StrNum);
            system.debug('>>>>>> street type=' + persData.strType);
            system.debug('>>>>>> street name=' + persData.StrName   );
            acc.ShippingStreet = 
                ((persData.StrNum == null) ? '' : persData.StrNum + ' ')
                + ((persData.strType == null) ? '' : persData.strType + ' ')
                + ((persData.StrName == null) ? '' : persData.StrName + ' ');
            system.debug('>>>>>> acc.ShippingStreet=' + acc.ShippingStreet ); 
            acc.ShippingStreet = acc.ShippingStreet.trim();
            system.debug('>>>>>> acc.ShippingStreet=' + acc.ShippingStreet ); 
            acc.ShippingCity = persData.City;
            //acc.ShippingState = ; //TODO
            acc.ShippingPostalCode = persData.Zip;
            acc.ShippingCountry = persData.CountryCode;
            //acc. = persData.response.infoClients[0].PostCommAgreement;
            //acc. = persData.response.infoClients[0].TelCommAgreemen;
            //acc. = persData.response.infoClients[0].SMSCommAgreement;
            //acc. = persData.response.infoClients[0].FaxCommAgreement;
            //acc. = persData.response.infoClients[0].EmailCommAgreement;
            if( accountBrand.equalsIgnoreCase('RENAULT') ) {
                acc.MYR_CreationDate__c = system.now();
            } else if( accountBrand.equalsIgnoreCase('DACIA') ) {
                acc.MYD_CreationDate__c = system.now();
            }
            if( response.response.dataSource == Myr_PersonalData_WS.DataSourceType.MDM ) {
                //remove the eventual space in number)
                acc.PersMobPhone__c = (persData.strMobile != null) ? persData.strMobile.replaceAll(' ', '') : '';
                acc.HomePhone__c = (persData.strFixeLandLine != null) ? persData.strFixeLandLine.replaceAll(' ', '') : '';
            } else {
                //FOR BCS / RBX, this is not enough clear between phone1, phone2 and phone3
            }
            try {
                insert acc; 
            } catch (Exception e) {
                return prepareResponse( null, 'MS101', 'An issue occurred during the creation of the user: ' + e.getMessage() );
            }
       } else {
            system.debug('>>>>>> Myr_ManageAccount_WS: NO PERSONAL DATA ');
            acc.RecordTypeId = Myr_Users_Utilities_Class.getPersonalAccountRecordType();
            acc.FirstName=firstName; 
            acc.LastName=lastName;
            acc.CustomerIdentificationNbr__c=customerIdentificationNbr;
            acc.PersEmailAddress__c=emailAddress;
            if( accountBrand.equalsIgnoreCase('RENAULT') ) {
                acc.MYR_CreationDate__c = system.now();
            } else if( accountBrand.equalsIgnoreCase('DACIA') ) {
                acc.MYD_CreationDate__c = system.now();
            }
            acc.Shippingcountry = country;
            acc.ShippingCity = city;
            acc.OptinEmail__c=generalOptin;
            acc.OptinPhone__c=generalOptin;
            acc.OptinSMS__c=generalOptin;
            if (title != null){
                acc.Title__c=title; 
            }
            if (zipCode != null){
                acc.ShippingPostalCode=zipCode; 
            }
            if (addressStreet != null){
                acc.RefAddressStreet__c=addressStreet;  
                acc.ShippingStreet = addressStreet;
            }
            if (landLine1 != null){
                acc.PersLandline__c=landLine1;
            }
            if (mobilePhone1 != null){
                acc.PersMobPhone__c=mobilePhone1;
            }
            try {
                insert acc; 
            } catch (Exception e) {
                return prepareResponse(null,'WS01MS504','An issue occurred during the creation of the account: '+e.getMessage());
            }
       }
       return prepareResponse(acc, 'WS01MS000', 'Account created');
     }
  }
  
  //TO DO : select le meilleur (k1,k2,k3,k4)
  static Account searchAccount (String lastName, String firstName, String customerIdentificationNbr, String emailAddress) {
    String QueryString =  'FIND \'' 
                            +       lastName 
                            + ' ' + firstName 
                            + ' ' + customerIdentificationNbr 
                            + ' ' + emailAddress 
                            + '\' IN ALL FIELDS RETURNING ACCOUNT(id, lastname, firstname, CustomerIdentificationNbr__c, PersEmailAddress__c)';
    List<List<sObject>> listSOSL = search.query(queryString);
    try{
        List<Account> listAccount = listSOSL[0];
        if (listSOSL[0].size() > 1){
            String majorString='';
            String str='';
            String tmpString='';
            Integer bestRecordIndice = 0;
            for (Integer  i = 0; i < listSOSL[0].size(); i++) {
                tmpString =   ((Account) listSOSL[0].get(i)).lastname
                            + ((Account) listSOSL[0].get(i)).firstname
                            + ((Account) listSOSL[0].get(i)).CustomerIdentificationNbr__c
                            + ((Account) listSOSL[0].get(i)).PersEmailAddress__c
                            ;
                if (tmpString.length() > majorString.length()){ 
                    majorString=tmpString;
                    bestRecordIndice=i;
                }
            }
            system.debug('--------------best : ' + bestRecordIndice);
            system.debug('--------------best record found : '
                            + ((Account) listSOSL[0].get(bestRecordIndice)).lastname 
                            + ((Account) listSOSL[0].get(bestRecordIndice)).firstname
                            + ((Account) listSOSL[0].get(bestRecordIndice)).CustomerIdentificationNbr__c
                            + ((Account) listSOSL[0].get(bestRecordIndice)).PersEmailAddress__c);
            return ((Account) listSOSL[0].get(bestRecordIndice));       
        }else{
            system.debug('--------------record : '
                            + ((Account) listSOSL[0].get(0)).lastname 
                            + ((Account) listSOSL[0].get(0)).firstname
                            + ((Account) listSOSL[0].get(0)).CustomerIdentificationNbr__c
                            + ((Account) listSOSL[0].get(0)).PersEmailAddress__c);
            return ((Account) listSOSL[0].get(0));
        }
    }catch (Exception e) {
        return null;
    }
  }

  static boolean communityUser(String accountId) { 
    List<User> listUser = [SELECT Id FROM user where ProfileId = :Myr_Users_Utilities_Class.getHeliosCommunityProfile().Id and Contact.Account.Id=:accountId ];
    if (listUser.size() > 0){ 
      return true;
    }else{
      return false;
    }
  }
  
  static boolean simpleUser(String accountId) { 
    List<User> listUser = [SELECT Id FROM user where Contact.Account.Id=:accountId ];
    if (listUser.size() > 0){ 
      return true;
    }else{
      return false;
    }
  }

  static boolean activatedUser(String accountId) { 
    List<User> listUser = [SELECT Id FROM user where Contact.Account.Id=:accountId and isActive=true];
    if (listUser.size() > 0){ 
      return true;
    }else{
      return false;
    }
  }

  static String missingMandatory(String accountBrand, String country, String emailAdress, String firstName, String lastName, String generalOptin, String accountSource, String accountSubSource) { 
    String str='';
    if (accountBrand==''){
        str+='accountBrand ';
    }
    if (country==''){
        str+='country ';
    }
    if (emailAdress==''){
        str+='emailAdress ';
    }
    if (firstName==''){
        str+='firstName ';
    }
    if (lastName==''){
        str+='lastName ';
    }
    if (generalOptin==''){
        str+='generalOptin ';
    }
    if (accountSource==''){
        str+='accountSource ';
    }
    if (accountSubSource==''){
        str+='accountSubSource';
    }
    return str;
  }
  
  /** @return the response in case of a bad situation **/
  private static Myr_ManageAccount_WS_Response prepareResponse(Account a, String code, String message) {
    Myr_ManageAccount_WS_Response response = new Myr_ManageAccount_WS_Response();
    if (a==null){
        response.accountSfdcId = null;
    }else{
        response.accountSfdcId = a.id;  
    }
    response.info = new Myr_ManageAccount_WS_Response_Msg();
    response.info.code = code;
    response.info.message = message;
    return response;
  }
 
  global class Myr_ManageAccount_WS_Response {
    WebService String accountSfdcId;
    WebService Myr_ManageAccount_WS_Response_Msg info;
  }

  global class Myr_ManageAccount_WS_Response_Msg {
    WebService String code;
    WebService String message;
  }
  
  
}