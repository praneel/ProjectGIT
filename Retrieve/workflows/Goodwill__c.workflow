<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>GOO_WF03_IKR_Commercial_GoodWill</fullName>
        <actions>
            <name>GOO_Update_FieldsGlobalAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Goodwill__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>TR GOO Commercial RecType,MidCE GOO Commercial RecType,FR GOO Commercial Certificate RecType,FR GOO Commercial RecType,ES GOO Commercial RecType,IT GOO Commercial RecType,PT GOO Commercial RecType,UK GOO Commercial RecType,AT GOO Comercial RecType</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goodwill__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NR GOO Commercial RecType,PL GOO Commercial RecType,UK GOO Commercial RecType,CH GOO Commercial RecType,DZ GOO Commercial RecType,UA GOO Commercial RecType,MA GOO Commercial RecType</value>
        </criteriaItems>
        <description>Permit to fill the field Amount__c</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
