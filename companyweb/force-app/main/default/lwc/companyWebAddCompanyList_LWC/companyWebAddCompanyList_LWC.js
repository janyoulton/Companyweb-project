import {LightningElement, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addCompanyListToAlerts from '@salesforce/apex/CompanyWebController.addCompanyListToAlerts';

export default class ListViewButton extends LightningElement {
	@api listViewIds;

    onAddListOfCompanies(){
        console.log('onAddListOfCompanies method');
        if(this.listViewIds){
            addCompanyListToAlerts({ 'listViewIds': this.listViewIds})
            .then(result => {
                this.showNotification('Add list of Companies to Alerts', result ? 'Companies successfully added to Companyweb Alerts' : 'Companies could not be added to Companyweb Alerts', result ? 'success' : 'error');
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
                this.close();
            });
        } else{
            this.showNotification('Warning','Select at least one company to be added to Alerts', 'warning');
        }

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

	close(){
		setTimeout(
			function() {
				window.history.back();
			},
			1000
		);
	}
}