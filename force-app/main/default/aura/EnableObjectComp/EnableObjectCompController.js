({
    
    

    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);
        helper.showFields(component, event, helper);
       // helper.scriptsLoaded(component, event, helper);
       // helper.callingGetPackageXML(component, event, helper);
        //helper.callingMetadataXML(component, event, helper);
       // helper.callingTriggerBody(component, event, helper);
      //  helper.saveRecordAsync(component, event, helper);
    },
    doHandlingChange : function(component, event, helper) {
       // helper.init2winit(component, event, helper);
    },
    
     
    
    
    
  
    handleChange: function (component, event) {
        var selectedOptionsList = event.getParam("value");
        console.log(selectedOptionsList);
        component.set("v.selectedArray", selectedOptionsList);
        
        
    },

fieldsName : function(component, event, helper) {
    
     var pickselected = component.find("selectid").get("v.value");
        console.log('pickselected--->' + pickselected);
		component.set('v.selectedValue', pickselected);
    var selected = component.get('v.selectedValue');
    console.log('Selected--->' + selected);
    var action = component.get('c.getObjectFields');
    action.setParams({
        objName: pickselected
    });

    action.setCallback(this, function(response){
        var options = [];
        var fieldMap = response.getReturnValue(); 
        for (var k in fieldMap) {
            options.push({ value:k, label:fieldMap[k]});
        }
        component.set('v.options', options);
         
    });
    
    $A.enqueueAction(action); 
},
    
    //controllerShowFields : function(component, event, helper) {
       // alert('inside controllerShowFields');
          
       // $A.enqueueAction(action); 
    //},

// For saving custom metadata record 
    handleSavePopupClick: function( component, event, helper ) {alert('onsave');
        var selectedObj = component.find("selectid").get("v.value");
          alert('selectedObj ' + selectedObj);
       // console.log('selectedObj--->' + selectedObj);
     // console.log('11111pickselected--->' + component.get('v.selectedArray'));
   	//let record = component.get( "v.record" );
   // var action = component.get('c.saveMethod');
    /*var action =component.get('c.callingGetPackageXML');
                               var action =component.get('c.callingMetadataXML ');                               
                                  var action =component.get('c.  callingTriggerBody');     */
    //var action = component.get('c.getPackageXml');
    //var action = component.get('c.getTriggerMetadata');
 //var action = component.get('c.getTriggerBody');
  helper.callingGetPackageXML(component, event, helper);
    helper.callingMetadataXML(component, event, helper);
    helper. scriptsLoaded (component, event, helper)
   // helper.callingTriggerBody(component, event, helper)
    action.setCallback(this, function(response){
       // var options = [];
        //var fieldMap = response.getReturnValue(); 
       // for (var k in fieldMap) {
          //  options.push({ value:k, label:fieldMap[k]});
      //  }
        component.set('v.packageXML', response.getReturnValue());
        
         
    });

           
      $A.enqueueAction(action);
    } ,
    
    
    
    
   
    
});