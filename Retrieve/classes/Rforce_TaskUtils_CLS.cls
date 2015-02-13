public with sharing class Rforce_TaskUtils_CLS
{
   /** 
      * Author : Rajavel Baskaran
      * Date   : 13-Oct-2014
      * Description: Contains Link or attachment checkbox should be active on Task insertion, if any attachment/URL Link1/URL Link2 presents. 
      * SCRUM ID  :    
      * RO Number : REQ-00314
      * Release No: R5
      * Sprint ID : 9
      */      

    public static void onAfterInsert(list <Task> listtask, boolean isInsert, Map <Id, Task> oldMap){
       Id attid;
       Integer i=0;
       List<Task> tasklist=new List<Task>();
       Set<Id> taskId=new Set<Id>();
       Set<Id> tID=new Set<Id>();
       Set<Id> parentId=new Set<Id>();
       system.debug('listtask-->'+listtask);
      // if(Rforce_Recursive.runOnce()){    
       for(Task ts : listtask){
       tID.add(ts.Id); 
       }
         if(!tID.isEmpty()){
          try{
          // Checking if task contains any attachment and make variable equal's 1. If no attachment then variable is 2
              Attachment att=[Select Id,ParentId from attachment where ParentId IN : tID limit 1];

              if(att!=null){
                 taskId.add(att.ParentID);
                  i=1;                 
              }else{
                 taskId.add(att.ParentID);
                  i=2;
              }
          }
          catch(Exception e){
              system.debug('Exception in catch onAfterInsert'+e);
          }
       }
       for(Task tsk : listtask){
       parentId.add(tsk.Id);
       }
       if(taskId.isEmpty()){       
       taskId=parentId;
       }
       // Enable Contains_link_or_attachment if URL Link1 and Link2 available , else make its as false
       for(Task t:[Select Id,Contains_link_or_attachement__c,URL_Link_1__c,URL_Link_2__c from Task where Id IN :taskId]){
        if(t.URL_Link_1__c != null || t.URL_Link_2__c !=null || i == 1){
           t.Contains_link_or_attachement__c=true;
           }else{
           t.Contains_link_or_attachement__c=false;
           }
           tasklist.add(t);
       }
       try{
           update tasklist;        
       }
       catch(Exception e){
              system.debug('Error in onAfterInsert==>'+e);
          }
     // }
   
    // }
    }
/**
      * Author : Rajavel Baskaran
      * Date   : 13-Oct-2014
      * Description: Contains Link or attachment checkbox should be active on Task Updation, if any attachment/URL Link1/URL Link2 presents. 
      * SCRUM ID  :    
      * RO Number : REQ-00314
      * Release No: R5
      * Sprint ID : 9
      */  
    public static void onAfterUpdate(list <Task> listtask, boolean isUpdate, Map <Id, Task> oldMap){
       Id attid;
       Integer i=0;
       
       List<Task> tasklist=new List<Task>();
       List<Attachment> atlist=new List<Attachment>();
       Set<Id> taskId=new Set<Id>();
       Set<Id> tID=new Set<Id>();
       Set<Id> parentId=new Set<Id>();       
       
      // if(Rforce_Recursive.runOnce()){      
       for(Task ts : listtask){ 
       tID.add(ts.Id);
       }
       if(!tID.isEmpty()){
          try{          
             // Checking if task contains any attachment and make variable equal's 1. If no attachment then variable is 2
             Attachment att=[Select Id,ParentId from attachment where ParentId IN : tID limit 1];
              if(att!=null){
                 taskId.add(att.ParentId);
                  i=1;                 
              }else{
                 taskId.add(att.ParentId);
                  i=2;
              }
          }
          catch(Exception e){
              system.debug('Exception in catch onAfterUpdate'+e);
          }
      }
       for(Task tsk : listtask){
       parentId.add(tsk.Id);
       }
       if(taskId.isEmpty()){       
       taskId=parentId;
       }
       
      // Enable Contains_link_or_attachment if URL Link1 and Link2 available , else make its as false
      for(Task t:[Select Id,Contains_link_or_attachement__c,URL_Link_1__c,URL_Link_2__c from Task where Id IN :taskId]){
      
           if(t.URL_Link_1__c != null || t.URL_Link_2__c !=null || i == 1){
           t.Contains_link_or_attachement__c=true;
           }else{
           t.Contains_link_or_attachement__c=false;
           }
           tasklist.add(t);
           
       }
          System.debug('tasklist in TaskTriggerHandler'+tasklist);
       try{
       update tasklist;
       }
       catch(Exception e){
              system.debug('Error in onAfterUpdate==>'+e);
          }
     //  }
     
      }
     
    }