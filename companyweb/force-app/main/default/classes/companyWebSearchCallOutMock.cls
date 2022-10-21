@isTest
global class companyWebSearchCallOutMock implements WebServiceMock {
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

        connectCompanywebBe.SearchResponseItem cSearchResponseItem = new connectCompanywebBe.SearchResponseItem();
        List<connectCompanywebBe.SearchResponseItem> lSearchResponseItem = new List<connectCompanywebBe.SearchResponseItem>();
        cSearchResponseItem.VatNumber = 35345343;
        cSearchResponseItem.CompanyName = 'Test LLC';
        cSearchResponseItem.Street = 'Rua Macaca';
        cSearchResponseItem.City = 'Lisbon';
        cSearchResponseItem.IsActive = true;
       
        lSearchResponseItem.add(cSearchResponseItem);
        connectCompanywebBe.ArrayOfSearchResponseItem cArrayOfSearchResponseItem = new connectCompanywebBe.ArrayOfSearchResponseItem();
        cArrayOfSearchResponseItem.SearchResponseItem = lSearchResponseItem;
        connectCompanywebBe.ResponseSearch submain = new  connectCompanywebBe.ResponseSearch();
        submain.SearchResponseList = cArrayOfSearchResponseItem;
        submain.StatusCode = 0;
        submain.StatusMessage = ''; 
        
        main.SearchCompaniesResult = subMain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main); 
        
   }
}