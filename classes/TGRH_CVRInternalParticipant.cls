/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        13-06-2018
* @Description: R1_R0241_Trigger handler class to call TGR_CVRInternalParticipant on Insert or update Event
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
public with sharing class TGRH_CVRInternalParticipant{
    String a='0';
   /* private static Map<ID, Call_Visit_Report__c> callVisitMap = new Map<ID, Call_Visit_Report__c>();
    private static List<Id> listcallreportIds = new List<Id>();*/
    
/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        13-06-2018
* @Description: R1_R0241_Method to change CVR record access to 'Edit' for CVR internal participants records
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
   /* public static void cvrRecordShare(List<CVR_Internal_Participant__c> CVRPartList)
    {
        for(CVR_Internal_Participant__c cvrPart : CVRPartList){
            listcallreportIds.add(cvrPart.Call_Visit_Report__c);
        }
        Integer maxRows = 0;
        List<Call_Visit_Report__share>cvrshareinsert = new List<Call_Visit_Report__share>();
        maxRows = (Limits.getLimitQueryRows() - Limits.getQueryRows());   
        callVisitMap = new  Map<ID, Call_Visit_Report__c>([SELECT id,Confidentiality_Level__c 
                                                           FROM Call_Visit_Report__c
                                                           WHERE ID IN :listcallreportIds LIMIT : maxRows]);
        for(CVR_Internal_Participant__c  cvrshareaccess: CVRPartList){
            Call_Visit_Report__c callVisit = callVisitMap.get(cvrshareaccess.Call_Visit_Report__c);
            if(cvrshareaccess.User__c!=null)
            {
                Call_Visit_Report__share cvr = returnCVRParticipantsshare();
                cvr.AccessLevel = CON_R1.EDIT;
                cvr.UserOrGroupId = cvrshareaccess.User__c;
                cvr.ParentId = cvrshareaccess.Call_Visit_Report__c;
                cvrshareinsert.add(cvr);
            }
        }
        if(cvrshareinsert!=Null && cvrshareinsert.size()>0){
            try{
                AvoidRecursion.setFirstRunFalse();
                database.insert(cvrshareinsert);                
            }
            catch(Exception ex){
               // ExceptionLog.createExceptionRecord(ex,CON_R1.CVRINTPARTICIPATIONCLASS,null,CON_R1.CVRINTPARTICIPATIONMETHOD);
            }
        }
    } */
/**********************************************************************************************
* @Author:      Prateek Chauhan
* @Date:        13-06-2018
* @Description: R1_R0241_helper method create instance.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
   /* static Call_Visit_Report__share returnCVRParticipantsshare()
    {
        Call_Visit_Report__share cVROparticipantsharebj = new Call_Visit_Report__share();
        return cVROparticipantsharebj;
    } */
}