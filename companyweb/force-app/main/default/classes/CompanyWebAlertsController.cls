public class CompanyWebAlertsController {

    @InvocableMethod(label='getAlertsALaCarte' description='Batch job which will check for all updates on monitored companies.')
    public static void invokeGetAlertsALaCarte() {
        System.enqueueJob(new companyWebAlertsQueueable());
    }
}