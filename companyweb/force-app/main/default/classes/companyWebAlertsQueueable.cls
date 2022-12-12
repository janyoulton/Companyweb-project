public class companyWebAlertsQueueable implements Queueable, Database.AllowsCallouts {

    public companyWebAlertsQueueable(){

    }

    public void execute(QueueableContext context) {
        System.debug('initial queueable job');
        List<Account> listOfAccountsToUpdate = new List<Account>();
        List<Lead> listOfLeadsToUpdate = new List<Lead>();

        CW_Login_Setup__mdt oLoginSetup = CompanyWebController.getCurrentVATNumberFields();

        connectCompanywebBe.RequestStep1 request1 = new connectCompanywebBe.RequestStep1();
        request1.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request1.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request1.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request1.LoginHash = companyWebController.createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();

        //Step 1: get Change Dates
        Map<Integer,String> mapOfStep2Token = Test.isRunningTest() ? new Map<Integer,String>() : companyWebController.getChangeDates(httpreq, request1);
        System.debug(mapOfStep2Token);

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

        //Create map to store all Dates and all VAT numbers
        Map<Integer, Integer> tempVatAndDateCollection = new Map<Integer,Integer>();
        //Get the VAT numbers that got updated twice and put them in the Map
        for(Integer changeDate: collectionOfStep3TokensByChangedDate.keySet()){
            for(Integer vatNumber: collectionOfStep3TokensByChangedDate.get(changeDate).keySet()){
                tempVatAndDateCollection.put(vatNumber, changeDate);
            }
        }

        //remove older duplicate VAT Number date values from collectionOfStep3TokensByChangedDate
        for(Integer changeDate: collectionOfStep3TokensByChangedDate.keySet()){
            for(Integer vatNumber: collectionOfStep3TokensByChangedDate.get(changeDate).keySet()){
                if(tempVatAndDateCollection.get(vatNumber) > changeDate){
                    collectionOfStep3TokensByChangedDate.get(changeDate).remove(vatNumber);
                }
            }
        }


        System.debug(collectionOfStep3TokensByChangedDate);
        connectCompanywebBe.RequestStep3_CompanyOnVat request3 = new connectCompanywebBe.RequestStep3_CompanyOnVat();
        request3.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request3.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request3.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request3.LoginHash = request1.LoginHash;
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

        if(!Test.isRunningTest()){
            System.enqueueJob(new companyWebCompanyByVATQueueable(httpreq, request3, oLoginSetup, collectionOfStep3TokensByChangedDate, new List<Account>(), new List<Lead>()));
        }

    }

}