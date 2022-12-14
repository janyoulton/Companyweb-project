@isTest
global class companyWebCallOutMock implements WebServiceMock {
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
        system.debug('response main: '+ main);
        connectCompanywebBe.ResponseCompanyByVatV1_5 subMain = new connectCompanywebBe.ResponseCompanyByVatV1_5 ();
        system.debug('response subMain: '+ subMain);
        connectCompanywebBe.Status cStatus =  new connectCompanywebBe.Status();
        cStatus.Code = 0;
        subMain.StatusCode = cStatus.Code;
        system.debug('response cStatus: ' + cStatus);
        connectCompanywebBe.CompanyResponseV1_5 subMain2 = new connectCompanywebBe.CompanyResponseV1_5 ();
        system.debug('response subMain2: '+subMain2);
        //connectCompanywebBe.CompanyResponseMetaData cMetaData = new connectCompanywebBe.CompanyResponseMetaData();

        connectCompanywebBe.PreferredLanguages cPreferredLanguages = new connectCompanywebBe.PreferredLanguages();
    
        cPreferredLanguages.LanguageString = 'NL';
        connectCompanywebBe.PreferredLanguagesResponseFragment cPreferredLanguagesResponseFragment = new connectCompanywebBe.PreferredLanguagesResponseFragment();
        cPreferredLanguagesResponseFragment.Value = cPreferredLanguages;
        cPreferredLanguagesResponseFragment.IsEnabled = true;

        connectCompanywebBe.StringResponseFragment cCommercialName = new connectCompanywebBe.StringResponseFragment();
        connectCompanywebBe.StringResponseFragment cShortName = new  connectCompanywebBe.StringResponseFragment();
        connectCompanywebBe.Address ccAddress = new connectCompanywebBe.Address();
        ccAddress.Street = 'Rua Macaca';
        ccAddress.PostalCode = '2020';
        ccAddress.City = 'Sitio da Cuca'; 
        ccAddress.CountryCode = 'BE';
        connectCompanywebBe.AddressResponseFragment cAddress= new connectCompanywebBe.AddressResponseFragment();
        cAddress.value = ccAddress;
        cAddress.IsEnabled = true;
        system.debug('response Address: '+cAddress);
        connectCompanywebBe.IntegerResponseFragment cVatNumber = new connectCompanywebBe.IntegerResponseFragment();
        cVatNumber.Value = 35345343; 
        cVatNumber.IsEnabled = true;
        system.debug('response VatNumber: '+cVatNumber);
        connectCompanywebBe.BooleanResponseFragment cVatEnabled = new connectCompanywebBe.BooleanResponseFragment();
        cVatEnabled.IsEnabled = true;
        cVatEnabled.Value = true;
        system.debug('response VatEnabled: '+cVatEnabled);
        connectCompanywebBe.StringResponseFragment cTelephoneNumber = new connectCompanywebBe.StringResponseFragment();
        cTelephoneNumber.IsEnabled = true;
        cTelephoneNumber.Value = '13124141';
        system.debug('response TelephoneNumber: '+cTelephoneNumber);
        connectCompanywebBe.StringResponseFragment cCompanyName = new connectCompanywebBe.StringResponseFragment();
        cCompanyName.IsEnabled = true;
        cCompanyName.Value = 'Cenas LLC';
        connectCompanywebBe.LegalForm ccLegalForm = new  connectCompanywebBe.LegalForm();
        ccLegalForm.Abbreviation = 'NV';
        connectCompanywebBe.LegalFormResponseFragment cLegalForm = new connectCompanywebBe.LegalFormResponseFragment();
        cLegalForm.IsEnabled = true;
        cLegalForm.Value = ccLegalForm;
        system.debug('response LegalForm: '+cLegalForm);
        connectCompanywebBe.IntegerResponseFragment cStartDate = new connectCompanywebBe.IntegerResponseFragment();
        cStartDate.IsEnabled = true;
        cStartDate.Value = 20050512;
        connectCompanywebBe.IntegerResponseFragment cEndDate = new connectCompanywebBe.IntegerResponseFragment();
        cEndDate.IsEnabled = true;
        cEndDate.Value = 20100512;

        connectCompanywebBe.PaymentExperience cPaymentExperience = new connectCompanywebBe.PaymentExperience();
        connectCompanywebBe.PaymentExperienceResponseFragment cPaymentExperienceResponseFragment = new connectCompanywebBe.PaymentExperienceResponseFragment();
        cPaymentExperienceResponseFragment.Value = cPaymentExperience;

  
        connectCompanywebBe.Management cstring_x = new connectCompanywebBe.Management();
        List<connectCompanywebBe.Management> lstring_x = new List<connectCompanywebBe.Management>();
        lstring_x.add(cstring_x);
        connectCompanywebBe.ArrayOfString cArrayOfString= new connectCompanywebBe.ArrayOfString();
        connectCompanywebBe.WarningsOverview cWarningsOverview  = new connectCompanywebBe.WarningsOverview();
        cWarningsOverview.Warnings = cArrayOfString;
        connectCompanywebBe.WarningsOverviewResponseFragment cWarningsOverviewResponseFragment = new connectCompanywebBe.WarningsOverviewResponseFragment();
        cWarningsOverviewResponseFragment.IsEnabled = true;
        cWarningsOverviewResponseFragment.Value = cWarningsOverview;
        
        connectCompanywebBe.Management cManagement= new connectCompanywebBe.Management();
        connectCompanywebBe.ManagementV1_5 cManagementV1_5= new connectCompanywebBe.ManagementV1_5();
        List<connectCompanywebBe.Management> lManagement = new List<connectCompanywebBe.Management>();
        List<connectCompanywebBe.ManagementV1_5> lManagementV1_5 = new List<connectCompanywebBe.ManagementV1_5>();
        lManagement.add(cManagement);
        lManagementV1_5.add(cManagementV1_5);
        connectCompanywebBe.ArrayOfManagement cArrayOfManagement= new connectCompanywebBe.ArrayOfManagement();
        connectCompanywebBe.ArrayOfManagementV1_5 cArrayOfManagementV1_5 = new connectCompanywebBe.ArrayOfManagementV1_5();
        cArrayOfManagement.Management = lManagement;
        cArrayOfManagementV1_5.ManagementV1_5 = lManagementV1_5;
        connectCompanywebBe.ManagementList cManagementList = new connectCompanywebBe.ManagementList();
        cManagementList.Management = cArrayOfManagementV1_5;
        connectCompanywebBe.ManagementListResponseFragmentV1_5 cCurrentManagementListResponseFragment = new connectCompanywebBe.ManagementListResponseFragmentV1_5();
        connectCompanywebBe.ManagementListResponseFragment cExternalManagementListResponseFragment = new connectCompanywebBe.ManagementListResponseFragment();
        cCurrentManagementListResponseFragment.Value = cManagementList;
        cExternalManagementListResponseFragment.Value = cArrayOfManagement;
        cCurrentManagementListResponseFragment.IsEnabled = true;
         
        connectCompanywebBe.ActivityV1_1 cActivityV1_12 = new  connectCompanywebBe.ActivityV1_1();
        connectCompanywebBe.ActivityResponseFragmentV1_1 cMainActivity = new connectCompanywebBe.ActivityResponseFragmentV1_1();
        cMainActivity.Value = cActivityV1_12;
        cMainActivity.IsEnabled = true;
        
        connectCompanywebBe.ActivityV1_1 cActivityV1_1= new connectCompanywebBe.ActivityV1_1();
        List<connectCompanywebBe.ActivityV1_1> lEActivityV1_1 = new List<connectCompanywebBe.ActivityV1_1>();
        lEActivityV1_1.add(cActivityV1_1);
        connectCompanywebBe.ArrayOfActivityV1_1 cArrayOfActivityV1_1 = new connectCompanywebBe.ArrayOfActivityV1_1();
        cArrayOfActivityV1_1.ActivityV1_1= lEActivityV1_1;
        connectCompanywebBe.ActivityListResponseFragmentV1_1 cActivities = new connectCompanywebBe.ActivityListResponseFragmentV1_1();
        cActivities.Value = cArrayOfActivityV1_1;
        cActivities.IsEnabled = true;

        connectCompanywebBe.EstablishmentV1_1 cEstablishmentV1_1= new connectCompanywebBe.EstablishmentV1_1();
        List<connectCompanywebBe.EstablishmentV1_1> lEstablishmentV1_1 = new List<connectCompanywebBe.EstablishmentV1_1>();
        lEstablishmentV1_1.add(cEstablishmentV1_1);
        connectCompanywebBe.ArrayOfEstablishmentV1_1 cArrayOfEstablishmentV1_1 = new connectCompanywebBe.ArrayOfEstablishmentV1_1();
        cArrayOfEstablishmentV1_1.EstablishmentV1_1 =lEstablishmentV1_1; 
        connectCompanywebBe.EstablishmentsListResponseFragmentV1_1 cEstablishments= new connectCompanywebBe.EstablishmentsListResponseFragmentV1_1();
        cEstablishments.Value = cArrayOfEstablishmentV1_1;
        
        connectCompanywebBe.JointCommitee cJointCommitee = new connectCompanywebBe.JointCommitee();
        cJointCommitee.Code = 200;
        cJointCommitee.Description = 'test description jointcommitee';    
        List<connectCompanywebBe.JointCommitee> lJointCommitee = new List<connectCompanywebBe.JointCommitee>();
        lJointCommitee.add(cJointCommitee);
        connectCompanywebBe.ArrayOfJointCommitee cArrayOfJointCommitee =new connectCompanywebBe.ArrayOfJointCommitee();
        cArrayOfJointCommitee.JointCommitee = lJointCommitee;
        connectCompanywebBe.JointCommiteesListResponseFragment cJointCommiteesListResponseFragment = new connectCompanywebBe.JointCommiteesListResponseFragment();
        cJointCommiteesListResponseFragment.IsEnabled = true;
        cJointCommiteesListResponseFragment.Value=cArrayOfJointCommitee;

        connectCompanywebBe.SocialSecurityInformation cSocialSecurityInformation = new connectCompanywebBe.SocialSecurityInformation();
        cSocialSecurityInformation.RegistrationId = '01234-56789';
        connectCompanywebBe.SocialSecurityResponseFragment SocialSecurityResponseFragment = new connectCompanywebBe.SocialSecurityResponseFragment();
        SocialSecurityResponseFragment.Value = cSocialSecurityInformation;
        SocialSecurityResponseFragment.IsEnabled = true;

        connectCompanywebBe.Participation cParticipation = new connectCompanywebBe.Participation();
        List<connectCompanywebBe.Participation> lParticipation = new List<connectCompanywebBe.Participation>();
        lParticipation.add(cParticipation);
        connectCompanywebBe.ArrayOfParticipation cArrayOfParticipation = new connectCompanywebBe.ArrayOfParticipation();
        cArrayOfParticipation.Participation = lParticipation;
        connectCompanywebBe.ParticipationsListResponseFragment cParentCompanies = new connectCompanywebBe.ParticipationsListResponseFragment();
        connectCompanywebBe.ParticipationsListResponseFragment cSubsidiaryCompanies = new connectCompanywebBe.ParticipationsListResponseFragment() ;
        cParentCompanies.Value = cArrayOfParticipation;
        cSubsidiaryCompanies.Value = cArrayOfParticipation;

        connectCompanywebBe.RszPublication cRszPublication  = new connectCompanywebBe.RszPublication();
        List<connectCompanywebBe.RszPublication> lRszPublication = new List<connectCompanywebBe.RszPublication>();
        lRszPublication.add(cRszPublication);
        connectCompanywebBe.ArrayOfRszPublication cArrayOfRszPublication = new connectCompanywebBe.ArrayOfRszPublication();
        cArrayOfRszPublication.RszPublication = lRszPublication;
        connectCompanywebBe.SocialSecuritySummonsListResponseFragment cSocialSecuritySummons = new connectCompanywebBe.SocialSecuritySummonsListResponseFragment() ;
        cSocialSecuritySummons.VAlue= cArrayOfRszPublication;


        connectCompanywebBe.JudicialAgreement cJudicialAgreement = new connectCompanywebBe.JudicialAgreement();
        List<connectCompanywebBe.JudicialAgreement> lJudicialAgreement = new List<connectCompanywebBe.JudicialAgreement>();
        lJudicialAgreement.add(cJudicialAgreement);
        connectCompanywebBe.ArrayOfJudicialAgreement cArrayOfJudicialAgreement = new connectCompanywebBe.ArrayOfJudicialAgreement(); 
        cArrayOfJudicialAgreement.JudicialAgreement = lJudicialAgreement;
        connectCompanywebBe.JudicialAgreementsListResponseFragment cJudicialAgreements = new connectCompanywebBe.JudicialAgreementsListResponseFragment();
        cJudicialAgreements.Value = cArrayOfJudicialAgreement;

        connectCompanywebBe.Curator cCurator = new connectCompanywebBe.Curator();
        List<connectCompanywebBe.Curator> lCurator = new List<connectCompanywebBe.Curator>();
        lCurator.add(cCurator);
        connectCompanywebBe.ArrayOfCurator cArrayOfCurator = new connectCompanywebBe.ArrayOfCurator();
        cArrayOfCurator.Curator = lCurator;
        connectCompanywebBe.CuratorListResponseFragment cCurators = new connectCompanywebBe.CuratorListResponseFragment();
        cCurators.Value = cArrayOfCurator;

        connectCompanywebBe.BankrupcyPublication cBankrupcyPublication  = new connectCompanywebBe.BankrupcyPublication();
        connectCompanywebBe.BankruptcyResponseFragment cBankruptcyOpen = new connectCompanywebBe.BankruptcyResponseFragment();
        cBankruptcyOpen.Value = cBankrupcyPublication;
        connectCompanywebBe.BankruptcyResponseFragment cBankruptcyClose = new connectCompanywebBe.BankruptcyResponseFragment();
        cBankruptcyClose.Value= cBankrupcyPublication;

        connectCompanywebBe.StringResponseFragment cCustomReportUrl = new  connectCompanywebBe.StringResponseFragment();
        connectCompanywebBe.StringResponseFragment cBalanceUrl = new connectCompanywebBe.StringResponseFragment();

        connectCompanywebBe.Publication cPublication = new connectCompanywebBe.Publication();
        cPublication.Id = 1;
        List<connectCompanywebBe.Publication> lPublication = new List<connectCompanywebBe.Publication>();
        lPublication.add(cPublication);  
        connectCompanywebBe.ArrayOfPublication cArrayOfPublication = new  connectCompanywebBe.ArrayOfPublication();
        cArrayOfPublication.Publication= lPublication;

        connectCompanywebBe.PublicationsListResponseFragment cPublications = new connectCompanywebBe.PublicationsListResponseFragment();
        cPublications.Value = cArrayOfPublication;

        connectCompanywebBe.KycLinkedEntities cKycLinkedEntities = new connectCompanywebBe.KycLinkedEntities();
        connectCompanywebBe.KycLinkedEntitiesResponseFragment cKycLinkedEntitiesResponseFragment = new connectCompanywebBe.KycLinkedEntitiesResponseFragment();
        cKycLinkedEntitiesResponseFragment.Value= cKycLinkedEntities;

        connectCompanywebBe.StringResponseFragment cKycReportUrl = new connectCompanywebBe.StringResponseFragment();
        cKycReportUrl.IsEnabled = true;
        cKycReportUrl.Value = '';
        connectCompanywebBe.Status ccStatus =  new connectCompanywebBe.Status();
        ccStatus.info = 'Active';
        connectCompanywebBe.CompanyStatusResponseFragment cCompanyStatus = new  connectCompanywebBe.CompanyStatusResponseFragment();
        cCompanyStatus.Value = ccStatus;
        cCompanyStatus.IsEnabled = true;
        system.debug('response CompanyStatus: '+cCompanyStatus);
        connectCompanywebBe.Score ccScore = new  connectCompanywebBe.Score();
        ccScore.ScoreAsDecimal = 1.4;
        ccScore.ScoreImage = 'pos-14.png';
        system.debug('response Score: '+ccScore);
        connectCompanywebBe.ScoreResponseFragment cScore = new  connectCompanywebBe.ScoreResponseFragment();
        cScore.Value = ccScore;
        cScore.IsEnabled = true;
        system.debug('response Score: '+cScore);
        connectCompanywebBe.CreditLimit ccCreditLimit = new connectCompanywebBe.CreditLimit();
        ccCreditLimit.Limit_x = 1232132;
        connectCompanywebBe.CreditLimitResponseFragment cCreditLimit = new connectCompanywebBe.CreditLimitResponseFragment();
        cCreditLimit.IsEnabled = true;
        cCreditLimit.Value = ccCreditLimit;
        system.debug('response CreditLimit: '+cCreditLimit);
        connectCompanywebBe.StringResponseFragment cDetailUrl = new connectCompanywebBe.StringResponseFragment();
        cDetailUrl.Value = '';
        cDetailUrl.IsEnabled = true;
        system.debug('response DetailUrl: '+cDetailUrl);
        connectCompanywebBe.StringResponseFragment cReportUrl = new connectCompanywebBe.StringResponseFragment();
        cReportUrl.Value= '';
        cReportUrl.IsEnabled = true;
    
        
        connectCompanywebBe.BalansData sBalansData1 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData2 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData3 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData4 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData5 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData6 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData7 = new  connectCompanywebBe.BalansData();
        connectCompanywebBe.BalansData sBalansData8 = new  connectCompanywebBe.BalansData();
        List<connectCompanywebBe.BalansData> lBalansData = new List<connectCompanywebBe.BalansData>();
        sBalansData1.Key ='CloseDate';
        sBalansData1.Value = '2019-12-31';
        lBalansData.add(sBalansData1); 
        sBalansData2.Key ='Rub10_15';
        sBalansData2.Value = '6130735';
        lBalansData.add(sBalansData2);
        sBalansData3.Key ='Rub70';
        sBalansData3.Value = '12885587';
        lBalansData.add(sBalansData3);
        sBalansData4.Key ='Rub9087';
        sBalansData4.Value = '84.9';
        lBalansData.add(sBalansData4);
        sBalansData5.Key ='Rub9800';
        sBalansData5.Value = '5911679';
        lBalansData.add(sBalansData5);
        sBalansData6.Key ='Rub9904';
        sBalansData6.Value = '641532';
        lBalansData.add(sBalansData6);
        sBalansData7.Key = 'Rub1323';
        sBalansData7.Value = '123';
        lBalansData.add(sBalansData7);
        sBalansData8.Key = 'Rub1343';
        sBalansData8.Value = '124';
        lBalansData.add(sBalansData8);
      

        connectCompanywebBe.ArrayOfBalansData cArrayOfBalansData = new connectCompanywebBe.ArrayOfBalansData();
        cArrayOfBalansData.BalansData = lBalansData;

        connectCompanywebBe.Balans cBalans = new connectCompanywebBe.Balans();
        List<connectCompanywebBe.Balans> lBalans = new List<connectCompanywebBe.Balans>();
        cBalans.BookYear = 2019;
        cBalans.BalansData = cArrayOfBalansData;
        lBalans.add(cBalans);

        connectCompanywebBe.ArrayOfBalans cArrayOfBalans = new connectCompanywebBe.ArrayOfBalans();
        cArrayOfBalans.Balans= lBalans;

        connectCompanywebBe.BookYearListResponseFragment cBookYearListResponseFragment  = new connectCompanywebBe.BookYearListResponseFragment();
        cBookYearListResponseFragment.Value = cArrayOfBalans;
        cBookYearListResponseFragment.IsEnabled = true;
        system.debug('response Balances: '+cBookYearListResponseFragment);
        
        //Costruction of the structure 
        //aArrayOfBalans[0].Balans[0].BalansData[0] 
       // cBalances.Value = aArrayOfBalans;
        subMain2.Balances=cBookYearListResponseFragment;
        subMain2.ReportUrl=cReportUrl;
        subMain2.DetailUrl=cDetailUrl;
        subMain2.CreditLimit=cCreditLimit;
        subMain2.Score=cScore;
        subMain2.CompanyStatus=cCompanyStatus;
        subMain2.LegalForm = cLegalForm;
        subMain2.TelephoneNumber = cTelephoneNumber;
        subMain2.CompanyName=cCompanyName;
        subMain2.VatEnabled = cVatEnabled;
        subMain2.VatNumber = cVatNumber;
        subMain2.Address = cAddress;
        subMain2.ShortName = cShortName;
        subMain2.CustomReportUrl= cCustomReportUrl;
        subMain2.BalanceUrl = cBalanceUrl;
        subMain2.Publications= cPublications;
        subMain2.KycLinkedEntities = cKycLinkedEntitiesResponseFragment;
        subMain2.KycReportUrl = cKycReportUrl;
        subMain2.EndDate = cEndDate;
        subMain2.StartDate = cStartDate;
        subMain2.PaymentExperience = cPaymentExperienceResponseFragment;
        subMain2.WarningsOverview = cWarningsOverviewResponseFragment;
        subMain2.CurrentManagement = cCurrentManagementListResponseFragment;
        subMain2.ExternalManagement = cExternalManagementListResponseFragment;
        subMain2.MainActivity = cMainActivity;
        subMain2.Activities = cActivities;
        subMain2.Establishments= cEstablishments;
        subMain2.JointCommitees = cJointCommiteesListResponseFragment;
        subMain2.SocialSecurityInformation = SocialSecurityResponseFragment;
        subMain2.ParentCompanies = cParentCompanies;
        subMain2.SubsidiaryCompanies = cSubsidiaryCompanies;
        subMain2.SocialSecuritySummons = cSocialSecuritySummons;
        subMain2.JudicialAgreements = cJudicialAgreements;
        subMain2.Curators = cCurators;
        subMain2.BankruptcyOpen = cBankruptcyOpen;
        subMain2.BankruptcyClose = cBankruptcyClose;
        subMain2.CommercialName = cCommercialName;
        subMain2.PreferredLanguages=cPreferredLanguagesResponseFragment;
        //subMain2.MetaData = cMetaData;
        subMain.CompanyResponse = subMain2;
        main.GetCompanyByVatResult = subMain;
        
        // end
        system.debug('Main '+ main);
        system.debug('JSON: ' + JSON.serialize(main));

        response.put('response_x', main);
        
   }
}