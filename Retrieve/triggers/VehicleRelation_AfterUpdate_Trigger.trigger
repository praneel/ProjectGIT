/*****************************************************************************************
    Name    : VehicleRelation_AfterInsert_Trigger
    Desc    : Update Account as Old Customer or Customer based on Vehicle Relation Status
    Approach: 
    Author  : Sumanth (RNTBCI)
    Project : Rforce
******************************************************************************************/
trigger VehicleRelation_AfterUpdate_Trigger on VRE_VehRel__c (after Update) {
    if (TriggerAdministration.canTrigger('VehicleRelation.onAfterUpdate')) {   
        VehicleRelationTriggerHandler.onAfterUpdate(trigger.new, Trigger.isUpdate, trigger.oldMap);
        }
    else {
        System.Debug('### Rforce - VehicleRelation_AfterInsert_Trigger : BYPASS onAfterUpdate - Run by ' + UserInfo.getName());
    } 
    
    /* BEGIN Rforce QuickRabbit */
    if (TriggerAdministration.canTrigger('VehicleRelationAdmin.onAfterUpdate')) {   
        VehicleRelationAdminTriggerHandler.onAfterUpdate(trigger.new, Trigger.isInsert, trigger.oldMap);
    } else {
        System.Debug('### Rforce - VehicleRelationAdmin_AfterUpdate_Trigger : BYPASS onAfterUpdate - Run by ' + UserInfo.getName());
    } 
    /* END Rforce QuickRabbit */ 
}