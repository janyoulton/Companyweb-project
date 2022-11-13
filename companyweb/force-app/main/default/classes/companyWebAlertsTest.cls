@isTest
public class companyWebAlertsTest {

    @TestSetup
    public static void testSetup(){
        Account acc = new Account(Name='testacc', CW_VAT_Number__c='869703978');
        Lead lead = new Lead(LastName='testlead', Company='testacc', Status='Open - Not Contacted', CW_VAT_Number__c='869703978');
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
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c,
            Lead_VAT_Number_Field__c,Account_Score_Field__c,Account_Activities_Field__c,Account_Credit_Limit_Field__c,Account_Joint_Commitees_Field__c,
            Account_Joint_Commitees_White_Field__c,Account_Legal_Form_Field__c,Account_Main_Activity_Field__c,Account_Number_Employees_Field__c,
            Account_Social_Security_Field__c,Account_Phone_Field__c,Account_Street_Field__c,Account_PostalCode_Field__c,Account_City_Field__c,Account_CountryCode_Field__c,
            Account_Annual_Revenue_Field__c,CW_Duplicate_Check_Creation__c,
            CW_Duplicate_Check_Refresh__c,Lead_Score_Field__c,Lead_Activities_Field__c,Lead_Credit_Limit_Field__c,Lead_Joint_Commitees_Field__c,
            Lead_Joint_Commitees_White_Field__c,Lead_Legal_Form_Field__c,Lead_Main_Activity_Field__c,Lead_Number_Employees_Field__c,Lead_Social_Security_Field__c,
            Lead_Phone_Field__c,Lead_Annual_Revenue_Field__c,Lead_Street_Field__c,Lead_PostalCode_Field__c,Lead_City_Field__c,Lead_CountryCode_Field__c
            FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
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
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c,
            Lead_VAT_Number_Field__c,Account_Score_Field__c,Account_Activities_Field__c,Account_Credit_Limit_Field__c,Account_Joint_Commitees_Field__c,
            Account_Joint_Commitees_White_Field__c,Account_Legal_Form_Field__c,Account_Main_Activity_Field__c,Account_Number_Employees_Field__c,
            Account_Social_Security_Field__c,Account_Phone_Field__c,Account_Street_Field__c,Account_PostalCode_Field__c,Account_City_Field__c,Account_CountryCode_Field__c,
            Account_Annual_Revenue_Field__c,CW_Duplicate_Check_Creation__c,
            CW_Duplicate_Check_Refresh__c,Lead_Score_Field__c,Lead_Activities_Field__c,Lead_Credit_Limit_Field__c,Lead_Joint_Commitees_Field__c,
            Lead_Joint_Commitees_White_Field__c,Lead_Legal_Form_Field__c,Lead_Main_Activity_Field__c,Lead_Number_Employees_Field__c,Lead_Social_Security_Field__c,
            Lead_Phone_Field__c,Lead_Annual_Revenue_Field__c,Lead_Street_Field__c,Lead_PostalCode_Field__c,Lead_City_Field__c,Lead_CountryCode_Field__c
            FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
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
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c,
            Lead_VAT_Number_Field__c,Account_Score_Field__c,Account_Activities_Field__c,Account_Credit_Limit_Field__c,Account_Joint_Commitees_Field__c,
            Account_Joint_Commitees_White_Field__c,Account_Legal_Form_Field__c,Account_Main_Activity_Field__c,Account_Number_Employees_Field__c,
            Account_Social_Security_Field__c,Account_Phone_Field__c,Account_Street_Field__c,Account_PostalCode_Field__c,Account_City_Field__c,Account_CountryCode_Field__c,
            Account_Annual_Revenue_Field__c,CW_Duplicate_Check_Creation__c,
            CW_Duplicate_Check_Refresh__c,Lead_Score_Field__c,Lead_Activities_Field__c,Lead_Credit_Limit_Field__c,Lead_Joint_Commitees_Field__c,
            Lead_Joint_Commitees_White_Field__c,Lead_Legal_Form_Field__c,Lead_Main_Activity_Field__c,Lead_Number_Employees_Field__c,Lead_Social_Security_Field__c,
            Lead_Phone_Field__c,Lead_Annual_Revenue_Field__c,Lead_Street_Field__c,Lead_PostalCode_Field__c,Lead_City_Field__c,Lead_CountryCode_Field__c
            FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
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