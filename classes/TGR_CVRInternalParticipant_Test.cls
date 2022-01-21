@isTest
public class TGR_CVRInternalParticipant_Test {
	 @isTest static void TGR_CVRInternalParticipant_Test_Method() {
         Call_Visit_Report__c obj2=new Call_Visit_Report__c();
         insert obj2;
         CVR_Internal_Participant__c obj=new CVR_Internal_Participant__c();
         obj.Call_Visit_Report__c=obj2.id;
         insert obj;    
}
}