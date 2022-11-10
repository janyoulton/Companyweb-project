public class companyWebCompanyByVATQueueable implements Queueable, Database.AllowsCallouts {

    private String loginHash {get; set;}
    private connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq {get; set;}
    private connectCompanywebBe.RequestStep3_CompanyOnVat request {get; set;}
    private CW_Login_Setup__mdt oLoginSetup {get; set;}
    private Map<Integer,Map<Integer,String>> collectionOfStep3TokensByChangedDate {get; set;}
    private List<Account> listOfAccountsToUpdate {get; set;}
    private List<Lead> listOfLeadsToUpdate {get; set;}

    public companyWebCompanyByVATQueueable(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq, connectCompanywebBe.RequestStep3_CompanyOnVat request, CW_Login_Setup__mdt oLoginSetup, Map<Integer, Map<Integer,String>> collectionOfStep3TokensByChangedDate, List<Account> listOfAccountsToUpdate, List<Lead> listOfLeadsToUpdate) {
        this.httpreq = httpreq;
        this.request = request;
        this.oLoginSetup = oLoginSetup;
        this.collectionOfStep3TokensByChangedDate = collectionOfStep3TokensByChangedDate;
        this.listOfAccountsToUpdate = listOfAccountsToUpdate;
        this.listOfLeadsToUpdate = listOfLeadsToUpdate;
    }

    public void execute(QueueableContext context) {
        System.debug('CompanyByVAT queueable job');
        Map<Integer,Map<Integer,String>> collectionForNextQueueableJob = collectionOfStep3TokensByChangedDate;
        Boolean chainJob = false;

        for(Integer changedDate : collectionOfStep3TokensByChangedDate.keySet()){
            Map<Integer, String> mapOfStep3Token = collectionOfStep3TokensByChangedDate.get(changedDate);
            if(chainJob){
                break;
            }

            request.ChangedDate = changedDate;
            for(Integer vatNumber : mapOfStep3Token.keySet()){
                request.Step3Token = mapOfStep3Token.get(vatNumber);
                request.VatNumber = String.valueOf(vatNumber);

                connectCompanywebBe.CompanyResponseV1_5 companyData;
                if(Limits.getCallouts() < Limits.getLimitCallouts()){
                    companyData = CompanyWebController.getCompanyData(httpreq, request);
                    collectionForNextQueueableJob.remove(changedDate);
                } else {
                    System.debug('exceeded Callouts limit');
                    chainJob = true;
                    break;
                    // DateTime nextRunTime = DateTime.now().addMinutes(2);
                    // String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                    //     nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                    //     nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                    // System.schedule(companyWebScheduledAlerts.class.getName() + '-' + nextRunTime.format(), cronString, new companyWebScheduledAlerts(httpreq, request, oLoginSetup, mapOfStep3TokenExcess));
                    // break;
                }

                if(companyData!=null && companyData?.VatNumber?.IsEnabled){
                    System.debug('companyData.VatNumber.Value : ' + companyData.VatNumber.Value);
                    CompanyWebController.updateCompanyByResponse(oLoginSetup, companyData, listOfAccountsToUpdate, listOfLeadsToUpdate);
                } else {
                    System.debug('vatnumber is disabled, won\'t update the company');
                }
            }
        }

        if(chainJob){
            System.enqueueJob(new companyWebCompanyByVATQueueable(httpreq, request, oLoginSetup, collectionForNextQueueableJob, listOfAccountsToUpdate, listOfLeadsToUpdate));
        }

        if(listOfAccountsToUpdate.size()>0 || listOfLeadsToUpdate.size()>0){
            CompanyWebController.updateCompanyOperation(listOfAccountsToUpdate, listOfLeadsToUpdate);
        }  
    }

}
