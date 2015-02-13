/*****************************************************************************************
    Name    : Case_BeforeInsert_Trigger
    Desc    : This is to update contact country and language fields based on user country details
    Approach: Used Custom settings to store country information
    Project : Rforce

******************************************************************************************/

trigger Case_BeforeInsert_Trigger on Case (before insert) {
    if (TriggerAdministration.canTrigger('Case.onBeforeInsert')) {
        CaseTriggerHandler.onBeforeInsert(trigger.new, Trigger.isInsert, trigger.oldMap);
    } else {
        System.Debug('### Rforce - Case_BeforeInsert_Trigger : BYPASS onBeforeInsert - Run by ' + UserInfo.getName());
    }

}