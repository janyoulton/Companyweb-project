@isTest
global class companyWebNegativeCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.GetCompanyByVatResponse_element main = new connectCompanywebBe.GetCompanyByVatResponse_element();
        connectCompanywebBe.ResponseCompanyByVatV1_5 subMain = new connectCompanywebBe.ResponseCompanyByVatV1_5 ();
        connectCompanywebBe.Status cStatus =  new connectCompanywebBe.Status();
        cStatus.Code = 306;
        subMain.StatusCode = cStatus.Code;
        subMain.StatusMessage = 'The parameter "VatNumber" is not a valid belgian vatnumber or empty.';
        connectCompanywebBe.CompanyResponseV1_5 subMain2 = new connectCompanywebBe.CompanyResponseV1_5 ();
        
        //Construction of the structure
        subMain.CompanyResponse = subMain2;
        main.GetCompanyByVatResult = subMain;
        
        // end
        system.debug('MAin '+ main);
        system.debug('JSON: ' + JSON.serialize(main));
        response.put('response_x', main); 
        
   }
}