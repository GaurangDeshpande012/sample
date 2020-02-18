
    import { LightningElement, wire } from 'lwc';
    import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
    import Id from '@salesforce/user/Id';
    import NAME_FIELD from '@salesforce/schema/User.Name';
    import EMAIL_FIELD from '@salesforce/schema/User.Email';
  
    import  Active_FIELD from '@salesforce/schema/User.IsActive';
    const fields = [NAME_FIELD, EMAIL_FIELD, Active_FIELD];
export default class CurrentUser extends LightningElement {

   
        userId = Id;
    
        @wire(getRecord, { recordId: '$userId', fields })
        user;
    
        get name() {
            return getFieldValue(this.user.data, NAME_FIELD);
        }
    
        get email() {
            return getFieldValue(this.user.data, EMAIL_FIELD);
        }

        get active() {
            return getFieldValue(this.user.data, Active_FIELD);
        }
    }


    



