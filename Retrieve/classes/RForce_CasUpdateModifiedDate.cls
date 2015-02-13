// ---------------------------------------------------------------------------
// Project: RForce
// Name: RForce_CasUpdateModifiedDate
// Desc: This class is used to update last activity date on case (REQ-261)
// CreatedBy: Sumanth(RNTBCI)
// CreatedDate: 01/12/2014
// ---------------------------------------------------------------------------
public class RForce_CasUpdateModifiedDate{
   
     public static void UpdateModifedDateTaskInsert(List<Task> tslist){
         Set<Id> casids= new Set<Id>();
         for(Task t: tslist){
             String csid=t.WhatId;
             if(csid!=null && csid.Substring(0,3)=='500'){
                 casids.add(t.WhatId);
             }
         }
         if(casids!=null){
             updatecaselist(casids);
         }   
     }
    
     public static void UpdateModifedDateTaskUpdate(List<Task> oldtslist,List<Task> newtslist,Map<Id,Task> oldmaptask){
         Set<Id> casids= new Set<Id>();
         List<Case> caslist=new List<Case>();         
         for(Task t: newtslist){
             Task told=oldmaptask.get(t.id);
             system.debug('told--'+told);
             String csid=t.WhatId;
             if(csid!=null && csid.Substring(0,3)=='500'){
                 system.debug('told--'+told);
                 system.debug('t--'+t);
                 if(t.From_To__c!=told.From_To__c || t.Subject!=told.Subject || t.Type!=told.Type ||
                    t.Description!=told.Description || t.Priority!=told.Priority || t.Status!=told.Status ||
                    t.ActivityDate!=told.ActivityDate || t.Contains_link_or_attachement__c!=told.Contains_link_or_attachement__c || 
                    t.WhoId!=told.WhoId || t.ownerid != told.ownerid){
                     casids.add(t.WhatId);
                 }    
             }
         }         
         if(casids!=null){
             updatecaselist(casids);
         } 
     } 
     public static void updatecaselist(Set<Id> casupdateids){
         List<Case> caslist=new List<Case>();         
         for(Case c: [Select Id,Modified_Date__c from Case where Id IN  : casupdateids]){
             if(c.Id!=null){
                 c.Last_Modified_Date_of_Task__c=system.now();
                 caslist.add(c);
             }    
         }
         if(caslist!=null){
             try{
                 update caslist;
             }catch(Exception e){
                 system.debug('updatingcaselist'+e);
             }    
         }         
     }
}