public with sharing class Rforce_W2CUpdateAccount_Controller {


    Id caseId=ApexPages.currentPage().getParameters().get('caseId');
    public List<caseAccount> accwrapList {get; set;}
    List<case> caseRec=new List<case>();
    List<Account> accRec=new List<Account>();
    List<Account> accDetailRec=new List<Account>();
    String casAccountId;
    Account acc=new Account();
    public Account updateAcc{get;set;}
    public Case updateCase{get;set;}
    Case caseForm=new case();
    Id casAccountIds;
    String show{get;set;}
    Pagereference cagePg=null;
    String display;
    Id csAccId;
    public String upFirstName{
    get;
    set {upFirstName=value;
    }
    }
    public String upLastName{
    get;
    set {upLastName=value;

    }
    }
    public String upPhone{
    get;
    set {upPhone=value;
    }
    }
    public String upEmail{
    get;
    set {  
    upEmail=value;

    }
    }
    public String upStreet{
    get; 
    set {upStreet=value;
    
    }
    }
    public String upCity{
    get; 
    set {upCity=value;
     
    }
    }
    public String upState{
    get; 
    set {upState=value;
    
    }
    }
   public String upName{
    get;    
    set {upName=value;
   
    }
    }
 public String upSecondSurname{
    get; 
    set {upSecondSurname=value;
    
    }
    }
    public String upCommAgreement{
    get;    
    set {upCommAgreement=value;
   
    }
    }
    public String upBillingPostalCode{
    get;    
    set {upBillingPostalCode=value;
   
    }
    }
    public String casecountry{get;set;}     
    public List<Case> getRecordsToDisplay() {
        return caseRec;
    }
    public List<caseAccount> getCaseAccList() {
        accwrapList= new List<caseAccount>();
        try{
        caseForm=[select Id,accountId,CaseNumber,Cell_Phone_Web__c,Address_Web__c,City_Web__c,SuppliedName,SuppliedPhone,SuppliedEmail,Email_Opt_In_Web__c,Second_name_Web__c,FirstName_Web__c,LastName_Web__c,License_Number_Web__c,State_Web__c,Title_Web__c,VIN_Web__c,Swiss_Web__c,Postal_Code_Web__c,CountryCase__c from case where Id=:caseId];
        casAccountIds=caseForm.accountId;
        casecountry=caseForm.CountryCase__c;
        acc=[select Id,name,phone,BillingCity, BillingCountry,BillingState, BillingStreet, BillingPostalCode,PersEmailAddress__c,ComAgreemt__c,SecondSurname__c from account where id=:casAccountIds];
        }
        catch(Exception e){
        System.debug('Error');
        }
        accwrapList.add(new caseAccount(caseForm,acc));
        return accwrapList;
    }
    public List<Account> getAccDetail() {
      
        try{
        csAccId=[select accountid from case where Id=:caseId].accountid ;
     
         accDetailRec=[SELECT AccountBrand__c,CurrencyIsoCode,Description,Fax,Id, Name, AccountNumber, Phone, FOManagerEmail__c, FOManagerName__c, FOManagerPhone__c, FOProvider__c from account where Id=:csAccId];
        }
        catch(Exception e){
        System.debug('Error');
        }
        
        return accDetailRec;
    }
    public class caseAccount{
        public Case cadetail {get; set;}
        public Account accdetail {get; set;}
        public Boolean selected {get; set;}
        
        public caseAccount(Case c,Account ac) {
        cadetail = c;
        accdetail=ac;
        selected = false;
        }
        
    }

    public PageReference bckToCase(){
        return cagePg= new PageReference('/'+caseId);
    }
    public PageReference processSelected() {
    system.debug('upBillingPostalCode--'+upBillingPostalCode);
    updateAcc=new Account();
    updateCase=new Case();
    if(upFirstName!=null){
    updateAcc.firstName=upFirstName;
    }
    if(upLastName!=null){
    updateAcc.lastName=upLastName;
    }
    if(upPhone!=null){
    updateAcc.phone=upPhone;
    }
    if(upEmail!=null){
    updateAcc.PersEmailAddress__c=upEmail;
    }
    if(upStreet!=null){
    updateAcc.billingstreet=upStreet;
    }
    if(upCity!=null){
    updateAcc.billingcity=upCity;
    }
    if(upState!=null){
    updateAcc.billingstate=upState;
    }
    if(upSecondSurname!=null){
    updateAcc.SecondSurname__c=upSecondSurname;
    }
    if(upBillingPostalCode!=null){
    system.debug('upBillingPostalCode--'+upBillingPostalCode);
    updateAcc.BillingPostalCode=upBillingPostalCode;
    }    
    
    if(upCommAgreement!=null){
    
        if(upCommAgreement == 'True') {
            updateAcc.ComAgreemt__c = 'Yes';
        }
        if(upCommAgreement == 'False') {
            updateAcc.ComAgreemt__c = 'No';
        }
    }
    
    updateAcc.Id=casAccountIds;
    try{
        update updateAcc;
        updateCase.Id=caseId;
        update updateCase;
    
    }
    catch(Exception e){}
      
        return null;
    
    }
     public PageReference processSelectedcmd() {
         return null;
     }
    public Id getAccountIds(){
        return casAccountIds;
    }
}