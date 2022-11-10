public class companyWebAlertsQueueable implements Queueable, Database.AllowsCallouts {

    public companyWebAlertsQueueable(){

    }

    public void execute(QueueableContext context) {
        System.debug('initial queueable job');
        List<Account> listOfAccountsToUpdate = new List<Account>();
        List<Lead> listOfLeadsToUpdate = new List<Lead>();

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
        system.debug('Result of loginSetup '+ oLoginSetup);

        connectCompanywebBe.RequestStep1 request1 = new connectCompanywebBe.RequestStep1();
        request1.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request1.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request1.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request1.LoginHash = companyWebController.createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();

        //Step 1: get Change Dates
        Map<Integer,String> mapOfStep2Token = companyWebController.getChangeDates(httpreq, request1);
        System.debug(mapOfStep2Token);

        if(!mapOfStep2Token.isEmpty()){
            connectCompanywebBe.RequestStep2 request2 = new connectCompanywebBe.RequestStep2();
            request2.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
            request2.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
            request2.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
            request2.LoginHash = request1.LoginHash;

            Map<Integer,String> mapOfStep3Token = new Map<Integer,String>();
            Map<Integer, Map<Integer,String>> collectionOfStep3TokensByChangedDate = new Map<Integer, Map<Integer,String>>();
            for(Integer changeDate : mapOfStep2Token.keySet()){
                request2.ChangedDate = changeDate;
                request2.Step2Token = mapOfStep2Token.get(changeDate);

                //Step 2: get Vat List
                mapOfStep3Token = CompanyWebController.getVatList(httpreq, request2);
                //System.debug(mapOfStep3Token);
                collectionOfStep3TokensByChangedDate.put(changeDate, mapOfStep3Token);
            }

            System.debug(collectionOfStep3TokensByChangedDate);
            connectCompanywebBe.RequestStep3_CompanyOnVat request3 = new connectCompanywebBe.RequestStep3_CompanyOnVat();
            request3.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
            request3.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
            request3.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
            // User user Language
            String userLanguage = UserInfo.getLanguage();
            if (userLanguage == 'en_US'){
                userLanguage = 'EN';
            } else if(userLanguage == 'nl_NL'){
                userLanguage = 'NL';
            } else if(userLanguage == 'fr'){
                userLanguage = 'FR';
            } else {
                userLanguage = 'EN';
            }
            request3.Language = userLanguage;
            request3.LoginHash = request1.LoginHash;

            System.enqueueJob(new companyWebCompanyByVATQueueable(httpreq, request3, oLoginSetup, collectionOfStep3TokensByChangedDate, new List<Account>(), new List<Lead>()));
        }
    }

}
