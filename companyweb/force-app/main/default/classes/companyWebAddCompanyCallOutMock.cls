@isTest
global class companyWebAddCompanyCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.Alerts_AddCompanyResponse_element main = new connectCompanywebBe.Alerts_AddCompanyResponse_element();

        connectCompanywebBe.ResponseAddToAlerts submain = new connectCompanywebBe.ResponseAddToAlerts();
        submain.StatusCode = 0;
        submain.StatusMessage = '';
        
        main.Alerts_AddCompanyResult = submain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main);  
   }
}