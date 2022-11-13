@isTest
global class companyWebGetChangedDatesCallOutMock implements WebServiceMock {
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
        connectCompanywebBe.Alerts_Step1_GetChangeDatesResponse_element main = new connectCompanywebBe.Alerts_Step1_GetChangeDatesResponse_element();

        connectCompanywebBe.ResponseStep1 submain = new connectCompanywebBe.ResponseStep1();
        submain.StatusCode = 0;
        submain.StatusMessage = '';
        
        connectCompanywebBe.ArrayOfChangeDate arrayOfChangedDates = new connectCompanywebBe.ArrayOfChangeDate();       
        connectCompanywebBe.ChangeDate changeDate = new connectCompanywebBe.ChangeDate();
        changeDate.DateOfChange = 20221113;
        changeDate.NumberOfChanges = 2;
        changeDate.Step2Token = 'tokenofnumbersandletters';
        arrayOfChangedDates.ChangeDate = new List<connectCompanywebBe.ChangeDate>{ changeDate };

        submain.ChangeDates = arrayOfChangedDates;
        
        main.Alerts_Step1_GetChangeDatesResult = submain;
        
        // end
        system.debug('Main Response '+ main);
        response.put('response_x', main);  
   }
}