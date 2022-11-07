public class companyWebAlertsQueueable implements Queueable, Database.AllowsCallouts {

    private Integer changeDate {get;set;}
    private Map<Integer, String> mapOfStep2Token {get; set;}
    private String loginHash {get; set;}
    private connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq {get; set;}
    private connectCompanywebBe.RequestStep3_CompanyOnVat request {get; set;}
    private CW_Login_Setup__mdt oLoginSetup {get; set;}
    private Map<Integer,String> mapOfStep3Token {get; set;}
    private List<Account> listOfAccountsToUpdate = new List<Account>();
    private List<Lead> listOfLeadsToUpdate = new List<Lead>();    

    public companyWebAlertsQueueable(Integer changeDate, Map<Integer, String> mapOfStep2Token, String loginHash, connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq, CW_Login_Setup__mdt oLoginSetup){
        this.changeDate = changeDate;
        this.mapOfStep2Token = mapOfStep2Token;
        this.loginHash = loginHash;
        this.httpreq = httpreq;
        this.oLoginSetup = oLoginSetup;  
    }

    public companyWebAlertsQueueable(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq, connectCompanywebBe.RequestStep3_CompanyOnVat request, CW_Login_Setup__mdt oLoginSetup, Map<Integer, String> mapOfStep3Token) {
        this.httpreq = httpreq;
        this.request = request;
        this.oLoginSetup = oLoginSetup;
        this.mapOfStep3Token = mapOfStep3Token;
    }

    public void execute(QueueableContext context) {
        if(mapOfStep3Token==null){
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
            Map<Integer,String> mapOfStep3TokenExcess = mapOfStep3Token;
            
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
                    connectCompanywebBe.CompanyResponseV1_3 companyData;
                    if(Limits.getCallouts()<100){
                        companyData = CompanyWebController.getCompanyData(httpreq, request3);
                        mapOfStep3TokenExcess.remove(vatNumber);
                    } else {
                        DateTime nextRunTime = DateTime.now().addMinutes(2);
                        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                        System.schedule(companyWebScheduledAlerts.class.getName() + '-' + nextRunTime.format(), cronString, new companyWebScheduledAlerts(httpreq, request, oLoginSetup, mapOfStep3TokenExcess));
                        //System.enqueueJob(new companyWebAlertsQueueable(httpreq, request3, oLoginSetup, mapOfStep3TokenExcess));
                        break;
                    }
                    if(companyData!=null && companyData?.VatNumber?.IsEnabled){
                        System.debug('companyData.VatNumber.Value : ' + companyData.VatNumber.Value);
                        CompanyWebController.updateCompanyByResponse(oLoginSetup, companyData, listOfAccountsToUpdate, listOfLeadsToUpdate);
                    } else {
                        System.debug('vatnumber is disabled, won\'t update the company');
                    }
                }
            }
            if(listOfAccountsToUpdate.size()>0 || listOfLeadsToUpdate.size()>0){
                CompanyWebController.updateCompanyOperation(listOfAccountsToUpdate, listOfLeadsToUpdate);
            }
        } else {
            if(!mapOfStep3Token.isEmpty()){
                Map<Integer,String> mapOfStep3TokenExcess = mapOfStep3Token;
                for(Integer vatNumber : mapOfStep3Token.keySet()){
                    request.Step3Token = mapOfStep3Token.get(vatNumber);
                    request.VatNumber = String.valueOf(vatNumber);

                    connectCompanywebBe.CompanyResponseV1_3 companyData;
                    if(Limits.getCallouts()<100){
                        companyData = CompanyWebController.getCompanyData(httpreq, request3);
                        mapOfStep3TokenExcess.remove(vatNumber);
                    } else {
                        DateTime nextRunTime = DateTime.now().addMinutes(2);
                        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                        System.schedule(companyWebScheduledAlerts.class.getName() + '-' + nextRunTime.format(), cronString, new companyWebScheduledAlerts(httpreq, request, oLoginSetup, mapOfStep3TokenExcess));
                        //System.enqueueJob(new companyWebAlertsQueueable(httpreq, request3, oLoginSetup, mapOfStep3TokenExcess));
                        break;
                    }

                    if(companyData!=null && companyData?.VatNumber?.IsEnabled){
                        System.debug('companyData.VatNumber.Value : ' + companyData.VatNumber.Value);
                        CompanyWebController.updateCompanyByResponse(oLoginSetup, companyData, listOfAccountsToUpdate, listOfLeadsToUpdate);
                    } else {
                        System.debug('vatnumber is disabled, won\'t update the company');
                    }
                }
                if(listOfAccountsToUpdate.size()>0 || listOfLeadsToUpdate.size()>0){
                    CompanyWebController.updateCompanyOperation(listOfAccountsToUpdate, listOfLeadsToUpdate);
                }
            }
        }
    }
}
