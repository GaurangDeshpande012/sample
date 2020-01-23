public with sharing class JSONDemoController {
   @AuraEnabled
   public static String getContactWithRelatedDataById() {

    String response = '';
    ResponseJSONWrapper wrapper = new ResponseJSONWrapper();
    wrapper.spouse = 'Test Spouse';
    wrapper.mailingAddress = 'Test Address';
    response = JSON.serialize(wrapper);
    return response;
}
}
