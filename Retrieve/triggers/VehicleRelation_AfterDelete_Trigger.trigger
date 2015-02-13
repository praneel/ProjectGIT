trigger VehicleRelation_AfterDelete_Trigger on VRE_VehRel__c (after delete) {

	if (TriggerAdministration.canTrigger('VehicleRelationAdmin.onAfterDelete')) {   
        VehicleRelationAdminTriggerHandler.onAfterDelete(Trigger.isDelete, Trigger.old, Trigger.oldMap);       
	}   
    else {
        system.debug('### Rforce - VehicleRelationAdmin_AfterDelete_Trigger : BYPASS onAfterDelete - Run by ' + UserInfo.getName());
    }
    
}