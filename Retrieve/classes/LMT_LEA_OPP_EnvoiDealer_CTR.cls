public with sharing class LMT_LEA_OPP_EnvoiDealer_CTR {

	public Account account {get;set;}	
	public Contact contact{get;set;}

	public LMT_LEA_OPP_EnvoiDealer_CTR() {
		User u = [Select Id, Name, ContactId from User where Id = :UserInfo.getUserId() LIMIT 1];
		
		if(u.ContactId == null){
			system.debug('LMT_LEA_OPP_EnvoiDealer_CTR - ' + u.Name + ' is not a dealer');
		}
		else{
			contact = [Select Id, Name, Salutation, FirstName, Lastname, Phone, AccountId, MobilePhone, LeadSource
			 from Contact where Id = :u.ContactId LIMIT 1];
			
			system.debug('LMT_LEA_OPP_EnvoiDealer_CTR - contact civilité : ' + contact.Salutation);
			system.debug('LMT_LEA_OPP_EnvoiDealer_CTR - contact FirstName : ' + contact.FirstName);
			system.debug('LMT_LEA_OPP_EnvoiDealer_CTR - contact Lastname : ' + contact.Lastname);
			
			account = [Select Id, Name, LogoId__c from Account where Id = :contact.AccountId LIMIT 1];
			}
	}

}