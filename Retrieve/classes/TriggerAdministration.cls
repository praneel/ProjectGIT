/*****************************************************************************************
    Name    : TriggerAdministration
    Desc    : This is a utility class
    Approach:
    Project : Rforce

******************************************************************************************/
public class TriggerAdministration {
    private static final Set<String> requiredOnce = new Set<String> {'Task.fillTaskType', 'Task.fillTaskSubject', 'CORE-APEX', 'ADM-APEX', 'Account.onBeforeUpdate', 'Account.onBeforeInsert', 'Account.onAfterInsert', 'Account.onAfterUpdate', 'Task.onAfterInsert','Task.onAfterUpdate','Task.onBeforeInsert','Task.onBeforeUpdate'}; //List of Apex codes that should run only once. Add any code to the list
    private static Set<String> hasRun = new Set<String>(); //List of Apex code that has already been run. Keep this list empty.
    public static final String PAD_BypassTrigger;//List of triggers that can be bypassed
    public static final Boolean PAD_DebugMode {get; set;}
    public static final String userRoleName;  //User Role Name
    public static final String userProfileName;//User Profile Name
    static {
        System.Debug('## >>> PAD constructor :BEGIN <<< run by ' + UserInfo.getName());
        User user = [SELECT UserRole.Name, Profile.Name, UserPreferencesApexPagesDeveloperMode, PAD_BypassTrigger__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        PAD_BypassTrigger = ';' + user.PAD_BypassTrigger__c + ';';
        PAD_DebugMode = user.UserPreferencesApexPagesDeveloperMode;
        userRoleName = user.UserRole.Name;
        userProfileName = user.Profile.Name;
        System.Debug('## >>> PAD constructor : END <<<');
    }
    public static boolean canTrigger(String ApexName) { //If no bypass
        if (requiredOnce.contains(ApexName)) { //If it should run Once
            if (hasRun.contains(ApexName))return false; //Already run, should not run
            hasRun.add(ApexName);//Never run, can run only if not bypassed
        }
        return (PAD_BypassTrigger.indexOf(';' + ApexName + ';') == -1);
    }


}