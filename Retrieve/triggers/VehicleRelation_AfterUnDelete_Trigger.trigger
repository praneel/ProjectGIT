trigger VehicleRelation_AfterUnDelete_Trigger on VRE_VehRel__c (after undelete) {

	if (TriggerAdministration.canTrigger('VehicleRelationAdmin.onAfterUnDelete')) {   
        VehicleRelationAdminTriggerHandler.onAfterUnDelete(Trigger.isDelete, Trigger.new, Trigger.oldMap);       
	}   
    else {
        system.debug('### Rforce - VehicleRelationAdmin_AfterUnDelete_Trigger : BYPASS onAfterUnDelete - Run by ' + UserInfo.getName());
    }
    
}