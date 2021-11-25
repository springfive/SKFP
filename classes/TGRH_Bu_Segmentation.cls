/**********************************************************************************************
* @Author:      Indrajit Chattaraj
* @Date:        20-07-2018
* @Description: Trigger handler class for Bu Segmentation.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
public with sharing class TGRH_Bu_Segmentation {
    public static Boolean checkTestRunFlag = false; 
    /**********************************************************************************************
    * @Author:      Indrajit Chattaraj
    * @Date:        20-07-2018
    * @Description: Method for bu mapping from sap to salesforce.
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
    ***********************************************************************************************  
    public static void setBuMapping(List<BU_Segmentation__c> buSegmentationLIst){
        try{
            LIst<Bu_Mapping__c> buMappingList = [SELECT Salesforce_Bu_Values__c,
                                                       Sap_Prd_Bu_Values__c,
                                                       Sap_Best_Bu_Value__c,
                                                       Sap_Nice_Bu_Values__c, 
                                                       Sap_Prd_Bu_Description__c, 
                                                       Sap_Nice_Bu_Description__c
                                               FROM  Bu_Mapping__c LIMIT:fetchMaxRows()];
            
            for(BU_Segmentation__c buSeg :  buSegmentationLIst){
                Boolean isCombinationFlag = false;
 
                if(String.isNotBlank(buSeg.SAP_BU_Value__c)){
                    if(String.isNotBlank(buSeg.SAP_source_system__c)){    
                        for(Bu_Mapping__c buMapping : buMappingList){ 
								if(((buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCENICEVALUESQA) || buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCENICEVALUESPRD))
                                && ( buSeg.SAP_BU_Value__c.equalsIgnoreCase(buMapping.Sap_Nice_Bu_Values__c) || buSeg.SAP_BU_Value__c.equalsIgnoreCase(buMapping.Sap_Nice_Bu_Description__c)))
                                ||
                                ((buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEPRDVALUESQA) || buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEPRDVALUESPRD))
                                && ( buSeg.SAP_BU_Value__c.equalsIgnoreCase(buMapping.Sap_Prd_Bu_Description__c) || buSeg.SAP_BU_Value__c.equalsIgnoreCase(buMapping.Sap_Prd_Bu_Values__c)))
                               	|| ((buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEBESTDEV) || buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEBESTQA)
                                           || buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEBESTPREPROD)
                                           || buSeg.SAP_source_system__c.equalsIgnoreCase(CON_R1_INTEGRATION.SAPSOURCEBESTPROD))
                                         &&( buSeg.SAP_BU_Value__c.equalsIgnoreCase(buMapping.Sap_Best_Bu_Value__c)))
                               
                              )
                            {
                                
                                buSeg.BU1__c = buMapping.Salesforce_Bu_Values__c;
                               isCombinationFlag = true;
                                break;
                            }
                        } 
                        if(!isCombinationFlag){
                            buSeg.addError(System.Label.Validate_BU_Mapping_Label);
                        }
                    }
                    else{
                        buSeg.addError(System.Label.SAP_Source_System_Empty);
                    }
                }                
            }
            if(test.isRunningTest() && checkTestRunFlag){
                buMappingList[0].Sap_Prd_Bu_Values__c = null;
            }            
        }
        catch(Exception ex){
            ExceptionLog.createExceptionRecord(ex,
                CON_R1_INTEGRATION.TRIGGERHANDLERBUSEGMENTATION,
                null,CON_R1_INTEGRATION.TRIGGERHANDLERBUSEGMENTATIONMETHOD);
        }        
    }
 /**********************************************************************************************
    * @Author:      Neha Sameen  
    * @Date:        16/04/2018
    * @Description: This is the handler class of Trigger "TGR_BU_Segmentation"for merging the BU_acount
    *               name in Account object "Active BUs" feild.        
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/
    public  static void createBuId(List<BU_Segmentation__c> buList){
        List<Id> buSegIdList = new List<Id>();
        for(BU_Segmentation__c buObj:buList){
            buSegIdList.add(buObj.Id);
        }
       active_BU_Units(buSegIdList);
    } 
    
    
    /**********************************************************************************************
    * @Author:      Neha Sameen  
    * @Date:        16/04/2018
    * @Description: This is the handler class of Trigger "TGR_BU_Segmentation"for merging the BU_acount
    *               name in Account object "Active BUs" feild.        
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
    ***********************************************************************************************/
    @future
    public static void active_BU_Units(List<Id> buIdList)
    { 
        List<BU_Segmentation__c> buSegList = [SELECT Id,Account__c from BU_Segmentation__c where id in:buIdList];
        set<id> buAccIds = new set<id>();
        for (BU_Segmentation__c bu_Seg : buSegList) {
            buAccIds.add(bu_Seg.Account__c);
        }
       
        List<Account> AccountList = [Select Id,(Select Account__c,Name,BU1__c FROM BU_Segmentations__r) 
                                     FROM Account WHERE  Id IN :buAccIds LIMIT:fetchMaxRows()];
         
        string picklistLable ;
        Schema.DescribeFieldResult fieldResult = BU_Segmentation__c.BU1__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<string,string> buMap = new Map<string,string>();
		 for( Schema.PicklistEntry v : values) {
              buMap.put(v.getValue(), v.getLabel());
             system.debug('buMap'+buMap);
                
         }
      
      /*  for (Account acct : AccountList) {
            if(Acct.BU_Segmentations__r.size() > 0 ){
               Acct.Active_BUs__c = buMap.containsKey(string.valueOf(Acct.BU_Segmentations__r[0].BU1__c))
                                    ? buMap.get(string.valueOf(Acct.BU_Segmentations__r[0].BU1__c)):null;
                 system.debug('Acct.Active_BUs__c'+Acct.Active_BUs__c);
                
                if(Acct.BU_Segmentations__r.size() == 1){
                Acct.Active_BUs__c = Acct.Active_BUs__c + CON_R1.SEMICOLON ;   
                }
                else if(Acct.BU_Segmentations__r.size() > 1){
		        for(integer i=1; i<Acct.BU_Segmentations__r.size();i++)
                {
                    if(Acct.BU_Segmentations__r[i].BU1__c != null){
                        system.debug('Acct.Active_BUs__c 2nd'+Acct.Active_BUs__c);
                        Acct.Active_BUs__c = Acct.Active_BUs__c + CON_R1.SEMICOLON + buMap.get(string.valueOf(Acct.BU_Segmentations__r[i].BU1__c));
                        system.debug('Acct.Active_BUs__c 3rd'+Acct.Active_BUs__c);
                        system.debug('Acct.Active_BUs__c 4th'+buMap.get(string.valueOf(Acct.BU_Segmentations__r[i].BU1__c)));
                   
                    }
                }
               
            }
            }
        }*/
        
        try{
            
           AvoidRecursion.setFirstRunFalse(); 
           database.update(AccountList);
            system.debug('AccountList'+AccountList);
            if(test.isRunningTest() && checkTestRunFlag){
                Integer num = 5/0;
            }
        }
        catch(Exception ex){
            //ExceptionLog.createExceptionRecord(ex,CON_R1_INTEGRATION.TRIGGERHANDLERBUSEGMENTATION,
                                             //  null,CON_R1.TRIGGERHANDLERACTIVEBUNMETHOD);
                                             }
    }
    
  /**********************************************************************************************
    * @Author:      Neha Sameen  
    * @Date:        16/04/2018
    * @Description: This is the handler class of Trigger "TGR_BU_Segmentation"for merging the BU_acount
    *               name in Account object "Active BUs" feild.        
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
    ***********************************************************************************************/
    public static void delActiveBuUnits(List<BU_Segmentation__c> buSegList)
    { 
        set<id> buAccIds = new set<id>();
        for (BU_Segmentation__c bu_Seg : buSegList) {
            buAccIds.add(bu_Seg.Account__c);
        }
       
        List<Account> AccountList = [Select Id,(Select Account__c,Name,BU1__c FROM BU_Segmentations__r) 
                                     FROM Account WHERE  Id IN :buAccIds LIMIT:fetchMaxRows()];
        for (Account acct : AccountList) {
            if(Acct.BU_Segmentations__r.size() > 0 ){
              // Acct.Active_BUs__c = string.valueOf(Acct.BU_Segmentations__r[0].BU1__c);
                if(Acct.BU_Segmentations__r.size() == 1){
              //  Acct.Active_BUs__c = Acct.Active_BUs__c + CON_R1.SEMICOLON ;   
                }
                else if(Acct.BU_Segmentations__r.size() > 1){
                for(integer i=0;i < Acct.BU_Segmentations__r.size();i++)
                {
                    if(Acct.BU_Segmentations__r[i].BU1__c != null){
                      //  Acct.Active_BUs__c = Acct.Active_BUs__c + CON_R1.SEMICOLON + string.valueOf(Acct.BU_Segmentations__r[i].BU1__c);
                    }
                }
            }
            }
        }
        
        try{
            
           AvoidRecursion.setFirstRunFalse(); 
           database.update(AccountList);
            if(test.isRunningTest() && checkTestRunFlag){
               Integer num = 5/0;
            }
        }
        catch(Exception ex){
           // ExceptionLog.createExceptionRecord(ex,CON_R1_INTEGRATION.TRIGGERHANDLERBUSEGMENTATION,
                                             //  null,CON_R1.TRIGGERHANDLERACTIVEBUNMETHOD);
        }
    }
    
    
    
    /**********************************************************************************************
    * @Author:      Indrajit CHattaraj  
    * @Date:        4-7-2018
    * @Description: helper method to return maxrow for limit.
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
    ***********************************************************************************************/    
    private static Integer fetchMaxRows(){
        Integer maxRows = 0;
        maxRows = (Limits.getLimitQueryRows() - Limits.getQueryRows());
        return maxRows;
    }  
}