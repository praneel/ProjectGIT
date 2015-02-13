/***************************************************************************
@Class              LMT_NetWorkVisibilityUtils_CLS
@Trigger            Lead_AfterInsert_Trigger, Lead_AfterUpdate_Trigger
					Opportunity_AfterInsert_Trigger, Opportunity_AfterUpdate_Trigger
					PropCom_AfterInsert_Trigger, PropCom_AfterUpdate_Trigger
@VisualforcePage    None
@CodeCoverage       95%
Created by Pierre Leleony (19/08/14)
>> On inserting a SObject record or on updating the owner of the SObject record,
>> this one is automatically shared with the users at the high levels
>> on the Account hierarchy (sous-plaque/plaque/groupe)
****************************************************************************/
public without sharing class LMT_NetWorkVisibilityUtils_CLS {
	
    //###	Manage account hierarchy
    private Map<Id, List<Id>> mapTopIds = new Map<Id, List<Id>>();      //Map current account Id, top account Ids
    private Map<Id, Id> mapTopId = new Map<Id, Id>();                   //Map current account Id, top acc
    private Map<Id, Id> mapOwnerIdAccountId = new Map<Id, Id>();        //USER> Map user id, account id
    private Map<Id, Id> mapUser = new Map<Id, Id>();            		//USER> Map SObject id, user id
    private Map<Id, Id> mapAccountUser = new Map<Id, Id>();         	//USER> Map SObject id, account id
    private Map<Id, Id> mapQueueIdAccountId = new Map<Id, Id>();        //QUEUE> Map queue id, account id
    private Map<Id, Id> mapQueue = new Map<Id, Id>();           		//QUEUE> Map lead id, queue id
    private Map<Id, Id> mapAccountQueue = new Map<Id, Id>();        	//QUEUE> Map lead id, account id
    
    //###	Manage visibility sharing on country
    private Map<Id, String> mapCountry = new Map<Id, String>();			//Map SObject id, SObject country
    private Set<String> countryVisibilitySet = new Set<String>();
  
    
    
    /*
        @Method     LMT_NetWorkVisibilityUtils_CLS
        @Param      String, List<SObject> 
    */
    public LMT_NetWorkVisibilityUtils_CLS (String typeObj, List<SObject> records) {
         
        //##### Set the maps of user, queue (if lead) and country
        setMapsUserQueueCountry(typeObj, records);
        
        //##### Process SObject User
        processSObjectUser(typeObj, records);
        
        //##### Process SObject Queue
        if (!mapQueue.isEmpty()) {
            processSObjectQueue(typeObj, records);
        }
        
        //##### Set the visibility country list
    	setVisibilityCountryList(); 
        
        //##### Set all Account hierarchy and do sharing
        if (   setAccountHierarchy(  getMapCountryVisibility( getAllAccountMaps() )  )   ) {
            doSharing(typeObj, records);            
        }      
        else {
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS | LMT_NetWorkVisibilityUtils_CLS => Network Visibility disabled on the CountryVisibility CS !!!');
        }
        
    }
		   
    
    /*
        @Method     setMapsUserQueueCountry
        @Param      String
        @Return     void
    */
    private void setMapsUserQueueCountry(String obj, List<SObject> records) {
        
        for (SObject so : records) {
            Id soId			 = (Id) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'Id', so);
            Id soOwnerId	 = (Id) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'OwnerId', so);
            String soCountry = (String) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'Country', so);
            
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | soId = ' + soId);
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | soOwnerId = ' + soOwnerId);
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | soCountry = ' + soCountry);
            //Set mapUser
            if (String.valueOf(soOwnerId).startsWith('005') == true) {
                mapUser.put(soId, soOwnerId);
            }
            //Set mapQueue
            else {
                mapQueue.put(soId, soOwnerId);
            }
            //Set mapCountry
            if (soCountry != null) {
                mapCountry.put(soId, soCountry);    
            }
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | mapUser = ' + mapUser);
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | mapQueue = ' + mapQueue);
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => setMapsUserQueueCountry | mapCountry = ' + mapCountry);
        }
    }
    
    /*
        @Method     processSObjectUser
        @Param      String, List<SObject>
        @Return     void
    */
    private void processSObjectUser(String obj, List<SObject> records) {
        
        //Get the list of users with a partner community licence
        List<User> userListPartnerCommunity = [SELECT        Id, AccountId, Name
                                               FROM          User
                                               WHERE         Profile.UserLicense.Name = 'Partner Community'
                                               AND           Id IN : mapUser.values()];
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS => userListPartnerCommunity = ' + userListPartnerCommunity);

        if (userListPartnerCommunity != null) {
            //Set a map of user ids with the account ids associated
            for (User u : userListPartnerCommunity) {
                mapOwnerIdAccountId.put(u.Id, u.AccountId);
            }
            
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => mapOwnerIdAccountId = ' + mapOwnerIdAccountId);
            
            //Set mapAccountUser
            for (SObject so : records) {
                Id soId = (Id) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'Id', so);
                if (mapUser.containsKey(soId)) {
                    mapAccountUser.put(soId, mapOwnerIdAccountId.get(mapUser.get(soId)));
                }
            }
        	System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  processSObjectUser => mapAccountUser = ' + mapAccountUser);   
        }
    }
    
    /*
        @Method     processSObjectQueue
        @Param      String, List<SObject>
        @Return     void
    */
    private void processSObjectQueue(String obj, List<SObject> records) {
    
        Map<String, Id> mapQueueNameId = new Map<String, Id>();
        
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS | processSObjectQueue => mapQueue = ' + mapQueue);
    
        //Get the queues from queues ids            
        List<Group> queues = [SELECT     Type, OwnerId, Name, Id, DeveloperName
                              FROM		 Group
                              WHERE  	 Type = 'queue'
                              AND    	 Id IN : mapQueue.values()];
        
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  processSObjectQueue => queues = ' + queues);   
        
        if (queues != null) {
            //Get the names list of the queues
            for (Group  q : queues) {
                mapQueueNameId.put(q.DeveloperName, q.Id);
            }
            //Get the Lead Dealer Queue records from the names list
            List<Lead_Dealer_Queue__c> ldqList = [SELECT     Id, Dealer__c, Queue_Name__c
                                      			  FROM		 Lead_Dealer_Queue__c
                                              	  WHERE  	 Queue_Name__c IN : mapQueueNameId.keySet()];
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  processSObjectQueue => ldqList = ' + ldqList); 
            
            if (ldqList != null) {
                //Set a map queue id and account id
                for (Lead_Dealer_Queue__c ldq : ldqList) {
                    mapQueueIdAccountId.put(mapQueueNameId.get(ldq.Queue_Name__c), ldq.Dealer__c);
                }
                //Set a map lead id and account id
                for (SObject so : records) {
                    Id soId = (Id) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'Id', so);
                    if (mapQueue.containsKey(soId)) {
                        mapAccountQueue.put(soId, mapQueueIdAccountId.get(mapQueue.get(soId)));
                    }
                }
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  processSObjectQueue => mapAccountQueue = ' + mapAccountQueue); 
            }
        } 
    }
    

    /*
        @Method     setVisibilityCountryList : Set of the list for network visibility by country
        @Param      None
        @Return     void
    */
    private void setVisibilityCountryList() {
        //Get all values of CountryInfo CS
        List<Country_Info__c> countryInfoList = Country_Info__c.getAll().values();
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  setVisibilityCountryList => countryInfoList = ' + countryInfoList);   
        if (countryInfoList != null) {
            for (Country_Info__c ci : countryInfoList) {
                if (ci.Network_Visibility__c == true) {
                    countryVisibilitySet.add(ci.Name);
                }
            }
        }
        
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  setVisibilityCountryList => countryVisibilitySet = ' + countryVisibilitySet);   
    }
    

    /*
        @Method     getAllAccountMaps : Merge into one map the two maps of SObject id, account id
        @Param      None
        @Return     Map<Id, Id>
    */
    private Map<Id, Id> getAllAccountMaps() {
        Map<Id, Id> mapAll = new Map<Id, Id>();
        if (!mapAccountUser.isEmpty()) {
            mapAll.putAll(mapAccountUser);
        }
        if (!mapAccountQueue.isEmpty()) {
            mapAll.putAll(mapAccountQueue);
        }
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS |  getAllAccountMaps => mapAll = ' + mapAll);     
        return mapAll;
    }
    
 
    /*
        @Method     getMapCountryVisibility : Filter the map SObject id, account id by Country visibility
        @Param      Map<Id, Id>
        @Return     Map<Id, Id>
    */
    private Map<Id, Id> getMapCountryVisibility(Map<Id, Id> mapAll) {
        Map<Id, Id> newMap = new Map<Id, Id>();
        if (!mapAll.isEmpty()) {
            for (Id id : mapAll.keySet()) {
                if (countryVisibilitySet.contains(mapCountry.get(id)) ) {
                    newMap.put(id, mapAll.get(id));
                }
            }
        }
        else {
            newMap = null;
        }   
        return newMap;
    }
    

    /*
        @Method     setAccountHierarchy : Setting the Account hierarchy for all SObject into maps
        @Param      Map<Id, Id>
        @Return     Boolean
    */
    private Boolean setAccountHierarchy(Map<Id, Id> mapIds) {  
        List<Account> accountList;
        if (mapIds != null && !mapIds.isEmpty()) {
            accountList = [SELECT    Id, ParentId, Parent.ParentId, Parent.Parent.ParentId
                           FROM      Account
                           WHERE     Id IN : mapIds.values()];
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS => accountList = ' + accountList);
            
            //Get the top level parent account for each element of the list
            if (accountList != null) {
                for (Account a : accountList) {        
                    setMaps(mapTopIds.containsKey(a.Id), a);
                }
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS => mapTopIds = ' + mapTopIds);
            }
            return true;
        }
        else {
        	return false;
        }
    }

    
    
    /*
        @Method     setMaps
        @Param      Boolean, Account
        @Return     void
    */
    private void setMaps(Boolean isExist, Account a) {
        List<Id> topIds;
        if (isExist) {
            topIds = mapTopIds.get(a.Id);
        }
        else {
            topIds = new List<Id>();
        }
    
        Id topId = null;        
        
        //First top level
        if (a.ParentId != null) {
            topId = a.ParentId;
            topIds.add(topId);
            //Second top level
            if (a.Parent.ParentId != null) {
                topId = a.Parent.ParentId;
                topIds.add(topId);
                //Third top level
                if (a.Parent.Parent.ParentId != null) {
                    topId = a.Parent.Parent.ParentId;
                    topIds.add(topId);
                }
            }
        }

        if (!topIds.isEmpty()) {        
            mapTopIds.put(a.Id, topIds);
        }
        else {
            //Put the current account id with empty Id list into the map
            List<Id> ids = new List<Id>();
            mapTopIds.put(a.Id, ids);
        }
        
    }
   
    
    /*
        @Method     doSharing
        @Param      none
        @Return     PageReference
    */
    private PageReference doSharing(String obj, List<SObject> records) {
        
        List<Id> userRoleIds = new List<Id>();
        Map<Id, Id> mapUserRoleTopAccount = new Map<Id, Id>();
        Map<Id, Id> mapTopAccountGroup = new Map<Id, Id>();
        List<Id> topAccountIdList = new List<Id>();	//List of all top account ids (plaque + group) and all current account ids (affaire)
        
        //Get the appropriate share SObject list to insert
        List<SObject> shareSObjectList = LMT_ShareObjectUtils_CLS.getShareObjectList(obj);
       
        
        //############################################
        //  SHARE THE SOBJECT RECORDS
        //############################################
        
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => mapTopIds = ' + mapTopIds);
        //Add the all current account ids to the global list
        topAccountIdList.addAll(mapTopIds.keySet());
        
        //Add the all top account ids to the global list
        if (!mapTopIds.values().isEmpty()) {
            for (List<Id> topAcctIdL : mapTopIds.values() ) {
                topAccountIdList.addAll(topAcctIdL);
            } 
        } 
        System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => all | topAccountIdList = ' + topAccountIdList);
        
        if(!topAccountIdList.isEmpty()){
            for(UserRole oUserRole : [SELECT Id, PortalAccountId, Name FROM UserRole WHERE PortalAccountId in : topAccountIdList and PortalRole = 'Executive']){
                System.Debug('### SFDC - LMT_NetWorkVisibilityUtils_CLS.doSharing => oUserRole.Name: ' + oUserRole.Name);
                userRoleIds.add(oUserRole.Id);
                mapUserRoleTopAccount.put(oUserRole.Id, oUserRole.PortalAccountId);
            }
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => mapUserRoleTopAccount = ' + mapUserRoleTopAccount);
            
            for(Group oGroup : [SELECT Id, RelatedId, DeveloperName FROM Group WHERE RelatedId in : userRoleIds and Type = 'RoleAndSubordinates']){
                System.Debug('### SFDC - LMT_LeadTopLevelSharing_CLS.doSharing => oGroup.DeveloperName: ' + oGroup.DeveloperName);
                mapTopAccountGroup.put(mapUserRoleTopAccount.get(oGroup.RelatedId), oGroup.Id);
            }    
            System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => mapTopAccountGroup = ' + mapTopAccountGroup);
        }
        
        for(SObject so : records){
            
            Id objId = (Id) LMT_ShareObjectUtils_CLS.getObjectField(obj, 'Id', so);
            
            if( getMapCountryVisibility(getAllAccountMaps()).containsKey(objId) ){
                
                //The current account id associated to the lead
                Id acctId = getMapCountryVisibility(getAllAccountMaps()).get(objId);
                
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => acctId = ' + acctId);
                
                //Add the lead share instance related to the current account id 
                if (mapTopAccountGroup.get(acctId) != null) {
                    shareSObjectList.add( LMT_ShareObjectUtils_CLS.getShareObject(obj, objId, 'Read', mapTopAccountGroup.get(acctId)) );
                    System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => sharing visibility inside the dealer account');
                }
                else {
                    System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => Error on current account : ' + acctId);
                }
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => current account | shareSObjectList = ' + shareSObjectList);
                
                //The accounts ids parent to the current account
                List<Id> acctParentIds = mapTopIds.get(acctId);
                
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => acctParentIds = ' + acctParentIds);
                
                if (acctParentIds != null && !acctParentIds.isEmpty()) {
                    
                    Integer compt = 0;
                    String errorList  = '';
                    
                    //Loop on the parent account ids
                    for (Id apId : acctParentIds) {
                        if (mapTopAccountGroup.get(apId) != null) {
                            shareSObjectList.add( LMT_ShareObjectUtils_CLS.getShareObject(obj, objId, 'Edit', mapTopAccountGroup.get(apId)) );
                            System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => top account | shareSObjectList = ' + shareSObjectList);
                        }
                        else {
                            compt++;
                            errorList = errorList + apId + ', ';
                        }
                    }
                    
                    if (compt > 0) {
                        System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => ERROR | No userole defined for the accounts = ' + errorList);
                    }
                    
                }
                
            }
        }
        
        if (!shareSObjectList.isEmpty()) {
            try {
                Database.insert(shareSObjectList, false);
            }
            catch(Exception e) {
                System.debug('########### LMT_NetWorkVisibilityUtils_CLS.doSharing => exception = ' + e.getMessage());
            }
            
        }
            
        
        return null;
      
    }
    
}