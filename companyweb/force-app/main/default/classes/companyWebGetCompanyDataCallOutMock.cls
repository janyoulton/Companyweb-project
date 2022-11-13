@isTest
global class companyWebGetCompanyDataCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.Alerts_Step3_CompanyOnVatResponse_element main = new connectCompanywebBe.Alerts_Step3_CompanyOnVatResponse_element();

        connectCompanywebBe.ResponseCompanyByVatV1_5 submain = new connectCompanywebBe.ResponseCompanyByVatV1_5();
        submain.StatusCode = 0;
        submain.StatusMessage = '';
        connectCompanywebBe.CompanyResponseV1_5 companyData = new connectCompanywebBe.CompanyResponseV1_5();
        connectCompanywebBe.IntegerResponseFragment vatNumberData = new connectCompanywebBe.IntegerResponseFragment();
        vatNumberData.IsEnabled = true;

        companyData.VatNumber = vatNumberData;
        submain.CompanyResponse = companyData;
        
        main.Alerts_Step3_CompanyOnVatResult = submain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main);  
   }
}