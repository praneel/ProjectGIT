public with sharing class LMT_LeadUtils_CLS {
	
	/** lead status: Nouveau */
	public static final String LEADSTATUS_NEW 				= 'New';
	/** lead status: En cours */
	public static final String LEADSTATUS_INPROGRESS 		= 'In progress';
	/** lead status: Converti */
	public static final String LEADSTATUS_CONVERTED 		= 'Converted';
	/** lead status: Qualifié à affecter */
	public static final String LEADSTATUS_QUALIFIEDTOASSIGN = 'Qualified to assign';
	/** lead status: Qualifié */
	public static final String LEADSTATUS_QUALIFIED 		= 'Qualified';
	/** lead status: A affecter */
	public static final String LEADSTATUS_TOASSIGN 			= 'To assign';
	/** lead status: A relancer */
	public static final String LEADSTATUS_TOREMIND 			= 'To remind';
	/** lead status: Clos sans suite */
	public static final String LEADSTATUS_CLOSED 			= 'Closed';
	
	public static final String QUALIFICATION_IN_PROGRESS         = 'In progress';
	public static final String QUALIFICATION_INTERESTED_CONTACT  = 'Interested contact';
	public static final String QUALIFICATION_ARGUED_REFUSAL     = 'Argued refusal';
	public static final String QUALIFICATION_NON_ARGUED_REFUSAL = 'Non argued refusal';
	
	public static final String SUB_QUALIFICATION_LESS_THAN_THREE_MONTHS = '< 3 months';
	public static final String SUB_QUALIFICATION_3_MONTHS_TO_1_YEAR = '3 months to one year';
	public static final String SUB_QUALIFICATION_MORE_THAN_1_YEAR = '> 1 year';
	public static final String SUB_QUALIFICATION_ACTIVITY_TRANSFER      = 'Activity transfer';
	
	public static final String LEAD_RECORDTYPE_APV = 'LEA_APV';
	public static final String LEAD_RECORDTYPE_DG = 'LEA_DG';
	public static final String LEAD_RECORDTYPE_VN_VO = 'LEA_VN_VO';
	
	private static final Set<String> PLATFORM_LEAD_STATUSES = new Set<String>(new String[]{
		LEADSTATUS_NEW, LEADSTATUS_INPROGRESS, LEADSTATUS_QUALIFIED, LEADSTATUS_TOREMIND, LEADSTATUS_CLOSED});
	
	
	/** lead status transition map */
	public static Map<String, Set<String>> getLeadStatusTransitionMap()
	{
		Map<String, Set<String>> statusTransitionMap = new Map<String, Set<String>>();
    	statusTransitionMap.put( leadStatus_NEW, new Set<String>( new String[]{ leadStatus_NEW, leadStatus_INPROGRESS, leadStatus_CLOSED } ) );
    	statusTransitionMap.put( leadStatus_INPROGRESS, new Set<String>( new String[]{ leadStatus_INPROGRESS, leadStatus_CONVERTED, leadStatus_CLOSED } ) );
    	statusTransitionMap.put( leadStatus_QUALIFIED, new Set<String>( new String[]{ leadStatus_INPROGRESS, leadStatus_CLOSED } ) );
    	
    	return statusTransitionMap;
	}
	
	
	/** if the lead is from LMT SFA **/
	public static boolean isLmtSfaLead(String leadId){
		List<Lead> lead = [SELECT RecordTypeId from Lead where Id = :leadId LIMIT 1];
		
		if(lead == null || lead.size() == 0){
			return false;
		}
		
		RecordType recType = [Select Id, DeveloperName from RecordType where SobjectType = 'Lead' 
			and Id = :lead[0].RecordTypeId LIMIT 1];

		if(recType.DeveloperName.equals(LEAD_RECORDTYPE_APV) || recType.DeveloperName.equals(LEAD_RECORDTYPE_DG) || recType.DeveloperName.equals(LEAD_RECORDTYPE_VN_VO)){
			return true;
		}
		
		return false;
	}
	
	
	/**
	 * Changes lead status after assignment.
	 */
	public static void changeLeadStatusAfterUserAssignment(Lead l){ 
		if (LEADSTATUS_QUALIFIEDTOASSIGN.equals(l.Status)){
			l.Status = LEADSTATUS_QUALIFIED;
		}else if (LEADSTATUS_TOASSIGN.equals(l.Status)){
			l.Status = LEADSTATUS_NEW;
		}else if (LEADSTATUS_TOREMIND.equals(l.Status)){
			l.Status = LEADSTATUS_TOREMIND;
		}else if (LEADSTATUS_CLOSED.equals(l.Status)){
		}else{
			System.debug(LoggingLevel.WARN, '#### LMT_LeadUtils_CLS - changeLeadStatusAfterUserAssignment - Unexpected lead status: ' + l.Status + ' during assignment (left unchanged)');
		}
		
		l.Status2__c = l.Status;
	}
	
	/**
	 * Changes lead status after assignment.
	 */
	public static Boolean changeLeadStatusAfterAutomaticAssignment(Lead l, String assignmentType){ 
		System.debug(LoggingLevel.WARN, '#### LMT_LeadUtils_CLS - changeLeadStatusAfterAutomaticAssignment - lead status: ' + l.Status + ' assignment type: ' + assignmentType);
		if (LEADSTATUS_NEW.equals(l.Status)){
			if ('CSMO'.equals(assignmentType)){
				l.Status = LEADSTATUS_TOASSIGN;
			}
		}else if (LEADSTATUS_QUALIFIED.equals(l.Status)){
			if ('CSMO'.equals(assignmentType)){
				l.Status = LEADSTATUS_QUALIFIEDTOASSIGN;
			}
		}else if (LEADSTATUS_CLOSED.equals(l.Status)){
		}else if (LEADSTATUS_TOREMIND.equals(l.Status)){
		}else if (LEADSTATUS_INPROGRESS.equals(l.Status)){
			return false;				
		}else{
			System.debug(LoggingLevel.WARN, '#### LMT_LeadUtils_CLS - changeLeadStatusAfterAutomaticAssignment - Unexpected lead status: ' + l.Status + ' during assignment (left unchanged)');
		}
		
		l.Status2__c = l.Status;
		
		return true;
	}
    
    /**
     * get list of objects. Lead Dealer Queue or Lead Platform Queue.
     */
    public static Set<String> checkInvalidNamesAsQueueNames(List<sObject> records){
        //-- extract list of queue names
        Set<String> queueNames = new Set<String>();
        Set<String> unknownQueues = new Set<String>();
        for (sObject q : records){
            String name = (String) q.get('Queue_Name__c');
            queueNames.add(name);
            unknownQueues.add(name);
        }
        //-- launch query
        for (QueueSObject q : [select QueueId, Queue.DeveloperName FROM QueueSObject WHERE SobjectType = 'Lead' AND Queue.Type='Queue' 
            AND Queue.DeveloperName IN :queuenames]){
            //-- remove queue from unknown if found
            unknownQueues.remove(q.Queue.DeveloperName);
        }
        return unknownQueues;
        //-- loop over unknown names to add error on object
        /*if (!unknownQueues.isEmpty()){
            for (Lead_Platform_Queue__c q : records){
                if (unknownQueues.contains(q.Name)){
                    q.Name.addError(System.Label.LMT_Unknown_Lead_Queue.replace('{0}', q.Name));
                }
            }
        }*/
    }
    
    public static void addCmdmOrVtcfExistingAccount( List<Lead> leadRecords )
    {
        Map<String,Lead> cmdmIdMap = new Map<String,Lead>();
        Map<String,Lead> vtcfIdMap = new Map<String,Lead>();
        for( Lead lead : leadRecords )
        {
            if( !String.isEmpty( lead.cmdmId__c ) && !cmdmIdMap.containsKey( lead.cmdmId__c ) )
            {
                cmdmIdMap.put( lead.cmdmId__c, lead );
            }
            if( !String.isEmpty( lead.vtcfId__c ) && !vtcfIdMap.containsKey( lead.vtcfId__c ) )
            {
                vtcfIdMap.put( lead.vtcfId__c, lead );
            }
        }
        
        List<Account> accountRecords = [SELECT Id, Tech_ACCExternalID__c, vtcfId__c FROM Account WHERE Tech_ACCExternalID__c IN :cmdmIdMap.keySet() OR vtcfId__c IN :vtcfIdMap.keySet()];
        for( Account account : accountRecords )
        {
            Lead lead = cmdmIdMap.get( account.Tech_ACCExternalID__c );
            if( lead == null )
            {
                lead = vtcfIdMap.get( account.vtcfId__c );
            }
            
            if( lead != null )
            {
                lead.Account__c = account.id;
            }
        }
    }
    
    /**
     * get the list of lead sources that are automatically converted to opportunities at creation time.
     */
    public static Set<String> getSkipAssignmentRuleLeadSources(){
        String setting = CS03_LMT_Settings__c.getInstance().LeadSource_SkipCustomAssignmentRules__c;
        if (String.isEmpty(setting)){
            return new Set<String>(); 
        }
        String[] leadsources = setting.split(';');
        return new Set<String>(leadsources);
    }
    
    /**
     * searches approaching accounts from the lead object.
     */
    public static List<Account> searchApproachingAccounts(Lead lead){
        System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - for user:' + UserInfo.getUserName() + ' id:' + UserInfo.getUserId());
        //-- search of approaching accounts
        List<Account> accounts = new List<Account>();
        // TODO Add callout to CMDM...
        //-- search account based on VTCF or CMDM Id
        System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - lead.CMDMID__c:' + lead.CMDMID__c + '- lead.VTCFID__c:'+ lead.VTCFID__c );
        accounts = [SELECT Id, Name, Tech_ACCExternalID__c, vtcfId__c, Salutation, LastName, FirstName, PersEmailAddress__c, PersLandline__c, PersMobPhone__c, ProfLandline__c, ProfMobPhone__c, BillingStreet, BillingPostalCode, BillingCity, Country__c FROM Account WHERE ( Tech_ACCExternalID__c != NULL AND Tech_ACCExternalID__c = :lead.CMDMID__c ) 
            OR ( vtcfId__c != NULL AND vtcfId__c = :lead.VTCFID__c )];
        //-- first search on firstname, lastname and email
        System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - lead.FirstName:' + lead.FirstName + '- lead.LastName:'+ lead.Lastname + '- lead.Email:' + lead.Email + ' - lead.Country__c:' + lead.Country__c);
        if (accounts.size() == 0 && String.isNotBlank(lead.Email)){
            accounts = [SELECT Name, Salutation, LastName, FirstName, PersEmailAddress__c, ProfEmailAddress__c, PersLandline__c, PersMobPhone__c, ProfLandline__c, ProfMobPhone__c, BillingStreet, BillingPostalCode, BillingCity, Country__c, IsPersonAccount
                FROM Account WHERE IsPersonAccount = true AND LastName = :lead.LastName AND FirstName = :lead.FirstName AND Country__c = :lead.Country__c
                AND ( PersEmailAddress__c = :lead.Email OR ProfEmailAddress__c = :lead.Email )];
            System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - found with Email:' + accounts.size());
        }
        //-- if no result continue to search on any phone
        System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - lead.Phone__c:' + lead.Phone__c + ' lead.MobilePhone__c:' + lead.MobilePhone__c + ' lead.BusinessPhone__c:' + lead.BusinessPhone__c + ' lead.BusinessMobilePhone__c:' + lead.BusinessMobilePhone__c);
        if (accounts.size() == 0 && !(String.isBlank(lead.Phone__c) && String.isBlank(lead.MobilePhone__c) && String.isBlank(lead.BusinessPhone__c) && String.isBlank(lead.BusinessMobilePhone__c))){
            String lastName = lead.LastName;
            String firstname = lead.FirstName;
            String phone = lead.Phone__c;
            String mobilePhone = lead.MobilePhone__c;
            String businessPhone = lead.BusinessPhone__c;
            String profMobPhone = lead.BusinessMobilePhone__c;
            String leadCountry = lead.Country__c;
            String query = 'SELECT Name, Salutation, LastName, FirstName, PersEmailAddress__c, PersLandline__c, PersMobPhone__c, ProfLandline__c, ProfMobPhone__c, BillingStreet, BillingPostalCode, BillingCity, Country__c, IsPersonAccount' + 
                ' FROM Account WHERE IsPersonAccount = true AND LastName = :lastName AND FirstName = :firstname AND Country__c = :leadCountry';
            boolean iswhere = false;
            if (String.isNotBlank(lead.Phone__c)){
                query += ' AND (PersLandline__c = :phone';  
                iswhere = true;         
            }
            if (String.isNotBlank(lead.MobilePhone__c)){
                query += (iswhere ? ' OR' : ' AND (');
                query += ' PersMobPhone__c = :mobilePhone';
                iswhere = true;
            } 
            if (String.isNotBlank(lead.BusinessPhone__c)){
                query += (iswhere ? ' OR' : ' AND (');
                query += ' ProfLandline__c = :businessPhone';
            }
            if (String.isNotBlank(lead.BusinessMobilePhone__c)){
                query += (iswhere ? ' OR' : ' AND (');
                query += ' ProfMobPhone__c = :profMobPhone';
            }
            query += ')';
            System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - query:' + query);
            //-- launch query
            accounts = Database.query(query); 
            System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - found with phones:' + accounts.size());
        }
        //-- if no result continue to search on any phone
        System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - lead.PostalCode:' + lead.PostalCode + ' lead.City:' + lead.City);
        if (accounts.size() == 0 && String.isNotBlank(lead.PostalCode) && String.isNotBlank(lead.City)){
            accounts = [SELECT Name, Salutation, LastName, FirstName, PersEmailAddress__c, PersLandline__c, PersMobPhone__c, ProfLandline__c, ProfMobPhone__c, BillingStreet, BillingPostalCode, BillingCity, Country__c, IsPersonAccount
                FROM Account WHERE IsPersonAccount = true AND LastName = :lead.LastName AND FirstName = :lead.FirstName AND Country__c = :lead.Country__c
                AND BillingPostalCode = :lead.PostalCode AND BillingCity = :lead.City];
            System.debug('##### LMT_LeadUtils_CLS - searchApproachingAccounts - found with address:' + accounts.size());
        }
        return accounts;
    }
    
    /**
     * when a RCI lead is inserted, check campaigns existence & create it if it does not exist..
     * then associate to the lead
     */
    public static void checkCampaignsAfterInsertLead(List<Lead> leads){
    	Set<String> setCampaign = new Set<String>(); // contains all campaigns from leads without duplicate
    	Set<Lead> setLead = new Set<Lead>(); // contains all leads to update
    	Set<String> setLeadSource = getCheckCampaignsLeadSources();
    	
    	For(Lead lead : leads){
    		if(setLeadSource.contains(lead.LeadSource) && lead.Campaign__c != null){
    			setCampaign.add(lead.Campaign__c);
    			setLead.add(lead);
    		}
    	}
    	
    	if(setLead.isEmpty()) return;
    	
    	// get the list of existing campaigns in setCampaign
    	List<Campaign> listCampaigns = [Select Id, Name from Campaign where Name IN :setCampaign];
    	
    	Map<String,Campaign> mapCampaigns = new Map<String,Campaign>();
    	for(Campaign c : listCampaigns){
    		mapCampaigns.put(c.Name,c);
    	}
    	
    	for(String nom : mapCampaigns.keySet()){
    		if(setCampaign.contains(nom)){
    			setCampaign.remove(nom);
    		}
    	} // setCompaign contains only campaigns to create
    	
    	// new campaigns are created
    	List<Campaign> campaignsToInsert= new List<Campaign>();
    	Campaign campToInsert = null;
    	for(String nameCampaign : setCampaign){
    		campToInsert = new Campaign();
    		campToInsert.Name = nameCampaign;
    		campToInsert.CurrencyIsoCode = 'EUR';
    		campaignsToInsert.add(campToInsert);
    		mapCampaigns.put(nameCampaign,campToInsert);
    	}
    	
    	insert campaignsToInsert;
    	
    	List<CampaignMember> listCM = new List<CampaignMember>();
    	For(Lead lead : setLead){
    		CampaignMember cm = new CampaignMember(campaignId = mapCampaigns.get(lead.Campaign__c).Id, leadId = lead.Id);
    		listCM.add(cm);
    	}
    	
    	insert listCM;

    }
    
    
    /**
     * get the list of lead sources where a campaign creation is necessary
     */
    public static Set<String> getCheckCampaignsLeadSources(){
        String setting = CS03_LMT_Settings__c.getInstance().LeadSource_CheckCampaign__c;
        if (String.isEmpty(setting)){
            return new Set<String>(); 
        }
        String[] leadsources = setting.split(';');
        return new Set<String>(leadsources);
    }
    
    public static void updateStatusFromQualification( List<Lead> leadRecords )
    {
    	for( Lead lead : leadRecords )
        {
        	String qualification    = lead.Qualification__c;
        	String subQualification = lead.SubQualification__c;
        	
        	if( !String.isEmpty( qualification )  && PLATFORM_LEAD_STATUSES.contains(lead.Status))
        	{
        		if( qualification == QUALIFICATION_ARGUED_REFUSAL || qualification == QUALIFICATION_NON_ARGUED_REFUSAL )
        		{
        			lead.Status = leadStatus_CLOSED;
        		}
        		else
        		if( qualification == QUALIFICATION_IN_PROGRESS )
        		{
        			lead.Status = leadStatus_INPROGRESS;
        		}
        		else
        		if( qualification == QUALIFICATION_INTERESTED_CONTACT )
        		{
        			if( !String.isEmpty( subQualification ) )
        			{
	        			if( subQualification == SUB_QUALIFICATION_LESS_THAN_THREE_MONTHS || subQualification == SUB_QUALIFICATION_ACTIVITY_TRANSFER )
	        			{
	        				lead.Status = leadStatus_QUALIFIED;
	        			}
	        			else if( subQualification == SUB_QUALIFICATION_3_MONTHS_TO_1_YEAR )
	        			{
	        				lead.Status = leadStatus_TOREMIND;
	        			}
	        			else if( subQualification == SUB_QUALIFICATION_MORE_THAN_1_YEAR )
	        			{
	        				lead.Status = leadStatus_CLOSED;
	        			}
        			}
        		}
        		
        		lead.Status2__c = lead.Status;
        	}
        }
    }
    
    /** Update the preassigned seller from the seller code user */
    public static void updatePreassignedSeller( List<Lead> leadRecords )
    {
    	Map<String, List<Lead>> sellerCodeLeadMap = new Map<String, List<Lead>>();
    	for( Lead lead : leadRecords )
        {
        	if( !String.isBlank( lead.SellerCode__c ) )
        	{
        		List<Lead> leadList = sellerCodeLeadMap.get( lead.SellerCode__c );
        		if( leadList == null )
        		{
        			leadList = new List<Lead>();
        			sellerCodeLeadMap.put( lead.SellerCode__c, leadList );
        		}
        		leadList.add( lead );
        	}
        }
        
        List<User> userList = [ SELECT Id, FederationIdentifier FROM User WHERE FederationIdentifier IN :sellerCodeLeadMap.keySet() ];
        for( User user : userList )
        {
        	List<Lead> leadList = sellerCodeLeadMap.get( user.FederationIdentifier );
        	if( leadList != null )
        	{
        		for( Lead lead : leadList )
        		{
        			if( lead != null )
        			{
        				lead.Preassigned_seller__c = user.Id;
        			}
        		}
        	}
        }
    }
    
    /**
     * Indicates whether a country-level configuration disables the mass assignment for duplicate leads.
     */
    public static Boolean doNotMassAssignDuplicateLeads(){
        boolean doNotAssign = false;
        String country = [SELECT RecordDefaultCountry__c FROM User WHERE Id =:UserInfo.getUserId()].RecordDefaultCountry__c;
        if (!String.isEmpty(country)){
	        Country_Info__c setting = Country_Info__c.getInstance(country);
	        if (setting != null){
	        	doNotAssign = setting.Do_not_mass_assign_duplicate_leads__c;	
	        }
        }
        System.debug('##### LMT_LeadUtils_CLS - doNotMassAssignDuplicateLeads - doNotAssign:' + doNotAssign);
        return doNotAssign;
    }
}