<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Reminder_Email</fullName>
        <description>Case Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer Service User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>HSE User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing and Business User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Read Only User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Technical User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Reminder_Email</template>
    </alerts>
    <alerts>
        <fullName>Case_Reminder_Email_for_90_days</fullName>
        <description>Case Reminder Email for 90 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer Service User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>HSE User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing and Business User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Read Only User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Technical User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Reminder_Email_for_90_days</template>
    </alerts>
    <alerts>
        <fullName>Case_cosure_email</fullName>
        <description>Case closure email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer Service User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>HSE User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing and Business User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Read Only User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Technical User</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Case_closure_email</template>
    </alerts>
</Workflow>
