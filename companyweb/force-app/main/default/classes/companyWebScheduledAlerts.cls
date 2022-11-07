global class companyWebScheduledAlerts implements Schedulable, Database.AllowsCallouts {
    private connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq {get; set;}
    private connectCompanywebBe.RequestStep3_CompanyOnVat request {get; set;}
    private CW_Login_Setup__mdt oLoginSetup {get; set;}
    private Map<Integer,String> mapOfStep3Token {get; set;}

    public companyWebScheduledAlerts(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_3 httpreq, connectCompanywebBe.RequestStep3_CompanyOnVat request, CW_Login_Setup__mdt oLoginSetup, Map<Integer, String> mapOfStep3Token) {
        this.httpreq = httpreq;
        this.request = request;
        this.oLoginSetup = oLoginSetup;
        this.mapOfStep3Token = mapOfStep3Token;
    }

    public void execute(SchedulableContext sc) {
        System.enqueueJob(new companyWebAlertsQueueable(httpreq, request, oLoginSetup, mapOfStep3Token));
        Id jobId = sc.getTriggerId();
        System.abortJob(jobId);
    }
}