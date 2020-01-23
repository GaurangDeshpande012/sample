/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
import { LightningElement ,track} from 'lwc';
import findDetails from  '@salesforce/apex/JSONDemoController.getContactWithRelatedDataById';
       
 import CONTACT_OBJECT from '@salesforce/schema/Contact';
 import NAME_FIELD from '@salesforce/schema/Contact.Name';
// import TEST_FIELD from '@salesforce/schema/Contact.TestField__c';
 import spouse from '@salesforce/apex/ResponseJSONWrapper.spouse';
 import mailingAddress from '@salesforce/apex/ResponseJSONWrapper.mailingAddress';
    


export default class JSONLWC extends LightningElement {


    contactObject = CONTACT_OBJECT;

    myFields = [SPOUSE_FIELD,ADDRESS_FIELD];
   @track contacts;
    @track error;
    
    handleContactCreated(){
        // Run code when account is created.
    }
    
    handleContactInitialized(){
      findDetails()
          .then(result => {
              var responseObj = JSON.parse(result.getReturnValue());
              this.SPOUSE_FIELD = responseObj.spouse;
              this.ADDRESS_FIELD = responseObj.mailingAddress;
          })
          .catch(error => {
              this.error = error;
          });
          myFields = [SPOUSE_FIELD,ADDRESS_FIELD];
        }


}