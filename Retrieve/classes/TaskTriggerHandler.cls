// ---------------------------------------------------------------------------
// Project: RForce, LMT
// Name: TaskTriggerHandler
// Desc: This class is used to fill "Subject" & "Type" information on a task
// CreatedBy: Praneel Pidikiti
// CreatedDate: 06/03/2014
// ---------------------------------------------------------------------------

public with sharing class TaskTriggerHandler {



    // ---------------------------------------------------------------------------------------
    // checkIsClosedCase method: Prevent task from being created on a closed case
    // ---------------------------------------------------------------------------------------
    public static void checkIsClosedCase(list<Task> lTasks) {
        set<Id> setCaseId = new set<Id>();
        map<Id, Task> mapTaskCase = new map<Id, Task>();
        Task oCaseTask = new Task();
        for (Task oTask : lTasks) {
            System.Debug('### SFDC - TaskTrigger.checkIsClosedCase : oTask.WhatId:' + oTask.WhatId);
            if (oTask.WhatId != null) {
                if (String.valueOf(oTask.WhatId).startsWith('500')) {
                    setCaseId.add(oTask.WhatId);
                    mapTaskCase.put(oTask.WhatId, oTask);
                }
            }

        }
        
        System.Debug('### SFDC - TaskTrigger.checkIsClosedCase : setCaseId.size:' + setCaseId.size());
        if (!setCaseId.isEmpty()) {
            for (Case oClosedCase : [select Id from Case where IsClosed = true and id in:setCaseId]) {
                if (mapTaskCase.containsKey(oClosedCase.Id)) {
                    oCaseTask = mapTaskCase.get(oClosedCase.Id);
                    oCaseTask.addError(Label.Task_Error_Closed_Case);
                }
            }
        }
    }


    // --------------------------------------------------------------------------------------
    // fillTaskType method: Fill "Type" field on the Task object based on the "Subject" field
    // --------------------------------------------------------------------------------------
    public static void fillTaskType(list<Task> lTasks) {
        // Collections
        map<String, String> refTaskSubjectTypeMappingMap = new map<String, String>();

        // "Ref - Task Subject Type Mapping" custom setting
        for (Task_Subject_Mapping__c oRTSTM : Task_Subject_Mapping__c.getAll().Values()) {
            refTaskSubjectTypeMappingMap.put(oRTSTM.Name, oRTSTM.Type__c);
        }

        for (Task oTask : lTasks) {
            // Fill "Type" information
            if (oTask.Type == '' || oTask.Type == null) {
                if (refTaskSubjectTypeMappingMap.containsKey(oTask.Subject)) {
                    oTask.Type = refTaskSubjectTypeMappingMap.get(oTask.Subject);
                }
            }
        }
    }
    // ---------------------------------------------------------------------------------------
    // fillTaskSubject method: Fill "Subject" field with "Type" information if "Subject" is blank
    // ---------------------------------------------------------------------------------------
    public static void fillTaskSubject(list<Task> lTasks) {       
        for (Task oTask : lTasks) {
            // Check if "Subject" is blank
            if (oTask.Subject == '' || oTask.Subject == null) {
                oTask.Subject = oTask.Type;
            }
        }
    }

    /**
     * trigger after insertion.
     */
    public static void onAfterInsert( List<Task> taskRecords ) {
        LMT_TaskUtils_CLS.updateLeadStatus( taskRecords );
        LMT_TaskUtils_CLS.updateOpportunityStatus( taskRecords );
        RForce_CasUpdateModifiedDate.UpdateModifedDateTaskInsert(taskRecords); 
    }

    /**
     * trigger after update.
     */
    public static void onAfterUpdate( List<Task> oldTaskRecords, List<Task> newTaskRecords ,Map<Id,Task> oldtaskmap) {
        LMT_TaskUtils_CLS.updateLeadStatus( newTaskRecords );
        LMT_TaskUtils_CLS.updateOpportunityStatus( newTaskRecords ); 
        RForce_CasUpdateModifiedDate.UpdateModifedDateTaskUpdate(oldTaskRecords,newTaskRecords,oldtaskmap); 
    }

    /**
     * trigger before insert.
     */
    public static void onBeforeInsert( List<Task> taskRecords ) {
        LMT_TaskUtils_CLS.preventTaskInsertion( taskRecords );
        for(Task ts: taskRecords){
            if(ts.Subject=='Brochure Request'){
               ts.Type='Sending Brochure';
               ts.ReminderDateTime=system.now().addHours(2);
            }
        } 
                
        for(Task oTask : taskRecords) {
         System.Debug('### SFDC - TaskTrigger.checkIsClosedCase : oTask.WhatId:' + oTask.WhatId);
         try{  
          Integer i = oTask.Description.length(); 
                                                    
           if (oTask.Description!= null) { 
             if (i > 200) {
                i = 195;                                                                
              }
               oTask.Comment_Preview__c=oTask.Description.substring(0,i);      
           }
           }
           catch(Exception e)
           {
           System.debug('comments'+e);
           }
         }                    
      }
  /**
     * added by ashok for trigger before insert task in Email-Inbound.    
     */  
        public static void onBeforeInserttask( List<Task> taskRecords ) {
         if(Rforce_Recursive.runOnce()){
        for(Task ts: taskRecords){          
       if(ts.Subject!=null){               
          if(ts.Subject.contains('Email')&& ts.type==null){
               ts.Type='Email-Inbound';
               ts.IsReminderSet = true;
               ts.ReminderDateTime=system.now().addHours(2);  
              }             
            }
           } 
        }
      } 
      
     /**
     * trigger before update.
     */     
      
     public static void onBeforeUpdate( List<Task> taskRecords ) {
       for (Task oTask : taskRecords) {
         System.Debug('### SFDC - TaskTrigger.onBeforeUpdate : oTask.WhatId:' + oTask.WhatId);
         try{
          Integer i = oTask.Description.length(); 
           if (oTask.Description!= null) { 
             if (i > 200) {
                i = 195;                                                                
              }           
               oTask.Comment_Preview__c=oTask.Description.substring(0,i);         
            } 
            }
            catch(Exception e)
            {
             System.debug('comments'+e);
            }                 
          }      
       }
    /**
     * trigger before delete.
     */
    public static void onBeforeDelete( List<Task> oldTaskRecords ) {
        LMT_TaskUtils_CLS.preventTaskDeletion( oldTaskRecords );
    }
      
  
}