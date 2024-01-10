@isTest
public class companyWebAlertsTest {

    @TestSetup
    public static void testSetup(){
        Account acc = new Account(Name='testacc', CW_VAT_Number__c='869703978');
        Lead lead = new Lead(LastName='testlead', Company='testacc', CW_VAT_Number__c='869703978');
        insert acc;
        insert lead;
    }
    
    @isTest
    public static void companyWebAlertsAddCompanyToAlertsTest(){
        Test.setMock(WebServiceMock.class, new companyWebAddCompanyCallOutMock());
        CompanyWebController.addCompanyToAlerts('869703978');
    }
    
    @isTest
    public static void companyWebAlertsAddCompanyListToAlertsTest(){
        String accountId = [SELECT Id FROM ACCOUNT LIMIT 1].Id;
        Test.setMock(WebServiceMock.class, new companyWebAddCompanyListCallOutMock());
        CompanyWebController.addCompanyListToAlerts(new List<String>{ accountId });
    }

    @isTest
    public static void companyWebAlertsControllerTest(){
        CompanyWebAlertsController.invokeGetAlertsALaCarte();
    }
	
    @isTest
    public static void companyWebAlertsGetChangeDatesTest(){
        CW_Login_Setup__mdt oLoginSetup = CompanyWebController.getCurrentVATNumberFields();
        connectCompanywebBe.RequestStep1 request = new connectCompanywebBe.RequestStep1();
        request.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request.LoginHash = companyWebController.createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();
        
        Test.setMock(WebServiceMock.class, new companyWebGetChangedDatesCallOutMock());
        CompanyWebController.getChangeDates(httpreq, request);
    }
    
    @isTest
    public static void companyWebAlertsGetVatListTest(){
        CW_Login_Setup__mdt oLoginSetup = CompanyWebController.getCurrentVATNumberFields();
        connectCompanywebBe.RequestStep2 request = new connectCompanywebBe.RequestStep2();
        request.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request.LoginHash = companyWebController.createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        request.ChangedDate = 20221113;
        request.Step2Token = 'tokenofnumbersandletters';
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();

        Test.setMock(WebServiceMock.class, new companyWebGetVatListCallOutMock());
        CompanyWebController.getVatList(httpreq, request);
    }
    
    @isTest
    public static void companyWebAlertsGetCompanyDataTest(){
        CW_Login_Setup__mdt oLoginSetup = CompanyWebController.getCurrentVATNumberFields();
        connectCompanywebBe.RequestStep3_CompanyOnVat request = new connectCompanywebBe.RequestStep3_CompanyOnVat();
        request.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request.LoginHash = companyWebController.createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        request.Language = 'EN';
        request.VatNumber = '869703978';
        request.ChangedDate = 20221113;
        request.Step3Token = 'tokenofnumbersandletters';
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();

        List<Account> listOfAccountsToUpdate = [SELECT Id FROM Account];
        List<Lead> listOfLeadsToUpdate = [SELECT Id FROM Lead];

        Map<Integer, Map<Integer,String>> collectionOfStep3TokensByChangedDate = new Map<Integer,Map<Integer,String>>();
        Map<Integer,String> mapOfStep3Token = new Map<Integer,String>();
        mapOfStep3Token.put(869703978,'tokenofnumbersandletters');
        collectionOfStep3TokensByChangedDate.put(20221113,mapOfStep3Token);

        Test.setMock(WebServiceMock.class, new companyWebGetCompanyDataCallOutMock());
        System.enqueueJob(new companyWebCompanyByVATQueueable(httpreq, request, oLoginSetup, collectionOfStep3TokensByChangedDate, listOfAccountsToUpdate, listOfLeadsToUpdate));
    }

    @isTest
    public static void companyWebSendEmailTest(){
        CompanyWebController.sendEmail('test method', 0, 'test method succeeded');
    }
    
}