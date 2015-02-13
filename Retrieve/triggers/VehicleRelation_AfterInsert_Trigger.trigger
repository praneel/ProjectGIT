/*****************************************************************************************
    Name    : VehicleRelation_AfterInsert_Trigger
    Desc    : Update Account as Old Customer or Customer based on Vehicle Relation Status
    Approach: 
    Author  : Sumanth (RNTBCI)
    Project : Rforce / MYR Helios
******************************************************************************************/
trigger VehicleRelation_AfterInsert_Trigger on VRE_VehRel__c (after Insert) {
    if (TriggerAdministration.canTrigger('VehicleRelation.onAfterInsert')) {   
        VehicleRelationTriggerHandler.onAfterInsert(trigger.new, Trigger.isInsert, trigger.oldMap);   
       }
    else {
        System.Debug('### Rforce - VehicleRelation_AfterInsert_Trigger : BYPASS onAfterUpdate - Run by ' + UserInfo.getName());
    } 
    
    /* BEGIN MYR Helios YellowCat*/  
    Myr_VehRelEndPreviousRelation_Cls.closePrevious(trigger.new, Trigger.isInsert, trigger.oldMap);
    /* END MYR Helios Yellow Cat*/
    
    /* BEGIN RForce QuickRabbit*/ 
    if (TriggerAdministration.canTrigger('VehicleRelationAdmin.onAfterInsert')) {   
        VehicleRelationAdminTriggerHandler.onAfterInsert(trigger.new, Trigger.isInsert, trigger.oldMap);    
    } else {
        System.Debug('### Rforce - VehicleRelationAdmin_AfterInsert_Trigger : BYPASS onAfterUpdate - Run by ' + UserInfo.getName());
    }    
    /* END RForce QuickRabbit*/
}