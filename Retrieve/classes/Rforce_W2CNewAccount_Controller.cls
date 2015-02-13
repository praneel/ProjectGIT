public with sharing class Rforce_W2CNewAccount_Controller {

    public Id caseId = ApexPages.currentPage().getParameters().get('caseId');

public List<case> caseRec = new List<case>();

    public String accFirstName;
    public String accLastName;
    public String CPF;
    public String billingStreet;
    public String billingCity;
    public String billingState;
    public String personTitle;
    public String phone;
    public String cellPhone;
    public String email;
    public String VIN;
    public String licenseNo;
    public String caseNumber;
    public ID accRecTypeId;
    public String billingCountry;
    public String  accSource;
    public String  accSubsource;
    public String accBrand;
    public String commAggreement = 'yes';
    //Added for Portugal Country
    public String billingPostalCode;
    // Add SecondSurname for UKRAINE country
    public String accSecSurname;





    public Rforce_W2CNewAccount_Controller () {
    }
    //This method is used to redirect users to New Account Page
    public PageReference accountRedirectPage() {

        try {

            caseRec = [select Id, CaseNumber, CaseBrand__c, Origin, CaseSubSource__c, CountryCase__c, Address_Web__c, City_Web__c, Postal_Code_Web__c, Cell_Phone_Web__c, SuppliedName, SuppliedPhone, SuppliedEmail, Email_Opt_In_Web__c, FirstName_Web__c, LastName_Web__c, License_Number_Web__c, State_Web__c, Title_Web__c, VIN_Web__c, Second_name_Web__c from case where Id = :caseId];

        }

        catch (System.Stringexception e) {

            System.debug(e.getMessage());
        } catch (System.Listexception e) {
            System.debug(e.getMessage());
        }
        caseNumber = caseRec[0].CaseNumber;

        if (caseRec[0].FirstName_Web__c != null) {
            accFirstName = caseRec[0].FirstName_Web__c;
        } else {
            accFirstName = '';
        }

        if (caseRec[0].LastName_Web__c != null) {
            accLastName = caseRec[0].LastName_Web__c;
        } else {
            accLastName = '';
        }
        if (caseRec[0].Title_Web__c != null) {
            personTitle = caseRec[0].Title_Web__c;
        } else {
            personTitle = '';
        }

        // accLastName=caseRec[0].LastName_Web__c;
        // personTitle=caseRec[0].Title_Web__c;

        /*    if(caseRec[0].CPF_Web__c!=null)
                CPF=caseRec[0].CPF_Web__c;

            else{
                CPF='';
            }

            */
        if (caseRec[0].Address_Web__c != null) {
            billingStreet = caseRec[0].Address_Web__c;
        } else {
            billingStreet = '';
        }
        if (caseRec[0].City_Web__c != null) {
            billingCity = caseRec[0].City_Web__c;
        } else {
            billingCity = '';
        }
        
        // Add SecondSurname for UKRAINE country
        if(caseRec[0].Second_name_Web__c!=null){
            accSecSurname=caseRec[0].Second_name_Web__c;
        } else{
            accSecSurname='';
        }
        


        //Added for Portugal Country

        if (caseRec[0].Postal_Code_Web__c != null) {
            billingPostalCode = caseRec[0].Postal_Code_Web__c;
        } else {
            billingPostalCode = '';
        }

        if (caseRec[0].CountryCase__c != null) {
            billingCountry = caseRec[0].CountryCase__c;
        } else {
            billingCountry = '';
        }



        if (caseRec[0].State_Web__c != null) {
            billingState = caseRec[0].State_Web__c;
        } else {
            billingState = '';
        }
        if (caseRec[0].SuppliedPhone != null) {
            phone = caseRec[0].SuppliedPhone;
        } else {
            phone = '';
        }
        if (caseRec[0].Cell_Phone_Web__c != null) {
            cellPhone = caseRec[0].Cell_Phone_Web__c;
        } else {
            cellPhone = '';
        }
        email = caseRec[0].SuppliedEmail;

        if (caseRec[0].SuppliedEmail != null) {
            email = caseRec[0].SuppliedEmail;
        } else {
            email = '';
        }




        if (caseRec[0].CaseBrand__c != null) {
            accBrand = caseRec[0].CaseBrand__c;
        } else {
            accBrand = '';
        }


        if (caseRec[0].Origin != null) {
            accSource = caseRec[0].Origin;
        } else {
            accSource = '';
        }

        if (caseRec[0].CaseSubSource__c != null) {
            accSubsource = caseRec[0].CaseSubSource__c;
        } else {
            accSubsource = '';
        }


        VIN = caseRec[0].VIN_Web__c;
        if (caseRec[0].License_Number_Web__c != null) {
            licenseNo = caseRec[0].License_Number_Web__c;

        }
        if(caseRec[0].CountryCase__c=='Switzerland'){
            if(caseRec[0].Swiss_Web__c==True){
                commAggreement='Yes';   
            }
            else if(caseRec[0].Swiss_Web__c==False){
                commAggreement='No';
            }
        }
        accRecTypeId = [Select Id, Name, DeveloperName from Recordtype WHERE SObjectType = 'Account' and Name = 'CORE-ACC-Personal Account RecType'].Id;

        If(caseRec[0].Origin == 'Email') {
            return new PageReference('/001/e?RecordType=' + accRecTypeId + '&00Nb0000007Q4ob=' + caseNumber + '&AccountSource=' + accSource);

        }
        return new PageReference('/001/e?ent=Account&nooverride=1&RecordType=012b0000000awv8&retURL=%2F001%2Fo&name_firstacc2=' + accFirstName + '&name_lastacc2=' + accLastName + '&acc10=' + phone + '&name_salutationacc2=' + personTitle + '&acc18street=' + billingStreet + '&acc18country=' + billingCountry + '&acc18city=' + billingCity + '&00N90000007WHiU=' + email + '&00Nb0000007Q4ob=' + caseNumber + '&00Nb0000007Q4px=' + cellPhone + '&acc18state=' + billingState + '&00Nb0000007Q4pG=' + phone + '&00Nb0000007Q4ps=' + email + '&00Nb0000007Q4oi=' + billingCountry + '&00Nb0000007Q4oC=' + accBrand + '&AccountSource=' + accSource + '&00Nb0000007Q4od=' + commAggreement + '&acc18zip=' + billingPostalCode);

    }

}