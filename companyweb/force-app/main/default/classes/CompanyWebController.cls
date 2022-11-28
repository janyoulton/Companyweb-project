public with sharing class CompanyWebController {

    //System
    public static Boolean duplicatedCheckOnCreation {get; set;}  
    public static Boolean duplicatedCheckOnRefresh {get; set;} 

    //Account 
    public static String accountVATAPI {get; set;}
    public static String accountScoreAPI {get; set;}
    public static String accountActivitiesAPI {get; set;}
    public static String accountCreditLimitAPI {get; set;}
    public static String accountJointCommitieesBlueAPI {get; set;}
    public static String accountJointCommitieesWhiteAPI {get; set;}
    public static String accountMainActivityAPI {get; set;}
    public static String accountNumberEmployeesAPI {get; set;}
    public static String accountSocialSecurityAPI {get; set;}
    public static String accountLegalFormAPI {get; set;}
    public static String accountPhoneAPI {get; set;}
    public static String accountAnnualRevenueAPI {get; set;}
    public static String accountStreetAPI {get; set;}
    public static String accountPostalCodeAPI {get; set;}
    public static String accountCityAPI {get; set;}
    public static String accountCountryCodeAPI {get; set;}
    public static String accountWorkersAPI {get; set;}
    public static String accountEmployeesAPI {get; set;}

    //Lead
    public static String leadVATAPI {get; set;}
    public static String leadScoreAPI {get; set;}
    public static String leadActivitiesAPI {get; set;}
    public static String leadCreditLimitAPI {get; set;}
    public static String leadJointCommitieesBlueAPI {get; set;}
    public static String leadJointCommitieesWhiteAPI {get; set;}
    public static String leadMainActivityAPI {get; set;}
    public static String leadNumberEmployeesAPI {get; set;}
    public static String leadSocialSecurityAPI {get; set;}
    public static String leadLegalFormAPI {get; set;}
    public static String leadPhoneAPI {get; set;}
    public static String leadAnnualRevenueAPI {get; set;}
    public static String leadStreetAPI {get; set;}
    public static String leadPostalCodeAPI {get; set;}
    public static String leadCityAPI {get; set;}
    public static String leadCountryCodeAPI {get; set;}
    public static String leadWorkersAPI {get; set;}
    public static String leadEmployeesAPI {get; set;}

    public static void assignDynamicMappingFields(CW_Login_Setup__mdt oLoginSetup){
        //System
        duplicatedCheckOnCreation = oLoginSetup.CW_Duplicate_Check_Creation__c;  
        duplicatedCheckOnRefresh = oLoginSetup.CW_Duplicate_Check_Refresh__c;

        //Account 
        accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c;
        accountScoreAPI = oLoginSetup.Account_Score_Field__c;
        accountActivitiesAPI = oLoginSetup.Account_Activities_Field__c;
        accountCreditLimitAPI = oLoginSetup.Account_Credit_Limit_Field__c;
        accountJointCommitieesBlueAPI = oLoginSetup.Account_Joint_Commitees_Field__c;
        accountJointCommitieesWhiteAPI = oLoginSetup.Account_Joint_Commitees_White_Field__c;
        accountMainActivityAPI = oLoginSetup.Account_Main_Activity_Field__c;
        accountNumberEmployeesAPI = oLoginSetup.Account_Number_Employees_Field__c;
        accountSocialSecurityAPI = oLoginSetup.Account_Social_Security_Field__c;
        accountLegalFormAPI = oLoginSetup.Account_Legal_Form_Field__c;
        accountPhoneAPI = oLoginSetup.Account_Phone_Field__c;
        accountAnnualRevenueAPI = oLoginSetup.Account_Annual_Revenue_Field__c;
        accountStreetAPI = oLoginSetup.Account_Street_Field__c;
        accountPostalCodeAPI = oLoginSetup.Account_PostalCode_Field__c;
        accountCityAPI = oLoginSetup.Account_City_Field__c;
        accountCountryCodeAPI = oLoginSetup.Account_CountryCode_Field__c;
        accountEmployeesAPI = oLoginSetup.Account_Employees_Field__c;
        accountWorkersAPI = oLoginSetup.Account_Workers_Field__c;

        //Lead
        leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c;
        leadScoreAPI = oLoginSetup.Lead_Score_Field__c;
        leadActivitiesAPI = oLoginSetup.Lead_Activities_Field__c;
        leadCreditLimitAPI = oLoginSetup.Lead_Credit_Limit_Field__c;
        leadJointCommitieesBlueAPI = oLoginSetup.Lead_Joint_Commitees_Field__c;
        leadJointCommitieesWhiteAPI = oLoginSetup.Lead_Joint_Commitees_White_Field__c;
        leadMainActivityAPI = oLoginSetup.Lead_Main_Activity_Field__c;
        leadNumberEmployeesAPI = oLoginSetup.Lead_Number_Employees_Field__c;
        leadSocialSecurityAPI = oLoginSetup.Lead_Social_Security_Field__c;
        leadLegalFormAPI = oLoginSetup.Lead_Legal_Form_Field__c;
        leadPhoneAPI = oLoginSetup.Lead_Phone_Field__c;
        leadAnnualRevenueAPI = oLoginSetup.Lead_Annual_Revenue_Field__c;
        leadStreetAPI = oLoginSetup.Lead_Street_Field__c;
        leadPostalCodeAPI = oLoginSetup.Lead_PostalCode_Field__c;
        leadCityAPI = oLoginSetup.Lead_City_Field__c;
        leadCountryCodeAPI = oLoginSetup.Lead_CountryCode_Field__c;
        leadEmployeesAPI = oLoginSetup.Lead_Employees_Field__c;
        leadWorkersAPI = oLoginSetup.Lead_Workers_Field__c;
    }

    @InvocableMethod(label='Call CW to Update Lead/Account' description='Callout to the CompanyWeb API to update information on the Lead/Account')
    public static void updateSObject(List<Requests> requestList) {
        List<SObject> inputCollection = requestList[0].inputCollection;
        SObject outputMember = inputCollection[0];
        String sObjectType = inputCollection[0].Id.getSObjectType().getDescribe().getName();
        System.debug('inputCollection = ' + sObjectType);
        System.debug('outputMember = ' + outputMember);
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c, Lead_VAT_Number_Field__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
        System.debug('Account_VAT_Number_Field__c = '+ oLoginSetup.Account_VAT_Number_Field__c);
        System.debug('Lead_VAT_Number_Field__c = '+ oLoginSetup.Lead_VAT_Number_Field__c);
        String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c;
        String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c;
        if (sObjectType == 'Lead') {
            Lead lead = (Lead)outputMember;
            if (leadVATAPI != null) {
                asyncGetCompanyInfo(lead.Id, String.valueOf(lead.get(leadVATAPI)), sObjectType);
            } else {
                asyncGetCompanyInfo(lead.Id, String.valueOf(lead.CW_VAT_Number__c), sObjectType);
            }
        } else {
            Account acc = (Account)outputMember;
            if (accountVATAPI != null) {
                asyncGetCompanyInfo(acc.Id, String.valueOf(acc.get(accountVATAPI)), sObjectType);
            } else {
                asyncGetCompanyInfo(acc.Id, String.valueOf(acc.CW_VAT_Number__c), sObjectType);
            }
        }
    }

    public class Requests {
        @InvocableVariable(label='Records for Input' description='yourDescription' required=true)
        public List<SObject> inputCollection;
    }

    @future(callout=true)
    public static void asyncGetCompanyInfo(String Id, String VatNumber, String objectName) {
        if(!test.isRunningTest()){
            System.debug('VatNumber = ' + VatNumber);
            getCompanyInfo(Id, VatNumber, objectName, false);
        }
    }

    public static String createCWLoginHash(String login, String password, String secret){
        //Date Handling
        DateTime dtTodayDate = System.today();
        String sMonth;
        String sDay;
        Integer Day =  dtTodayDate.day();
        Integer Month = dtTodayDate.Month();

        if(Day < 10){
            sDay = String.valueOf('0'+ Day);
        }else{
            sDay = String.valueOf(Day);
        }
        
        if(Month < 10){
            sMonth = String.valueOf('0'+ Month);
        }else{
            sMonth = String.valueOf(Month);
        }

        Integer Year = dtTodayDate.Year();

        //String to be passed for SHA1 hash generation
        String targetString = (
            Year +
            sMonth +
            sDay +
            login +
            password +
            secret
        ).toLowercase();
        // Convert to BLOB
        Blob targetBlob = Blob.valueOf(targetString);
        // Generate SHA1 digest
        Blob hashSHA1 = Crypto.generateDigest('SHA1', targetBlob);
        // For Rackspace Compatiblity encode the binary into BASE 64
        // this will result in 28 chars long string 
        String hashBase64SHA1 = EncodingUtil.base64encode(hashSHA1);
        System.debug(EncodingUtil.convertToHex(hashSHA1));
        return EncodingUtil.convertToHex(hashSHA1);
    }
    
    @AuraEnabled
    public static object getCompanyInfo(String Id, String VatNumber, String objectName, Boolean fromPick){
        //try {
            system.debug('called');
            if (fromPick == false) {
                VatNumber = getVATNumber(Id, objectName);
            }

            connectCompanywebBe.ResponseCompanyByVatV1_5 result = new connectCompanywebBe.ResponseCompanyByVatV1_5();
            List<Account> accts = new List<Account>();
            String accQueryString;
            string functionResponse;

            CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();

            oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c,
             Lead_VAT_Number_Field__c,Account_Score_Field__c,Account_Activities_Field__c,Account_Credit_Limit_Field__c,Account_Joint_Commitees_Field__c,
             Account_Joint_Commitees_White_Field__c,Account_Legal_Form_Field__c,Account_Main_Activity_Field__c,Account_Number_Employees_Field__c,
             Account_Social_Security_Field__c,Account_Phone_Field__c,Account_Street_Field__c,Account_PostalCode_Field__c,Account_City_Field__c,Account_CountryCode_Field__c,
             Account_Annual_Revenue_Field__c,CW_Duplicate_Check_Creation__c,
             CW_Duplicate_Check_Refresh__c,Lead_Score_Field__c,Lead_Activities_Field__c,Lead_Credit_Limit_Field__c,Lead_Joint_Commitees_Field__c,
             Lead_Joint_Commitees_White_Field__c,Lead_Legal_Form_Field__c,Lead_Main_Activity_Field__c,Lead_Number_Employees_Field__c,Lead_Social_Security_Field__c,
             Lead_Phone_Field__c,Lead_Annual_Revenue_Field__c,Lead_Street_Field__c,Lead_PostalCode_Field__c,Lead_City_Field__c,Lead_CountryCode_Field__c
             FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

            system.debug('Result of loginSetup '+ oLoginSetup);
            system.debug('objectName '+ objectName);

            assignDynamicMappingFields(oLoginSetup);

            String queryString;

            switch on objectName {
                when 'Account' {
                    // if (accountVATAPI != null) {
                    //    queryString = 'SELECT Id, ' + accountVATAPI + ' FROM Account WHERE Id = :Id';
                    //} else {
                        queryString = 'SELECT Id FROM Account WHERE Id = :Id';
                    // }
                }
                when 'Lead' {
                    // if (leadVATAPI != null) {
                    //    queryString = 'SELECT Id, ' + leadVATAPI + ' FROM Lead WHERE Id = :Id';
                    //} else {
                        queryString = 'SELECT Id FROM Lead WHERE Id = :Id';
                    // }
                }
            }

            sObject genericObject = Database.query(queryString);
            System.debug('genericObject: '+genericObject );

            if(accountVATAPI != null){
                Schema.DisplayType dtAccountVAT = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountVATAPI).getDescribe().getType();
                    String vatAccountFieldType = String.valueOf(dtAccountVAT);
                    if (vatAccountFieldType == 'String') {
                        String VATString = String.ValueOf(VatNumber);
                        accQueryString = 'SELECT Id FROM Account WHERE '+ accountVATAPI +' =: VATString'; 
                        accts = Database.query(accQueryString);
                    } else {
                        if(!Test.isRunningTest()){
                            Decimal VATDecimal = Decimal.ValueOf(VatNumber);
                            accQueryString = 'SELECT Id FROM Account WHERE '+ accountVATAPI +' =: VATDecimal'; 
                            accts = Database.query(accQueryString);
                        }
                    }
            }else{
                accts = [SELECT Id FROM Account Where CW_VAT_Number__c =: VatNumber];
            }
          
            system.debug('how many accounts -> '+ accts.size());
            system.debug('is from pick ->'+ fromPick);
            system.debug('Object Name ->'+ objectName);
            
            if((accts.size() <= 1 && objectName == 'Account' && fromPick == false) || (accts.size() < 1 && objectName == 'Account' && fromPick == true) || duplicatedCheckOnRefresh == false ){
                
            // User user Language
            String userLanguage = UserInfo.getLanguage();
            
            if (userLanguage == 'en_US'){
                userLanguage = 'EN';
            } else if(userLanguage == 'nl_NL'){
                userLanguage = 'NL';
            } else if(userLanguage == 'fr'){
                userLanguage = 'FR';
            } else {
                userLanguage = 'EN';
            }

            connectCompanywebBe.RequestCompanyByVat reqByVAT = new connectCompanywebBe.RequestCompanyByVat();
            reqByVAT.VatNumber = VatNumber;
            reqByVAT.Language = userLanguage ;// 'EN'
            reqByVAT.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
            reqByVAT.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
            reqByVAT.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
            reqByVAT.LoginHash = createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
            connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();
            //http Reponse
            result = httpreq.GetCompanyByVat(reqByVAT);

            String warningsString = '';
            System.debug('statuscode = ' + result.StatusCode);


            if(result.StatusCode  == 0){
                if(objectName == 'Account'){
                    Account acc = (Account)genericObject;
                    assignAccountFields(acc, result, fromPick);
                    //Update Account
                    update acc;

                } else if (objectName == 'Lead'){
                    Lead lead = (Lead)genericObject;
                    assignLeadFields(lead, result, fromPick);
                    //Update Lead
                    update lead;
                }
            } else {
                if(objectName == 'Account'){
                    Account acc = (Account)genericObject;
                    acc.CW_VAT_Number__c = null;
                    update acc;
                } else {
                    Lead lead = (Lead)genericObject;
                    lead.CW_VAT_Number__c = null;
                    update lead;
                }
            }
            // } catch (Exception e) {
            //     throw new AuraHandledException(e.getMessage());
            // }
                functionResponse = JSON.serialize(result);
            } else{
                connectCompanywebBe.GetCompanyByVatResponse_element main = new connectCompanywebBe.GetCompanyByVatResponse_element();
                connectCompanywebBe.ResponseCompanyByVatV1_5 subMain = new connectCompanywebBe.ResponseCompanyByVatV1_5 ();
                connectCompanywebBe.Status cStatus =  new connectCompanywebBe.Status();
                cStatus.Code = 999;
                subMain.StatusCode = cStatus.Code;
                submain.StatusMessage = 'Existing Account with same VAT Number.'; 
    
                functionResponse = JSON.serialize(subMain);
            }

            return functionResponse;
    }

    @AuraEnabled
    public static object searchCompaniesInfo(String sTerm){
        system.debug('searchCompaniesInfo');
        system.debug('searchTerm: '+sTerm);
        try {

            CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();

            oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

            system.debug('Result of loginSetup '+ oLoginSetup);

            // User user Language
            String userLanguage = UserInfo.getLanguage();
            
            if (userLanguage == 'en_US'){
                userLanguage = 'EN';
            } else if(userLanguage == 'nl_NL'){
                userLanguage = 'NL';
            } else if(userLanguage == 'fr'){
                userLanguage = 'FR';
            } else {
                userLanguage = 'EN';
            }

            connectCompanywebBe.RequestSearch reqSearch = new connectCompanywebBe.RequestSearch();
            reqSearch.SearchTerm  = sTerm;
            reqSearch.Language = userLanguage; //'EN'
            reqSearch.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
            reqSearch.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
            reqSearch.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
            reqSearch.LoginHash = createCWLoginHash(reqSearch.CompanyWebLogin, reqSearch.CompanyWebPassword, oLoginSetup.CW_CompanyWebSecret__c);
            connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();
            //http Reponse
            connectCompanywebBe.ResponseSearch result = httpreq.SearchCompanies(reqSearch);
            
            system.debug('Result:' +result);
            system.debug('Status Code:' +result.StatusCode);

            if(result.StatusCode  == 0){
                system.debug('full result' + result);
            }

            return JSON.serialize(result);
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
    }

    public static CW_Login_Setup__mdt getCurrentVATNumberFields() {
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c, Lead_VAT_Number_Field__c,Account_Score_Field__c,Account_Activities_Field__c,Account_Credit_Limit_Field__c,Account_Joint_Commitees_Field__c,Account_Joint_Commitees_White_Field__c,Account_Legal_Form_Field__c,Account_Main_Activity_Field__c,Account_Number_Employees_Field__c,Account_Social_Security_Field__c,Account_Phone_Field__c,Account_Street_Field__c,Account_PostalCode_Field__c,Account_City_Field__c,Account_CountryCode_Field__c,Account_Annual_Revenue_Field__c,Account_Employees_Field__c,Account_Workers_Field__c,CW_Duplicate_Check_Creation__c,CW_Duplicate_Check_Refresh__c,Lead_Score_Field__c,Lead_Activities_Field__c,Lead_Credit_Limit_Field__c,Lead_Joint_Commitees_Field__c,Lead_Joint_Commitees_White_Field__c,Lead_Legal_Form_Field__c,Lead_Main_Activity_Field__c,Lead_Number_Employees_Field__c,Lead_Social_Security_Field__c,Lead_Phone_Field__c,Lead_Street_Field__c,Lead_PostalCode_Field__c,Lead_City_Field__c,Lead_CountryCode_Field__c,Lead_Annual_Revenue_Field__c,Lead_Employees_Field__c,Lead_Workers_Field__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
        System.debug('Account_VAT_Number_Field__c = '+ oLoginSetup.Account_VAT_Number_Field__c);
        System.debug('Lead_VAT_Number_Field__c = '+ oLoginSetup.Lead_VAT_Number_Field__c);
        return oLoginSetup;
    }

    @AuraEnabled
    public static String getVATNumber(String Id, String objectName){
        String queryString;
        String result;

        CW_Login_Setup__mdt oLoginSetup = getCurrentVATNumberFields();
        String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c;
        String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c;
        System.debug('accountVATAPI = '+ oLoginSetup.Account_VAT_Number_Field__c);
        System.debug('leadVATAPI = '+ oLoginSetup.Lead_VAT_Number_Field__c);

        if(objectName == 'Account'){
            if (accountVATAPI != null) {
                queryString = 'SELECT Id, ' + accountVATAPI + ' FROM Account WHERE Id = :Id';
            } else {
                queryString = 'SELECT Id, CW_VAT_Number__c FROM Account WHERE Id = :Id';
            }
            
        }
        else if (objectName == 'Lead'){
            if (leadVATAPI != null) {
                queryString = 'SELECT Id, ' + leadVATAPI + ' FROM Lead WHERE Id = :Id';
            } else {
                queryString = 'SELECT Id, CW_VAT_Number__c FROM Lead WHERE Id = :Id';
            }
        }
        
        sObject obj = Database.query(queryString);

        if(objectName == 'Account'){
            Account acc = (Account)obj;
            if (accountVATAPI != null) {
                result =  String.ValueOf(acc.get(accountVATAPI));
            } else {
                result =  String.ValueOf(acc.CW_VAT_Number__c);
            }
            
        }
        else if (objectName == 'Lead'){
            Lead lead = (Lead)obj;
            if (leadVATAPI != null) {
                result = String.ValueOf(lead.get(leadVATAPI));
            } else {
                result = String.ValueOf(lead.CW_VAT_Number__c);
            }
        }

        System.debug('result vat = ' + result);
        
        return result;
    }

    // @AuraEnabled
    // public static void copyData(String Id, String objectName){
    //     CW_Login_Setup__mdt oLoginSetup = getCurrentVATNumberFields();

    //     //Account
    //     String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c;
    //     String accountScoreAPI = oLoginSetup.Account_Score_Field__c;
    //     String accountActivitiesAPI = oLoginSetup.Account_Activities_Field__c;
    //     String accountCreditLimitAPI = oLoginSetup.Account_Credit_Limit_Field__c;
    //     String accountJointCommitieesBlueAPI = oLoginSetup.Account_Joint_Commitees_Field__c;
    //     String accountJointCommitieesWhiteAPI = oLoginSetup.Account_Joint_Commitees_White_Field__c;
    //     String accountMainActivityAPI = oLoginSetup.Account_Main_Activity_Field__c;
    //     String accountNumberEmployeesAPI = oLoginSetup.Account_Number_Employees_Field__c;
    //     String accountSocialSecurityAPI = oLoginSetup.Account_Social_Security_Field__c;
    //     String accountLegalFormAPI = oLoginSetup.Account_Legal_Form_Field__c;
        
    //     //Lead
    //     String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c;
    //     String leadScoreAPI = oLoginSetup.Lead_Score_Field__c;
    //     String leadActivitiesAPI = oLoginSetup.Lead_Activities_Field__c;
    //     String leadCreditLimitAPI = oLoginSetup.Lead_Credit_Limit_Field__c;
    //     String leadJointCommitieesBlueAPI = oLoginSetup.Lead_Joint_Commitees_Field__c;
    //     String leadJointCommitieesWhiteAPI = oLoginSetup.Lead_Joint_Commitees_White_Field__c;
    //     String leadMainActivityAPI = oLoginSetup.Lead_Main_Activity_Field__c;
    //     String leadNumberEmployeesAPI = oLoginSetup.Lead_Number_Employees_Field__c;
    //     String leadSocialSecurityAPI = oLoginSetup.Lead_Social_Security_Field__c;
    //     String leadLegalFormAPI = oLoginSetup.Lead_Legal_Form_Field__c;

    //     //Schema Datatypes
    //     Schema.DisplayType dtAccountVAT, dtAccountScore, dtAccountActivities, dtAccountCreditLimit, dtAccountJointCommiteesBlue, dtJointCommiteesWhite, dtAccountLegalForm, dtAccountMainActivity, dtAccountNumberEmployees, dtAccountSocialSecurity,dtLeadVAT, dtLeadScore, dtLeadActivities, dtLeadCreditLimit, dtLeadJointCommiteesBlue, dtLeadJointCommiteesWhite, dtLeadLegalForm, dtLeadMainActivity, dtLeadNumberEmployees, dtLeadSocialSecurity;

    //     if(accountVATAPI != null){
    //         dtAccountVAT = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountVATAPI).getDescribe().getType();
    //     }
        
    //     if(accountScoreAPI != null){
    //         dtAccountScore = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountScoreAPI).getDescribe().getType();
    //     }

    //     if(accountActivitiesAPI != null){
    //         dtAccountActivities = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountActivitiesAPI).getDescribe().getType();
    //     }

    //     if(accountCreditLimitAPI != null){
    //         dtAccountCreditLimit = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountCreditLimitAPI).getDescribe().getType();
    //     }

    //     if(accountJointCommitieesBlueAPI != null){
    //         dtAccountJointCommiteesBlue = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountJointCommitieesBlueAPI).getDescribe().getType();
    //     }

    //     if(accountJointCommitieesWhiteAPI != null){
    //         dtJointCommiteesWhite = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountJointCommitieesWhiteAPI).getDescribe().getType();
    //     }

    //     if(accountLegalFormAPI != null){
    //         dtAccountLegalForm = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountLegalFormAPI).getDescribe().getType();
    //     }

    //     if(accountMainActivityAPI != null){
    //         dtAccountMainActivity = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountMainActivityAPI).getDescribe().getType();
    //     }

    //     if(accountNumberEmployeesAPI != null){
    //         dtAccountNumberEmployees = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountNumberEmployeesAPI).getDescribe().getType();
    //     }

    //     if(accountSocialSecurityAPI != null){
    //         dtAccountSocialSecurity = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountSocialSecurityAPI).getDescribe().getType();
    //     }

    //     if(leadVATAPI != null){
    //         dtLeadVAT = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadVATAPI).getDescribe().getType();
    //     }
        
    //     if(leadScoreAPI != null){
    //         dtLeadScore = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadScoreAPI).getDescribe().getType();
    //     }

    //     if(leadActivitiesAPI != null){
    //         dtLeadActivities = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadActivitiesAPI).getDescribe().getType();
    //     }

    //     if(leadCreditLimitAPI != null){
    //         dtLeadCreditLimit = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadCreditLimitAPI).getDescribe().getType();
    //     }

    //     if(leadJointCommitieesBlueAPI != null){
    //         dtLeadJointCommiteesBlue = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadJointCommitieesBlueAPI).getDescribe().getType();
    //     }

    //     if(leadJointCommitieesWhiteAPI != null){
    //         dtJointCommiteesWhite = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadJointCommitieesWhiteAPI).getDescribe().getType();
    //     }

    //     if(leadLegalFormAPI != null){
    //         dtLeadLegalForm = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadLegalFormAPI).getDescribe().getType();
    //     }

    //     if(leadMainActivityAPI != null){
    //         dtLeadMainActivity = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadMainActivityAPI).getDescribe().getType();
    //     }

    //     if(leadNumberEmployeesAPI != null){
    //         dtLeadNumberEmployees = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadNumberEmployeesAPI).getDescribe().getType();
    //     }

    //     if(leadSocialSecurityAPI != null){
    //         dtLeadSocialSecurity = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadSocialSecurityAPI).getDescribe().getType();
    //     }

    //     //try {

    //         System.debug('recordId = ' + Id);
    //         System.debug('objectName = ' + objectName);

    //         //clearStdData(Id, objectName);

    //         String queryString;

    //         switch on objectName {
    //             when 'Account' {
    //                 queryString = 'SELECT Id, CW_Name__c, CW_Phone__c, CW_Employees__c, CW_Revenue__c, CW_Street__c, CW_City__c, CW_PostalCode__c, CW_Country__c, CW_VAT_Number__c, CW_Score__c, CW_Abbreviation__c, CW_Credit_Limit__c, CW_Main_Activity__c, CW_Activities__c, CW_Joint_Commitees__c, CW_Joint_Commitees_White_Collar__c, CW_Social_Security_Information__c,CW_Legal_Form__c FROM Account WHERE Id = :Id';
    //             }
    //             when 'Lead' {
    //                 queryString = 'SELECT Id, CW_Name__c, CW_Phone__c, CW_Employees__c, CW_Revenue__c, CW_Street__c, CW_City__c, CW_PostalCode__c, CW_Country__c, CW_VAT_Number__c FROM Lead WHERE Id = :Id';
    //             }
    //         }

    //         sObject genericObject = Database.query(queryString);

    //         if(objectName == 'Account'){
    //             Account acc = (Account)genericObject;
    //             if (accountVATAPI != null) {
    //                 dtAccountVAT = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountVATAPI).getDescribe().getType();
    //                 String vatAccountFieldType = String.valueOf(dtAccountVAT);
    //                 if (vatAccountFieldType == 'String') {
    //                     acc.put(accountVATAPI, acc.CW_VAT_Number__c);
    //                 } else {
    //                     acc.put(accountVATAPI, Integer.valueOf(acc.CW_VAT_Number__c));
    //                 }
    //             }
    //             if (acc.CW_Name__c != null) {
    //                 acc.Name = acc.CW_Name__c;
    //             }
    //             if (acc.CW_Phone__c != null) {
    //                 acc.Phone = acc.CW_Phone__c;
    //             }
    //             if (acc.CW_Street__c != null) {
    //                 acc.ShippingStreet = acc.CW_Street__c;
    //             }
    //             if (acc.CW_City__c != null) {
    //                 acc.ShippingCity = acc.CW_City__c;
    //             }
    //             if (acc.CW_PostalCode__c != null) {
    //                 acc.ShippingPostalCode = acc.CW_PostalCode__c;
    //             }
    //             if (acc.CW_Country__c != null) {
    //                 acc.ShippingCountry = acc.CW_Country__c;
    //             }
    //             acc.ShippingState = null;
    //             if (acc.CW_Revenue__c != null) {
    //                 acc.AnnualRevenue = acc.CW_Revenue__c;
    //             }
    //             if (acc.CW_Abbreviation__c != null) {
    //                 if(accountLegalFormAPI != null){
    //                     String accountLegalFormFieldType = String.valueOf(dtAccountLegalForm);
    //                     /*if (accountLegalFormFieldType == 'String') {
    //                         acc.put(accountLegalFormAPI, String.valueOf(acc.CW_Legal_Form__c));
    //                     } else {
    //                         acc.put(accountLegalFormAPI, acc.CW_Legal_Form__c);
    //                     } */
    //                 }
    //             } 
    //             if (acc.CW_Score__c != null) {
    //                 if(accountScoreAPI != null){
    //                     String accountScoreFieldType = String.valueOf(dtAccountScore);
    //                     if (accountScoreFieldType == 'String') {
    //                         acc.put(accountScoreAPI, String.valueOf(acc.CW_Score__c));
    //                     } else {
    //                         acc.put(accountScoreAPI, String.valueOf(acc.CW_Score__c));
    //                     }
    //                 }
    //             }
    //             if (acc.CW_Employees__c != null) {
    //                 if(accountNumberEmployeesAPI != null){
    //                     String NumberEmployeesFieldType = String.valueOf(dtAccountNumberEmployees);
    //                     if (NumberEmployeesFieldType == 'String') {
    //                         acc.put(accountNumberEmployeesAPI, acc.CW_Employees__c);
    //                     } else {
    //                         acc.put(accountNumberEmployeesAPI,acc.CW_Employees__c);
    //             }
    //                }
    //                //acc.NumberOfEmployees = Integer.valueOf(acc.CW_Employees__c);    
    //             }
    //             if (acc.CW_Credit_Limit__c != null) {
    //                 if(accountCreditLimitAPI != null){
    //                     String CreditLimitFieldType = String.valueOf(dtAccountCreditLimit);
    //                     if (CreditLimitFieldType == 'String') {
    //                         acc.put(accountCreditLimitAPI, acc.CW_Credit_Limit__c);
    //                 } else {
    //                         acc.put(accountCreditLimitAPI, Integer.valueOf(acc.CW_Credit_Limit__c));
    //                     }
    //                 }  
    //             }
    //             if (acc.CW_Main_Activity__c != null) {
    //                 if(accountMainActivityAPI != null){
    //                     String CreditLimitFieldType = String.valueOf(dtAccountMainActivity);
    //                     if (CreditLimitFieldType == 'String') {
    //                         acc.put(accountMainActivityAPI, acc.CW_Main_Activity__c);
    //                     } else {
    //                         acc.put(accountMainActivityAPI, String.valueOf(acc.CW_Main_Activity__c));
    //                     }
    //                 }
    //             }
    //             if (acc.CW_Activities__c != null) {
    //                if(accountActivitiesAPI != null){
    //                     String ActivitiesFieldType = String.valueOf(dtAccountActivities);
    //                     if (ActivitiesFieldType == 'String') {
    //                         acc.put(accountActivitiesAPI, acc.CW_Activities__c);
    //                     } else {
    //                        // acc.put(accountActivitiesAPI, String.valueOf(acc.CW_Activities__c));
    //                     }
    //                }  
    //             }
    //             // if (acc.CW_Joint_Commitees__c != null) {
    //             //     if(accountJointCommitieesBlueAPI != null){
    //             //        // String accountJointCommiteesBlueFieldType = String.valueOf(dtJointCommiteesBlue);
    //             //         if (accountJointCommiteesBlueFieldType == 'String') {
    //             //             acc.put(accountJointCommitieesBlueAPI, acc.CW_Joint_Commitees__c);
    //             //         } else {
    //             //             acc.put(accountJointCommitieesBlueAPI, String.valueOf(acc.CW_Joint_Commitees__c));
    //             //         }
    //             //     }  
    //             // }
    //             if (acc.CW_Joint_Commitees_White_Collar__c != null) {
    //                 if(accountJointCommitieesWhiteAPI != null){
    //                     String accountJointCommiteesWhiteFieldType = String.valueOf(dtJointCommiteesWhite);
    //                     if (accountJointCommiteesWhiteFieldType == 'String') {
    //                         acc.put(accountJointCommitieesWhiteAPI, acc.CW_Joint_Commitees_White_Collar__c);
    //                     } else {
    //                         acc.put(accountJointCommitieesWhiteAPI, String.valueOf(acc.CW_Joint_Commitees_White_Collar__c));
    //                     }
    //                 }  
    //             }
    //             if (acc.CW_Social_Security_Information__c != null) {
    //                 if(accountSocialSecurityAPI != null){
    //                     String accountSocialSecurityType = String.valueOf(dtAccountSocialSecurity);
    //                     if (AccountSocialSecurityType == 'String') {
    //                         acc.put(accountSocialSecurityAPI, acc.CW_Social_Security_Information__c);
    //                     } else {
    //                         acc.put(accountSocialSecurityAPI, String.valueOf(acc.CW_Social_Security_Information__c));
    //                     }
    //                 }
    //            }

    //             // Update Account
    //             update acc;
    //         } else if (objectName == 'Lead'){
    //             Lead lead = (Lead)genericObject;
    //             if (lead.CW_Name__c != null) {
    //                 lead.Company = lead.CW_Name__c;
    //             }
    //             if (lead.CW_Phone__c != null) {
    //                 lead.Phone = lead.CW_Phone__c;
    //             }
    //             if (lead.CW_Street__c != null) {
    //                 lead.Street = lead.CW_Street__c;
    //             }
    //             if (lead.CW_City__c != null) {
    //                 lead.City = lead.CW_City__c;
    //             }
    //             if (lead.CW_PostalCode__c != null) {
    //                 lead.PostalCode = lead.CW_PostalCode__c;
    //             }
    //             if (lead.CW_Country__c != null) {
    //                 lead.Country = lead.CW_Country__c;
    //             }
    //             lead.State = null;
    //             if (lead.CW_Revenue__c != null) {
    //                 lead.AnnualRevenue = lead.CW_Revenue__c;
    //             }
    //             if (lead.CW_Employees__c != null) {
    //                 if(leadNumberEmployeesAPI != null){
    //                     String NumberEmployeesFieldType = String.valueOf(dtAccountNumberEmployees);
    //                     if (NumberEmployeesFieldType == 'String') {
    //                         lead.put(leadNumberEmployeesAPI, lead.CW_Employees__c);
    //                     } else {
    //                         lead.put(leadNumberEmployeesAPI,lead.CW_Employees__c);
    //             }
    //                }
    //                //lead.NumberOfEmployees = Integer.valueOf(lead.CW_Employees__c);    
    //             }
    //             //lead.ShippingState = null;
    //             if (lead.CW_Revenue__c != null) {
    //                 lead.AnnualRevenue = lead.CW_Revenue__c;
    //             }
    //             if (lead.CW_Abbreviation__c != null) {
    //                 if(leadLegalFormAPI != null){
    //                     String leadLegalFormFieldType = String.valueOf(dtAccountLegalForm);
    //                     // if (leadLegalFormFieldType == 'String') {
    //                     //     lead.put(leadLegalFormAPI, String.valueOf(lead.CW_Legal_Form__c));
    //                     // } else {
    //                     //     lead.put(leadLegalFormAPI, lead.CW_Legal_Form__c);
    //                     // } 
    //                 }
    //             } 
    //             if (lead.CW_Score__c != null) {
    //                 if(leadScoreAPI != null){
    //                     String leadScoreFieldType = String.valueOf(dtAccountScore);
    //                     if (leadScoreFieldType == 'String') {
    //                         lead.put(leadScoreAPI, String.valueOf(lead.CW_Score__c));
    //                     } else {
    //                         lead.put(leadScoreAPI, String.valueOf(lead.CW_Score__c));
    //                     }
    //                 }
    //             }
    //             if (lead.CW_Employees__c != null) {
    //                 if(leadNumberEmployeesAPI != null){
    //                     String NumberEmployeesFieldType = String.valueOf(dtAccountNumberEmployees);
    //                     if (NumberEmployeesFieldType == 'String') {
    //                         lead.put(leadNumberEmployeesAPI, lead.CW_Employees__c);
    //                     } else {
    //                         lead.put(leadNumberEmployeesAPI,lead.CW_Employees__c);
    //             }
    //                }
    //                //lead.NumberOfEmployees = Integer.valueOf(lead.CW_Employees__c);    
    //             }
    //             if (lead.CW_Credit_Limit__c != null) {
    //                 if(leadCreditLimitAPI != null){
    //                     String CreditLimitFieldType = String.valueOf(dtAccountCreditLimit);
    //                     if (CreditLimitFieldType == 'String') {
    //                         lead.put(leadCreditLimitAPI, lead.CW_Credit_Limit__c);
    //                 } else {
    //                         lead.put(leadCreditLimitAPI, Integer.valueOf(lead.CW_Credit_Limit__c));
    //                     }
    //                 }  
    //             }
    //             if (lead.CW_Main_Activity__c != null) {
    //                 if(leadMainActivityAPI != null){
    //                     String CreditLimitFieldType = String.valueOf(dtAccountMainActivity);
    //                     if (CreditLimitFieldType == 'String') {
    //                         lead.put(leadMainActivityAPI, lead.CW_Main_Activity__c);
    //                     } else {
    //                         lead.put(leadMainActivityAPI, String.valueOf(lead.CW_Main_Activity__c));
    //                     }
    //                 }
    //             }
    //             if (lead.CW_Activities__c != null) {
    //                if(leadActivitiesAPI != null){
    //                     String ActivitiesFieldType = String.valueOf(dtAccountActivities);
    //                     if (ActivitiesFieldType == 'String') {
    //                         lead.put(leadActivitiesAPI, lead.CW_Activities__c);
    //                     } else {
    //                         lead.put(leadActivitiesAPI, String.valueOf(lead.CW_Activities__c));
    //                     }
    //                }  
    //             }
    //             // if (lead.CW_Joint_Commitees__c != null) {
    //             //     if(leadJointCommitieesBlueAPI != null){
    //             //         String leadJointCommiteesBlueFieldType = String.valueOf(dtJointCommiteesBlue);
    //             //         if (leadJointCommiteesBlueFieldType == 'String') {
    //             //             lead.put(leadJointCommitieesBlueAPI, lead.CW_Joint_Commitees__c);
    //             //         } else {
    //             //             lead.put(leadJointCommitieesBlueAPI, String.valueOf(lead.CW_Joint_Commitees__c));
    //             //         }
    //             //     }  
    //             //}
    //             if (lead.CW_Joint_Commitees_White_Collar__c != null) {
    //                 if(leadJointCommitieesWhiteAPI != null){
    //                     String leadJointCommiteesWhiteFieldType = String.valueOf(dtJointCommiteesWhite);
    //                     if (leadJointCommiteesWhiteFieldType == 'String') {
    //                         lead.put(leadJointCommitieesWhiteAPI, lead.CW_Joint_Commitees_White_Collar__c);
    //                     } else {
    //                         lead.put(leadJointCommitieesWhiteAPI, String.valueOf(lead.CW_Joint_Commitees_White_Collar__c));
    //                     }
    //                 }  
    //             }
    //             if (lead.CW_Social_Security_Information__c != null) {
    //                 if(leadSocialSecurityAPI != null){
    //                     String leadSocialSecurityType = String.valueOf(dtAccountSocialSecurity);
    //                     if (LeadSocialSecurityType == 'String') {
    //                         lead.put(leadSocialSecurityAPI, lead.CW_Social_Security_Information__c);
    //                     } else {
    //                         lead.put(leadSocialSecurityAPI, String.valueOf(lead.CW_Social_Security_Information__c));
    //                     }
    //                 }
    //            }

    //             update lead;
    //         }
    //     /* } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     } */
    // }

    @AuraEnabled
    public static void clearData(String Id, String objectName){
        try {
            System.debug('recordId = ' + Id);
            System.debug('objectName = ' + objectName);

            CW_Login_Setup__mdt oLoginSetup = getCurrentVATNumberFields();
            
            assignDynamicMappingFields(oLoginSetup);

            System.debug('accountVATAPI = '+ oLoginSetup.Account_VAT_Number_Field__c);
            System.debug('leadVATAPI = '+ oLoginSetup.Lead_VAT_Number_Field__c);

            String queryString;

            switch on objectName {
                when 'Account' {
                    if (accountVATAPI != null) {
                        queryString = 'SELECT Id, Name, Phone, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingCountry, AnnualRevenue, NumberOfEmployees, CW_Phone__c, CW_Address_Line_1__c, CW_Address_Line_2__c, CW_Name__c, ' + accountVATAPI + ', CW_VAT_Liable__c, CW_Abbreviation__c, CW_Company_Status__c, CW_Score_Image__c, CW_Score__c, CW_Credit_Limit__c, CW_Detail_URL__c, CW_Report_URL__c, CW_Balance__c, CW_Equity__c, CW_Last_Sync__c, CW_Revenue__c, CW_Employees__c, CW_Gross_Margin__c, CW_Result__c, CW_Warnings__c,CW_Kyc_URL__c,CW_Credit_Limit_Reason__c,CW_Start_Date__c,CW_End_Date__c,CW_Preferred_Languages_PL__c,CW_Legal_Form__c FROM Account WHERE Id = :Id';
                    } else {
                        queryString = 'SELECT Id, Name, Phone, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingCountry, AnnualRevenue, NumberOfEmployees, CW_Phone__c, CW_Address_Line_1__c, CW_Address_Line_2__c, CW_Name__c, CW_VAT_Number__c, CW_VAT_Liable__c, CW_Abbreviation__c, CW_Company_Status__c, CW_Score_Image__c, CW_Score__c, CW_Credit_Limit__c, CW_Detail_URL__c, CW_Report_URL__c, CW_Balance__c, CW_Equity__c, CW_Last_Sync__c, CW_Revenue__c, CW_Employees__c, CW_Gross_Margin__c, CW_Result__c, CW_Warnings__c,CW_Kyc_URL__c,CW_Credit_Limit_Reason__c,CW_Start_Date__c,CW_End_Date__c,CW_Preferred_Languages_PL__c,CW_Legal_Form__c FROM Account WHERE Id = :Id';
                    }
                    
                }
                when 'Lead' {
                    if (leadVATAPI != null) {
                        queryString = 'SELECT Id, Company, Phone, Street, City, PostalCode, Country, AnnualRevenue, NumberOfEmployees, CW_Phone__c, CW_Address_Line_1__c, CW_Address_Line_2__c, CW_Name__c, ' + leadVATAPI + ', CW_VAT_Liable__c, CW_Abbreviation__c, CW_Company_Status__c, CW_Score_Image__c, CW_Score__c, CW_Credit_Limit__c, CW_Detail_URL__c, CW_Report_URL__c, CW_Balance__c, CW_Equity__c, CW_Last_Sync__c, CW_Revenue__c, CW_Employees__c, CW_Gross_Margin__c, CW_Result__c, CW_Warnings__c,CW_Kyc_URL__c,CW_Credit_Limit_Reason__c,CW_Start_Date__c,CW_End_Date__c,CW_Preferred_Languages_PL__c,CW_Legal_Form__c FROM Lead WHERE Id = :Id';
                    } else {
                        queryString = 'SELECT Id, Company, Phone, Street, City, PostalCode, Country, AnnualRevenue, NumberOfEmployees, CW_Phone__c, CW_Address_Line_1__c, CW_Address_Line_2__c, CW_Name__c, CW_VAT_Number__c, CW_VAT_Liable__c, CW_Abbreviation__c, CW_Company_Status__c, CW_Score_Image__c, CW_Score__c, CW_Credit_Limit__c, CW_Detail_URL__c, CW_Report_URL__c, CW_Balance__c, CW_Equity__c, CW_Last_Sync__c, CW_Revenue__c, CW_Employees__c, CW_Gross_Margin__c, CW_Result__c, CW_Warnings__c,CW_Kyc_URL__c,CW_Credit_Limit_Reason__c,CW_Start_Date__c,CW_End_Date__c,CW_Preferred_Languages_PL__c,CW_Legal_Form__c FROM Lead WHERE Id = :Id';
                    }
                    
                }
            }

            sObject genericObject = Database.query(queryString);

            if(objectName == 'Account'){
                Account acc = (Account)genericObject;
                //acc.Name = null; cant be nullified required
                if(accountPhoneAPI != null) acc.put(accountPhoneAPI, null);
                acc.Phone = null;
                if(accountStreetAPI != null) acc.put(accountStreetAPI, null);
                acc.ShippingStreet = null;
                if(accountCityAPI != null) acc.put(accountCityAPI, null);
                acc.ShippingCity = null; 
                if(accountPostalCodeAPI != null) acc.put(accountPostalCodeAPI, null);
                acc.ShippingPostalCode = null;
                if(accountCountryCodeAPI != null) acc.put(accountCountryCodeAPI, null);
                acc.ShippingCountry = null;
                if(accountAnnualRevenueAPI != null) acc.put(accountAnnualRevenueAPI, null);
                acc.AnnualRevenue = null; 
                if (accountNumberEmployeesAPI != null) {
                    acc.put(accountNumberEmployeesAPI, null);
                    //acc.NumberOfEmployees = null;
                } else {
                    //acc.NumberOfEmployees = null;
                }
                acc.CW_Street__c = null;
                acc.CW_City__c = null;
                acc.CW_PostalCode__c = null; 
                acc.CW_Country__c = null;
                if (accountVATAPI != null) {
                    acc.put(accountVATAPI, null);
                } else {
                    acc.CW_VAT_Number__c = null;
                }
                acc.CW_Phone__c = null;
                acc.CW_Address_Line_1__c = null;
                acc.CW_Address_Line_2__c = null;
                acc.CW_Name__c = null;
                if (accountLegalFormAPI != null) {
                    acc.put(accountLegalFormAPI, null);
                    acc.CW_Abbreviation__c = null;
                    acc.CW_Legal_Form__c = null;
                } else {
                    acc.CW_Abbreviation__c = null;
                    acc.CW_Legal_Form__c = null;
                }
                acc.CW_Company_Status__c = null;
                acc.CW_Score_Image__c = null;
                if (accountScoreAPI != null) {
                    acc.put(accountScoreAPI, null);
                    acc.CW_Score__c = null;
                } else {
                    acc.CW_Score__c = null;
                }
                if (accountCreditLimitAPI != null) {
                    acc.put(accountCreditLimitAPI, null);
                    acc.CW_Credit_Limit__c = null;
                } else {
                    acc.CW_Credit_Limit__c = null;
                }
                acc.CW_Detail_URL__c = null;
                acc.CW_Report_URL__c = null;
                acc.CW_Balance__c = null;
                acc.CW_Equity__c = null;
                acc.CW_Last_Sync__c = null;
                acc.CW_Revenue__c = null;
                acc.CW_Employees__c = null;
                acc.CW_Gross_Margin__c = null;
                acc.CW_Result__c = null;
                acc.CW_Warnings__c = null;
                acc.CW_Kyc_URL__c = null;
                acc.CW_Credit_Limit_Reason__c = null;
                acc.CW_Start_Date__c = null;
                acc.CW_End_Date__c = null;
                acc.CW_Preferred_Languages_PL__c = null;
                if (accountJointCommitieesBlueAPI != null) {
                    acc.put(accountJointCommitieesBlueAPI, null);
                    acc.CW_Joint_Commitees__c = null;
                } else {
                   acc.CW_Joint_Commitees__c = null;
                }
                if (accountJointCommitieesWhiteAPI != null) {
                    acc.put(accountJointCommitieesWhiteAPI, null);
                    acc.CW_Joint_Commitees_White_Collar__c = null;
                } else {
                    acc.CW_Joint_Commitees_White_Collar__c = null;
                }
                if (accountActivitiesAPI != null) {
                    acc.put(accountActivitiesAPI, null);
                    acc.CW_Activities__c = null;
                } else {
                    acc.CW_Activities__c = null;
                }
                if (accountMainActivityAPI != null) {
                    acc.put(accountMainActivityAPI, null);
                    acc.CW_Main_Activity__c = null;
                } else {
                    acc.CW_Main_Activity__c = null;
                }
                if (accountSocialSecurityAPI != null) {
                    acc.put(accountSocialSecurityAPI, null);
                    acc.CW_Social_Security_Information__c = null;
                } else {
                    acc.CW_Social_Security_Information__c = null;
                }

                update acc;
            } else if (objectName == 'Lead'){
                Lead lead = (Lead)genericObject;
                //lead.Company = null;  cant be nullified required
                if(leadPhoneAPI != null) lead.put(leadPhoneAPI, null);
                lead.Phone = null;
                if(leadStreetAPI != null) lead.put(leadStreetAPI, null);
                lead.Street = null;
                if(leadCityAPI != null) lead.put(leadCityAPI, null);
                lead.City = null; 
                if(leadPostalCodeAPI != null) lead.put(leadPostalCodeAPI, null);
                lead.PostalCode = null;
                if(leadCountryCodeAPI != null) lead.put(leadCountryCodeAPI, null);
                lead.Country = null;
                if(leadAnnualRevenueAPI != null) lead.put(leadAnnualRevenueAPI, null);
                lead.AnnualRevenue = null; 
                if (leadNumberEmployeesAPI != null) {
                    lead.put(leadNumberEmployeesAPI, null);
                    //lead.NumberOfEmployees = null;
                } else {
                    //lead.NumberOfEmployees = null;
                }
                lead.CW_Street__c = null;
                lead.CW_City__c = null;
                lead.CW_PostalCode__c = null; 
                lead.CW_Country__c = null; 
                lead.CW_Phone__c = null; 
                lead.CW_Address_Line_1__c = null; 
                lead.CW_Address_Line_2__c = null;
                lead.CW_Name__c = null; 
                if (leadVATAPI != null) {
                    lead.put(leadVATAPI, null);
                } else {
                    lead.CW_VAT_Number__c = null;
                }
                if (leadLegalFormAPI != null) {
                    lead.put(leadLegalFormAPI, null);
                    lead.CW_Abbreviation__c = null;
                } else {
                    lead.CW_Abbreviation__c = null;
                }
                lead.CW_Company_Status__c = null;
                lead.CW_Score_Image__c = null; 
                if (leadScoreAPI != null) {
                    lead.put(leadScoreAPI, null);
                    lead.CW_Score__c = null;
                } else {
                    lead.CW_Score__c = null;
                }
                if (leadCreditLimitAPI != null) {
                    lead.put(leadCreditLimitAPI, null);
                    lead.CW_Credit_Limit__c = null;
                } else {
                    lead.CW_Credit_Limit__c = null;
                }
                lead.CW_Detail_URL__c = null;
                lead.CW_Report_URL__c = null;
                lead.CW_Balance__c = null;
                lead.CW_Equity__c = null;
                lead.CW_Last_Sync__c = null;
                lead.CW_Revenue__c = null;
                lead.CW_Employees__c = null;
                lead.CW_Gross_Margin__c = null;
                lead.CW_Result__c = null;
                lead.CW_Warnings__c = null;
                lead.CW_Kyc_URL__c = null;
                lead.CW_Credit_Limit_Reason__c = null;
                lead.CW_Start_Date__c = null;
                lead.CW_End_Date__c = null;
                lead.CW_Preferred_Languages_PL__c = null;
                if (leadJointCommitieesBlueAPI != null) {
                    lead.put(leadJointCommitieesBlueAPI, null);
                    lead.CW_Joint_Commitees__c = null;
                } else {
                    lead.CW_Joint_Commitees__c = null;
                }
                if (leadJointCommitieesWhiteAPI != null) {
                    lead.put(leadJointCommitieesWhiteAPI, null);
                    lead.CW_Joint_Commitees_White_Collar__c = null;
                } else {
                    lead.CW_Joint_Commitees_White_Collar__c = null;
                }
                if (leadActivitiesAPI != null) {
                    lead.put(leadActivitiesAPI, null);
                    lead.CW_Activities__c = null;
                } else {
                    lead.CW_Activities__c = null;
                }
                if (leadMainActivityAPI != null) {
                    lead.put(leadMainActivityAPI, null);
                    lead.CW_Main_Activity__c = null;
                } else {
                    lead.CW_Main_Activity__c = null;
                }
                if (leadSocialSecurityAPI != null) {
                    lead.put(leadSocialSecurityAPI, null);
                    lead.CW_Social_Security_Information__c = null;
                } else {
                    lead.CW_Social_Security_Information__c = null;
                }

                update lead;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /* @AuraEnabled
    public static void clearStdData(String Id, String objectName){
        try {
            System.debug('recordId = ' + Id);
            System.debug('objectName = ' + objectName);

            String queryString;

            switch on objectName {
                when 'Account' {
                    queryString = 'SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingCountry, AnnualRevenue, NumberOfEmployees FROM Account WHERE Id = :Id';
                }
                when 'Lead' {
                    queryString = 'SELECT Id, Company, Phone, Street, City, PostalCode, Country, AnnualRevenue, NumberOfEmployees FROM Lead WHERE Id = :Id';
                }
            }

            sObject genericObject = Database.query(queryString);

            if(objectName == 'Account'){
                Account acc = (Account)genericObject;
                //acc.Name = null; cant be nullified required
                acc.Phone = null;
                //acc.BillingStreet = null;
                //acc.BillingCity = null; 
                //acc.BillingPostalCode = null;
                //acc.BillingCountry = null;
                acc.ShippingStreet = null;
                acc.ShippingCity = null; 
                acc.ShippingPostalCode = null;
                acc.ShippingCountry = null;
                acc.AnnualRevenue = null; 
                acc.NumberOfEmployees = null;

                update acc;
            } else if (objectName == 'Lead'){
                Lead lead = (Lead)genericObject;
                //lead.Company = null;  cant be nullified required
                lead.Phone = null; 
                lead.Street = null;
                lead.City = null; 
                lead.PostalCode = null;
                lead.Country = null;
                lead.AnnualRevenue = null; 
                lead.NumberOfEmployees = null;

                update lead;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } */

    @AuraEnabled
    public static SObject getCWFields(Id recordId ,String objectName ){

        CW_Login_Setup__mdt oLoginSetup = getCurrentVATNumberFields();
        String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c;
        String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c;
        System.debug('accountVATAPI = '+ oLoginSetup.Account_VAT_Number_Field__c);
        System.debug('leadVATAPI = '+ oLoginSetup.Lead_VAT_Number_Field__c);

        List<String> reponseList = new List<String>();
        String responseString;
        String queryString;

        switch on objectName {
            when 'Account' {
                if (accountVATAPI != null) {
                    queryString = 'SELECT Id, companyweb__CW_Full_Name__c, companyweb__CW_Phone__c,companyweb__CW_Address_Line_1__c, companyweb__CW_Address_Line_2__c, companyweb__CW_Name__c, ' + accountVATAPI + ', companyweb__CW_VAT_Liable__c, companyweb__CW_Abbreviation__c, companyweb__CW_Company_Status__c, companyweb__CW_Score_Image__c, companyweb__CW_Score__c, companyweb__CW_Credit_Limit__c, companyweb__CW_Detail_URL__c, companyweb__CW_Report_URL__c, companyweb__CW_Balance__c, companyweb__CW_Equity__c, companyweb__CW_Last_Sync__c, companyweb__CW_Revenue__c, companyweb__CW_Employees__c, companyweb__CW_Gross_Margin__c, companyweb__CW_Result__c, companyweb__CW_Warnings__c,companyweb__CW_Kyc_URL__c,companyweb__CW_Credit_Limit_Reason__c,companyweb__CW_Start_Date__c,companyweb__CW_End_Date__c,companyweb__CW_Preferred_Languages_PL__c,companyweb__CW_Avoid_Callout__c,companyweb__CW_Main_Activity__c, companyweb__CW_Activities__c, companyweb__CW_Joint_Commitees__c, companyweb__CW_Social_Security_Information__c, companyweb__CW_In_Follow_Up__c, companyweb__CW_Legal_Form__c FROM Account WHERE Id = :recordId';
                } else {
                    queryString = 'SELECT Id, companyweb__CW_Full_Name__c, companyweb__CW_Phone__c,companyweb__CW_Address_Line_1__c, companyweb__CW_Address_Line_2__c, companyweb__CW_Name__c, companyweb__CW_VAT_Number__c, companyweb__CW_VAT_Liable__c, companyweb__CW_Abbreviation__c, companyweb__CW_Company_Status__c, companyweb__CW_Score_Image__c, companyweb__CW_Score__c, companyweb__CW_Credit_Limit__c, companyweb__CW_Detail_URL__c, companyweb__CW_Report_URL__c, companyweb__CW_Balance__c, companyweb__CW_Equity__c, companyweb__CW_Last_Sync__c, companyweb__CW_Revenue__c, companyweb__CW_Employees__c, companyweb__CW_Gross_Margin__c, companyweb__CW_Result__c, companyweb__CW_Warnings__c,companyweb__CW_Kyc_URL__c,companyweb__CW_Credit_Limit_Reason__c,companyweb__CW_Start_Date__c,companyweb__CW_End_Date__c,companyweb__CW_Preferred_Languages_PL__c,companyweb__CW_Avoid_Callout__c,companyweb__CW_Main_Activity__c, companyweb__CW_Activities__c, companyweb__CW_Joint_Commitees__c, companyweb__CW_Social_Security_Information__c, companyweb__CW_In_Follow_Up__c, companyweb__CW_Legal_Form__c FROM Account WHERE Id = :recordId';
                }
            }
            when 'Lead' {
                if (leadVATAPI != null) {
                    queryString = 'SELECT Id, companyweb__CW_Full_Name__c, companyweb__CW_Phone__c,companyweb__CW_Address_Line_1__c, companyweb__CW_Address_Line_2__c, companyweb__CW_Name__c, ' + leadVATAPI + ', companyweb__CW_VAT_Liable__c, companyweb__CW_Abbreviation__c, companyweb__CW_Company_Status__c, companyweb__CW_Score_Image__c, companyweb__CW_Score__c, companyweb__CW_Credit_Limit__c, companyweb__CW_Detail_URL__c, companyweb__CW_Report_URL__c, companyweb__CW_Balance__c, companyweb__CW_Equity__c, companyweb__CW_Last_Sync__c, companyweb__CW_Revenue__c, companyweb__CW_Employees__c, companyweb__CW_Gross_Margin__c, companyweb__CW_Result__c, companyweb__CW_Warnings__c,companyweb__CW_Kyc_URL__c,companyweb__CW_Credit_Limit_Reason__c,companyweb__CW_Start_Date__c,companyweb__CW_End_Date__c,companyweb__CW_Preferred_Languages_PL__c,companyweb__CW_Avoid_Callout__c,companyweb__CW_Main_Activity__c, companyweb__CW_Activities__c, companyweb__CW_Joint_Commitees__c, companyweb__CW_Social_Security_Information__c, companyweb__CW_In_Follow_Up__c, companyweb__CW_Legal_Form__c FROM Lead WHERE Id = :recordId';
                } else {
                    queryString = 'SELECT Id, companyweb__CW_Full_Name__c, companyweb__CW_Phone__c,companyweb__CW_Address_Line_1__c, companyweb__CW_Address_Line_2__c, companyweb__CW_Name__c, companyweb__CW_VAT_Number__c, companyweb__CW_VAT_Liable__c, companyweb__CW_Abbreviation__c, companyweb__CW_Company_Status__c, companyweb__CW_Score_Image__c, companyweb__CW_Score__c, companyweb__CW_Credit_Limit__c, companyweb__CW_Detail_URL__c, companyweb__CW_Report_URL__c, companyweb__CW_Balance__c, companyweb__CW_Equity__c, companyweb__CW_Last_Sync__c, companyweb__CW_Revenue__c, companyweb__CW_Employees__c, companyweb__CW_Gross_Margin__c, companyweb__CW_Result__c, companyweb__CW_Warnings__c,companyweb__CW_Kyc_URL__c,companyweb__CW_Credit_Limit_Reason__c,companyweb__CW_Start_Date__c,companyweb__CW_End_Date__c,companyweb__CW_Preferred_Languages_PL__c,companyweb__CW_Avoid_Callout__c,companyweb__CW_Main_Activity__c, companyweb__CW_Activities__c, companyweb__CW_Joint_Commitees__c, companyweb__CW_Social_Security_Information__c, companyweb__CW_In_Follow_Up__c, companyweb__CW_Legal_Form__c FROM Lead WHERE Id = :recordId';                
                }
            }
        }

        system.debug('recordId = ' + recordId);
        system.debug('queryString = ' + queryString);

        sObject genericObject = Database.query(queryString);
        
        return genericObject;
    }

    @AuraEnabled
    public static String errorHandler(Integer errorCode){
        String errorMessage;
        switch on errorCode {
            when 101 {
                errorMessage =  System.Label.X101;  
            }   
            when 102 {      
                errorMessage =  System.Label.X102;
            }
            when 103 {  
                errorMessage =  System.Label.X103;  
            }
            when 104 {  
                errorMessage =  System.Label.X104;      
            }
            when 201 {
                errorMessage =  System.Label.X201;          
            }
            when 202 {
                errorMessage =  System.Label.X202;          
            }
            when 301 {
                errorMessage =  System.Label.X301;          
            }
            when 302 {
                errorMessage =  System.Label.X302;          
            }
            when 303 {      
                errorMessage =  System.Label.X303;  
            }
            when 304 {      
                errorMessage =  System.Label.X304;  
            }
            when 305 {      
                errorMessage =  System.Label.X305;  
            }
            when 306 {      
                errorMessage =  System.Label.X306;  
            }
            when 307 {      
                errorMessage =  System.Label.X307;  
            }
            when 308 {      
                errorMessage =  System.Label.X308;  
            }
            when 309 {      
                errorMessage =  System.Label.X309;  
            }
            when 310 {      
                errorMessage =  System.Label.X310;  
            }
            when 311 {      
                errorMessage =  System.Label.X311;  
            }
            when 401 {      
                errorMessage =  System.Label.X401;  
            }
            when 402 {      
                errorMessage =  System.Label.X402;  
            }
            when 403 {      
                errorMessage =  System.Label.X403;  
            }
            when 404 {      
                errorMessage =  System.Label.X404;  
            }
            when 405 {      
                errorMessage =  System.Label.X405;  
            }
            // when 999 {      
            //     errorMessage =  System.Label.X999;  
            // }
            when else { 
                errorMessage = System.Label.X900;     
            }
        }
        system.debug('ERROR: '+errorMessage);
        return errorMessage;
    }

    @AuraEnabled
    public static Boolean addCompanyToAlerts(String vatNumber){
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c, Account_In_Follow_Up_Field__c, Lead_VAT_Number_Field__c, Lead_In_Follow_Up_Field__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

        connectCompanywebBe.RequestAddToAlerts request = new connectCompanywebBe.RequestAddToAlerts();
        request.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request.LoginHash = createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        request.VatNumber = vatNumber;
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();
        connectCompanywebBe.ResponseAddToAlerts result = httpreq.Alerts_AddCompany(request);

        System.debug('addCompanyToAlerts StatusCode: ' + result.StatusCode);

        //find Account with given VAT Number
        String accountInFollowUpAPI = !String.isEmpty(oLoginSetup.Account_In_Follow_Up_Field__c) ? oLoginSetup.Account_In_Follow_Up_Field__c : 'CW_In_Follow_Up__c';
        String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c!=null ? oLoginSetup.Account_VAT_Number_Field__c : 'companyweb__CW_VAT_Number__c';
        String qryString = 'SELECT Id, ' + AccountInFollowUpAPI + ' FROM Account WHERE ' + accountVATAPI + '=:vatNumber';
        List<Account> acc = Database.query(qryString);

        //find Lead with given VAT Number
        String leadInFollowUpAPI = !String.isEmpty(oLoginSetup.Lead_In_Follow_Up_Field__c) ? oLoginSetup.Lead_In_Follow_Up_Field__c : 'CW_In_Follow_Up__c';
        String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c!=null ? oLoginSetup.Lead_VAT_Number_Field__c : 'companyweb__CW_VAT_Number__c';
        qryString = 'SELECT Id, ' + LeadInFollowUpAPI + ' FROM Lead WHERE ' + LeadVATAPI + '=:vatNumber';
        List<Lead> lead = Database.query(qryString);
        
        if(result.StatusCode == 0){
            if(acc.size()>0){
                acc[0].put(accountInFollowUpAPI, true);
                update acc;
            }
            if(lead.size()>0){
                lead[0].put(leadInFollowUpAPI, true);
                update lead;
            }

            return true;
        } else {
            if(acc.size()>0){
                acc[0].put(accountInFollowUpAPI, false); 
                update acc;
            }
            if(lead.size()>0){
                lead[0].put(leadInFollowUpAPI, false);
                update lead;
            }
        }
        
        return false;
    }

    @AuraEnabled
    public static Boolean addCompanyListToAlerts(List<String> listViewIds){
        System.debug('addCompanyListToAlerts method');
        System.debug('param listViewIds: ' + listViewIds);
        CW_Login_Setup__mdt oLoginSetup = new CW_Login_Setup__mdt();
        oLoginSetup = [SELECT Id, CW_CompanyWebLogin__c, CW_CompanyWebPassword__c, CW_CompanyWebSecret__c, CW_ServiceIntegrator__c, Account_VAT_Number_Field__c, Account_In_Follow_Up_Field__c, Lead_VAT_Number_Field__c, Lead_In_Follow_Up_Field__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];

        String accountVATAPI = oLoginSetup.Account_VAT_Number_Field__c!=null ? oLoginSetup.Account_VAT_Number_Field__c : 'companyweb__CW_VAT_Number__c';
        String accountInFollowUpAPI = !String.isEmpty(oLoginSetup.Account_In_Follow_Up_Field__c) ? oLoginSetup.Account_In_Follow_Up_Field__c : 'CW_In_Follow_Up__c';
        String leadVATAPI = oLoginSetup.Lead_VAT_Number_Field__c!=null ? oLoginSetup.Lead_VAT_Number_Field__c : 'companyweb__CW_VAT_Number__c';
        String leadInFollowUpAPI = !String.isEmpty(oLoginSetup.Lead_In_Follow_Up_Field__c) ? oLoginSetup.Lead_In_Follow_Up_Field__c : 'CW_In_Follow_Up__c';

        String queryString = 'SELECT Id, ' + accountVATAPI + ', ' + accountInFollowUpAPI + ' FROM Account WHERE Id IN :listViewIds';
        System.debug(queryString);
        List<Account> accountList = Database.query(queryString);
        queryString = 'SELECT Id, ' + leadVATAPI + ', ' + leadInFollowUpAPI + ' FROM Lead WHERE Id IN :listViewIds';
        System.debug(queryString);
        List<Lead> leadList = Database.query(queryString);

        List<String> vatNumbersList = new List<String>();
        for(Account acc : accountList){
            vatNumbersList.add(String.valueOf(acc.get(accountVATAPI)));
        }
        for(Lead lead: leadList){
            vatNumbersList.add(String.valueOf(lead.get(leadVATAPI)));
        }

        System.debug('vatNumbersList: ' + vatNumbersList);
            
        connectCompanywebBe.ArrayOfString vatNumbers = new connectCompanywebBe.ArrayOfString();
        vatNumbers.string_x = vatNumbersList;

        connectCompanywebBe.RequestAddListToAlerts request = new connectCompanywebBe.RequestAddListToAlerts();
        request.CompanyWebLogin = oLoginSetup.CW_CompanyWebLogin__c;
        request.CompanyWebPassword = oLoginSetup.CW_CompanyWebPassword__c;
        request.ServiceIntegrator = oLoginSetup.CW_ServiceIntegrator__c;
        request.LoginHash = createCWLoginHash(oLoginSetup.CW_CompanyWebLogin__c, oLoginSetup.CW_CompanyWebPassword__c, oLoginSetup.CW_CompanyWebSecret__c);
        request.VatNumbers = vatNumbers;
        connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq = new connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap();
        connectCompanywebBe.ResponseAddListToAlerts result = httpreq.Alerts_AddListOfCompanies(request);

        if(result?.StatusCode == 0){ //check if statuscode 0 also happens if some companies were added but others were not (see count_invalids field)
            System.debug('Count_ActiveAlerts: ' + result.Count_ActiveAlerts);
            System.debug('Count_Adds: ' + result.Count_Adds);
            System.debug('Count_Updates: ' + result.Count_Updates);
            System.debug('Count_Invalids: ' + result.Count_Invalids);

            for(Account acc : accountList){
                acc.put(accountInFollowUpAPI, true);
            }
            for(Lead lead: leadList){
                lead.put(leadInFollowUpAPI, true);
            }
            update accountList;
            update leadList;

            return true;
        } else {
            System.debug('add list of companies unsuccessful: statuscode = ' + String.valueOf(result?.StatusCode) + ', message = ' + result?.StatusMessage);
        }
        return false;
    }

    //Step 1: get Change Dates
    public static Map<Integer,String> getChangeDates(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq, connectCompanywebBe.RequestStep1 request){
        //http Reponse
        connectCompanywebBe.ResponseStep1 result = new connectCompanywebBe.ResponseStep1();
        result = httpreq.Alerts_Step1_GetChangeDates(request);

        Map<Integer,String> mapOfStep2Token = new Map<Integer,String>();

        String warningsString = '';
        System.debug('getChangeDates statuscode = ' + result?.StatusCode);

        if(result!=null){
            if(result?.StatusCode == 0){
                if(result?.ChangeDates?.ChangeDate!=null){
                    for(connectCompanywebBe.ChangeDate changeDate : result.ChangeDates.ChangeDate){
                        mapOfStep2Token.put(changeDate.DateOfChange,changeDate.Step2Token);
                    }
                }
            }else{
                sendEmail('getChangeDates', result.StatusCode, result.StatusMessage);
            }
        }else{
            sendEmail('getChangeDates', null, 'No response returned');
        }
        return mapOfStep2Token;
    }

    //Step 2: get Vat List
    public static Map<Integer,String> getVatList(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq, connectCompanywebBe.RequestStep2 request){
        //http Reponse
        connectCompanywebBe.ResponseStep2 result = new connectCompanywebBe.ResponseStep2();
        if(Limits.getCallouts()<100){
            result = httpreq.Alerts_Step2_GetVatList(request);
        } else {
            System.debug('Callout limit of 100 reached');
        }
        Map<Integer,String> mapOfStep3Token = new Map<Integer,String>();

        String warningsString = '';
        //System.debug('getVatList statuscode = ' + result?.StatusCode);

        if(result!=null){
            if(result?.StatusCode == 0){
                if(result?.ChangedVatList?.ChangedVat!=null){
                    for(connectCompanywebBe.ChangedVat changedVat : result.ChangedVatList.ChangedVat){
                        mapOfStep3Token.put(changedVat.VatNumber,changedVat.Step3Token);
                    }
                }
            }else{
                sendEmail('getVatList', result.StatusCode, result.StatusMessage);
            }
        }else{
            sendEmail('getVatList', null, 'No response returned');
        }
        return mapOfStep3Token;
    }

    //Step 3: get Company Data
    public static connectCompanywebBe.CompanyResponseV1_5 getCompanyData(connectCompanywebBe.BasicHttpBinding_AlacarteServiceV1_6_soap httpreq, connectCompanywebBe.RequestStep3_CompanyOnVat request){
        //http Reponse
        connectCompanywebBe.ResponseCompanyByVatV1_5 result = new connectCompanywebBe.ResponseCompanyByVatV1_5();
        if(Limits.getCallouts()<100){
            result = httpreq.Alerts_Step3_CompanyOnVat(request);
        } else {
            System.debug('Callout limit of 100 reached');
        }
        
        String warningsString = '';
        //System.debug('getCompanyData statuscode = ' + result.StatusCode);

        if(result!=null){
            if(result?.StatusCode == 0){
                return result.CompanyResponse;
            }else{
                sendEmail('getCompanyData', result.StatusCode, result.StatusMessage);
            }
        }else{
            sendEmail('getCompanyData', null, 'No response returned');
        }
        return null;
    }

    public static void updateCompanyByResponse(CW_Login_Setup__mdt oLoginSetup, connectCompanywebBe.CompanyResponseV1_5 companyData, List<Account> listOfAccountsToUpdate, List<Lead> listOfLeadsToUpdate){
        String vatNumber = String.valueOf(companyData.VatNumber.Value);
        String qryString;

        //find Account with given VAT Number
        if(oLoginSetup.Account_VAT_Number_Field__c != null){
            qryString = 'SELECT Id FROM Account WHERE ' + oLoginSetup.Account_VAT_Number_Field__c + ' =:vatNumber';
        } else {
            qryString = 'SELECT Id FROM Account WHERE CW_Vat_Number__c =: vatNumber';
        }
        List<Account> accounts = Database.query(qryString);

        //find Lead with given VAT Number
        if(oLoginSetup.Lead_VAT_Number_Field__c != null){
            qryString = 'SELECT Id FROM Lead WHERE ' + oLoginSetup.Lead_VAT_Number_Field__c + ' =:vatNumber';
        } else {
            qryString = 'SELECT Id FROM Lead WHERE CW_Vat_Number__c =: vatNumber';
        }
        List<Lead> leads = Database.query(qryString);

        assignDynamicMappingFields(oLoginSetup);

        connectCompanywebBe.ResponseCompanyByVatV1_5 result = new connectCompanywebBe.ResponseCompanyByVatV1_5();
        result.CompanyResponse = companyData;

        if(accounts.size()>0){
            for(Account acc: accounts){
                System.debug('Found account to update: ' + acc.Id);
                assignAccountFields(acc, result, false);
                listOfAccountsToUpdate.add(acc);
            }
        }
        if(leads.size()>0){
            for(Lead lead: leads){
                System.debug('Found lead to update: ' + lead.Id);
                assignLeadFields(lead, result, false);
                listOfLeadsToUpdate.add(lead);
            }
        }
    }

    public static void updateCompanyOperation(List<Account> listOfAccountsToUpdate, List<Lead> listOfLeadsToUpdate){
        if(!listOfAccountsToUpdate.isEmpty()){
            //update accounts
            System.debug(listOfAccountsToUpdate);
            Database.SaveResult[] srl = Database.update(listOfAccountsToUpdate, false);
            System.debug('srl accounts: ' + srl);
            for(Database.SaveResult sr : srl){
                if(!sr.isSuccess()){
                    String errorMessage='';
                    for(Database.Error err : sr.getErrors()){
                        errorMessage += err.getMessage() + '. ';
                    }
                    sendEmail('updateCompanyOperation', null, errorMessage);
                }
            }
        }
        if(!listOfLeadsToUpdate.isEmpty()){
            //update leads
            System.debug(listOfLeadsToUpdate);
            Database.SaveResult[] srl = Database.update(listOfLeadsToUpdate, false);
            System.debug('srl leads: ' + srl);
            for(Database.SaveResult sr : srl){
                if(!sr.isSuccess()){
                    String errorMessage='';
                    for(Database.Error err : sr.getErrors()){
                        errorMessage += err.getMessage() + '. ';
                    }
                    sendEmail('updateCompanyOperation', null, errorMessage);
                }
            }
        }
    }

    public static void sendEmail(String methodName, Integer statusCode, String exceptionMessage){
        CW_Login_Setup__mdt oLoginSetup = [SELECT CW_API_Email_Recipient__c FROM CW_Login_Setup__mdt WHERE DeveloperName = 'CW_Login'];
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setToAddresses(new List<String>{oLoginSetup.CW_API_Email_Recipient__c});
        mail.setSenderDisplayName('Companyweb Support');
        mail.setSubject('Unexpected outcome during companyweb alerts batch');
        mail.setBccSender(false);
        mail.setUseSignature(false);

        String baseMessage = 'The following method has returned an unexpected outcome: ' + methodName + '. ';
        if(statusCode!=null){
            baseMessage += 'The Companyweb API has returned a response with the StatusCode ' + statusCode + '. ';
        }
        baseMessage += 'Summary of what went wrong during the process: ' + exceptionMessage;
        mail.setPlainTextBody(baseMessage);
        if(oLoginSetup.CW_API_Email_Recipient__c!=null && !Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }else{
            System.debug('The recipient for email is not set!');
        }
    }

    public static void assignAccountFields(Account acc, connectCompanywebBe.ResponseCompanyByVatV1_5 result, Boolean fromPick){
        Schema.DisplayType dt, dtAccountVAT, dtAccountScore, dtAccountActivities, dtAccountCreditLimit, dtAccountJointCommiteesBlue, dtAccountJointCommiteesWhite, dtAccountLegalForm, dtAccountMainActivity, dtAccountNumberEmployees, dtAccountSocialSecurity, dtAccountPhone, dtAccountAnnualRevenue;
        String warningsString = '';

        /* Schema.DisplayType dt; */
        if(accountVATAPI != null){
            dtAccountVAT = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountVATAPI).getDescribe().getType();
        }
            
        if(accountScoreAPI != null){
            dtAccountScore = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountScoreAPI).getDescribe().getType();
        }

        if(accountActivitiesAPI != null){
            dtAccountActivities = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountActivitiesAPI).getDescribe().getType();
        }

        if(accountCreditLimitAPI != null){
            dtAccountCreditLimit = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountCreditLimitAPI).getDescribe().getType();
        }

        if(accountJointCommitieesBlueAPI != null){
            dtAccountJointCommiteesBlue = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountJointCommitieesBlueAPI).getDescribe().getType();
        }

        if(accountJointCommitieesWhiteAPI != null){
            dtAccountJointCommiteesWhite = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountJointCommitieesWhiteAPI).getDescribe().getType();
        }

        if(accountLegalFormAPI != null){
            dtAccountLegalForm = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountLegalFormAPI).getDescribe().getType();
        }

        if(accountMainActivityAPI != null){
            dtAccountMainActivity = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountMainActivityAPI).getDescribe().getType();
        }

        if(accountNumberEmployeesAPI != null){
            dtAccountNumberEmployees = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountNumberEmployeesAPI).getDescribe().getType();
        }

        if(accountSocialSecurityAPI != null){
            dtAccountSocialSecurity = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountSocialSecurityAPI).getDescribe().getType();
        }

        if(accountPhoneAPI != null){
            dtAccountPhone = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountPhoneAPI).getDescribe().getType();
        }

        if(accountAnnualRevenueAPI != null){
            dtAccountAnnualRevenue = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(accountAnnualRevenueAPI).getDescribe().getType();
        }
        
        String vatAccountFieldType,scoreFieldType,activitiesFieldType,creditLimitFieldType,joinCommiteesBlueFieldType,joinCommiteesWhiteFieldType,legalFormFieldType,mainActivityFieldType,numberEmployeesFieldType,socialSecurityFieldType,phoneFieldType,annualRevenueFieldType;

        vatAccountFieldType = String.valueOf(dtAccountVAT);
        scoreFieldType = String.valueOf(dtAccountScore);
        activitiesFieldType = String.valueOf(dtAccountActivities);
        creditLimitFieldType = String.valueOf(dtAccountCreditLimit);
        joinCommiteesBlueFieldType= String.valueOf(dtAccountJointCommiteesBlue);
        joinCommiteesWhiteFieldType= String.valueOf(dtAccountJointCommiteesWhite);
        legalFormFieldType= String.valueOf(dtAccountLegalForm);
        mainActivityFieldType= String.valueOf(dtAccountMainActivity);
        numberEmployeesFieldType= String.valueOf(dtAccountNumberEmployees);
        socialSecurityFieldType= String.valueOf(dtAccountSocialSecurity);
        phoneFieldType = String.valueOf(dtAccountPhone);
        annualRevenueFieldType = String.valueOf(dtAccountAnnualRevenue);

        System.debug('vatFieldType = ' + vatAccountFieldType);
        
        //Address
        if(result.CompanyResponse.Address.IsEnabled == True){
            if(accountStreetAPI!=null) acc.put(accountStreetAPI, result.CompanyResponse.Address.Value.Street + ' ' + result.CompanyResponse.Address.Value.HouseNumber);
            if(accountCityAPI!=null) acc.put(accountCityAPI, result.CompanyResponse.Address.Value.City);
            if(accountPostalCodeAPI!=null) acc.put(accountPostalCodeAPI, result.CompanyResponse.Address.Value.PostalCode);
            if(accountCountryCodeAPI!=null) acc.put(accountCountryCodeAPI, result.CompanyResponse.Address.Value.CountryCode);
        }else{
            acc.CW_Street__c = null;
            acc.CW_City__c = null;
            acc.CW_PostalCode__c = null;
            acc.CW_Country__c = null;
            acc.CW_Address_Line_1__c = null;
            acc.CW_Address_Line_2__c = null;
        }

        //Company Name
        if(result.CompanyResponse.CompanyName.IsEnabled == True){
            acc.Name = result.CompanyResponse.CompanyName.Value;
            acc.CW_Name__c = result.CompanyResponse.CompanyName.Value;
        } else{
            acc.CW_Name__c = null;
        }
        //Prefered Language
        if(result.CompanyResponse.PreferredLanguages.IsEnabled == True){
            acc.CW_Preferred_Languages_PL__c = result.CompanyResponse.PreferredLanguages.Value.LanguageString;
        }else{
            acc.CW_Preferred_Languages_PL__c = null;
        }
        //VAT Number
        if(result.CompanyResponse.VatNumber.IsEnabled = True){
            if(fromPick) {
                acc.CW_VAT_Number__c = String.valueOf(result.CompanyResponse.VatNumber.Value);
                if (accountVATAPI != null) {
                        if (vatAccountFieldType != 'String') {
                        acc.put(accountVATAPI, result.CompanyResponse.VatNumber.Value);
                    } else {
                        acc.put(accountVATAPI, String.valueOf(result.CompanyResponse.VatNumber.Value));
                    }
                }
            } else {
                if (accountVATAPI != null) {
                    acc.CW_VAT_Number__c = String.valueOf(result.CompanyResponse.VatNumber.Value);
                }
            }                   
        }else{
            acc.CW_VAT_Number__c = null;
            if(accountVatAPI != null){
                acc.put(accountVATAPI, null);
            }
        }

        //VAT NumberEnabled
        if(result.CompanyResponse.VatEnabled.IsEnabled = True){
            acc.CW_VAT_Liable__c = result.CompanyResponse.VatEnabled.Value;
        } else{
            acc.CW_VAT_Liable__c = false; 
        }
        //Phone number
        if(result.CompanyResponse.TelephoneNumber.IsEnabled == True){
            if (accountPhoneAPI != null) {
                if (phoneFieldType != 'String') {
                    acc.put(accountPhoneAPI, result.CompanyResponse.TelephoneNumber.Value);
                } else {
                    acc.put(accountPhoneAPI, String.valueOf(result.CompanyResponse.TelephoneNumber.Value));
                }
            } else {
                acc.CW_Phone__c = result.CompanyResponse.TelephoneNumber.Value;
            }
        }else{
            acc.CW_Phone__c = null;
            if(accountPhoneAPI != null){
                acc.put(accountPhoneAPI, null);
            }
        }
        //Legal form
        if(result.CompanyResponse.LegalForm.IsEnabled == True){
            acc.CW_Legal_Form__c = String.valueOf(result.CompanyResponse.LegalForm.Value.Abbreviation);
            acc.CW_Abbreviation__c = String.valueOf(result.CompanyResponse.LegalForm.Value.Abbreviation);
            if (legalFormFieldType != null) {
                acc.put(accountLegalFormAPI, String.valueOf(result.CompanyResponse.LegalForm.Value.Abbreviation));
            }
        } else{
            if (legalFormFieldType != null) {
                acc.put(accountLegalFormAPI, null);
            }
            acc.CW_Abbreviation__c = null;
            acc.CW_Legal_Form__c = null;
        }
        //Company Status 
        if(result.CompanyResponse.CompanyStatus.IsEnabled == True){
            acc.CW_Company_Status__c = result.CompanyResponse.CompanyStatus.Value.info;
        }
        else{
            acc.CW_Company_Status__c = null;
        }
        //Start Date 
        if(result.CompanyResponse.StartDate.IsEnabled == True){
            if(result.CompanyResponse.StartDate.Value != 0){
                String sStartDate = String.ValueOf(result.CompanyResponse.StartDate.Value);
                String fStartDate = sStartDate.right(2)+ '/' +sStartDate.mid(4,2) +'/'+ sStartDate.left(4);
                acc.CW_Start_Date__c = date.parse(fStartDate); 
            } else {
                acc.CW_Start_Date__c = null; 
            }
        }else{
            acc.CW_Start_Date__c = null; 
        }
        //End Date 
        if(result.CompanyResponse.EndDate.IsEnabled == True){
            if(result.CompanyResponse.EndDate.Value != 0){
                String sEndDate = String.ValueOf(result.CompanyResponse.EndDate.Value);
                String fEndDate = sEndDate.right(2)+ '/' +sEndDate.mid(4,2) +'/'+ sEndDate.left(4);
                acc.CW_End_Date__c = date.parse(fEndDate);
            } else{
                acc.CW_End_Date__c = null;
            }
        } else {
            acc.CW_End_Date__c = null;
        }

        //Score
        if(result.CompanyResponse.Score.IsEnabled == True){
            //Decimal Score
            acc.CW_Score__c = result.CompanyResponse.Score.Value.ScoreAsDecimal;
            if (accountScoreAPI != null) {
                if (scoreFieldType != 'String') {
                    acc.put(accountScoreAPI, result.CompanyResponse.Score.Value.ScoreAsDecimal);
                } else {
                    acc.put(accountScoreAPI, String.valueOf(result.CompanyResponse.Score.Value.ScoreAsDecimal));
                }
            }
            //Score Image
            acc.CW_Score_Image__c = result.CompanyResponse.Score.Value.ScoreImage;
        } else {
            acc.CW_Score__c = null;
            acc.CW_Score_Image__c = null;
            if(accountScoreAPI != null){
                acc.put(accountScoreAPI, null);
            }
        }
        
        //CreditLimit
        if(result.CompanyResponse.CreditLimit.IsEnabled == True){
            acc.CW_Credit_Limit__c= result.CompanyResponse.CreditLimit.Value.Limit_x;
            if (accountCreditLimitAPI != null) {
                if (creditLimitFieldType != 'String') {
                    acc.put(accountCreditLimitAPI, result.CompanyResponse.CreditLimit.Value.Limit_x);
                } else {
                    acc.put(accountCreditLimitAPI, String.valueOf(result.CompanyResponse.CreditLimit.Value.Limit_x));
                }
            }
            if (result.CompanyResponse.CreditLimit.Value.Limit_x == 0) {
                //CreditLimitReason
                acc.CW_Credit_Limit_Reason__c = result.CompanyResponse.CreditLimit.Value.Info;
            } else {
                acc.CW_Credit_Limit_Reason__c = null;
            }
        }else{
            acc.CW_Credit_Limit__c = null;
            acc.CW_Credit_Limit_Reason__c = null;
            if(accountCreditLimitAPI != null){
                acc.put(accountCreditLimitAPI, null);
            }
        }
        
        //Detail url
        if(result.CompanyResponse.DetailUrl.IsEnabled == True){
            acc.CW_Detail_URL__c = result.CompanyResponse.DetailUrl.Value;
        }else{
            acc.CW_Detail_URL__c = null;
        }
        //Report url
        if(result.CompanyResponse.ReportUrl.IsEnabled == True){
            acc.CW_Report_URL__c = result.CompanyResponse.ReportUrl.Value;
        }else{
            acc.CW_Report_URL__c = null;
        }
        //Kyc Report
        if(result.CompanyResponse.KycReportUrl.IsEnabled == True){
            acc.CW_Kyc_URL__c = result.CompanyResponse.KycReportUrl.Value;
        }else{
            acc.CW_Kyc_URL__c = null;
        }
        //Lastsync
        acc.CW_Last_Sync__c = System.now();
        //Balance
        if(result.CompanyResponse.Balances.IsEnabled == True){
            if(result.CompanyResponse.Balances.Value.Balans != null){
                //Balance Year
                acc.CW_Balance__c = String.valueOf(result.CompanyResponse.Balances.Value.Balans[0].BookYear);

                for(connectCompanywebBe.BalansData balansData : result.CompanyResponse.Balances.Value.Balans[0].BalansData.BalansData){
                    switch on balansData.Key {
                        when 'CloseDate' { //Closing date of the Financial year
                            
                        }
                        when 'Rub10_15' { //Equity
                            if (String.isNotBlank(balansData.Value)){
                                //Equity Year
                                acc.CW_Equity__c = Decimal.valueOf(balansData.Value);
                            }
                            else{
                                acc.CW_Equity__c = null;
                            }
                        }
                        when 'Rub1323' { //Workers (Blue collar workers)

                        }
                        when 'Rub1343' { //Employees (White collar workers)

                        }
                        when 'Rub70' { //Turnover
                            if (String.isNotBlank(balansData.Value)){
                                //Revenue
                                if(accountAnnualRevenueAPI != null){
                                    if (annualRevenueFieldType != 'String') {
                                        acc.put(accountAnnualRevenueAPI, Decimal.valueOf(balansData.Value));
                                    } else {
                                        acc.put(accountAnnualRevenueAPI, String.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)));
                                    }
                                } else {
                                    acc.CW_Revenue__c = Decimal.valueOf(balansData.Value);
                                }
                            }
                            else{
                                acc.CW_Revenue__c = null;
                                if(accountAnnualRevenueAPI != null){
                                    acc.put(accountAnnualRevenueAPI, null);  
                                }
                            }
                        }
                        when 'Rub9087' { //Average number of staff in FTE
                            if (String.isNotBlank(balansData.Value)){
                                //# Employees
                                //acc.NumberOfEmployees = Integer.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)); 
            
                                if (accountNumberEmployeesAPI != null) {
                                    if (numberEmployeesFieldType != 'String') {
                                        acc.put(accountNumberEmployeesAPI, Integer.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)));
                                    } else {
                                        acc.put(accountNumberEmployeesAPI, balansData.Value);
                                    }
                                } else{
                                    acc.CW_Employees__c = Decimal.valueOf(balansData.Value);
                                }
                            }
                            else{
                                acc.CW_Employees__c = null;
                                //acc.NumberOfEmployees = null;
                                if(accountNumberEmployeesAPI != null){
                                    acc.put(accountNumberEmployeesAPI, null);  
                                }
                            }
                        }
                        when 'Rub9800' { //Gross Margin
                            if (String.isNotBlank(balansData.Value)){
                                //Gross margin
                                acc.CW_Gross_Margin__c = Decimal.valueOf(balansData.Value);
                            }
                            else{
                                acc.CW_Gross_Margin__c = null;
                            }
                        }
                        when 'Rub9904' { //Profit/Loss of the book year
                            if (String.isNotBlank(balansData.Value)){
                                //Result
                                acc.CW_Result__c = Decimal.valueOf(balansData.Value);
                            }
                            else{
                                acc.CW_Result__c = null;
                            }
                        }
                        when else {
                            System.debug('unfamiliar balansdata, companyweb service added new values...');
                        }
                    }
                }
            } else{
                acc.CW_Balance__c = null;
                acc.CW_Equity__c = null;
                acc.CW_Revenue__c = null;
                acc.CW_Employees__c = null;
                acc.CW_Gross_Margin__c = null;
                acc.CW_Result__c = null; 
            }
        }else{
            acc.CW_Balance__c = null;
            acc.CW_Equity__c = null;
            acc.CW_Revenue__c = null;
            acc.CW_Employees__c = null;
            acc.CW_Gross_Margin__c = null;
            acc.CW_Result__c = null;
        }
        
        //Warnings
        if(result.CompanyResponse.WarningsOverview.IsEnabled == True){
            if (result.CompanyResponse.WarningsOverview.Value.Warnings.string_x != null) {
                System.debug('string_x = ' + result.CompanyResponse.WarningsOverview.Value.Warnings.string_x);
                warningsString = '<ul>';
                for (String warning : result.CompanyResponse.WarningsOverview.Value.Warnings.string_x) {
                    //add warnings to a string
                    System.debug('warning = ' + warning);
                    warningsString += '<li>';
                    warningsString += warning;
                    warningsString += '</li>';
                }
                warningsString += '</ul>';
                acc.CW_Warnings__c = warningsString;
                System.debug('warningsString = ' + warningsString);
            }
        }else {
            acc.CW_Warnings__c = null;
        }
        
        //Social Security
        if(result.CompanyResponse.SocialSecurityInformation.IsEnabled == True){
            String delimiter = '-';
            String socialSecurityNumberPart1 = String.ValueOf(result.CompanyResponse.SocialSecurityInformation.Value.RegistrationId).substringBefore(delimiter);
            String socialSecurityNumberPart2 = String.ValueOf(result.CompanyResponse.SocialSecurityInformation.Value.RegistrationId).substringAfter(delimiter);

            String fullSocialSecurityNumber = socialSecurityNumberPart1+socialSecurityNumberPart2;
            
            if (accountSocialSecurityAPI != null) {
                if (socialSecurityFieldType != 'String') {
                    acc.put(accountSocialSecurityAPI, fullSocialSecurityNumber);
                } else {
                    acc.put(accountSocialSecurityAPI, fullSocialSecurityNumber);
                }
            } 
        } else {
            //acc.CW_Social_Security_Information__c = null;
            if(accountSocialSecurityAPI != null){
                acc.put(accountSocialSecurityAPI, null);
            }
        }


        //Join Commitees
        if(result.CompanyResponse.JointCommitees.IsEnabled == True){
            Integer JointCommiteeArraySize;
            String JointCommiteeFieldConcatBlue = ''; 
            String JointCommiteeFieldConcatWhite = '';

            if(result.CompanyResponse.JointCommitees.Value.JointCommitee != null){

                JointCommiteeArraySize = result.CompanyResponse.JointCommitees.Value.JointCommitee.size();

                for (Integer i = 0; i < JointCommiteeArraySize; i++) {
                    if(result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code >= 100 && result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code < 200){
                        JointCommiteeFieldConcatBlue  = JointCommiteeFieldConcatBlue + result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code +' - '+result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Description+'\n';
                    } else{
                        JointCommiteeFieldConcatWhite  = JointCommiteeFieldConcatWhite + result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code +' - '+result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Description+'\n';
                    }        
                }

                if (accountJointCommitieesBlueAPI != null) {
                    if (joinCommiteesBlueFieldType != 'String') {
                        acc.put(accountJointCommitieesBlueAPI, String.ValueOf(JointCommiteeFieldConcatBlue));
                        } else {
                            acc.put(accountJointCommitieesBlueAPI, JointCommiteeFieldConcatBlue);
                        }
                }

                if(accountJointCommitieesWhiteAPI != null){
                    if (joinCommiteesWhiteFieldType != 'String') {
                        acc.put(accountJointCommitieesWhiteAPI, String.ValueOf(JointCommiteeFieldConcatWhite));
                        } else {
                            acc.put(accountJointCommitieesWhiteAPI, JointCommiteeFieldConcatWhite);
                        }
                }
            }
        } else {

            if(accountJointCommitieesBlueAPI != null){
                acc.put(accountJointCommitieesBlueAPI, null);
            } 

            if(accountJointCommitieesWhiteAPI != null){
                acc.put(accountJointCommitieesWhiteAPI, null);
            } 
        }

        //Avoid call out
        acc.CW_Avoid_Callout__c = false;
    }

    public static void assignLeadFields(Lead lead, connectCompanywebBe.ResponseCompanyByVatV1_5 result, Boolean fromPick){
        Schema.DisplayType dt, dtLeadVAT, dtLeadScore, dtLeadActivities, dtLeadCreditLimit, dtLeadJointCommiteesBlue, dtLeadJointCommiteesWhite, dtLeadLegalForm, dtLeadMainActivity, dtLeadNumberEmployees, dtLeadSocialSecurity, dtLeadPhone, dtLeadAnnualRevenue, dtLeadWorkers, dtLeadEmployees;
        String warningsString = '';
        String vatFieldType = String.valueOf(dt);
                        
        /* Schema.DisplayType dt; */
        if(leadVATAPI != null){
            dtLeadVAT = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadVATAPI).getDescribe().getType();
        }
        
        if(leadScoreAPI != null){
            dtLeadScore = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadScoreAPI).getDescribe().getType();
        }

        if(leadActivitiesAPI != null){
            dtLeadActivities = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadActivitiesAPI).getDescribe().getType();
        }

        if(leadCreditLimitAPI != null){
            dtLeadCreditLimit = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadCreditLimitAPI).getDescribe().getType();
        }

        if(leadJointCommitieesBlueAPI != null){
            dtLeadJointCommiteesBlue = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadJointCommitieesBlueAPI).getDescribe().getType();
        }

        if(leadJointCommitieesWhiteAPI != null){
            dtLeadJointCommiteesWhite = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadJointCommitieesWhiteAPI).getDescribe().getType();
        }

        if(leadLegalFormAPI != null){
            dtLeadLegalForm = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadLegalFormAPI).getDescribe().getType();
        }

        if(leadMainActivityAPI != null){
            dtLeadMainActivity = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadMainActivityAPI).getDescribe().getType();
        }

        if(leadNumberEmployeesAPI != null){
            dtLeadNumberEmployees = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadNumberEmployeesAPI).getDescribe().getType();
        }

        if(leadSocialSecurityAPI != null){
            dtLeadSocialSecurity = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadSocialSecurityAPI).getDescribe().getType();
        }

        if(leadPhoneAPI != null){
            dtLeadPhone = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadPhoneAPI).getDescribe().getType();
        }

        if(leadAnnualRevenueAPI != null){
            dtLeadAnnualRevenue = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadAnnualRevenueAPI).getDescribe().getType();
        }

        if(leadWorkersAPI != null){
            dtLeadWorkers = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadWorkersAPI).getDescribe().getType();
        }
        
        if(leadEmployeesAPI != null){
            dtLeadEmployees = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get(leadEmployeesAPI).getDescribe().getType();
        }

        String vatLeadFieldType, scoreFieldType, activitiesFieldType,creditLimitFieldType,joinCommiteesBlueFieldType,joinCommiteesWhiteFieldType,legalFormFieldType,mainActivityFieldType,numberEmployeesFieldType,socialSecurityFieldType,phoneFieldType,annualRevenueFieldType, workersFieldType, employeesFieldType;

        vatLeadFieldType = String.valueOf(dtLeadVAT);
        scoreFieldType = String.valueOf(dtLeadScore);
        activitiesFieldType = String.valueOf(dtLeadActivities);
        creditLimitFieldType = String.valueOf(dtLeadCreditLimit);
        joinCommiteesBlueFieldType= String.valueOf(dtLeadJointCommiteesBlue);
        joinCommiteesWhiteFieldType= String.valueOf(dtLeadJointCommiteesWhite);
        legalFormFieldType= String.valueOf(dtLeadLegalForm);
        mainActivityFieldType= String.valueOf(dtLeadMainActivity);
        numberEmployeesFieldType= String.valueOf(dtLeadNumberEmployees);
        socialSecurityFieldType= String.valueOf(dtLeadSocialSecurity);
        phoneFieldType = String.valueOf(dtLeadPhone);
        annualRevenueFieldType = String.valueOf(dtLeadAnnualRevenue);
        workersFieldType = String.valueOf(dtLeadWorkers);
        employeesFieldType = String.valueOf(dtLeadEmployees);

        System.debug('vatFieldType = ' + vatLeadFieldType);
        System.debug('vatFieldType = ' + vatFieldType);
        
        //Address
        if(result.CompanyResponse.Address.IsEnabled == True){
            if(leadStreetAPI!=null) lead.put(leadStreetAPI, result.CompanyResponse.Address.Value.Street + ' ' + result.CompanyResponse.Address.Value.HouseNumber);
            if(leadCityAPI!=null) lead.put(leadCityAPI, result.CompanyResponse.Address.Value.City);
            if(leadPostalCodeAPI!=null) lead.put(leadPostalCodeAPI, result.CompanyResponse.Address.Value.PostalCode);
            if(leadCountryCodeAPI!=null) lead.put(leadCountryCodeAPI, result.CompanyResponse.Address.Value.CountryCode);
        } 
        //else {
        //     lead.CW_Street__c = null;
        //     lead.CW_City__c = null;
        //     lead.CW_PostalCode__c = null; 
        //     lead.CW_Country__c = null;
        //     lead.CW_Address_Line_1__c = null; 
        //     lead.CW_Address_Line_2__c = null;
        // }

        //Lead Name
        if(result.CompanyResponse.CompanyName.IsEnabled == True){
            lead.Company = result.CompanyResponse.CompanyName.Value;
            lead.CW_Name__c = result.CompanyResponse.CompanyName.Value;
        } else {
            lead.CW_Name__c = null;
        }

        //Prefered Language
        if(result.CompanyResponse.PreferredLanguages.IsEnabled == True){
            lead.CW_Preferred_Languages_PL__c = result.CompanyResponse.PreferredLanguages.Value.LanguageString;
        } else {
            lead.CW_Preferred_Languages_PL__c = null;
        }
        //VAT Number
        if(result.CompanyResponse.VatNumber.IsEnabled = True){
            if(fromPick) {
                lead.CW_VAT_Number__c = String.valueOf(result.CompanyResponse.VatNumber.Value);
                if (leadVATAPI != null) {
                    if (vatFieldType != 'String') {
                        lead.put(leadVATAPI, result.CompanyResponse.VatNumber.Value);
                    } else {
                        lead.put(leadVATAPI, String.valueOf(result.CompanyResponse.VatNumber.Value));
                    }
                }
            } else {
                if (leadVATAPI != null) {
                    lead.CW_VAT_Number__c = String.valueOf(result.CompanyResponse.VatNumber.Value);
                }
            }                   
        }
        
        //VAT NumberEnabled
        if(result.CompanyResponse.VatEnabled.IsEnabled = True){
            lead.CW_VAT_Liable__c = result.CompanyResponse.VatEnabled.Value;
        } else {
            lead.CW_VAT_Liable__c = false;
        }
        //Phone number
        if(result.CompanyResponse.TelephoneNumber.IsEnabled == True){
            if(leadPhoneAPI != null){
                if(phoneFieldType != 'String'){
                    lead.put(leadPhoneAPI, result.CompanyResponse.TelephoneNumber.Value);
                } else {
                    lead.put(leadPhoneAPI, String.ValueOf(result.CompanyResponse.TelephoneNumber.Value));
                }
            } else {
                lead.CW_Phone__c = result.CompanyResponse.TelephoneNumber.Value;
            }
        }
        //Legal form
        if(result.CompanyResponse.LegalForm.IsEnabled == True){
            if(leadLegalFormAPI != null){
                lead.put(leadLegalFormAPI, result.CompanyResponse.LegalForm.Value.Abbreviation);
            }
            lead.CW_Legal_Form__c = result.CompanyResponse.LegalForm.Value.Abbreviation;
            lead.CW_Abbreviation__c = result.CompanyResponse.LegalForm.Value.Abbreviation;
        } else {
            if(leadLegalFormAPI != null){
                lead.put(leadLegalFormAPI, null);
            }
            lead.CW_Legal_Form__c = null;
            lead.CW_Abbreviation__c = null;
        }
        // Company status
        if(result.CompanyResponse.CompanyStatus.IsEnabled == True){ 
            lead.CW_Company_Status__c = result.CompanyResponse.CompanyStatus.Value.info;
        } else {
            lead.CW_Company_Status__c = null;
        }
        //Start Date 
        if(result.CompanyResponse.StartDate.IsEnabled == True){ 
            if(result.CompanyResponse.StartDate.Value != 0){
                String sStartDate = String.ValueOf(result.CompanyResponse.StartDate.Value);
                String fStartDate = sStartDate.right(2)+ '/' +sStartDate.mid(4,2) +'/'+ sStartDate.left(4);
                lead.CW_Start_Date__c = date.parse(fStartDate);
            }
            else{
                lead.CW_Start_Date__c = null;
            }
        }else{
            lead.CW_Start_Date__c = null;
        }
        //End Date 
        if(result.CompanyResponse.EndDate.IsEnabled == True){
            if(result.CompanyResponse.EndDate.Value != 0){
                String sEndDate = String.ValueOf(result.CompanyResponse.EndDate.Value);
                String fEndDate = sEndDate.right(2)+ '/' +sEndDate.mid(4,2) +'/'+ sEndDate.left(4);
                lead.CW_End_Date__c = date.parse(fEndDate);
            } else{
                lead.CW_End_Date__c = null;
            }
        }else{
            lead.CW_End_Date__c = null;
        }

        //TF
        //Score
        if(result.CompanyResponse.Score.IsEnabled == True){
            //Decimal Score
            lead.CW_Score__c = result.CompanyResponse.Score.Value.ScoreAsDecimal;
            if (leadScoreAPI != null) {
                if (scoreFieldType != 'String') {
                    lead.put(leadScoreAPI, result.CompanyResponse.Score.Value.ScoreAsDecimal);
                } else {
                    lead.put(leadScoreAPI, String.valueOf(result.CompanyResponse.Score.Value.ScoreAsDecimal));
                }
            }
            //Score Image
            lead.CW_Score_Image__c = result.CompanyResponse.Score.Value.ScoreImage;
        } else {
            lead.CW_Score__c = null;
            lead.CW_Score_Image__c = null;
            if(leadScoreAPI != null){
                lead.put(leadScoreAPI, null);
            }
        }
        
        //CreditLimit
        if(result.CompanyResponse.CreditLimit.IsEnabled == True){
            lead.CW_Credit_Limit__c= result.CompanyResponse.CreditLimit.Value.Limit_x;
            if (leadCreditLimitAPI != null) {
                if (creditLimitFieldType != 'String') {
                    lead.put(leadCreditLimitAPI, result.CompanyResponse.CreditLimit.Value.Limit_x);
                } else {
                    lead.put(leadCreditLimitAPI, String.valueOf(result.CompanyResponse.CreditLimit.Value.Limit_x));
                }
            }
            if (result.CompanyResponse.CreditLimit.Value.Limit_x == 0) {
                //CreditLimitReason
                lead.CW_Credit_Limit_Reason__c = result.CompanyResponse.CreditLimit.Value.Info;
            } else {
                lead.CW_Credit_Limit_Reason__c = null;
            }
        }else{
            lead.CW_Credit_Limit__c = null;
            lead.CW_Credit_Limit_Reason__c = null;
            if(leadCreditLimitAPI != null){
                lead.put(leadCreditLimitAPI, null);
            }
        }
        //TF


        /*if(result.CompanyResponse.Score.IsEnabled == True){
            //Decimal Score
            lead.CW_Score__c = result.CompanyResponse.Score.Value.ScoreAsDecimal;
            
            //Score Image
            if (leadScoreAPI != null) {
                if (scoreFieldType != 'String') {
                    lead.put(leadScoreAPI, result.CompanyResponse.Score.Value.ScoreAsDecimal);
                } else {
                    lead.put(leadScoreAPI, String.valueOf(result.CompanyResponse.Score.Value.ScoreAsDecimal));
                }
            }
        } else {
            lead.CW_Score__c = null;
            lead.CW_Score_Image__c = null;
        }
        //CreditLimit
        if(result.CompanyResponse.CreditLimit.IsEnabled == True){
            if (leadCreditLimitAPI != null) {
                if (creditLimitFieldType != 'String') {
                    lead.put(leadCreditLimitAPI, result.CompanyResponse.CreditLimit.Value.Limit_x);
                } else {
                    lead.put(leadCreditLimitAPI, String.valueOf(result.CompanyResponse.CreditLimit.Value.Limit_x));
                }
            }
            
            if (result.CompanyResponse.CreditLimit.Value.Limit_x == 0) {
                //CreditLimitReason
                lead.CW_Credit_Limit_Reason__c = result.CompanyResponse.CreditLimit.Value.Info;
            } else {
                lead.CW_Credit_Limit_Reason__c = null;
            }
        }else{
            lead.CW_Credit_Limit__c = null;
            lead.CW_Credit_Limit_Reason__c = null;
        }*/

        //Detail url
        if(result.CompanyResponse.DetailUrl.IsEnabled == True){
            lead.CW_Detail_URL__c = result.CompanyResponse.DetailUrl.Value;
        } else {
            lead.CW_Detail_URL__c = null;
        }
        //Report url
        if(result.CompanyResponse.ReportUrl.IsEnabled == True){
            lead.CW_Report_URL__c = result.CompanyResponse.ReportUrl.Value;
        } else {
            lead.CW_Report_URL__c = null;
        }
        //Kyc Report
        if(result.CompanyResponse.KycReportUrl.IsEnabled == True){
            lead.CW_Kyc_URL__c = result.CompanyResponse.KycReportUrl.Value;
        } else {
            lead.CW_Kyc_URL__c = null;
        }
        //Lastsync
        lead.CW_Last_Sync__c = System.now();
        //Balance
        if(result.CompanyResponse.Balances.IsEnabled == True){
            if(result.CompanyResponse.Balances.Value.Balans != null){
                //Balance Year
                lead.CW_Balance__c = String.valueOf(result.CompanyResponse.Balances.Value.Balans[0].BookYear);

                for(connectCompanywebBe.BalansData balansData : result.CompanyResponse.Balances.Value.Balans[0].BalansData.BalansData){
                    switch on balansData.Key {
                        when 'CloseDate' { //Closing date of the Financial year
                            
                        }
                        when 'Rub10_15' { //Equity
                            if (String.isNotBlank(balansData.Value)){
                                //Equity
                                lead.CW_Equity__c = Decimal.valueOf(balansData.Value);
                            }else{
                                lead.CW_Equity__c = null;
                            }
                        }
                        when 'Rub1323' { //Workers (Blue collar workers)
                            if (String.isNotBlank(balansData.Value)){
                                //Workers
                                if(leadWorkersAPI != null){
                                    if (workersFieldType != 'String') {
                                        lead.put(leadWorkersAPI, Decimal.valueOf(String.valueOf(balansData.Value)));
                                    } else {
                                        lead.put(leadWorkersAPI, Decimal.valueOf(balansData.Value));
                                    }
                                } else {
                                    lead.CW_Joint_Commitees_Blue_Collar__c = String.valueOf(balansData.Value);
                                }
                            }else{
                                lead.CW_Joint_Commitees_Blue_Collar__c = null;
                            }
                        }
                        when 'Rub1343' { //Employees (White collar workers)
                            if (String.isNotBlank(balansData.Value)){
                                //Employees
                                if(leadEmployeesAPI != null){
                                    if (employeesFieldType != 'String') {
                                        lead.put(leadEmployeesAPI, Decimal.valueOf(String.valueOf(balansData.Value)));
                                    } else {
                                        lead.put(leadEmployeesAPI, Decimal.valueOf(balansData.Value));
                                    }
                                } else {
                                    lead.CW_Joint_Commitees_White_Collar__c = String.valueOf(balansData.Value);
                                }
                            }else{
                                lead.CW_Joint_Commitees_White_Collar__c = null;
                            }
                        }
                        when 'Rub70' { //Turnover
                            if (String.isNotBlank(balansData.Value)){
                                //Revenue
                                if(leadAnnualRevenueAPI != null){
                                    if (annualRevenueFieldType != 'String') {
                                        lead.put(leadAnnualRevenueAPI, Decimal.valueOf(balansData.Value));
                                    } else {
                                        lead.put(leadAnnualRevenueAPI, Integer.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)));
                                    }
                                } else {
                                    lead.CW_Revenue__c = Decimal.valueOf(balansData.Value);
                                }
                            }else{
                                lead.CW_Revenue__c = null;
                            }
                        }
                        when 'Rub9087' { //Average number of staff in FTE
                            if (String.isNotBlank(balansData.Value)){
                                //# Employees
                                //lead.NumberOfEmployees = Integer.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)); 
                                if (leadNumberEmployeesAPI != null) {
                                    if (numberEmployeesFieldType != 'String') {
                                        lead.put(leadNumberEmployeesAPI, Integer.valueOf(Decimal.valueOf(balansData.Value).round(RoundingMode.HALF_UP)));
                                    } else {
                                        lead.put(leadNumberEmployeesAPI, balansData.Value);
                                    }
                                } else {
                                    lead.CW_Employees__c = Decimal.valueOf(balansData.Value);
                                }
                            }else{
                                lead.CW_Employees__c = null;
                            }
                        }
                        when 'Rub9800' { //Gross Margin
                            if (String.isNotBlank(balansData.Value)){
                                //Gross margin
                                lead.CW_Gross_Margin__c = Decimal.valueOf(balansData.Value);
                            }else{
                                lead.CW_Gross_Margin__c = null;
                            }
                        }
                        when 'Rub9904' { //Profit/Loss of the book year
                            if (String.isNotBlank(balansData.Value)){
                                //Result
                                lead.CW_Result__c = Decimal.valueOf(balansData.Value);
                            }else{
                                lead.CW_Result__c = null;
                            }
                        }
                        when else {
                            System.debug('unfamiliar balansdata, companyweb service added new values...');
                        }
                    }
                }
            } else {
                lead.CW_Balance__c = null;
                lead.CW_Equity__c = null;
                lead.CW_Revenue__c = null;
                lead.CW_Employees__c = null;
                lead.CW_Gross_Margin__c = null;
                lead.CW_Result__c = null;
            }
        } else {
            lead.CW_Balance__c = null;
            lead.CW_Equity__c = null;
            lead.CW_Revenue__c = null;
            lead.CW_Employees__c = null;
            lead.CW_Gross_Margin__c = null;
            lead.CW_Result__c = null;
        }
        //Warnings
        if(result.CompanyResponse.WarningsOverview.IsEnabled == True){
            if (result.CompanyResponse.WarningsOverview.Value.Warnings.string_x != null) {
                System.debug('string_x = ' + result.CompanyResponse.WarningsOverview.Value.Warnings.string_x);
                warningsString = '<ul>';
                for (String warning : result.CompanyResponse.WarningsOverview.Value.Warnings.string_x) {
                    //add warnings to a string
                    System.debug('warning = ' + warning);
                    warningsString += '<li>';
                    warningsString += warning;
                    warningsString += '</li>';
                }
                warningsString += '</ul>';
                lead.CW_Warnings__c = warningsString;
                System.debug('warningsString = ' + warningsString);
            }
        } else {
            lead.CW_Warnings__c= null;
        }

        //Social Security
        if(result.CompanyResponse.SocialSecurityInformation.IsEnabled == True){
            String delimiter = '-';
            String socialSecurityNumberPart1 = String.ValueOf(result.CompanyResponse.SocialSecurityInformation.Value.RegistrationId).substringBefore(delimiter);
            String socialSecurityNumberPart2 = String.ValueOf(result.CompanyResponse.SocialSecurityInformation.Value.RegistrationId).substringAfter(delimiter);

            String fullSocialSecurityNumber = socialSecurityNumberPart1+socialSecurityNumberPart2;
            
            lead.CW_Social_Security_Information__c = fullSocialSecurityNumber;
            
            if (leadSocialSecurityAPI != null) {
                if (socialSecurityFieldType != 'String') {
                    lead.put(leadSocialSecurityAPI, fullSocialSecurityNumber);
                } else {
                    lead.put(leadSocialSecurityAPI, fullSocialSecurityNumber);
                }
            } 
        } else {
            lead.CW_Social_Security_Information__c = null;
            if(leadSocialSecurityAPI != null){
                lead.put(leadSocialSecurityAPI, null);
            }
        }

        //Main Activity
        if(result.CompanyResponse.MainActivity.IsEnabled == True){
            lead.CW_Main_Activity__c = String.ValueOf(result.CompanyResponse.MainActivity.Value.Description);
            if (leadMainActivityAPI != null) {
                if (mainActivityFieldType != 'String') {
                lead.put(leadMainActivityAPI, String.ValueOf(result.CompanyResponse.MainActivity.Value.Description));
                } else {
                    lead.put(leadMainActivityAPI, String.ValueOf(result.CompanyResponse.MainActivity.Value.Description));
                }
            } 
        } else {
            lead.CW_Main_Activity__c = null;
            if(leadMainActivityAPI != null){
                lead.put(leadMainActivityAPI, null);
            }
        }

        //Activities
        if(result.CompanyResponse.Activities.IsEnabled == True){
            Integer activitiesArraySize;
            String activitiesField = '';

            if(result.CompanyResponse.Activities.Value.ActivityV1_1 != null){

                activitiesArraySize = result.CompanyResponse.Activities.Value.ActivityV1_1.size();

                for (Integer i = 0; i < activitiesArraySize; i++) {
                    activitiesField = activitiesField + result.CompanyResponse.Activities.Value.ActivityV1_1[i].Description+'\n' ;
                }
                system.debug('a activitiesField Inserir ->'+ activitiesField );

                lead.CW_Activities__c = activitiesField;

                if (leadActivitiesAPI != null) {
                    if (activitiesFieldType != 'String') {
                        lead.put(leadActivitiesAPI, String.ValueOf(activitiesField));
                    } else {
                        lead.put(leadActivitiesAPI, activitiesField);                        
                    }
                }
            }
        } else {
            // lead.CW_Activities__c = null;
            if(leadActivitiesAPI != null){
                lead.put(leadActivitiesAPI, null);
            }
        }

            //Joint Commitees
            if(result.CompanyResponse.JointCommitees.IsEnabled == True){
            Integer JointCommiteeArraySize;
            String JointCommiteeFieldConcatBlue = ''; 
            String JointCommiteeFieldConcatWhite = '';

            if(result.CompanyResponse.JointCommitees.Value.JointCommitee != null){

                JointCommiteeArraySize = result.CompanyResponse.JointCommitees.Value.JointCommitee.size();

                for (Integer i = 0; i < JointCommiteeArraySize; i++) {
                    if(result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code >= 100 && result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code < 200){
                        JointCommiteeFieldConcatBlue  = JointCommiteeFieldConcatBlue + result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code +' - '+result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Description+'\n';
                    } else{
                        JointCommiteeFieldConcatWhite  = JointCommiteeFieldConcatWhite + result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Code +' - '+result.CompanyResponse.JointCommitees.Value.JointCommitee[i].Description+'\n';
                    }        
                }
                
                lead.CW_Joint_Commitees__c = JointCommiteeFieldConcatBlue;
                lead.CW_Joint_Commitees_White_Collar__c = JointCommiteeFieldConcatWhite;

                if (leadJointCommitieesBlueAPI != null) {
                    if (joinCommiteesBlueFieldType != 'String') {
                        lead.put(leadJointCommitieesBlueAPI, String.ValueOf(JointCommiteeFieldConcatBlue));
                        } else {
                            lead.put(leadJointCommitieesBlueAPI, JointCommiteeFieldConcatBlue);
                        }
                }

                if(leadJointCommitieesWhiteAPI != null){
                    if (joinCommiteesWhiteFieldType != 'String') {
                        lead.put(leadJointCommitieesWhiteAPI, String.ValueOf(JointCommiteeFieldConcatWhite));
                        } else {
                            lead.put(leadJointCommitieesWhiteAPI, JointCommiteeFieldConcatWhite);
                        }
                }
            }
        } else {
            lead.CW_Joint_Commitees__c = null;
            lead.CW_Joint_Commitees_White_Collar__c = null;
            if(leadJointCommitieesBlueAPI != null){
                lead.put(leadJointCommitieesBlueAPI, null);
            } 

            if(leadJointCommitieesWhiteAPI != null){
                lead.put(leadJointCommitieesWhiteAPI, null);
            } 
        }

        //Avoid Callout
        lead.CW_Avoid_Callout__c = false;
    }

}