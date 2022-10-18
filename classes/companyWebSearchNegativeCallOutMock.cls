@isTest
global class companyWebSearchNegativeCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.SearchCompaniesResponse_element main = new connectCompanywebBe.SearchCompaniesResponse_element();
        connectCompanywebBe.ResponseSearch submain = new  connectCompanywebBe.ResponseSearch();
        submain.StatusCode = 307;
        submain.StatusMessage = 'The parameter "SearchTerm" is invalid or empty.'; 
        
        main.SearchCompaniesResult = subMain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main); 
        
   }
}