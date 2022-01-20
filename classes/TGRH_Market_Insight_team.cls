/**********************************************************************************************
* @Author:  Anant Singh       
* @Date:     6/2/2019      
* @Description: R3_R-0299_Class to give Access to MarketInsight
***********************************************************************************************/ 
public with sharing class TGRH_Market_Insight_team 
{
    private static Map<ID, Market_Insight__c> marketMap = new Map<ID, Market_Insight__c>();
    private static List<ID> listMarketIds = new List<ID>();
    
    /**********************************************************************************************
* @Author: Anant Singh     
* @Date:   6/2/2019     
* @Description: R3_R-0299_Method to give access to Mrket Insight Team   
***********************************************************************************************/    
public static void marketRecordShare(List<Market_Insight_Team__c> MTeamList)
    {
        List<Market_Insight__share> marketshareinsert = new List<Market_Insight__share>();
        set<id> miId = new set<id>();
        for(Market_Insight_Team__c miTeamRec:MTeamList){
            miId.add(miTeamRec.id);
        }
        for(Market_Insight_Team__c marketshareaccess:DAO_MarketInsight.fetchMarketInsightTeam2(miId))
        {
            if(marketshareaccess.User__c!=null)
            {
                Market_Insight__share market = returnMarketTeamShare();
                market.AccessLevel = CON_R1.EDIT;
                market.UserOrGroupId = marketshareaccess.User__c;
                market.ParentId = marketshareaccess.Market_Insight__c;
                Marketshareinsert.add(market);
            }
        }
        try{
            if(marketshareinsert!=null && marketshareinsert.size()>0)
            {
                AvoidRecursion.setFirstRunFalse();
                database.insert(marketshareinsert);
            }
        }
        catch(Exception ex){
            //ExceptionLog.createExceptionRecord(ex,CON_R3.MARKETINSIGHTTEAMCLASS,null,CON_R3.MARKETRECORDSHARE);
        }
    }
    
    
    /**********************************************************************************************
* @Author:      Anant Singh
* @Date:        6/2/2019
* @Description: R3_R-0299_Helper Method to return MarketTeamShare
* @Revision(s): [13/11/2018] - [D-0540] - [Prateek Chauhan] - [Removed the confidentiality condition for record share with Sample Team]   
***********************************************************************************************/    
static Market_Insight__share returnMarketTeamShare(){
        Market_Insight__share marketparticipantshare = new Market_Insight__share();
        return marketparticipantshare;
    }
}