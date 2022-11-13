@isTest
global class companyWebAddCompanyListCallOutMock implements WebServiceMock {
    global void doInvoke(
                Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) 
        {
        // structure constructed by multiple functions
        connectCompanywebBe.Alerts_AddListOfCompaniesResponse_element main = new connectCompanywebBe.Alerts_AddListOfCompaniesResponse_element();

        connectCompanywebBe.ResponseAddListToAlerts submain = new connectCompanywebBe.ResponseAddListToAlerts();
        submain.Count_ActiveAlerts = 10;
        submain.Count_Adds = 1;
        submain.Count_Updates = 1;
        submain.Count_Invalids = 0;
        submain.StatusCode = 0;
        submain.StatusMessage = '';
        
        main.Alerts_AddListOfCompaniesResult = submain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main);  
   }
}