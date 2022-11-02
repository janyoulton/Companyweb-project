public class companyWebAlertsBatch implements Queueable, Database.AllowsCallouts {

    private Integer changeDate {get;set;}
    private Map<Integer, String> mapOfStep2Token {get; set;}
    private String loginHash {get; set;}
    connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq {get; set;}
    private CW_Login_Setup__mdt oLoginSetup {get; set;}
    private List<Account> listOfAccountsToUpdate {get; set;}
    private List<Lead> listOfLeadsToUpdate {get; set;}

    public companyWebAlertsBatch(Integer changeDate, Map<Integer, String> mapOfStep2Token, String loginHash, connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq, CW_Login_Setup__mdt oLoginSetup){
        this.changeDate = changeDate;
        this.mapOfStep2Token = mapOfStep2Token;
        this.loginHash = loginHash;
        this.httpreq = httpreq;
        this.oLoginSetup = oLoginSetup;
        listOfAccountsToUpdate = new List<Account>();
        listOfLeadsToUpdate = new List<Lead>();    
    }

    public void execute(QueueableContext context) {
        connectCompanywebBe.RequestStep2 request2 = new connectCompanywebBe.RequestStep2();
        request2.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request2.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request2.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request2.LoginHash = loginHash;
        request2.ChangedDate = changeDate;
        request2.Step2Token = mapOfStep2Token.get(changeDate);

        //Step 2: get Vat List
        Map<Integer,String> mapOfStep3Token = CompanyWebController.getVatList(httpreq, request2);
        System.debug(mapOfStep3Token);
        
        if(!mapOfStep3Token.isEmpty()){
            for(Integer vatNumber : mapOfStep3Token.keySet()){
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
                request3.LoginHash = loginHash;
                request3.ChangedDate = changeDate;
                request3.VatNumber = String.valueOf(vatNumber);
                request3.Step3Token = mapOfStep3Token.get(vatNumber);

                //Step 3: get Company Data
                connectCompanywebBe.CompanyResponseV1_3 companyData = CompanyWebController.getCompanyData(httpreq, request3);
                if(companyData!=null && companyData?.VatNumber?.IsEnabled){
                    System.debug('companyData.VatNumber.Value : ' + companyData.VatNumber.Value);
                    CompanyWebController.updateCompanyByResponse(oLoginSetup, companyData, listOfAccountsToUpdate, listOfLeadsToUpdate);
                } else {
                    System.debug('vatnumber is disabled, won\'t update the company');
                }
            }
        }
        CompanyWebController.updateCompanyOperation(listOfAccountsToUpdate, listOfLeadsToUpdate);
    }
}
