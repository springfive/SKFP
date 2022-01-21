/**********************************************************************************************
* @Author:      Anant Singh
* @Date:        25-09-2018
* @Description: R1_R-0682_Trigger handler class to call TGR_SampleTeam 
***********************************************************************************************/ 
public with sharing class TGRH_SampleTeam {
    String a='0';
    public TGRH_SampleTeam() {}
    /*private static Map<ID, Sample__c> sampleMap = new Map<ID, Sample__c>();
    private static List<ID> listsampleIds = new List<ID>();*/
    
    /**********************************************************************************************
* @Author:      Anant Singh
* @Date:        25-09-2018
* @Description: R1_R-0682_Method to change sample record access to 'Edit' for sample team members
* @Revision(s): [13/11/2018] - [D-0540] - [Prateek Chauhan] - [Removed the confidentiality condition for record share with Sample Team]   
***********************************************************************************************/    
   /* public static void sampleRecordShare(List<Sample_Team__c> STeamList)
    {
        Integer maxRows = 0;
        maxRows = (Limits.getLimitQueryRows()-Limits.getQueryRows());
        List<Sample__share>sampleshareinsert = new List<Sample__share>();
        
        for(Sample_Team__c sampleshareaccess:STeamList)
        {
            
            if(sampleshareaccess.User_Active__c == TRUE && sampleshareaccess.Team_Member__c!=null)
            {
                Sample__share smpl = returnSampleTeamShare();
                smpl.AccessLevel = CON_R1.EDIT;
                smpl.UserOrGroupId = sampleshareaccess.Team_Member__c;
                smpl.ParentId = sampleshareaccess.Sample__c;
                sampleshareinsert.add(smpl);
            }
        }
        
        if(sampleshareinsert!=null && sampleshareinsert.size()>0){
            try{
                database.insert(sampleshareinsert);
             }
            catch(Exception ex){
                //ExceptionLog.createExceptionRecord(ex, CON_R1.SAMPLEPARTICIPATIONCLASS, null, CON_R1.SAMPLEPARTICIPATIONMETHOD);
            }
        }
    } */
    /**********************************************************************************************
* @Author:      Anant Singh
* @Date:        25-09-2018
* @Description: R1_R-0682_Helper Method to return sampleTeamShare
* @Revision(s): [13/11/2018] - [D-0540] - [Prateek Chauhan] - [Removed the confidentiality condition for record share with Sample Team]   
***********************************************************************************************/    
   /* static Sample__share returnSampleTeamShare(){
        Sample__share sampleparticipantshare = new Sample__share();
        return sampleparticipantshare;
    } */
    /**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        13-03-2019
* @Description: R1_R-0682_Method to change sample record access to 'Edit' for sample team members
* @Revision(s): [13/11/2018] - [D-0540] - [Prateek Chauhan] - [Removed the confidentiality condition for record share with Sample Team]   
***********************************************************************************************/    
   /* public static void AccessToSalesUser(List<Sample_Team__c> STeamList){
        Integer maxRows = 0;
        maxRows = (Limits.getLimitQueryRows()-Limits.getQueryRows());
        system.debug('');
        List<String> sampleTeamOwnerProfile = new List<String>();
        set<id> sampleId = new set<id>();
        id LoggedInUserId = UserInfo.getUserId();
        
        Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        List<Sample_Team__c> newSamTeamList = new List<Sample_Team__c>();
        
        set<id> sampleTeamUserId = new set<id>();
        for(Sample_Team__c sTeamRec:STeamList){
            sampleTeamUserId.add(sTeamRec.Sample__c);
           system.debug('sampleTeamUserId'+sampleTeamUserId); 
        }
        List<Sample_Team__c> sampleTeamList = [select id,Access__c,Team_Member__r.name,sample__c 
                                               from Sample_Team__c 
                                               where sample__c in: sampleTeamUserId];
        
        List<string> userId = new List<String>();
        for(Sample_Team__c samTeamOb:sampleTeamList){
        userId.add(samTeamOb.Team_Member__c); 
        system.debug('userId'+userId);    
        }
        if(STeamList.size()>0){
        for(Sample_Team__c sTeamRec:STeamList){
           system.debug('Enter inside for');
            
            if(sTeamRec.User_Active__c == TRUE && sTeamRec.SampleTeamProfile__c == CON_R1.SALESUSER && profileName == CON_R1.SALESUSER
              && sTeamRec.Team_Member__c != LoggedInUserId && userId.contains(LoggedInUserId)){
             system.debug('Enter inside if');     
             sTeamRec.Access__c = CON_R1.READ; 
             system.debug('Access__c'+sTeamRec.Access__c);  
            }   
        }
        }
       
    } */

   
}