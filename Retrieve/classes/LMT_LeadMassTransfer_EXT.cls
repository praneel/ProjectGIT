public with sharing class LMT_LeadMassTransfer_EXT {

    public List<Lead> leads {get; set;}
    private ApexPages.StandardSetController sc;
    private String retURL;
    
    public LMT_LeadMassTransfer_EXT(ApexPages.StandardSetController sc0){
        //-- two ways to get the set
        String customids = ApexPages.currentPage().getParameters().get('customids');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        //System.debug('#### LMT_LeadMassTransfer_EXT - <init> - retURL='+retURL);
        if (customids != null){
            String[] ids = customids.split(',');
            leads = [SELECT Name, OwnerId, Date_Echeance__c, Status FROM Lead WHERE Id IN :ids];
        }else{
            List<Lead> sel = sc0.getSelected();
            leads = [SELECT Name, OwnerId, Date_Echeance__c, Status FROM Lead WHERE Id IN :sel];
        }
        sc = sc0;
    }
    
    public PageReference save(){
    	try{
	        Lead record = (Lead) sc.getRecord();
	        for (Lead l : leads){
	            l.OwnerId = record.OwnerId;
	            l.Is_assigned__c = true;
            	LMT_LeadUtils_CLS.changeLeadStatusAfterUserAssignment(l);
		        if (record.Date_Echeance__c != null){
		            l.Date_Echeance__c = record.Date_Echeance__c;
		        }
	        }
	        update leads;
	        
	        //------- Assign child leads
			try{	        
	            // also process duplicate children. 
				LMT_LeadOwnershipUtils_CLS.massReassignDuplicateLeads(leads, record.OwnerId);
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.LMT_Reassignation_DuplicateNotReassigned));					
				System.debug(LoggingLevel.DEBUG, '##### LMT_LeadMassTransfer_EXT - WARNING reassign - First error=' + e.getMessage());
			}

	        
	        System.debug('#### LMT_LeadMassTransfer_EXT - save - retURL='+retURL);
	        return new PageReference(retURL);
    	}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.LMT_Controller_ErrorOccured));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;    	
    	}
    }

}