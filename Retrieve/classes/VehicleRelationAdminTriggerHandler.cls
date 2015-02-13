/** Apex class used to compute or update data independently from the User profiles
    => It concerns today CountRelation on Vehicles
    @author S�bastien Ducamp
    @date 03.12.2014
**/
public without sharing class VehicleRelationAdminTriggerHandler {

	/** On After Insert event, added on 03.12.2014 **/
	public static void onAfterInsert(list <VRE_VehRel__c> listVRE, boolean isInsert, Map <Id, VRE_VehRel__c> oldMap) {
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterInsert : BEGIN');
		//Update the count of relations --- S?bastien Ducamp, 19.11.2014
		computeCountRelation(listVRE);
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterInsert : END');
	}
	
	/** On After Update event, added on 03.12.2014 **/
	public static void onAfterUpdate(list <VRE_VehRel__c> listVRE, boolean isUpdate, Map <Id, VRE_VehRel__c> oldMap) {
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterUpdate : BEGIN');
		//Update the count of relations --- S?bastien Ducamp, 19.11.2014
	    //Potentially we need to update the vehicles that potentially have been removed from the relations
	    List<VRE_VehRel__c> listVehRel = listVRE.clone(); //caution: we have to clone the list because we cannot modify the trigger itself (collection is read-only)
	    if( oldMap != null ) { 
	    	listVehRel.addAll(oldMap.values());
	    }
		computeCountRelation(listVehRel);
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterUpdate : END');
	}
	
	/** On After Delete event, added on 19.11.2014 **/
	public static void onAfterDelete(boolean isDelete, list<VRE_VehRel__c> listVRE, map<Id, VRE_VehRel__c> oldMap) {
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterDelete : BEGIN');
		computeCountRelation(oldMap.values());
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterDelete : END');
	}
	
	/** On After UnDelete event, added on 19.11.2014 **/
	public static void onAfterUnDelete(boolean isDelete, list<VRE_VehRel__c> listVRE, map<Id, VRE_VehRel__c> oldMap) {
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterUnDelete : BEGIN');
		computeCountRelation(listVRE);
		system.Debug('### Rforce - VehicleRelationAdminTriggerHandler.onAfterUnDelete : END');
	}
	
	/** Computes the count of relation for each vehicle linked to these list of relation. 
		Put in place to replace the roll-up summary field CountRelation__c.
		@param  ilistVRE, the list of VRE_VehRel__c updated, inserted, deleted or undeleted
	    @return <void>
	    S?bastien Ducamp 19.11.2014
	**/
	private static void computeCountRelation(list <VRE_VehRel__c> ilistVRE) {	
		Set<Id> setIdVehicles = new Set<Id>();
		for(VRE_VehRel__c vre :  ilistVRE) {
			setIdVehicles.add(vre.VIN__c);
		}
		//computes the number of relations
		Map<Id, AggregateResult> mapAggResult = new Map<Id, AggregateResult>( [SELECT VIN__c Id, COUNT(Id) countRel 
																			 FROM VRE_VehRel__c
																			 WHERE VIN__c IN :setIdVehicles 
																			 GROUP BY VIN__c 
												 ] );
		//update the field CountRelationV2 on the vehicle
		List<Veh_VEH__c> listVehicles = [SELECT Id, CountRelationV2__c FROM Veh_VEH__c WHERE Id IN :setIdVehicles ];
		for( Veh_VEH__c veh : listVehicles ) {
			if( mapAggResult.containsKey(veh.Id) ) {
				veh.CountRelationV2__c = (Integer) mapAggResult.get(veh.Id).get('countRel');
			} else {
				veh.CountRelationV2__c = 0;
			}
		}
		
		update listVehicles;
	}
}