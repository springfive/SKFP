/**********************************************************************************************
* @Author:      Neha Sameen 
* @Date:        08/05/2018
* @Description: This is the handler util class to avoid Recursive call for Triggers on multiple objects.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/
public with sharing Class AvoidRecursion{
private static boolean  firstRun = true;
private static boolean  setInactiveTgr = true;  
private static user us=[select id,Skip_Trigger__c  from user where ID =:UserInfo.getUserId() LIMIT 1];
private static boolean productRecursiveFlag = false;

/**********************************************************************************************
* @Author:     Neha Sameen 
* @Date:        08/05/2018
* @Description: This is the class to check trigger run first time equal to true.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/    
    public static boolean checkFirstRun(){
        return firstRun;
    }    
    
    /**********************************************************************************************
* @Author:      Neha Sameen  
* @Date:        08/05/2018
* @Description: This is the reset the firstrun boolean value to false to reset the boolean value.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/ 
    public static void setFirstRunFalse(){
        firstrun = false;         
    } 
    /**********************************************************************************************
* @Author:      Neha Sameen  
* @Date:        08/05/2018
* @Description: This is the reset the firstrun boolean value to true to reset the boolean value.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/ 
    public static void setFirstRunTrue(){
        firstrun = true;
    }
/**********************************************************************************************
* @Author:      Neha Sameen  
* @Date:        12/01/2019
* @Description: R-0826- Method is used to skip the trigger for specific user 
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/
    public static Boolean setInactiveTgr(){
        
         
        if(us.Skip_Trigger__c)
         {
          return false;
         }
        else
        {
          return true;
        }
        
    }
/**********************************************************************************************
* @Author:     Indrajit Chattaraj 
* @Date:        27/05/2018
* @Description: This is the class to check trigger run first time equal to true for commercial prod creation.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/
    public static boolean checkProdRecFlag(){
        return productRecursiveFlag;
    } 
/**********************************************************************************************
* @Author:     Indrajit Chattaraj 
* @Date:        27/05/2018
* @Description: This is the class to check trigger run first time equal to true for commercial prod creation.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]    
***********************************************************************************************/ 
    public static void setProdRecFlag(){
         productRecursiveFlag = true;
    }  

}