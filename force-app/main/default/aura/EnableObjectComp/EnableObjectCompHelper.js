({
	onInit : function(component, event, helper) {
        alert('inside onInit method');
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.listAllObject');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i].split('####')[1],
                        key : responseValue[i].split('####')[0]
                    });
                }
                lstOptions.sort();
                component.set('v.objectList', lstOptions);

            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showFields: function( component ) {
        alert('inside controllerShowFields');
         var pickselected = component.find("selectid").get("v.value");
        console.log('showFields selected val--->' + pickselected);
		component.set('v.selectedValue', pickselected);
    var selected = component.get('v.selectedValue');
    console.log('helper Selected--->' + selected);
    var action = component.get('c.getShowFields');
    action.setParams({
        objName: pickselected
    });

  /*  action.setCallback(this, function(response){
        var options = [];
       // var fieldMap = response.getReturnValue(); 
        for (var k in fieldMap) {
            options.push({ value:k, label:fieldMap[k]});
        }
        component.set('v.options', options);
    });*/
    $A.enqueueAction(action); 
        
    },
    
    
    
    saveRecordAsync: function( component ) {
        alert('inside saveRecordAsync');
        let action = component.get("c.saveRecord");
        action.setParam( "metadataRecord", component.get("v.record") );
        component.set( "v.record", {} );
        let ele = component.find( "recordPopup" );
        $A.util.addClass( ele, "slds-hide" );
        
        action.setCallback( this, function( response ) {
            var state = response.getState();
            if( state === "SUCCESS") {
                console.log( response.getReturnValue() );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    message: 'This is a required message',
                    messageTemplate: 'Your request has been submitted. Click {0}  to track the progress.',
                    messageTemplateData: [{
                        url: '/changemgmt/monitorDeploymentsDetails.apexp?asyncId=' + response.getReturnValue(),
                        label: 'Deployment Status',
                        }
                    ]
                });
                toastEvent.fire();
            }
            else if (state === "INCOMPLETE") {
            	alert('Error in the response');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction( action );
    },
    callingGetPackageXML : function(component, event, helper) {
        alert('inside packageXML method');
        var selectedObj = component.find("selectid").get("v.value");
         alert('inside packageXML selectedObj '+ selectedObj);
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.getPackageXml');
         action.setParams({
        	objectLabel: selectedObj
    		});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                console.log('packagexml '+responseValue);
                
                component.set('v.packageXML', responseValue);

            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
     callingMetadataXML : function(component, event, helper) {
        alert('inside packageXML method');
        var selectedObj = component.find("selectid").get("v.value");
         alert('inside packageXML selectedObj '+ selectedObj);
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.getTriggerMetadata');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                console.log('meta '+ responseValue);
                
                component.set('v.metadataXML', responseValue);

            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    callingTriggerBody : function(component, event, helper) {
        alert('inside packageXML method');
        var selectedObj = component.find("selectid").get("v.value");
         alert('inside packageXML selectedObj '+ selectedObj);
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.getTriggerBody');
         action.setParams({
        	objName: selectedObj
    		});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                console.log( 'triggerBody ' + responseValue);
                
                component.set('v.triggerBody', responseValue);

            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    scriptsLoaded : function(component, event, helper) {
        alert('11111111111111Script loaded..');
        console.log('Script loaded..'); 
    }
    
     
    
})