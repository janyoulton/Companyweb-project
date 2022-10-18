@isTest
private class companyWebControllerTest {

    @isTest static Void companyWebControllerTestcall() {

        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();

        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

        connectCompanywebBe.RequestCompanyByVat reqByVAT = new connectCompanywebBe.RequestCompanyByVat();
        reqByVAT.VatNumber = '423584152';
        reqByVAT.Language = 'EN';
        reqByVAT.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        reqByVAT.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        reqByVAT.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
            
        DateTime dtTodayDate = System.today();
        String sMonth;
        Integer Day =  dtTodayDate.day();
        Integer Month = dtTodayDate.Month();

        if(Month < 10){
            sMonth = String.valueOf('0'+ Month);
        }else{
            sMonth = String.valueOf(Month);
        }
        Integer Year = dtTodayDate.Year();

        String targetString = (
            Year +
            sMonth +
            Day +
            oLoginSetup.CW_CompanyWebLogin__c +
            oLoginSetup.CW_CompanyWebPassword__c +
            oLoginSetup.CW_CompanyWebSecret__c
        ).toLowercase();
        Blob targetBlob = Blob.valueOf(targetString);
        Blob hashSHA1 = Crypto.generateDigest('SHA1', targetBlob);
        String hashBase64SHA1 = EncodingUtil.base64encode (hashSHA1);
        System.debug(EncodingUtil.convertToHex(hashSHA1));
        reqByVAT.LoginHash = EncodingUtil.convertToHex(hashSHA1);

        Test.setMock(WebServiceMock.class, new companyWebCallOutMock());
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3();
        connectCompanywebBe.ResponseCompanyByVatV1_3 result = httpreq.GetCompanyByVat(reqByVAT);

        system.debug(JSON.serialize(result));
    }

    // @isTest static void bankruptCompanySearch(){
    //    Test.startTest();
    //    companyWebControllerTestcall('453163907');
    //    Test.stopTest();
    //}

    //@isTest static void stopCompanySearch(){
    //    Test.startTest();
    //    companyWebControllerTestcall('860690304');
    //    Test.stopTest();
    //}

    //@isTest static void whiteCompanySearch(){
    //    Test.startTest();
    //    companyWebControllerTestcall('207436775');
    //    Test.stopTest();
    //}

    @isTest static Void errorHandlingTest() {
        Test.startTest();
        for(Integer i = 101 ; i < 406; i++){
            CompanyWebController.errorHandler(i);
        }
        Test.stopTest();
    }

    @isTest static Void clearDataAccountTest() {
        Test.startTest();
        Account account = new Account (Name = 'test1', CW_VAT_Number__c= '423584152');
        insert account;
    
        CompanyWebController.clearData(account.id, 'Account');
        Test.stopTest();
    }

    @isTest static Void clearDataLeadTest() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test2', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
    
        CompanyWebController.clearData(lead.id, 'Lead');
        Test.stopTest();
    }

    @isTest static Void copyDataAccountTest() {
        Test.startTest();
        
        Account account = new Account (Name = 'test3', CW_VAT_Number__c= '423584152' , CW_Name__c = 'Test LLC', CW_Phone__c = '1313131' , CW_Employees__c= 4.5 , CW_Revenue__c = 324324, CW_Street__c = 'Street Test' , CW_City__c = 'City Test', CW_PostalCode__c = '2035', CW_Country__c='BE');
        insert account;
    
        CompanyWebController.copyData(account.id, 'Account');
        Test.stopTest();
    }

    @isTest static Void copyDataLeadTest() {
        Test.startTest();
        
        Lead lead = new Lead (LastName = 'test4', Company='Test LLC', CW_VAT_Number__c= '423584152' , CW_Name__c = 'Test LLC', CW_Phone__c = '1313131' , CW_Employees__c= 4.5 , CW_Revenue__c = 324324, CW_Street__c = 'Street Test' , CW_City__c = 'City Test', CW_PostalCode__c = '2035', CW_Country__c='BE');
        insert lead;
    
        CompanyWebController.copyData(lead.id, 'Lead');
        Test.stopTest();
    }

    @isTest static Void getCWFieldsAccountTest() {
        Test.startTest();
        
        Account account = new Account (Name = 'test5', CW_VAT_Number__c= '423584152');
        insert account;
    
        CompanyWebController.getCWFields(account.id, 'Account');
        Test.stopTest();
    }

    @isTest static Void getCWFieldsLeadTest() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test6', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
    
        CompanyWebController.getCWFields(lead.id,'Lead');
        Test.stopTest();
    }
    
    @isTest static Void getAccountVatNumberTest() {
        Test.startTest();
        Account account = new Account (Name = 'test7', CW_VAT_Number__c= '423584152');
        insert account;
    
        CompanyWebController.getVATNumber(account.id,'Account');
        Test.stopTest();
    }

    @isTest static Void getLeadVatNumberTest() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test8', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
    
        CompanyWebController.getVATNumber(lead.id,'Lead');
        Test.stopTest();
    }

    @isTest static Void companyWebControllerPositiveAccountTestcall2() {
        Test.startTest();
        Account account = new Account (Name = 'test9', CW_VAT_Number__c= '423584152');
        insert account;
    
        Test.setMock(WebServiceMock.class, new companyWebCallOutMockEmpty());
        calloutGetCompanyByVAT(account.Id,'423584152','Account');
        Test.stopTest();
    }
    
    @isTest static Void companyWebControllerPositiveLeadTestcall2() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test10', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
    
        Test.setMock(WebServiceMock.class, new companyWebCallOutMockEmpty());
        calloutGetCompanyByVAT(lead.Id,'423584152','Lead');
        Test.stopTest();
    }

    @isTest static Void companyWebControllerPositiveAccountTestcall() {
        Test.startTest();
        Account account = new Account (Name = 'test9', CW_VAT_Number__c= '423584152');
        insert account;
    
        Test.setMock(WebServiceMock.class, new companyWebCallOutMock());
        calloutGetCompanyByVAT(account.Id,'423584152','Account');
        Test.stopTest();
    }
    
    @isTest static Void companyWebControllerPositiveLeadTestcall() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test10', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
    
        Test.setMock(WebServiceMock.class, new companyWebCallOutMock());
        calloutGetCompanyByVAT(lead.Id,'423584152','Lead');
        Test.stopTest();
    }

    @isTest static Void companyWebControllerNegativeAccountTestcall() {
            Test.startTest();
            Account account = new Account (Name = 'test11', CW_VAT_Number__c= '423584152');
            insert account;
         
            Test.setMock(WebServiceMock.class, new companyWebNegativeCallOutMock());
            calloutGetCompanyByVAT(account.Id,'','Account');
            Test.stopTest();
    }

    @isTest static Void companyWebControllerNegativeLeadTestcall() {
        Test.startTest();
        Lead lead = new Lead (LastName = 'test12', Company='Test LLC', CW_VAT_Number__c= '423584152');
        insert lead;
     
        Test.setMock(WebServiceMock.class, new companyWebNegativeCallOutMock());
        calloutGetCompanyByVAT(lead.Id,'','Lead');
        Test.stopTest();
    }

    @isTest static Void companyWebControllerSearchCompaniesInfoTestcall() {
        Test.startTest();
            Test.setMock(WebServiceMock.class, new companyWebSearchNegativeCallOutMock());
            calloutSearchCompany('');
        Test.stopTest();
    }

    @future(callout = true)
    public static void calloutGetCompanyByVAT(string Id, String Vat, String ObjectNAme){
        CompanyWebController.getCompanyInfo(Id,Vat,ObjectNAme,false);
    }

    @future(callout = true)
    public static void calloutSearchCompany(string sTerm){
        CompanyWebController.searchCompaniesInfo(sTerm);
    }

    @isTest static Void companyWebSearchControllerTestcall() {

        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();

        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

        system.debug('Result of loginSetup '+ oLoginSetup);

        connectCompanywebBe.RequestSearch reqSearch = new connectCompanywebBe.RequestSearch();
        reqSearch.SearchTerm  = 'The Customer Link';
        reqSearch.Language = 'EN';
        reqSearch.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        reqSearch.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        reqSearch.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
         
        DateTime dtTodayDate = System.today();
        String sMonth;
        Integer Day =  dtTodayDate.day();
        Integer Month = dtTodayDate.Month();

        if(Month < 10){
            sMonth = String.valueOf('0'+ Month);
        }else{
            sMonth = String.valueOf(Month);
        }
        Integer Year = dtTodayDate.Year();

        String targetString = (
            Year +
            sMonth +
            Day +
            oLoginSetup.CW_CompanyWebLogin__c +
            oLoginSetup.CW_CompanyWebPassword__c +
            oLoginSetup.CW_CompanyWebSecret__c
        ).toLowercase();
        Blob targetBlob = Blob.valueOf(targetString);
        Blob hashSHA1 = Crypto.generateDigest('SHA1', targetBlob);
        String hashBase64SHA1 = EncodingUtil.base64encode (hashSHA1);
        System.debug(EncodingUtil.convertToHex(hashSHA1));
        reqSearch.LoginHash = EncodingUtil.convertToHex(hashSHA1);
    
        Test.setMock(WebServiceMock.class, new companyWebSearchNegativeCallOutMock());
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3();
        connectCompanywebBe.ResponseSearch result = httpreq.SearchCompanies(reqSearch);

        system.debug(JSON.serialize(result));
    }
}