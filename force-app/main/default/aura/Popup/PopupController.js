({
 
  fetchListOfRecordTypes: function(component, event, helper) {
       var action = component.get("c.fetchRecordTypeValues");
       action.setCallback(this, function(response) {
          component.set("v.lstOfRecordType", response.getReturnValue());
       });
       $A.enqueueAction(action);
    },
        
     
   
    FunctionLoad: function(component, event, helper) {

        
    },
      
  
    closeModal: function(component, event, helper) {
       // set "isOpen" attribute to false for hide/close model box 
       component.set("v.isOpen", false);
    },
  
    openModal: function(component, event, helper) {
       // set "isOpen" attribute to true to show model box
       component.set("v.isOpen", true);
    },
 })