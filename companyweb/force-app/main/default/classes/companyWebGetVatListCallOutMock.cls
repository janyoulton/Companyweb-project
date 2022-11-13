@isTest
global class companyWebGetVatListCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.Alerts_Step2_GetVatListResponse_element main = new connectCompanywebBe.Alerts_Step2_GetVatListResponse_element();

        connectCompanywebBe.ResponseStep2 submain = new connectCompanywebBe.ResponseStep2();
        submain.StatusCode = 0;
        submain.StatusMessage = '';
        
        connectCompanywebBe.ArrayOfChangedVat arrayOfChangedVat = new connectCompanywebBe.ArrayOfChangedVat();       
        connectCompanywebBe.ChangedVat changedVat = new connectCompanywebBe.ChangedVat();
        changedVat.DateOfChange = 20221113;
        changedVat.VatNumber = 869703978;
        changedVat.Step3Token = 'tokenofnumbersandletters';
        arrayOfChangedVat.changedVat = new List<connectCompanywebBe.ChangedVat>{ changedVat };

        submain.ChangedVatList = arrayOfChangedVat;
        
        main.Alerts_Step2_GetVatListResult = submain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main);  
   }
}