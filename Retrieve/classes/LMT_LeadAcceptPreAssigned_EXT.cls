public with sharing class LMT_LeadAcceptPreAssigned_EXT {

    public List<Lead> assignableLeads {get; private set;}
    public List<Lead> notassignableLeads {get; private set;}
    public Map<String, User> userMap {get; private set;}
    public String retURL {get; private set;}
    private Lead record;
    
    public LMT_LeadAcceptPreAssigned_EXT(ApexPages.StandardSetController sc){
        //-- model object
        record = (Lead) sc.getRecord();
        //-- construct instance variables
        assignableLeads = new List<Lead>();
        notassignableLeads = new List<Lead>();
        userMap = new Map<String, User>();
        //-- get selected oppties
        List<Lead> leads ; 
        //-- two ways to get the set
        String customids = ApexPages.currentPage().getParameters().get('customids');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (customids != null){
            String[] ids = customids.split(',');
            leads = [SELECT Name, Preassigned_Seller__c, OwnerId, Date_Echeance__c, SellerCode__c, Status FROM Lead WHERE Id IN :ids];
        }else{
            List<Lead> sel = sc.getSelected();
            leads = [SELECT Name, Preassigned_Seller__c, OwnerId, Date_Echeance__c, SellerCode__c, Status FROM Lead WHERE Id IN :sel];
        }
        //-- dispatch opportunities 
        for (Lead l : leads){
            if (!String.isBlank((String) l.Preassigned_Seller__c)){ 
                assignableLeads.add(l);
            }else{
                notassignableLeads.add(l);
            }
        }
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, customids));
    }
    
    /**
     * Accepts reassignation by assigning all opportunities to pre-assigned seller.
     */
    public PageReference accept(){
    	try{
	        for (Lead l : assignableLeads){
	            l.OwnerId = l.Preassigned_Seller__c;
	            l.Is_assigned__c = true;
            	LMT_LeadUtils_CLS.changeLeadStatusAfterUserAssignment(l);
		        if (record.Date_Echeance__c != null){
		            l.Date_Echeance__c = record.Date_Echeance__c;
		        }
	        }
	        update assignableLeads;
	        
	        //------- Assign child leads
			try{	        
	            // also process duplicate children. 
				LMT_LeadOwnershipUtils_CLS.massAcceptReassignDuplicateLeads(assignableLeads);
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.LMT_Reassignation_DuplicateNotReassigned));					
				System.debug(LoggingLevel.DEBUG, '##### LMT_LeadMassTransfer_EXT - WARNING reassign - First error=' + e.getMessage());
			}
	        
	        return new PageReference(retURL);
    	}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.LMT_Controller_ErrorOccured));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;    	
    	}
	}

}