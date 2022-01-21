@isTest(SeeAllData = False)
public class SampleProduct_Test {
    @isTest static void product(){
        System.Test.startTest();
        Sample__c obj=new Sample__c();
        obj.Additional_website_request__c='test';
        insert obj;
        Product2  obj1=new Product2();
        obj1.Color__c='blue';
        obj1.Name='test';
        insert obj1;
        
        
       	Sample_Product__c sampleProd= new Sample_Product__c();
        
        sampleProd.Sample__c = obj.Id;
        sampleProd.Product__c = obj1.Id;
        sampleProd.Quantity__c = 0.01;
        sampleProd.Unit_of_Measure__c= 'KGM';
        sampleProd.Price__c = 0.10;
       //sampleProd.Approval_Status__c = CON_R1.APPROVED;
        
            insert sampleProd;
       System.Test.stopTest();
       
        
        
    	/*Sample_Product__c obj=new Sample_Product__c();
    	obj.Carrier_Account_Name__c='Test';
        obj.Sample__c='a138E000000N9dr';
        System.Test.startTest();
    	insert obj; 
        System.Test.stopTest();*/
    }
}