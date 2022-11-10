import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
//Custom Metadata Type Configuration
const FIELDS = [
    'CW_Login_Setup__mdt.Account_VAT_Number_Field__c',
    'CW_Login_Setup__mdt.Lead_VAT_Number_Field__c'
];
//Account 
import ACCOUNT_VAT from "@salesforce/schema/Account.CW_VAT_Number__c";
import ACCOUNT_SCORE_IMAGE from "@salesforce/schema/Account.CW_Score_Image__c";
import ACCOUNT_REPORT from "@salesforce/schema/Account.CW_Report_URL__c";
import ACCOUNT_DETAIL from "@salesforce/schema/Account.CW_Detail_URL__c";
import ACCOUNT_KYC from "@salesforce/schema/Account.CW_Kyc_URL__c";
//Lead
import LEAD_VAT from "@salesforce/schema/Lead.CW_VAT_Number__c";
import LEAD_SCORE_IMAGE from "@salesforce/schema/Lead.CW_Score_Image__c";
import LEAD_REPORT from "@salesforce/schema/Lead.CW_Report_URL__c";
import LEAD_DETAIL from "@salesforce/schema/Lead.CW_Detail_URL__c";
import LEAD_KYC from "@salesforce/schema/Lead.CW_Kyc_URL__c";
//Apex methods
import getCompanyInfo from '@salesforce/apex/CompanyWebController.getCompanyInfo';
import getVATNumber from '@salesforce/apex/CompanyWebController.getVATNumber';
import searchCompaniesInfo from '@salesforce/apex/CompanyWebController.searchCompaniesInfo';
import getCWFields from '@salesforce/apex/CompanyWebController.getCWFields';
//import copyData from '@salesforce/apex/CompanyWebController.copyData';
import clearData from '@salesforce/apex/CompanyWebController.clearData';
import errorHandler from '@salesforce/apex/CompanyWebController.errorHandler';
import addCompanyToAlerts from '@salesforce/apex/CompanyWebController.addCompanyToAlerts';
//Resources
import SCORE_IMAGES from '@salesforce/resourceUrl/CWScoreImages';
//Lables
import detailsBtn from '@salesforce/label/c.Details_Button';
import addCompanyBtn from '@salesforce/label/c.AddCompany_Button';
import refreshBtn from '@salesforce/label/c.Refresh_Button';
import reportBtn from '@salesforce/label/c.Report_Button';
import searchBtn from '@salesforce/label/c.Search_Button';
import selectBtn from '@salesforce/label/c.Select_Button';
import copyBtn from '@salesforce/label/c.Copy_Button';
import clearBtn from '@salesforce/label/c.Clear_Button';
import searchTerm from '@salesforce/label/c.Term_to_search';
import kycBtn from '@salesforce/label/c.KycReport_Button';

export default class CompanyWeb_LWC extends NavigationMixin(LightningElement) {

    @api recordId;

    @api objectApiName;

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_VAT, ACCOUNT_SCORE_IMAGE, ACCOUNT_REPORT, ACCOUNT_DETAIL, ACCOUNT_KYC] })
    account;

    @wire(getRecord, { recordId: '$recordId', fields: [LEAD_VAT, LEAD_SCORE_IMAGE, LEAD_REPORT, LEAD_DETAIL, LEAD_KYC] })
    lead;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    metadatarecord;

    scoreImageUrl;
    urlPath = SCORE_IMAGES;

    @track isScoreImage = true;
    @track isEmployees = true;
    @track isEquity = true;
    @track isRevenue = true;
    @track isGrossMargin = true;
    @track isResult = true;
    @track isCreditLimit = true;
    @track isWarning = true;
    @track isDetailsURL = true;
    @track isReportURL = true;
    @track isKYCReport = true;
    @track isCreditLimitReason = false;
    @track isCompanyActive = true;
    @track isBalance = true;
    @track isAvoidCallout = false;
    @track isCompanyAvailable = false;
    @track isNameAvailable = false;
    @track isStartDateAvailable = false;
    @track isEndDateAvailable = false;
    @track isLiableAvailable = false;
    @track isFullAddressAvailable = false;
    @track isPrefLangAvailable = false;
    @track isCreditLimitAvailable = false;
    @track isInFollowUpAvailable = false;

    label = {
        detailsBtn,
        addCompanyBtn,
        refreshBtn,
        reportBtn,
        searchBtn,
        selectBtn,
        copyBtn,
        clearBtn,
        searchTerm,
        kycBtn
    };

    @track isVAT = false;

    @track isLEAD = false;

    @track reportURL;

    @track detailURL;

    @track kycURL;

    @track companies = [];

    errorMessage;

    //Custom Metadata Type Config
    get accountVATAPI() {
        return this.metadatarecord.data.fields.Account_VAT_Number_Field__c.value;
    }

    get leadVATAPI() {
        return this.metadatarecord.data.fields.Lead_VAT_Number_Field__c.value;
    }

    //Account Object
    get accountVATNumber() {
        return getFieldValue(this.account.data, ACCOUNT_VAT);
    }

    get accountScoreImage() {
        return getFieldValue(this.account.data, ACCOUNT_SCORE_IMAGE);
    }

    get accountReportURL() {
        return getFieldValue(this.account.data, ACCOUNT_REPORT);
    }

    get accountDetailURL() {
        return getFieldValue(this.account.data, ACCOUNT_DETAIL);
    }

    get accountKycURL() {
        return getFieldValue(this.account.data, ACCOUNT_KYC);
    }

    // Lead Object
    get leadVATNumber() {
        return getFieldValue(this.lead.data, LEAD_VAT);
    }

    get leadScoreImage() {
        return getFieldValue(this.lead.data, LEAD_SCORE_IMAGE);
    }

    get leadReportURL() {
        return getFieldValue(this.lead.data, LEAD_REPORT);
    }

    get leadDetailURL() {
        return getFieldValue(this.lead.data, LEAD_DETAIL);
    }

    get leadKycURL() {
        return getFieldValue(this.lead.data, LEAD_KYC);
    }

    renderedCallback() {
        console.log('renderedCallback Method');

        getCWFields({ 'recordId': this.recordId, 'objectName': this.objectApiName })
        //getCWFields({ 'recordId': this.recordId, 'objectName': 'Account' })
            .then(result => {
                //console.log('result REPONSE ' + JSON.stringify(result));

                let vStatus = this.checkVisibility(result);
                console.log('vStatus = ' + JSON.stringify(vStatus));
                console.log('vStatus-ScoreImage = ' + vStatus['ScoreImage']);

                this.isScoreImage = vStatus['ScoreImage'];
                this.isKYCReport = vStatus['KYCReport'];
                this.isDetailsURL = vStatus['DetailsURL'];
                this.isReportURL = vStatus['ReportURL'];
                this.isEquity = vStatus['Equity'];
                this.isRevenue = vStatus['Revenue'];
                this.isEmployees = vStatus['Employees'];
                this.isGrossMargin = vStatus['GrossMargin'];
                this.isResult = vStatus['Result'];
                this.isCompanyActive = vStatus['CompanyActive'];
                this.isCreditLimit = vStatus['CreditLimit'];
                this.isCreditLimitReason = vStatus['CreditLimitReason'];
                this.isWarning = vStatus['Warning'];
                this.isBalance = vStatus['Balance'];
                this.isAvoidCallout = vStatus['AvoidCallout'];
                this.isCompanyAvailable = vStatus['CompanyAvailable'];
                this.isNameAvailable = vStatus['NameAvailable'];
                this.isStartDateAvailable = vStatus['StartDateAvailable'];
                this.isEndDateAvailable = vStatus['EndDateAvailable'];
                this.isLiableAvailable = vStatus['LiableAvailable'];
                this.isFullAddressAvailable = vStatus['FullAddressAvailable'];
                this.isPrefLangAvailable = vStatus['PrefLangAvailable'];
                this.isCreditLimitAvailable = vStatus['CreditLimitAvailable'];
                this.isInFollowUpAvailable = vStatus['InFollowUpAvailable'];
                if (this.isScoreImage) {
                    this.scoreImageUrl = this.urlPath + '/' + result.companyweb__CW_Score_Image__c;
                }

            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {

            });
    }

    connectedCallback() {
        console.log('connectedCallback Method');

        getVATNumber({ 'Id': this.recordId, 'objectName': this.objectApiName })
            .then(result => {
                if (result != null) {
                    if (this.objectApiName == 'Account') {
                        this.isVAT = true;
                    } else if (this.objectApiName == 'Lead') {
                        this.isVAT = true;
                        this.isLEAD = true;
                    }
                }
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {
                if (this.objectApiName == 'Account') {
                    this.scoreImageUrl = this.urlPath + '/' + this.accountScoreImage;
                    this.reportURL = this.accountReportURL;
                    this.detailURL = this.accountDetailURL;
                    this.kycURL = this.accountKycURL;
                } else if (this.objectApiName == 'Lead') {
                    this.scoreImageUrl = this.urlPath + '/' + this.leadScoreImage;
                    this.reportURL = this.leadReportURL;
                    this.detailURL = this.leadDetailURL;
                    this.kycURL = this.leadKycURL;
                }
            });
    }

    sync() {
        console.log('Sync Method');

        let oVatNumber;

        if (this.objectApiName == 'Account') {
            oVatNumber = this.accountVATNumber;
        } else if (this.objectApiName == 'Lead') {
            oVatNumber = this.leadVATNumber;
        }
        
        getCompanyInfo({ 'Id': this.recordId, 'VatNumber': oVatNumber, 'objectName': this.objectApiName, 'fromPick': false })
            .then(result => {
                //console.log('result = '+ result);
                let rJson = JSON.parse(result);
                console.log('Json Response = ' + JSON.stringify(rJson));
                let statusCode = rJson['StatusCode'];
                if (statusCode == 0) {
                    if (rJson.CompanyResponse['ReportUrl']['IsEnabled']) {
                        this.reportURL = rJson.CompanyResponse['ReportUrl']['Value'];
                    }
                    if (rJson.CompanyResponse['DetailUrl']['IsEnabled']) {
                        this.detailURL = rJson.CompanyResponse['DetailUrl']['Value'];
                    }
                    if (rJson.CompanyResponse['Score']['IsEnabled']) {
                        this.scoreImageUrl = this.urlPath + '/' + rJson.CompanyResponse['Score']['Value']['ScoreImage'];
                    }
                    if (rJson.CompanyResponse['KycReportUrl']['IsEnabled']) {
                        this.kycURL = rJson.CompanyResponse['KycReportUrl']['Value'];
                    }
                    this.isAvoidCallout = false;

                    getCWFields({ 'recordId': this.recordId, 'objectName': this.objectApiName })
                        .then(result => {
                            //console.log('result REPONSE ' + JSON.stringify(result));

                            let vStatus = this.checkVisibility(result);
                            console.log('vStatus = ' + JSON.stringify(vStatus));
                            console.log('vStatus-ScoreImage = ' + vStatus['ScoreImage']);

                            this.isScoreImage = vStatus['ScoreImage'];
                            this.isKYCReport = vStatus['KYCReport'];
                            this.isDetailsURL = vStatus['DetailsURL'];
                            this.isReportURL = vStatus['ReportURL'];
                            this.isEquity = vStatus['Equity'];
                            this.isRevenue = vStatus['Revenue'];
                            this.isEmployees = vStatus['Employees'];
                            this.isGrossMargin = vStatus['GrossMargin'];
                            this.isResult = vStatus['Result'];
                            this.isCompanyActive = vStatus['CompanyActive'];
                            this.isCreditLimit = vStatus['CreditLimit'];
                            this.isCreditLimitReason = vStatus['CreditLimitReason'];
                            this.isWarning = vStatus['Warning'];
                            this.isBalance = vStatus['Balance'];
                            this.isAvoidCallout = vStatus['AvoidCallout'];
                            this.isCompanyAvailable = vStatus['CompanyAvailable'];
                            this.isNameAvailable = vStatus['NameAvailable'];
                            this.isStartDateAvailable = vStatus['StartDateAvailable'];
                            this.isEndDateAvailable = vStatus['EndDateAvailable'];
                            this.isLiableAvailable = vStatus['LiableAvailable'];
                            this.isFullAddressAvailable = vStatus['FullAddressAvailable'];
                            this.isPrefLangAvailable = vStatus['PrefLangAvailable'];
                            this.isCreditLimitAvailable = vStatus['CreditLimitAvailable'];
                            this.isInFollowUpAvailable = vStatus['InFollowUpAvailable'];
                            if (this.isScoreImage) {
                                this.scoreImageUrl = this.urlPath + '/' + result.companyweb__CW_Score_Image__c;
                            }

                        })
                        .catch(error => {
                            window.console.log('Error Occured', error);
                            if(Object.values(error.body.fieldErrors).length > 0)
                            {
                                this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                            } else if (error.body.pageErrors.length > 0){
                                this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                            }
                        })
                        .finally(() => {

                        });


                    updateRecord({ fields: { Id: this.recordId } });
                } else {
                    errorHandler({ 'errorCode': statusCode })
                        .then(result => {
                            this.showNotification('Oops', result, 'error');
                        })
                }
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {

            });
    }

    search() {
        console.log('Search Method');

        let searchValue;

        this.companies = [];
        this.template.querySelectorAll('lightning-input').forEach(ele => {
            if (ele.name === 'searchTerm') {
                searchValue = ele.value;
            }
        });

        //console.log('searchValue :' + searchValue);
        searchCompaniesInfo({ 'sTerm': searchValue })
            .then(result => {
                //console.log('result = '+ result);
                let rJson = JSON.parse(result);
                let statusCode = rJson['StatusCode'];
                let counter = 0;
                if (statusCode == 0) {
                    let numberOfResults = rJson.SearchResponseList.SearchResponseItem.length;
                    if (numberOfResults != null) {
                        if (numberOfResults > 10) {
                            counter = 10;
                        }
                        else {
                            counter = numberOfResults;
                        }

                        for (let i = 0; i < counter; i++) {
                            let company = {
                                'companyName': rJson.SearchResponseList.SearchResponseItem[i].CompanyName,
                                'vatNumber': rJson.SearchResponseList.SearchResponseItem[i].VatNumber,
                                'street': rJson.SearchResponseList.SearchResponseItem[i].Street,
                                'city': rJson.SearchResponseList.SearchResponseItem[i].City
                            };

                            this.companies.push(company);
                        }
                    }
                    //console.log("companyArray = "+  this.companies);
                } else {
                    errorHandler({ 'errorCode': statusCode })
                        .then(result => {
                            this.showNotification('Oops', result, 'error');
                        })
                }

            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {
            });
    }

    pick(event) {
        console.log('Pick Method');
        let vatNumber = event.target.dataset.id;
        console.log('VAT pick' + vatNumber);
        getCompanyInfo({ 'Id': this.recordId, 'VatNumber': vatNumber, 'objectName': this.objectApiName, 'fromPick': true })
            .then(result => {
                console.log('result = ' + result);
                let rJson = JSON.parse(result);
                let statusCode = rJson['StatusCode'];
                if (statusCode == 0) {
                    this.isVAT = true;
                    this.companies = [];
                    if (rJson.CompanyResponse['ReportUrl']['IsEnabled']) {
                        this.reportURL = rJson.CompanyResponse['ReportUrl']['Value'];
                    }
                    if (rJson.CompanyResponse['DetailUrl']['IsEnabled']) {
                        this.detailURL = rJson.CompanyResponse['DetailUrl']['Value'];
                    }
                    if (rJson.CompanyResponse['Score']['IsEnabled']) {
                        this.scoreImageUrl = this.urlPath + '/' + rJson.CompanyResponse['Score']['Value']['ScoreImage'];
                    }
                    if (rJson.CompanyResponse['KycReportUrl']['IsEnabled']) {
                        this.kycURL = rJson.CompanyResponse['KycReportUrl']['Value'];
                    }

                    updateRecord({ fields: { Id: this.recordId } });
                }
                else {
                    errorHandler({ 'errorCode': statusCode })
                        .then(result => {
                            this.showNotification('Oops', result, 'error');
                        })
                }
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {
                console.log('Finally VAT Number: ' + vatNumber);
            });
    }

    copyData() {
        console.log('copyData Method');

        copyData({ 'Id': this.recordId, 'objectName': this.objectApiName })
            .then(result => {
                //console.log('result = ' + result);
                if (result == null) {
                    updateRecord({ fields: { Id: this.recordId } });
                }
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {
            });
    }

    clearData() {
        console.log('clearData Method');

        clearData({ 'Id': this.recordId, 'objectName': this.objectApiName })
            .then(result => {
                //console.log('result = ' + result);
                if (result == null) {
                    this.isVAT = false;

                    updateRecord({ fields: { Id: this.recordId } });
                }
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            })
            .finally(() => {
            });
    }

    showNotification(title, message, variant) {
        console.log('showNotification Method');

        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    openReportURL() {
        console.log('openReportURL Method');

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.reportURL
            }
        });
    }

    openDetailsURL() {
        console.log('openDetailsURL Method');

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.detailURL
            }
        });
    }

    openKycURL() {
        console.log('openKycURL Method');

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.kycURL
            }
        });
    }

    keyCheck(component, event, helper) {
        console.log('keycheck Method');

        if (component.which == 13) {
            this.search();
        }
    }

    addCompany(){
        console.log('addCompanyToAlerts method');

        let oVatNumber;

        if (this.objectApiName == 'Account') {
            oVatNumber = this.accountVATNumber;
        } else if (this.objectApiName == 'Lead') {
            oVatNumber = this.leadVATNumber;
        }

        addCompanyToAlerts({'vatNumber' : oVatNumber})
            .then(result => {
                this.showNotification('Add Company To Alerts', result ? 'Company successfully added to Companyweb Alerts' : 'Company could not be added to Companyweb Alerts', result ? 'success' : 'error');
            })
            .catch(error => {
                window.console.log('Error Occured', error);
                if(Object.values(error.body.fieldErrors).length > 0)
                {
                    this.showNotification('Oops', Object.values(error.body.fieldErrors)[0][0].message, 'error');
                } else if (error.body.pageErrors.length > 0){
                    this.showNotification('Oops', error.body.pageErrors[0].message, 'error');
                }
            });
    }

    checkVisibility(jsonResponse) {
        console.log('checkVisibility Method');
        console.log(JSON.stringify(jsonResponse));

        let sIsNameAvailable, sIsScoreImage, sIsKYCReport, sIsEquity, sIsRevenue, sIsEmployees, sIsGrossMargin, sIsResult, sIsCreditLimitAvailable, sIsCreditLimit, sIsCreditLimitReason, sIsCompanyActive, sIsCompanyAvailable, sIsWarning, sIsBalance, sIsAvoidCallOut, sIsEndDateAvailable, sIsLiableAvailable, sIsFullAddressAvailable, sIsStartDateAvailable, sIsPrefLangAvailable, sIsDetailsURL, sIsReportURL, sIsInFollowUpAvailable;

        if (!jsonResponse.companyweb__CW_Full_Name__c) {
            sIsNameAvailable = false;
        } else {
            sIsNameAvailable = true;
        }

        if (jsonResponse.companyweb__CW_Avoid_Callout__c === false) {
            sIsAvoidCallOut = false;
        } else {
            sIsAvoidCallOut = true;
        }

        if (!jsonResponse.companyweb__CW_Score_Image__c) {
            sIsScoreImage = false;
        } else {
            sIsScoreImage = true;
        }

        if (!jsonResponse.companyweb__CW_Kyc_URL__c) {
            sIsKYCReport = false;
        } else {
            sIsKYCReport = true;
        }

        if (!jsonResponse.companyweb__CW_Balance__c) {
            sIsBalance = false;
        } else {
            sIsBalance = true;
        }

        if (!jsonResponse.companyweb__CW_Equity__c) {
            sIsEquity = false;
        } else {
            sIsEquity = true;
        }

        if (!jsonResponse.companyweb__CW_Revenue__c) {
            sIsRevenue = false;
        } else {
            sIsRevenue = true;
        }

        if (!jsonResponse.companyweb__CW_Employees__c) {
            sIsEmployees = false;
        } else {
            sIsEmployees = true;
        }

        if (!jsonResponse.companyweb__CW_Gross_Margin__c) {
            sIsGrossMargin = false;
        } else {
            sIsGrossMargin = true;
        }

        if (!jsonResponse.companyweb__CW_Result__c) {
            sIsResult = false;
        } else {
            sIsResult = true;
        }

        if (jsonResponse.companyweb__CW_Credit_Limit__c == null || jsonResponse.companyweb__CW_Credit_Limit__c == undefined) {
            sIsCreditLimitAvailable = false;
        } else {
            sIsCreditLimitAvailable = true;
        }

        if (jsonResponse.companyweb__CW_Credit_Limit__c == 0) {
            sIsCreditLimit = true;
            if (!jsonResponse.companyweb__CW_Credit_Limit_Reason__c) {
                sIsCreditLimitReason = false;
            } else {
                sIsCreditLimitReason = true;
            }
        } else {
            sIsCreditLimit = true;
            sIsCreditLimitReason = false;
        }

        if (!jsonResponse.companyweb__CW_Warnings__c) {
            sIsWarning = false;
        } else {
            sIsWarning = true;
        }

        if (!jsonResponse.companyweb__CW_Company_Status__c) {
            sIsCompanyAvailable = false;
            sIsCompanyActive = false;
        } else {
            if (jsonResponse.companyweb__CW_Company_Status__c === 'Active' || jsonResponse.companyweb__CW_Company_Status__c === 'Actif' || jsonResponse.companyweb__CW_Company_Status__c === 'Actief') {
                sIsCompanyAvailable = true;
                sIsCompanyActive = true;
            } else {
                sIsCompanyActive = false;
            }
        }

        if (!jsonResponse.companyweb__CW_End_Date__c) {
            sIsEndDateAvailable = false;
        } else {
            sIsEndDateAvailable = true;
        }

        if (!jsonResponse.companyweb__CW_Start_Date__c) {
            sIsStartDateAvailable = false;
        } else {
            sIsStartDateAvailable = true;
        }

        if (!jsonResponse.companyweb__CW_Address_Line_1__c && !jsonResponse.companyweb__CW_Address_Line_2__c) {
            sIsFullAddressAvailable = false;
        } else {
            sIsFullAddressAvailable = true;
        }

        if (!jsonResponse.companyweb__CW_VAT_Liable__c) {
            sIsLiableAvailable = false;
        } else {
            sIsLiableAvailable = true;
        }

        if (!jsonResponse.companyweb__CW_Preferred_Languages__c) {
            sIsPrefLangAvailable = false;
        } else {
            sIsPrefLangAvailable = true;
        }

        if (!jsonResponse.companyweb__CW_Detail_URL__c) {
            sIsDetailsURL = false;
        } else {
            sIsDetailsURL = true;
        }

        if (!jsonResponse.companyweb__CW_Report_URL__c) {
            sIsReportURL = false;
        } else {
            sIsReportURL = true;
        }

        if(!jsonResponse.companyweb__CW_In_Follow_Up__c){
            sIsInFollowUpAvailable = false;
        } else {
            sIsInFollowUpAvailable = true;
        }

        // return objct
        let statusObj = {
            'Balance': sIsBalance,
            'ScoreImage': sIsScoreImage,
            'KYCReport': sIsKYCReport,
            'Equity': sIsEquity,
            'Revenue': sIsRevenue,
            'Employees': sIsEmployees,
            'GrossMargin': sIsGrossMargin,
            'Result': sIsResult,
            'CreditLimit': sIsCreditLimit,
            'Warning': sIsWarning,
            'CreditLimitReason': sIsCreditLimitReason,
            'CompanyActive': sIsCompanyActive,
            'AvoidCallout': sIsAvoidCallOut,
            'CompanyAvailable': sIsCompanyAvailable,
            'NameAvailable': sIsNameAvailable,
            'EndDateAvailable': sIsEndDateAvailable,
            'StartDateAvailable': sIsStartDateAvailable,
            'LiableAvailable': sIsLiableAvailable,
            'FullAddressAvailable': sIsFullAddressAvailable,
            'PrefLangAvailable': sIsPrefLangAvailable,
            'CreditLimitAvailable': sIsCreditLimitAvailable,
            'InFollowUpAvailable': sIsInFollowUpAvailable,
            'DetailsURL': sIsDetailsURL,
            'ReportURL': sIsReportURL
        };

        return statusObj;
    }
}