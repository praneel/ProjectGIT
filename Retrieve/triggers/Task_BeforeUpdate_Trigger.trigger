// ---------------------------------------------------------------------------
// Project: RForce
// Name: Task_BeforeInsert_Trigger
// Desc: This trigger is to block event update on closed Case
// CreatedBy: Mehdi Salmi
// CreatedDate: 21/04/2014
// ---------------------------------------------------------------------------

trigger Task_BeforeUpdate_Trigger on Task (before update) {
    system.Debug('### - Task_BeforeUpdate_Trigger - BEGIN - Run by: ' + UserInfo.getName());   
    if (TriggerAdministration.canTrigger('Task.checkIsClosedCase')) {
        TaskTriggerHandler.checkIsClosedCase(trigger.new);
    }
    else {
        System.debug('### SFDC - Task_BeforeInsert_Trigger.fillTaskSubject Run by ' + UserInfo.getName());
    }      
    system.debug('### - Task_BeforeInsert_Trigger - END');
    
    if (TriggerAdministration.canTrigger('Task.onBeforeUpdate')) {
     TaskTriggerHandler.onBeforeUpdate(trigger.new);
    }
    else {
        System.debug('### SFDC - Task_BeforeUpdate_Trigger.onBeforeUpdateRun by ' + UserInfo.getName());
    }      
    
}