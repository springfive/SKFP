@isTest(SeeAllData = False)
public class TGR_SampleTeam_Test {
    @isTest static void sampleTeam(){
        Sample__c obj1=new Sample__c();
        insert obj1;
        Sample_Team__c  obj = new Sample_Team__c();
        obj.Sample__c=obj1.id;
        insert obj;
        
    }
    

}