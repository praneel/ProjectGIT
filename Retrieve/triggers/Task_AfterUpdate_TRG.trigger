trigger Task_AfterUpdate_TRG on Task (after update)
{
    if( TriggerAdministration.canTrigger( 'Task.onAfterUpdate' ) )
    {
         TaskTriggerHandler.onAfterUpdate( Trigger.Old, Trigger.New,trigger.oldMap);
         String userProfileName;
         Set<String> profileCheck = new Set<String> {'CORE CCBIC - Local Read Only', 'CORE CCBIC - Renault Consulting Administrator', 'CORE CCBIC - Local Administrator', 'CORE CCBIC - Agent - Front Office', 'CORE CCBIC - Kbase Manager', 'CORE CCBIC - Agent - Back Office L3', 'CORE CCBIC - Agent - Back Office L2', 'CORE CCBIC - Supervisor','CORE CCBIC - Technical Integration','Core-Service Profile Community','Core Community Profile','System Administrator'}; //List of Apex codes that should run only once. Add any code to the list
         User user = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
         userProfileName = user.Profile.Name;
         if(profileCheck.contains(userProfileName)){
      
          Rforce_TaskUtils_CLS.onAfterUpdate(trigger.new, Trigger.isUpdate, trigger.oldMap);
        
        }
    }
    else
    {
        System.Debug( '### LMT - Task_AfterUpdate_TRG : BYPASS onAfterUpdate - Run by ' + UserInfo.getName() );
    }
}