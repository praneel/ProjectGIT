<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ACC_FU_MyD_Status</fullName>
        <field>MyD_Status_UpdateDate__c</field>
        <formula>now()</formula>
        <name>ACC_FU_MyD_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ACC_FU_MyR_Status</fullName>
        <description>&quot;MyR Status&quot; field value moved (updated or created), so update of &quot;MyR Status UpdateDate&quot;</description>
        <field>MYR_Status_UpdateDate__c</field>
        <formula>now()</formula>
        <name>ACC_FU_MyR_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACC_WF15_MyD_Status</fullName>
        <actions>
            <name>ACC_FU_MyD_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>&quot;MyD Status&quot; field value moved (updated or created), so update of &quot;MyD Status UpdateDate&quot;</description>
        <formula>ISCHANGED(MyD_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ACC_WF16_MyR_Status</fullName>
        <actions>
            <name>ACC_FU_MyR_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>&quot;MyR Status&quot; field value moved (updated or created), so update of &quot;MyR Status UpdateDate&quot;</description>
        <formula>ISCHANGED(MYR_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
