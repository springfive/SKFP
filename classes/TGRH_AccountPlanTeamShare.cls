/**********************************************************************************************
* @Author:      Prateek Chauhan 
* @Date:        13-06-2018
* @Description: R1_R0657_Trigger handler class to call TGR_AccountPlanTeam on Insert or update Event
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
public with sharing class TGRH_AccountPlanTeamShare{
  /*  private Map<ID, AP_Account_Plan__c> accPlanMap = new Map<ID, AP_Account_Plan__c>();
    private List<Id> listacccplanIds = new List<Id>();
    private List<AP_Account_Plan__share> accPlanShareinsert = new List<AP_Account_Plan__share>(); */
    
/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        13-06-2018
* @Description: R1_R0657_Method to change Account Plan record access to 'Edit' for Account plan team records
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
   /* public void accPlanrecordShare(List<Account_Plan_Team__c > AccPlanTeamList){
        for(Account_Plan_Team__c accplanteam : AccPlanTeamList){
            listacccplanIds.add(accplanteam.Account_Plan__c);
        }
        
        Integer maxRows = 0;
        maxRows = (Limits.getLimitQueryRows() - Limits.getQueryRows()); 
        accPlanMap = new  Map<ID, AP_Account_Plan__c>([SELECT id,Confidentiality_Level__c FROM AP_Account_Plan__c 
                                                       WHERE ID IN :listacccplanIds LIMIT : maxRows]);
        for(Account_Plan_Team__c  accplanteamshare: AccPlanTeamList){
            AP_Account_Plan__c accPlan = accPlanMap.get(accplanteamshare.Account_Plan__c);
            if(accPlan.Confidentiality_Level__c.equalsIgnoreCase(CON_R1.ACCOUNTPLANTEAM) && accplanteamshare.User__c!=null){
                AP_Account_Plan__share accplanshare = returnAccountPlanShareWrapper();
                accplanshare.AccessLevel = CON_R1.EDIT;
                accplanshare.UserOrGroupId = accplanteamshare.User__c;
                accplanshare.ParentId = accplanteamshare.Account_Plan__c;
                accPlanShareinsert.add(accplanshare);
            }
        }
        if(accPlanShareinsert!=Null && accPlanShareinsert.size()>0){
            try{
                AvoidRecursion.setFirstRunFalse();
                database.insert(accPlanShareinsert);                             
            }
            catch(Exception ex){
                //ExceptionLog.createExceptionRecord(ex,CON_R1.ACCOUNTPLANCLASS,null,CON_R1.ACCOUNTPLANMETHOD);
            }
            
        }
        
    }    */
    /**********************************************************************************************
* @Author:      Shipra Srivastava 
* @Date:        26/6/2018
* @Description: helper method create instance.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/   
   /* static AP_Account_Plan__share returnAccountPlanShareWrapper(){
        AP_Account_Plan__share apAccPlanShareObj = new AP_Account_Plan__share();
        return apAccPlanShareObj;        
    } */
}