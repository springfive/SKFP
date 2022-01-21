/**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        04-10-2018
* @Description: R2-R-0419_Class created to update the "New Development sample" based on product 
value of sample product
* @Revision(s):   
***********************************************************************************************/
public with sharing class TGRH_SampleProduct {
    public static Boolean checkTestRunFlag = false; 
    /**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        04-10-2018
* @Description: R2-R-0419_Class created to update the "New Development sample" with Yes when 
there is only one product that is "00 - Product to be developed" and when there
is more than 1 product its NO.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public static void updateSampleAsPerProductValue(list<Sample_Product__c> newSamplePrd){
        Integer maxRows = 0;
        maxRows = (Limits.getLimitQueryRows() - Limits.getQueryRows());
        set<id> sampleId = new set<id>();
        List<Sample__c> sampleList = new List<Sample__c>();        
        //  List<Sample_Product__c> sampleProdList = new List<Sample_Product__c>();
        ID userId= UserInfo.getUserId();
        List<user> UserProfile = new list<user>();
        UserProfile = [SELECT id,Profile.Name FROM User where ID=: userId AND (profile.Name =: CON_R1.SYSADMINPROFILE OR profile.Name =: CON_R1.INTERFACEPROFILE OR profile.Name =: CON_R1.WEBSITEUSERPROFILE) LIMIT 1];        
        
        for(Sample_Product__c spObj:newSamplePrd){
            sampleId.add(spObj.Sample__c);
        } 
        
        for (Sample__c sampleRec : [select id,New_Development_Sample__c,No_SAP_Interface_expected__c, 
                                    (SELECT Id,Name,Sample__c,SampleProductName__c,Product__c,Good_Issue_Date__c,Planned_Delivery_Date__c from Sample_Products__r where SampleProductName__c =: CON_R1.PRODUCTVALUE1) 
                                    from Sample__c where id in :sampleId LIMIT:maxRows]) {
                                        if(sampleRec.Sample_Products__r.size() > 0){   
                                            sampleRec.New_Development_Sample__c = CON_R1.YES ;
                                        }
                                        else {
                                            sampleRec.New_Development_Sample__c  = CON_R1.NO ; 
                                        } 
                                        
                                        sampleList.add(sampleRec);
                                        
                                    }
        
        
        try{
            AvoidRecursion.setFirstRunFalse();
            database.update(sampleList);
        }
        catch(Exception ex){
            //ExceptionLog.createExceptionRecord(ex,CON_R1.SAMPLEPRODUCTHSNDLER,null,CON_R1.SAMPLEPRODUCTMETHOD1);
                           }
    }
    
    /*******************************************************************************************************
* @Author:      Neha Sameen
* @Date:        14-11-2018
* @Description: R2_Skip validation for Interface, Webuser & System admin to edit good issues date & Planned delivery date
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description] 
* *****************************************************************************************************/  
    
    public static void preventFormEditing(list<Sample_Product__c> sampleNew, Map<ID,Sample_Product__c>samplOldMap){
        
        ID userId= UserInfo.getUserId();
        List<user> UserProfile = new list<user>();
        UserProfile = [SELECT id,Profile.Name FROM User where ID=: userId AND 
                       (profile.Name =: CON_R1.SYSADMINPROFILE 
                        OR profile.Name =: CON_R1.INTERFACEPROFILE 
                        OR profile.Name =: CON_R1.WEBSITEUSERPROFILE) LIMIT 1];        
        list<ID> samList = new list<ID>(); 
        
        for (Sample_Product__c sample:sampleNew)
        {
            Sample_Product__c sampleOld = samplOldMap.get(sample.Id);
            Date samPrdGood= sampleOld.Good_Issue_Date__c;
            Date samPrdPlanned= sampleOld.Planned_Delivery_Date__c;
            string samPrdName= sampleOld.SampleProductName__c ;  
            
            if(UserProfile.size() == 0 && samPrdGood != null && samPrdPlanned != null && sample.Sample_SAP_interface_Checkbox_Value__c != TRUE&& samPrdName != CON_R1.PRODUCTVALUE1 )
            {                                             
                sample.addError(CON_R1.SAMPRODDATESERROR);
            }
        }
        
    }           
    
    
    /**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        22-10-2018
* @Description: R2-R-0707_Update Sample_Contact_Email__c with the email of the contact selected in 
Contact_for_Shipping__c of Sample Request.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/   
    public static void updateSampleContactEmail(list<Sample_Product__c> newSamplePrd){
        for(Sample_Product__c samPrdObj:newSamplePrd){
            samPrdObj.Sample_Contact_Email__c =  samPrdObj.Sample_Contact_for_Shipping__c;
            samPrdObj.ERP__c = samPrdObj.Sample_ERP__c;
            // sampleProdList.add(samPrdObj);
        }
        //  update sampleProdList;
    }
    /**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        12-11-2018
* @Description: R2-D-0515_Update Sample's status to "Good Issue" if the sample product associated to
it has Good Issue Date filled in.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public static void updateSampleProductStatus(list<Sample_Product__c> newSamplePrd){
        set<id> sampleId = new set<id>();      
        
        List<Sample_Product__c> samPrdList = new List<Sample_Product__c>();
        List<Sample__c> samList = new List<Sample__c>();
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
            
        }
        
        //string.valueOf(groupedResults[0].get('Product_Group__c'));
        
        /* for(Sample_Product__c samPrdRec:[select id,Good_Issue_Date__c,Sample__c,Sample__r.Status__c 
from Sample_Product__c 
where Sample__c in:sampleId]){
if(samPrdRec.Good_Issue_Date__c != null){
samPrdRec.Sample__r.Status__c = c 
samPrdList.add(samPrdRec);
system.debug('sample status#####'+samPrdRec.Sample__r.Status__c);
}
}*/
        for(Sample__c samObj:[select id,Status__c from Sample__c where id in:sampleId]){
            for(Sample_Product__c samPrdRec:newSamplePrd){
                if(samPrdRec.Good_Issue_Date__c != null){
                    samObj.Status__c = CON_R1.GOODISSUES;  
                    samList.add(samObj); 
                }
            }
        }
        if(samList.size()>0){
            database.update (samList);
        }
        
    }
    /**********************************************************************************************
* @Author:      Shipra Srivastava
* @Date:        15-11-2018
* @Description: R2-D-0545_Update Sample's product group with the first sample product created.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public static void updateSamplesProductGroup(list<Sample_Product__c> newSamplePrd){
        set<id> sampleId = new set<id>();
        set<id> productId = new set<id>();
        List<Sample__c> samList = new List<Sample__c>();
        
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
            productId.add(samPrdObj.Material_Product__c);
        }
        string productGroup;
        //List<Product2> prdList=[select id,Product_Group__c,CreatedDate from Product2 where id in:productId ];
        for(Product2 prdObj:[select id,Product_Group__c,CreatedDate from Product2 where id in:productId AND Product_Group__c != null]){
            productGroup=prdObj.Product_Group__c;
        }
        for(Sample__c samObj:[select id,Status__c,CreatedDate from Sample__c where id in:sampleId order by CreatedDate limit 1]){
            if(productGroup != null && productGroup != ''){
                samObj.Product_Group__c = productGroup;
                samList.add(samObj);
            }
        }
        if(samList.size()>0){
            database.update(samList);  
        }
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-13-2018  
* @Description: D-0784, update Approval status of sample product based certain criteria.
* @Revision(s): [08/08/20019] - [R5_R-1115] - [Prateek Chauhan] - [Added W5 BUs condition as per the requirment]   
***********************************************************************************************/ 
    public static void updateSPStatusToApprove(list<Sample_Product__c> newSamplePrd){
        String usrRegion = [Select Region__c From User Where Id = :UserInfo.getUserId()][0].Region__c;
        //system.debug('usrRegion'+usrRegion);
        String usrBU = [Select BU__c From User Where Id = :UserInfo.getUserId()][0].BU__c;
        //system.debug('usrBU'+usrBU);
        // String usrProfile = [Select Profile.Name From User Where Id = :UserInfo.getUserId()][0].Profile.Name;
        // system.debug('usrProfile'+usrProfile);
        List<Sample_Product__c> sampleProdLst = new List<Sample_Product__c>();
        for(Sample_Product__c sampleProdObj:[select id,Approval_Status__c,Cancel_my_Sample_Product__c,
                                             Sample__r.Status__c,Sample__r.Interface_Status__c,Sample__r.Next_Steps__c,
                                             Product__r.BU__c,Product__r.Bypass_Sample_Approval_Process__c,CreatedBy.Profile.Name
                                             from Sample_Product__c where id in:newSamplePrd AND Product__r.Bypass_Sample_Approval_Process__c!=null
                                             AND Cancel_my_Sample_Product__c =: false]){
                                              /*   usrBU == CON_R1.SARTOMER || usrBU == CON_R1.COATINGRESINS || usrBU == CON_R1.FUNCTIONALADDITIVES 
                                                     || usrBU == CON_R1.THIOCHEMICALS || usrBU == CON_R1.ALTUGLAS || usrBU == CON_R3.FLUROGASES
                                                     || usrBU == CON_R3.TECHNICALPOLYMERS || usrBU == CON_R3.OXYGENERATEDDERIVATED || usrBU == CON_R3.BOSTIKIA
                                                     || usrBU == CON_R3.BOSTIKNW || usrBU == CON_R3.SURFACTANTSADDITIVES || usrBU == CON_R3.MOLECULARSIEVES
                                                     || usrBU == CON_R3.ACRYLICS || usrBU == CON_R3.BOSTIKCCC || usrBU == CON_R3.COATEX || usrBU == CON_R3.INCUBATOR*/
                                                 if((usrBU == CON_R3.POF) && (sampleProdObj.Product__r.BU__c == CON_R3.POF)
                                                    && ((usrRegion == CON_R1.EMEA && sampleProdObj.Product__r.Bypass_Sample_Approval_Process__c.contains(CON_R1.EMEA))
                                                        || (usrRegion == CON_R1.APAC && sampleProdObj.Product__r.Bypass_Sample_Approval_Process__c.contains(CON_R1.APAC))
                                                        || (usrRegion == CON_R1.AMERICAS && sampleProdObj.Product__r.Bypass_Sample_Approval_Process__c.contains(CON_R1.AMERICAS)) ))
                                                     
                                                 {
                                                     system.debug('check bypass field'+sampleProdObj.Product__r.Bypass_Sample_Approval_Process__c);
                                                     sampleProdObj.Approval_Status__c = CON_R1.APPROVED;
                                                     system.debug('Approval status'+ sampleProdObj.Approval_Status__c);
                                                     sampleProdLst.add(sampleProdObj);
                                                     system.debug('sampleProdLst'+ sampleProdLst);
                                                 }            
                                             }
        AvoidRecursion.setFirstRunFalse();
        database.update(sampleProdLst);
        //system.debug('sampleProdLst2****'+ sampleProdLst);
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     22-11-2018  
* @Description: D-0570, Created to update Sample's Approval_Status_PAS__c with the count of sample
product's with status Pending Approval Submission.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
    public static void countPASOnParent(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        
        integer intCount = 0;
        List<Sample__c> sampleList = new List<Sample__c>();
        
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
        }
        /* List<Sample_Product__c> samPrdChildRec=[select id,Sample__c,Approval_Status__c 
from Sample_Product__c  where Sample__c in:sampleId];
List<Sample__c> samPrdParentRec=[select id,Approval_Status_PAS__c
from Sample__c  where id in:sampleId];*/
        List<Sample__c> samPrdParentRec = new List<Sample__c>();
        for(Sample__c samObj:[select id,Approval_Status_PAS__c
                              from Sample__c  where id in:sampleId]){
                                  intCount = 0;
                                  
                                  for(Sample_Product__c newSamPrd : [select id,Sample__c,Approval_Status__c 
                                                                     from Sample_Product__c  where Sample__c in:sampleId]){
                                                                         if(newSamPrd.Approval_Status__c == CON_R1.APPROVALSTATUSPAS)
                                                                             intCount++;
                                                                     }
                                  samObj.Approval_Status_PAS__c = intCount;
                                  system.debug('Pending Approved Submission count'+samObj.Approval_Status_PAS__c);
                                  samPrdParentRec.add(samObj);
                              }
        // AvoidRecursion.setFirstRunTrue();
        AvoidRecursion.setFirstRunFalse();
        database.update (samPrdParentRec);
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     22-11-2018  
* @Description: D-0570, Created to update Sample's Approval_Status_PA__c with the count of sample
product's with status Pending Approval.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
    public static void countPAOnParent(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        
        integer intCount = 0;
        List<Sample__c> sampleList = new List<Sample__c>();
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
        }
        List<Sample__c> samPrdParentRec = new List<Sample__c>();
        /* List<Sample_Product__c> samPrdChildRec=[select id,Sample__c,Approval_Status__c 
from Sample_Product__c  where Sample__c in:sampleId];
List<Sample__c> samPrdParentRec=[select id,Approval_Status_PA__c
from Sample__c  where id in:sampleId];*/
        for(Sample__c samObj:[select id,Approval_Status_PA__c
                              from Sample__c  where id in:sampleId]){
                                  intCount = 0;
                                  for(Sample_Product__c newSamPrd : [select id,Sample__c,Approval_Status__c 
                                                                     from Sample_Product__c  where Sample__c in:sampleId]){
                                                                         if(newSamPrd.Approval_Status__c == CON_R1.APPROVALSTATUSPA)
                                                                             intCount++;
                                                                     }
                                  samObj.Approval_Status_PA__c = intCount;
                                  system.debug('PA COunt'+samObj.Approval_Status_PA__c);
                                  samPrdParentRec.add(samObj);
                                  
                              }
        //AvoidRecursion.setFirstRunTrue();
        AvoidRecursion.setFirstRunFalse();
        database.update (samPrdParentRec);
    }   
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     22-11-2018  
* @Description: D-0570, Created to update Sample's Approval_Status_Approved__c with the count of sample
product's with status Approved.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
    public static void countApprovedOnParent(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        
        integer intCount = 0;
        List<Sample__c> sampleList = new List<Sample__c>();
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
        }
        /*  List<Sample_Product__c> samPrdChildRec=[select id,Sample__c,Approval_Status__c 
from Sample_Product__c  where Sample__c in:sampleId];
List<Sample__c> samPrdParentRec=[select id,Approval_Status_Approved__c
from Sample__c  where id in:sampleId];*/
        
        List<Sample__c> samPrdParentRec = new List<Sample__c>();
        
        for(Sample__c samObj:[select id,Approval_Status_Approved__c
                              from Sample__c  where id in:sampleId]){
                                  intCount = 0;
                                  for(Sample_Product__c newSamPrd : [select id,Sample__c,Approval_Status__c 
                                                                     from Sample_Product__c  where Sample__c in:sampleId]){
                                                                         if(newSamPrd.Approval_Status__c == CON_R1.APPROVED) 
                                                                             intCount++;
                                                                     }
                                  samObj.Approval_Status_Approved__c = intCount;
                                  system.debug('Approved COunt'+samObj.Approval_Status_Approved__c);
                                  samPrdParentRec.add(samObj);
                                  
                              }
        //AvoidRecursion.setFirstRunTrue();
        AvoidRecursion.setFirstRunFalse();
        update samPrdParentRec;
    }
    
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     22-11-2018  
* @Description: D-0570, Created to update Sample's Approval_Status_Rejected__c with the count of sample
product's with status Rejected.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/ 
    public static void countRejectedOnParent(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        
        integer intCount = 0;
        List<Sample__c> sampleList = new List<Sample__c>();
        for(Sample_Product__c samPrdObj:newSamplePrd){
            sampleId.add(samPrdObj.Sample__c);
        }
        /* List<Sample_Product__c> samPrdChildRec=[select id,Sample__c,Approval_Status__c 
from Sample_Product__c  where Sample__c in:sampleId];
List<Sample__c> samPrdParentRec=[select id,Approval_Status_Rejected__c
from Sample__c  where id in:sampleId]; */
        List<Sample__c> samPrdParentRec = new List<Sample__c>();
        
        for(Sample__c samObj:[select id,Approval_Status_Rejected__c
                              from Sample__c  where id in:sampleId]){
                                  intCount = 0;
                                  for(Sample_Product__c newSamPrd : [select id,Sample__c,Approval_Status__c 
                                                                     from Sample_Product__c  where Sample__c in:sampleId]){
                                                                         if(newSamPrd.Approval_Status__c == CON_R1.REJECTED)
                                                                             intCount++;
                                                                     }
                                  samObj.Approval_Status_Rejected__c = intCount;
                                  samPrdParentRec.add(samObj);
                                  
                              }
        // AvoidRecursion.setFirstRunTrue();
        AvoidRecursion.setFirstRunFalse();
        database.update (samPrdParentRec);
        
    }
    
    
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     22-11-2018  
* @Description: D-0570, Created to update Sample's Status based on the Approval status of associated 
Sample Product.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateStatusBasedOnApproval(List<Sample_Product__c> newSamplePrd)
    {
        List<Sample__c> samList = new List<Sample__c>();
        set<id> sampleId = new set<id>();
        for(Sample_Product__c samPrdObj:newSamplePrd){
            if(samPrdObj.Good_Issue_Date__c == null)
            {
                sampleId.add(samPrdObj.Sample__c);
            }
            //sampleId.add(samPrdObj.Sample__c);
        }
        
        
        /*ID userId= UserInfo.getUserId();
List<user> UserProfile = new list<user>();
UserProfile = [SELECT id,Profile.Name FROM User where ID=: userId AND 
profile.Name =: CON_R1.WEBSITEUSERPROFILE];
AND CreatedBy.profile.Name !=: CON_R1.WEBSITEUSERPROFILE 
if(UserProfile.size() == 0 ){ */ 
        
        
        for(Sample__c sampleObj:[select id,status__c,CreatedBy.profile.Name,Approval_Status_PAS__c,Approval_Status_Rejected__c,
                                 Approval_Status_PA__c,interface_status__c,Approval_Status_Approved__c from Sample__c where id in:sampleId])
        { 
            system.debug('Enter For');
            if((sampleObj.Status__c!=CON_R1.GOODISSUES && sampleObj.Status__c != CON_R1.INPROGRESS 
                && sampleObj.Status__c!=CON_R1.PENDINGCUSFEEDBACK && sampleObj.Status__c!=CON_R1.CLOSEDAPPROVED
                && sampleObj.Status__c!=CON_R1.CLOSEDREJECTED) && (sampleobj.Interface_Status__c == null || sampleobj.Interface_Status__c == ''))
            {
                system.debug('enter in loop'+sampleObj);
                if((sampleObj.Approval_Status_PAS__c > 0  || sampleObj.Approval_Status_PA__c > 0
                    || sampleObj.Approval_Status_Approved__c > 0 || sampleObj.Approval_Status_Rejected__c > 0)
                   && sampleObj.Approval_Status_PAS__c ==1){
                       sampleObj.Status__c = CON_R1.SAMPLEDRAFT;
                       system.debug('Enter SAMPLEDRAFT');
                       samList.add(sampleObj);
                   }
                
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c == 0
                        && sampleObj.Approval_Status_Approved__c == 1 && sampleObj.Approval_Status_Rejected__c ==0){
                            sampleObj.Status__c = CON_R1.APPROVED;
                            system.debug('status approved1');
                            samList.add(sampleObj);
                        }
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c > 1 && sampleObj.Approval_Status_Approved__c == 0 && sampleObj.Approval_Status_Rejected__c ==0){
                    sampleObj.Status__c = CON_R1.APPROVALSTATUSPA;
                    system.debug('status pending approved');
                    samList.add(sampleObj);
                }
                else if(sampleObj.Approval_Status_PA__c >= 1 && (sampleObj.Approval_Status_PAS__c >= 0 || sampleObj.Approval_Status_Approved__c >= 0 || sampleObj.Approval_Status_Rejected__c >=0)){
                    sampleObj.Status__c = CON_R1.APPROVALSTATUSPA;
                    system.debug('status pending approved');
                    samList.add(sampleObj);
                }
                
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c == 0 && (sampleObj.Approval_Status_Approved__c > 0 || sampleObj.Approval_Status_Rejected__c > 0) && sampleObj.Approval_Status_Approved__c >= 1){
                    sampleObj.Status__c = CON_R1.APPROVED;
                    system.debug('status approved 2');
                    samList.add(sampleObj);
                }
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c == 0 && sampleObj.Approval_Status_Approved__c == 0 && sampleObj.Approval_Status_Rejected__c ==1){
                    system.debug('enter rejected here');
                    sampleObj.Status__c = CON_R1.REJECTED;
                    samList.add(sampleObj);
                }
                
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c == 0 && sampleObj.Approval_Status_Approved__c == 0 && sampleObj.Approval_Status_Rejected__c >1){
                    system.debug('enter rejected again');
                    sampleObj.Status__c = CON_R1.REJECTED;
                    samList.add(sampleObj);
                }
                
                
                else if(sampleObj.Approval_Status_PAS__c == 0 && sampleObj.Approval_Status_PA__c == 1 && sampleObj.Approval_Status_Approved__c == 0 && sampleObj.Approval_Status_Rejected__c ==0){
                    sampleObj.Status__c = CON_R1.APPROVALSTATUSPA;
                    system.debug('Enter Approval_Status_PA__c');
                    samList.add(sampleObj);
                }                                        
                
                else if(sampleObj.Approval_Status_PAS__c == 1 && sampleObj.Approval_Status_PA__c == 0 && sampleObj.Approval_Status_Approved__c == 0 && sampleObj.Approval_Status_Rejected__c == 0){
                    sampleObj.Status__c = CON_R1.SAMPLEDRAFT;
                    system.debug('Enter SAMPLEDRAFT 2');
                    samList.add(sampleObj);
                }
            }         
        }
        AvoidRecursion.setFirstRunFalse();
        system.debug('samList^^^^^^^^^^^^'+samList);
        update samList;
        
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018 
* @Method:   updateSPApprover5Criterias
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover5Criterias(List<Sample_Product__c> newSamplePrd)
    {
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Account__c != null AND Region__c != null AND 
                                          BU__c != null AND Product_Group__c != null AND Arkema_Legal_Entity__c != null]){
                                              system.debug('enter in 5th criteria----');
                                              if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Product_Group__c == samProdObj.SP_Product_ProductGroup__c && approverObj.Account__c == samProdObj.SampleAccountName__c && approverObj.Arkema_Legal_Entity__c == samProdObj.SampleLegalEntity__c) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                              }
                                          }
            
            // }
        }
        // AvoidRecursion.setFirstRunFalse();    
        //  update sampleId;
        
    }
    
    
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover1stOf4Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover1stOf4Criterias(List<Sample_Product__c> newSamplePrd)
    {
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c Where Account__c = null AND Arkema_Legal_Entity__c != null 
                                          AND Region__c != null AND BU__c != null AND Product_Group__c != null ]){
                                              
                                              if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Product_Group__c == samProdObj.SP_Product_ProductGroup__c && approverObj.Arkema_Legal_Entity__c == samProdObj.SampleLegalEntity__c) 
                                              {
                                                  
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                              }
                                          }
            
            // }
            
            
        }
        //AvoidRecursion.setFirstRunFalse();
        // update sampleId;
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover2ndOf4Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover2ndOf4Criterias(List<Sample_Product__c> newSamplePrd)
    {
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        for(Sample_Product__c samProdObj:newSamplePrd){
            //  if(samProdObj.SP_Approver__c == null){
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c Where Arkema_Legal_Entity__c = null AND
                                          Region__c != null AND BU__c != null AND Product_Group__c != null
                                          AND Account__c != null 
                                         ]){
                                             if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Product_Group__c == samProdObj.SP_Product_ProductGroup__c && approverObj.Account__c == samProdObj.SampleAccountName__c) 
                                             {
                                                 samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                             }
                                         }
            
            // }
        }
        
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover3rdOf4Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover3rdOf4Criterias(List<Sample_Product__c> newSamplePrd)
    {
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Product_Group__c = null
                                          AND Arkema_Legal_Entity__c != null AND Region__c != null AND 
                                          BU__c != null AND Account__c != null]){
                                              system.debug('enter For updateSPApprover3rdOf4Criterias----');
                                              if(approverObj.Region__c == userRegion&& approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Account__c == samProdObj.SampleAccountName__c && approverObj.Arkema_Legal_Entity__c == samProdObj.SampleLegalEntity__c ) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                              }
                                          }
            
            // }
        }
        //AvoidRecursion.setFirstRunFalse();
        //    update sampleId;
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover1stOf3Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover1stOf3Criterias(List<Sample_Product__c> newSamplePrd)
    {
       system.debug('enter in 1st of 3 criteria');
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Account__c = null 
                                          AND Arkema_Legal_Entity__c = null AND Region__c != null 
                                          AND BU__c != null AND Product_Group__c != null]){
                                              system.debug('enter For updateSPApprover1stOf3Criterias----');
                                              if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Product_Group__c == samProdObj.SP_Product_ProductGroup__c) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                                  
                                              }
                                          }
            
            //}
        }
        
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover2ndOf3Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover2ndOf3Criterias(List<Sample_Product__c> newSamplePrd)
    {
        system.debug('enter in 2nd of 3 criteria');
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Product_Group__c = null
                                          AND Account__c = null AND Arkema_Legal_Entity__c != null 
                                          AND Region__c != null AND BU__c != null]){
                                              system.debug('enter For updateSPApprover2ndOf3Criterias----');
                                              if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Arkema_Legal_Entity__c == samProdObj.SampleLegalEntity__c) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                              }
                                          }
            
            // }
        }
        // AvoidRecursion.setFirstRunFalse();
        //    update sampleId;
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover3rdOf3Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover3rdOf3Criterias(List<Sample_Product__c> newSamplePrd)
    {
        system.debug('enter in 3rd of 3 criteria');
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            // if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Arkema_Legal_Entity__c = null AND Product_Group__c = null AND Account__c != null AND Region__c != null AND BU__c != null]){
                                              system.debug('enter For updateSPApprover3rdOf3Criterias----');
                                              if(approverObj.Region__c == userRegion && approverObj.BU__c == samProdObj.SampleBU__c && approverObj.Account__c == samProdObj.SampleAccountName__c) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                              }
                                          }
            
            //}
        }
        //  AvoidRecursion.setFirstRunFalse();
        //    update sampleId;
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018
* @Method:   updateSPApprover2Criterias  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void updateSPApprover2Criterias(List<Sample_Product__c> newSamplePrd)
    {
        system.debug('enter in 2nd criteria');
        List<Sample_Product__c> sampleId = new List<Sample_Product__c>();
        string userRegion = [select id,Region__c from User WHERE Id = :UserInfo.getUserId()].Region__c;
        //system.debug('userRegion'+userRegion);
        for(Sample_Product__c samProdObj:newSamplePrd){
            //if(samProdObj.SP_Approver__c == null){
            //system.debug('enter For----');
            for(Approver__c approverObj :[select id,User_to_approve__c,Product_Group__c,Region__c,Arkema_Legal_Entity__c,
                                          BU__c,Account__c from Approver__c where Region__c != null AND BU__c != null AND Account__c = null AND Product_Group__c = null AND Arkema_Legal_Entity__c = null]){
                                              
                                              if(approverObj.Region__c == userRegion 
                                                 && approverObj.BU__c == samProdObj.SampleBU__c) 
                                              {
                                                  samProdObj.SP_Approver__c =  approverObj.User_to_approve__c;
                                                  
                                              }
                                          }
            
            // }
        }
        // AvoidRecursion.setFirstRunFalse();
        //  update sampleId;
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     12-19-2018  
* @Description: R3_R-0808, updated Sample product's SP Approver based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void InsertSPApproverInST(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        List<string> sampleStr = new List<string>();
        List<Sample_Team__c> samTeamList = new List<Sample_Team__c>();
        for(Sample_Product__c samProd:newSamplePrd){
            sampleId.add(samProd.Sample__c);
            sampleStr.add(samProd.SP_Approver__c);
        }
        set<id> uniqueSampleTeam = new set<id>();
        List<Sample_Team__c> sampleTeamList = [select id,Sample__c,Team_Member__c from Sample_Team__c where Sample__c in:sampleId];
        system.debug('sampleTeamList'+sampleTeamList);
        for(Sample_Team__c stObj : sampleTeamList){
            uniqueSampleTeam.add(stObj.Team_Member__c);   
        }
        for(Sample_Product__c samProdRec:[select id,Sample__c,SP_Approver__c,CreatedById 
                                          from Sample_Product__c  where Sample__c in:sampleId]){
                                              system.debug('sampleTeamList1234'+[select id,Sample__c,SP_Approver__c
                                                                                 from Sample_Product__c  where Sample__c in:sampleId]);
                                              if(!(uniqueSampleTeam).contains(samProdRec.SP_Approver__c) &&
                                                 samProdRec.SP_Approver__c != null){
                                                     system.debug('enter 2nd');
                                                     Sample_Team__c STObj = new Sample_Team__c();
                                                     system.debug('samProdRec.SP_Approver__c'+samProdRec.SP_Approver__c);
                                                     STObj.Sample__c = samProdRec.Sample__c;
                                                     STObj.Team_Member__c =  samProdRec.SP_Approver__c ;
                                                     if(samProdRec.CreatedById != UserInfo.getUserId()){
                                                         STObj.Access__c = 'Read';
                                                     }
                                                     samTeamList.add(STObj);
                                                 }    
                                          }
        //AvoidRecursion.setFirstRunTrue();
        insert samTeamList;
        // system.debug('Check if Calling Sample Team Trigger'+ AvoidRecursion.checkFirstRun());
        
        
    }
    /**********************************************************************************************
* @Author:   Shipra Srivastava   
* @Date:     1-18-2019  
* @Description: PSR-000445 , Insert Delegate Approver of the user in the SP Approver  
of Sample product based on certain criteria.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/    
    public static void InsertDelegateApproverInST(List<Sample_Product__c> newSamplePrd)
    {
        set<id> sampleId = new set<id>();
        List<string> sampleStr = new List<string>();
        List<Sample_Team__c> samTeamList = new List<Sample_Team__c>();
        for(Sample_Product__c samProd:newSamplePrd){
            sampleId.add(samProd.Sample__c);
            sampleStr.add(samProd.SP_Approver__r.DelegatedApproverId);
            //system.debug('sampleStr'+sampleStr);
        }
        set<id> uniqueSampleTeam = new set<id>();
        List<Sample_Team__c> sampleTeamList = [select id,Sample__c,Team_Member__c from Sample_Team__c where Sample__c in:sampleId];
        // system.debug('sampleTeamList'+sampleTeamList);
        for(Sample_Team__c stObj : sampleTeamList){
            uniqueSampleTeam.add(stObj.Team_Member__c);   
        }
        for(Sample_Product__c samProdRec:[select id,Sample__c,SP_Approver__c,SP_Approver__r.DelegatedApproverId 
                                          from Sample_Product__c  where Sample__c in:sampleId]){
                                              if(!(uniqueSampleTeam).contains(samProdRec.SP_Approver__r.DelegatedApproverId) &&
                                                 samProdRec.SP_Approver__r.DelegatedApproverId != null){
                                                     //system.debug('enter 2nd');
                                                     Sample_Team__c STObj = new Sample_Team__c();
                                                     //system.debug('samProdRec.SP_Approver__c'+samProdRec.SP_Approver__c);
                                                     STObj.Sample__c = samProdRec.Sample__c;
                                                     STObj.Team_Member__c =  samProdRec.SP_Approver__r.DelegatedApproverId ; 
                                                     //STObj.Access__c = 'Read';
                                                     samTeamList.add(STObj);
                                                 }    
                                          }
        // AvoidRecursion.setFirstRunTrue();
        insert samTeamList;
        // system.debug('Check if Calling Sample Team Trigger'+ AvoidRecursion.checkFirstRun());
        
        
    }
    /** Added by shipra to perform some testing regarding PSR-002277 ***/   
    public static void reassignApprover(List<Sample_Product__c> newSamplePrd)
    {
        Set <id> samProdIds = new Set <id>();
        List<Sample_Product__c> spObjList =new List<Sample_Product__c>();
        for(Sample_Product__c spObj : newSamplePrd){
           samProdIds.add(spObj.id);
            system.debug('samProdIds'+samProdIds);
        }
            List<ProcessInstanceWorkitem> listPIH = [select ActorId,OriginalActorId,ProcessInstance.TargetObjectId 
                                                     FROM ProcessInstanceWorkItem 
                                                     where ProcessInstance.TargetObjectId in:samProdIds];
        for(Sample_Product__c samProdObj:newSamplePrd){
            system.debug('enter 1st loop');
        for(ProcessInstanceWorkitem pIWObj:listPIH){
            system.debug('enter 2nd loop');
         samProdObj.SP_Approver__c =   pIWObj.ActorId;
            system.debug('pIWObj.ActorId'+pIWObj.ActorId);
            system.debug('pIWObj.SP_Approver__c'+samProdObj.SP_Approver__c);
            spObjList.add(samProdObj);
        }
            AvoidRecursion.setFirstRunFalse();
            database.update(spObjList);
        }
  //[Select Id, (Select Id, ActorId, Actor.Name, Comments, StepStatus from Steps 
  //where StepStatus = 'Approved' or StepStatus='Rejected' order by CreatedDate) 
  //from ProcessInstance where TargetObjectId in :ids];
         
    }
}