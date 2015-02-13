/**
 * Process some treatments on lead ownership that necessitate a without sharing mode.
 */
public with sharing class LMT_LeadOwnershipUtils_CLS {

	public class DuplicateLeadReassignmentException extends Exception {}

    /**
     * Reassign duplicate leads
     */
	public static void reassignDuplicateLeads(Id parentId, Id owneId){
		System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN reassignDuplicateLeads parentId=' + parentId + ' OwnerId=' + owneId);    
        // also process duplicate children. 
        List<Lead> lleads = new List<Lead>();
    	for (Lead child : [SELECT Id, OwnerId FROM Lead WHERE Parent_Lead__c = :parentId]){
			// reassign to cold queue - or default error queue if any error
			System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN reassignDuplicateLeads child.Id=' + child.Id);    
			child.OwnerId = owneId;		            		
			lleads.add(child);
    	}
        
        Database.Saveresult[] results = Database.update(lleads, false);
        for (Database.Saveresult sr : results){
        	if (!sr.isSuccess()){
             	System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - reassignDuplicateLeads - ERROR : ' + sr.getErrors()[0].getMessage());
        		throw new DuplicateLeadReassignmentException( sr.getErrors()[0].getMessage() );
        	}else{
        		System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - reassignDuplicateLeads - Reassigned : ' + sr.getId());
        	}	
        }
	}
	
	/**
     * Mass Reassign duplicate leads
     */
	public static void massReassignDuplicateLeads(Lead[] parentLeads, Id ownerId){

		System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN massReassignDuplicateLeads parentLeads=' + parentLeads + ' OwnerId=' + ownerId);    
        if (!LMT_LeadUtils_CLS.doNotMassAssignDuplicateLeads()){
	        List<Lead> lLeadsToUpdate = new List<Lead>();
	        //------- search children
	        for (Lead c : [SELECT Id FROM Lead WHERE Parent_Lead__c IN :parentLeads]){
	        	System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN massReassignDuplicateLeads child.Id=' + c.Id);
				c.OwnerId = ownerId;
				c.Is_assigned__c = true;
				lLeadsToUpdate.add(c);
	        }
        	Database.SaveResult[] results = Database.update(lLeadsToUpdate, false);
	        for (Database.Saveresult sr : results){
	        	if (!sr.isSuccess()){
	             	System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - massReassignDuplicateLeads - ERROR : ' + sr.getErrors()[0].getMessage());
	        		throw new DuplicateLeadReassignmentException( sr.getErrors()[0].getMessage() );
	        	}else{
	        		System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - reassignDuplicateLeads - Reassigned : ' + sr.getId());
		        }
	        }
        }	
    }
    
    /**
     * Mass accept pReassignment duplicate leads
     */
	public static void massAcceptReassignDuplicateLeads(Lead[] parentLeads){

		System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN massAcceptReassignDuplicateLeads parentLeads=' + parentLeads);
        if (!LMT_LeadUtils_CLS.doNotMassAssignDuplicateLeads()){
        	
        	// searching pre-assigned sellers from parent leads -> directly querying "Parent_Lead__r.Preassigned_Seller__c" doesn't work
        	Map<Id, Id> preassigned = new Map<Id, Id>();
        	for (Lead p : parentLeads){
        		preassigned.put(p.Id, p.Preassigned_seller__c);	
        	}
        	
	        List<Lead> lLeadsToUpdate = new List<Lead>();
	        //------- search children 
	        List<Lead> lleads = [SELECT Id, OwnerId, Parent_Lead__c FROM Lead WHERE Parent_Lead__c IN :parentLeads];
	        for (Lead c : lleads){
	        	String ps = preassigned.get(c.Parent_Lead__c);
	        	System.debug(LoggingLevel.DEBUG, '##### LMT_LeadOwnershipUtils_CLS - BEGIN massAcceptReassignDuplicateLeads child.Id=' + c.Id + ' to:' + ps);
				c.OwnerId = ps;
				c.Is_assigned__c = true;
				lLeadsToUpdate.add(c);
	        }
        	Database.SaveResult[] results = Database.update(lLeadsToUpdate, false);
	        for (Database.Saveresult sr : results){
	        	if (!sr.isSuccess()){
	             	System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - massAcceptReassignDuplicateLeads - ERROR : ' + sr.getErrors()[0].getMessage());
	        		throw new DuplicateLeadReassignmentException( sr.getErrors()[0].getMessage() );
	        	}else{
	        		System.debug(LoggingLevel.INFO, '##### LMT_LeadOwnershipUtils_CLS - reassignDuplicateLeads - Reassigned : ' + sr.getId());
		        }
	        }
        }	
    }
}