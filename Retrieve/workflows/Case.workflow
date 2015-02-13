<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MA_EM01_Case_Approved</fullName>
        <description>MA EM01 Case Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_01_Goodwill_approval_confirmation</template>
    </alerts>
    <alerts>
        <fullName>MA_EM02_Case_Rejected</fullName>
        <description>MA EM02 Case Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_02_Goodwill_rejected</template>
    </alerts>
    <alerts>
        <fullName>MA_EM03_SLA_CaseStatus_New_after_2_days</fullName>
        <description>MA EM03 SLA CaseStatus New after 2 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>MA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_03_SLA_CaseStatus_New_after_2_days</template>
    </alerts>
    <alerts>
        <fullName>MA_EM04_SLA_CaseStatus_New_After_1_day</fullName>
        <description>MA EM04 SLA CaseStatus New After 1 day</description>
        <protected>false</protected>
        <recipients>
            <recipient>MA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_04_SLA_CaseStatus_New_After_1_day</template>
    </alerts>
    <alerts>
        <fullName>MA_EM05_SLA_CaseStatus_Open_after_6_days</fullName>
        <description>MA EM05 SLA CaseStatus Open after 6 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>MA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_05_SLA_CaseStatus_Open_after_6_days</template>
    </alerts>
    <alerts>
        <fullName>MA_EM06_SLA_CaseStatus_Open_after_2_days</fullName>
        <description>MA EM06 SLA CaseStatus Open after 2 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>MA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Morocco_Template/MA_TE_06_SLA_CaseStatus_Open_after_2_days</template>
    </alerts>
    <alerts>
        <fullName>UA_EM01_Case_New1day</fullName>
        <description>UA EM01 Case New1day</description>
        <protected>false</protected>
        <recipients>
            <recipient>UA_Agent_Back_Office_L2</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Agent_Front_Office_L1</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Supervisor_FO</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ukraine_Template/UA_TE01_New1day</template>
    </alerts>
    <alerts>
        <fullName>UA_EM02_Case_New2days</fullName>
        <description>UA EM02 Case New2days</description>
        <protected>false</protected>
        <recipients>
            <recipient>UA_Agent_Back_Office_L2</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Agent_Front_Office_L1</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>UA_Supervisor_FO</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ukraine_Template/UA_TE02_New2days</template>
    </alerts>
    <fieldUpdates>
        <fullName>CAS_Update_Modified_Date</fullName>
        <description>R-FORCE:Release 6</description>
        <field>Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>CAS Update Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CORE_CAS_FU01_e2c_origin_Email_update</fullName>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>CORE CAS FU01 e2c origin Email update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CORE_CAS_FU02_e2c_from_Customer</fullName>
        <field>From__c</field>
        <literalValue>Customer</literalValue>
        <name>CORE CAS FU02 e2c from Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CORE_CAS_FU08_e2c_brand_Renault</fullName>
        <description>RForce : This rule allows to update automatically the field &quot;Brand&quot; on Case object with the value &quot;Renault&quot; for cases coming from Renault mailbox</description>
        <field>CaseBrand__c</field>
        <literalValue>Renault</literalValue>
        <name>CORE CAS FU08 e2c brand Renault</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MA_E2C_Update_the_case_owner</fullName>
        <description>MA E2C Update the case owner to &quot;MA - File d’attente FO&quot;</description>
        <field>OwnerId</field>
        <lookupValue>MA_File_d_attente_FO</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>MA E2C Update the case owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UA_CAS_FU01_Country_to_Ukraine</fullName>
        <description>Update &quot;Country Case&quot; to Ukraine</description>
        <field>CountryCase__c</field>
        <literalValue>Ukraine</literalValue>
        <name>UA CAS FU01 Country to Ukraine</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UA_CAS_FU02_Queue_to_Web2case_Formulaire</fullName>
        <field>OwnerId</field>
        <lookupValue>UA_Web2case_Formulaires</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UA CAS FU02 Queue to Web2case&amp;Formulaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CAS WF40 ModifiedDate</fullName>
        <actions>
            <name>CAS_Update_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R-FORCE:Release 6
When case field value is changed the Idle SLA time field is updated</description>
        <formula>OR( ISCHANGED( Status ),ISCHANGED( Closure_reason__c ),ISCHANGED( Priority),ISCHANGED( Type ), ISCHANGED( SubType__c ),ISCHANGED( Detail__c ),ISCHANGED( Vehicle_Model__c ), ISCHANGED( Subject ),ISCHANGED( Description ),ISCHANGED(  Punctual_follow_up__c ), ISCHANGED( Description ),ISCHANGED( CaseBrand__c ),ISCHANGED( Origin ), ISCHANGED( CaseSubSource__c ),ISCHANGED( Approval_required__c ),ISCHANGED( From__c ), ISCHANGED( VIN__c ),ISCHANGED( Kilometer__c ),ISCHANGED( VehicleMaintenance__c ), ISCHANGED( MaintHistAvail__c ),ISCHANGED( StopSurvey__c ),ISCHANGED( Answer__c ), ISCHANGED( Dealer__c ),ISCHANGED( CustPerception__c ),ISCHANGED( CustomerWants__c ), ISCHANGED( Risk__c ),ISCHANGED( Expertise__c ),ISCHANGED( CIRNumber__c ), ISCHANGED( ProductFault__c ),ISCHANGED( SubProductFault__c),ISCHANGED( ServiceProblem__c ), ISCHANGED( SalesProblem__c ),ISCHANGED( ServiceProblem__c ),ISCHANGED( SalesProblem__c ), ISCHANGED( Product_Problem__c ),ISCHANGED( CatalogFuncCode__c),ISCHANGED(PartOrderType__c), ISCHANGED( RetainedVehicle__c ),ISCHANGED( RetainedVehDate__c ),ISCHANGED( GWStatus__c ), ISCHANGED( FirstrequestDate__c ),ISCHANGED( EscalatedTo__c ),ISCHANGED( EscalReferBy__c ), ISCHANGED( Processing__c ),ISCHANGED( CaseReopeningNumber__c ),ISCHANGED( ParentId ), ISCHANGED( ChronoNumber__c ),ISCHANGED( Generated_Chrono_Number__c ),ISCHANGED( SiebelCaseNbr__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MA CAS WF01 E2C Customer</fullName>
        <actions>
            <name>CORE_CAS_FU01_e2c_origin_Email_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CORE_CAS_FU02_e2c_from_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MA_E2C_Update_the_case_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>_TECH_CUSTOMER</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MA Case RecType</value>
        </criteriaItems>
        <description>MA CAS WF01 E2C Customer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UA CAS WF01 relation%2Eclient%40renault%2Ecom</fullName>
        <actions>
            <name>CORE_CAS_FU01_e2c_origin_Email_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CORE_CAS_FU02_e2c_from_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CORE_CAS_FU08_e2c_brand_Renault</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UA_CAS_FU01_Country_to_Ukraine</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UA_CAS_FU02_Queue_to_Web2case_Formulaire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>UA Case RecType</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>_TECH_CUSTOMER</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Email sent to: relation.client@renault.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UA CAS WF02 EA New1Day</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>UA Case RecType</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Information Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>The  case owner has not sent an answer to customer within 24 calendar hours (status should be either &quot;Resolved&quot; or &quot;Closed&quot;)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UA_EM01_Case_New1day</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>UA CAS WF03 EA New2Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>UA Case RecType</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>The  case owner has not sent an answer to customer within 48 calendar hours(status should be either &quot;Answered&quot; or &quot;Resolved&quot; or &quot;Closed&quot;)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UA_EM02_Case_New2days</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Check_Case</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>To Do</status>
        <subject>Check Case</subject>
    </tasks>
    <tasks>
        <fullName>Goodwill_Approved</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Goodwill Approved</subject>
    </tasks>
    <tasks>
        <fullName>Goodwill_Recall_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Goodwill Recall for Approval</subject>
    </tasks>
    <tasks>
        <fullName>Goodwill_Refused</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Goodwill Refused</subject>
    </tasks>
    <tasks>
        <fullName>Goodwill_Submission_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Goodwill Submission for Approval</subject>
    </tasks>
    <tasks>
        <fullName>MA_TA_03_SLA_CaseStatus_New_after_2_days</fullName>
        <assignedTo>MA_Supervisor_FO</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Dossier client #{!Case.CaseNumber}  en attente depuis 2 jours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>MA TA 03 SLA CaseStatus New after 2 days</subject>
    </tasks>
    <tasks>
        <fullName>MA_TA_04_SLA_CaseStatus_New_After_1_day</fullName>
        <assignedTo>MA_Agent_Back_Office_L1</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Dossier client   #{!Case.CaseNumber}   transmis par le réseau en attente depuis 1 jours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>MA TA 04 SLA CaseStatus New After 1 day</subject>
    </tasks>
    <tasks>
        <fullName>MA_TA_05_SLA_CaseStatus_Open_after_6_days</fullName>
        <assignedTo>MA_Agent_Back_Office_L1</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Dossier #{!Case.CaseNumber} réclamation prise en charge depuis 6 jours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>MA TA 05 SLA CaseStatus Open after 6 days</subject>
    </tasks>
    <tasks>
        <fullName>MA_TA_06_SLA_CaseStatus_Open_after_2_days</fullName>
        <assignedTo>MA_Agent_Front_Office_L1</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Dossier #{!Case.CaseNumber} demande d’infos prise en charge depuis 2 jours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>MA TA 06 SLA CaseStatus Open after 2 days</subject>
    </tasks>
</Workflow>
