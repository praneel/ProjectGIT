/**
 * This class is a extension controller class for lead re-assignment functionnality.
 *
 */
public without sharing class LMT_LeadReassign_EXT {
    /** the lead */
    public Lead lead {get; set;}
    /** Error message */
    @TestVisible private String errMsg;

	/**
	 * Constructor.
	 * @param	sc	lead standard controller
	 */
    public LMT_LeadReassign_EXT(ApexPages.StandardController sc){
    	System.debug(LoggingLevel.DEBUG, '##### LMT_LeadReassign_EXT - <init> - User:' + UserInfo.getName());
        lead = [SELECT Id, Assignment_Counter__c, Country__c, LeadSource, Brand__c, DealerOfInterest__c, TypeOfInterest__c, SubType_Of_Interest__c, AssignmentError__c, OwnerId, Status, Campaign__c FROM Lead WHERE Id = :sc.getId()];
    }
    
    /**
     * Reassigns a lead by sending it to assignment matrix and chains to leads list page.
     */
    public PageReference reassign(){
        try{
            System.debug(LoggingLevel.DEBUG, '##### LMT_LeadReassign_EXT - BEGIN reassign - Lead:' + lead);

            LMT_LeadAssignmentRuleProcessor_CLS processor = new LMT_LeadAssignmentRuleProcessor_CLS(new Lead[]{lead}, false);
            processor.execute();
			update lead;
			
			try{	        
	            // also process duplicate children. 
				LMT_LeadOwnershipUtils_CLS.reassignDuplicateLeads(lead.Id, lead.OwnerId);
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.LMT_Reassignation_DuplicateNotReassigned));					
				System.debug(LoggingLevel.DEBUG, '##### LMT_LeadReassign_EXT - WARNING reassign - Lead:' + lead + ' ; First error==' + e.getMessage());
			}
			
            return new PageReference('/00Q');
        }catch(Exception e){
            errMsg = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
            System.debug(LoggingLevel.DEBUG, '##### LMT_LeadReassign_EXT - ERROR reassign - Lead=' + lead + ' ; errMsg=' + errMsg);
            return null;
        }
    }
}