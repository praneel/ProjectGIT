public without sharing class Myr_VehRelEndPreviousRelation_Cls {
  public static void closePrevious(list <VRE_VehRel__c> listVRE, boolean isInsert, Map <Id, VRE_VehRel__c> oldMap) {
    DateTime dT = System.now();
    Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
    Set<Id> setVehicles = new Set<Id>();
    for(VRE_VehRel__c vr : listVRE){
        setVehicles.add(vr.VIN__c);
    }
    List<VRE_VehRel__c> listVREsToClose = [SELECT Id, EndRelationFlag__c FROM VRE_VehRel__c
        WHERE VIN__c IN :setVehicles AND EndRelationFlag__c = false AND Id NOT IN :listVRE];
    for(VRE_VehRel__c vr : listVREsToClose){
        vr.EndRelationFlag__c = true;
        //vr.EndDateRelation__c=myDate; //!!! NO UPDATE OF THIS FIELD, IT IS A VALUE OF THE SELL
    }
    update listVREsToClose;
  } 
}