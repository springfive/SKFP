@isTest(SeeAllData = False)
/*********************************************************************
@Author : Neha Sameen 
@name : TGRH_AccountPlanTeamShare_Test
@CreateDate : 18-06-2018
@Description : Test class for Test_TGRH_AccountPlanTeamShare.
***********************************************************************/
private class TST_TGRH_AccountPlanTeamShare {
    
    /******************************************************************
@MethodName : insertData
@ReturnType : void
@Description : Method creating test data for Account Plan.
*******************************************************************/ 
    private static testMethod void insertAccountPlanData() {
        
        AvoidRecursion.setFirstRunTrue();
        DataFactory.createAcount('AccName', 'Boston', 'US', 'Alaska');
        
       
        AvoidRecursion.setFirstRunTrue();    
        DataFactory.createAcount('test account', 'Boston', 'US', 'Alaska');
        Id accId= [Select Id from Account Where name ='test account' Limit 1].id;
        AvoidRecursion.setFirstRunTrue();
        
        DataFactory.CreateSalesUser('usear', 'usear@arkema.com', 'lname', 'Fname', 'Functional Polyolefins');
        User salesUser = [Select Id, name from User Where lastname ='lname' Limit 1];
        AvoidRecursion.setFirstRunTrue();
        DataFactory.CreateSalesUser('SauSer', 'sales@arkema.com', 'Sales', 'Referal','Functional Polyolefins');
        Id susrId = [Select Id from User Where lastname = 'Sales' Limit 1].Id;
        AvoidRecursion.setFirstRunTrue();  
        DataFactory.createAccPlan('Account plan Title', 'Account Plan Team', accID, system.today(), system.today());
        AP_Account_Plan__c accplan= [Select Id,Account_Plan_Title__c 
                                     from AP_Account_Plan__c 
                                     Where Account_Plan_Title__c='Account plan Title' Limit 1];
        ID accplanID= [Select Id,Account_Plan_Title__c 
                       from AP_Account_Plan__c 
                       Where Account_Plan_Title__c='Account plan Title' Limit 1].Id;
        
        AvoidRecursion.setFirstRunTrue();
        DataFactory.createAccPlan('Account plan Title', 'Account Plan Team', accID, system.today(), system.today());
        
        
        Test.startTest();
        try{
            
            
            Account_Plan_Team__c apt = new Account_Plan_Team__c();
            apt.Account_Plan__c= accplanID;
            apt.User__c=susrId;
            AvoidRecursion.setFirstRunTrue();
            Database.insert(apt);
            AvoidRecursion.setFirstRunTrue();
            DataFactory.createAccPlan('34 Title', 'Plan', accID, system.today(), system.today());
        }
        catch(Exception ex)
        {
            
            //ExceptionLog.createExceptionRecord(ex,CON_R1.ACCOUNTPLANSHARETESTCLASS,null,CON_R1.INSERTACCOUNTPLANDATA);
            
            
        }
        Test.stopTest(); 
            system.assertEquals(salesUser.Name, 'Fname lname');
            system.assertEquals(accplan.Account_Plan_Title__c, 'Account plan Title');
        
        
        
    }
}