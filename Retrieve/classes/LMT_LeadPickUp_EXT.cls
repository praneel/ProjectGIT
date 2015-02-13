/**
 * Controller class to work with confirmation screen for picking up a lead.
 */
public with sharing class LMT_LeadPickUp_EXT
{
	
	/** Lead Id */
	private ApexPages.StandardController stdController;
	/** true if pick-up has failed */
	public Boolean failed {get; private set;}
	
	/**
	 * Constructor
	 * @param sc
	 */
	public LMT_LeadPickUp_EXT( ApexPages.StandardController sc )
	{
  		stdController = sc;
  		failed = false;
  	}
  	
  	/**
  	 * Picks up the lead
  	 */
  	public PageReference pickUp()
  	{
        /****************************** CODE BY PIERRE TO REVIEW (05/0914)
  		try
  		{
	  		Lead lead1 = (Lead) stdController.getRecord();
            	
            
            //## Case where the lead owner is a user
            if ( String.valueOf(lead1.OwnerId).startsWith('005') ) {
                UserRecordAccess ura = [SELECT RecordId, HasReadAccess, HasEditAccess
                                     FROM UserRecordAccess
                                     WHERE UserId = : Userinfo.getUserId()
                                     AND RecordId = : lead1.Id limit 1];
            	System.debug('######## LMT_LeadPickUp_EXT => pickUp : ura = ' + ura);
                
				if (ura != null) {
                    if (ura.HasEditAccess) {
                        lead1.OwnerId = Userinfo.getUserId();
                        update lead1;
                        return new PageReference( '/' + lead1.Id );
                    }
                    else {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LMT_Lead_PickUp_Error ) );
                        return null;
                    }
                }
				return null;              
            }
            //## Case where the lead owner is a queue
            else {
               //Get the members of the queue
               List<GroupMember> members = [SELECT	 UserOrGroupId
                   						    FROM	 GroupMember g
                   						    WHERE	 groupId = : lead1.OwnerId];
               System.debug('######## LMT_LeadPickUp_EXT => pickUp : members = ' + members);
                
               if (members != null) {
                    Boolean isMember = false;
                    for (GroupMember m : members) {
                        System.debug('######## LMT_LeadPickUp_EXT => pickUp : userid logged = ' + Userinfo.getUserId() + ' | m.UserOrGroupId = ' + m.UserOrGroupId);
                        if (Userinfo.getUserId() == m.UserOrGroupId) {
                            isMember = true;
                            break;
                        }
                    }
                    if (isMember) {
                        lead1.OwnerId = Userinfo.getUserId();
                        update lead1;
                        return new PageReference( '/' + lead1.Id );
                    }
                    else {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LMT_Lead_PickUpFromQueue_Error ) );
                        return null;
                    }
               } 
                
               return null;
           }
            	  		
  		}
        *****************************************************************************************/
        
        try
  		{
	  		Lead lead1 = [SELECT Id, OwnerId FROM Lead WHERE Id = :stdController.getId()];
            lead1.OwnerId = Userinfo.getUserId();
            update lead1;
            
			try{	        
	            // also process duplicate children. 
				LMT_LeadOwnershipUtils_CLS.reassignDuplicateLeads(lead1.Id, Userinfo.getUserId());
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.LMT_Reassignation_DuplicateNotReassigned));					
				System.debug(LoggingLevel.DEBUG, '##### LMT_LeadPickUp_EXT - WARNING reassign - Lead:' + lead1 + ' ; First error=' + e.getMessage());
			}

            return new PageReference( '/' + lead1.Id );
            
        }
  		catch( Exception e )
  		{
  			if( e instanceof DmlException && ((DmlException)e).getDmlType( 0 ) == StatusCode.INSUFFICIENT_ACCESS_OR_READONLY )
  			{
            	ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LMT_Lead_PickUp_Error ) );
  			}
  			else
  			{
  				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LMT_Controller_ErrorOccured ) );
  				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, e.getMessage() ) );
  			}
  			failed = true;
            return null;
  		}
  	}
  	
}