@isTest(SeeAllData = False)
/*********************************************************************
@Author : Anant Singh	
@name : TST_TGRH_Market_Insight_Team
@CreateDate : 18/2/2019
@Description : Test Class for TGRH_Market_Insight_Team 
***********************************************************************/
private class TST_TGRH_Market_Insight_Team 
{
/*********************************************************************
@Author : Anant Singh	
@name : TGRH_MarketRecordShare
@CreateDate : 18/2/2019
@Description : Test Method for TGRH_Market_Insight_Team 
***********************************************************************/    
    private static testMethod void TGRH_MarketRecordShare()
    {
        Test.startTest();
        String comptRecty =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        AvoidRecursion.setFirstRunTrue();    
        Account accId = DataFactory.createAcount('test account', 'Boston', 'US', 'Alaska');
        AvoidRecursion.setFirstRunTrue();    
        Account accId1 = DataFactory.createCompetitorAcount('AccName New', comptRecty, false, 'MUMBAI', 'IN', 'Maharashtra','Functional Polyolefins');
        AvoidRecursion.setFirstRunTrue();
        User salesUser = DataFactory.createSalesUser('usear', 'usear@arkema.com', 'lname', 'Fname', 'Functional Polyolefins');
        AvoidRecursion.setFirstRunTrue();
        Market_Insight__c market = DataFactory.createMarketInsight(accId.Id,accId1.Id,'Functional Polyolefins','All Users','Adhesives');
        Market_Insight_Team__c mteam = new Market_Insight_Team__c();
        mteam.Market_Insight__c = market.Id;
        mteam.User__c = salesUser.Id;
        AvoidRecursion.setFirstRunTrue();
        Database.insert(mteam);
       Test.stopTest(); 
       system.assertEquals(market.BU__c, 'Functional Polyolefins');
        
    }
    
}