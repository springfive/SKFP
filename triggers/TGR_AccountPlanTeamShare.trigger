/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        17-06-2018
* @Description: R1_R0657_Trigger to call handler class - TGRH_AccountPlanTeamShare
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
trigger TGR_AccountPlanTeamShare on Account_Plan_Team__c (after insert, after update) {
    if(Trigger.IsExecuting )
    {
        if(!TGRH_Generic_CustomMetaData.CustomMetaDataMethod(CON_R1.ACCOUNTPLANTEAMSHARE) && AvoidRecursion.checkFirstRun())
        {             
            If(Trigger.isInsert || Trigger.isUpdate){
/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        17-06-2018
* @Description: R1_R0657_Trigger to call handler class - TGRH_AccountPlanTeamShare
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
                TGRH_AccountPlanTeamShare accPlanshare = new TGRH_AccountPlanTeamShare();
                //accPlanshare.AccPlanrecordShare(Trigger.New);
            }
            
        }
    }
}