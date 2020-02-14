public with sharing class SelectedSObjectFieldsController 
 {
    
    public String objName {get; set;}
    public String objectLabel {get; set;}
    public static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    
    
    public List<SelectOption> getObjectNames() 
    {
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        for(String name : entities)
        {
            objNames.add(new SelectOption(name,name));
        }
        return objNames;
     }

    @AuraEnabled
public static  Map<String, String> getObjectFields(String objName) {
    Map<String, String> retVal = new Map<String, String>();
    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
    for (String fieldName: fieldMap.keySet()) {  
        retVal.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
    }
   
    return retVal;
}
    @AuraEnabled
   public static List<String> getObjectName1(){
        List<String> objects=new List<String>();
       List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
        for(SObjectType sot:gd){
           objects.add(sot.getDescribe().getName());
        }
       System.debug('objects'+objects);
        return objects;
    }
    @AuraEnabled
    public static List<String> listAllObject(){
        List<String> objectList = new List<String>();
        For(Schema.sObjectType sobj: schema.getGlobalDescribe().values()){
            if(sobj.getDescribe().isQueryable())
                objectList.add(sobj.getDescribe().getName()+'####'+sobj.getDescribe().getLabel());
        }
        objectList.sort();
        System.debug('objectList'+objectList);
        
        return objectList;
    }

    
    /**
    * @description Variable to Store metatdata of the object 
    */
   // public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    /**
    * @description Variable to Store selectedObject
    */
    public static string selectedObject {get; set;}
    
    /**
    * @description Variable to Store listField 
    */
    public static List<FieldWrapper> listField{get;set;}
    /**
    * @description Variable to Store dynamicObjList 
    */
    public static  List<UserPreference__c>  dynamicObjList {get;set;}
     /**
    * @description Variable to Store zipData 
    */
    public String zipData { get; set; } 
     /**
    * @description Variable to Store asyncResult 
    */
    //public HT_MetadataService.AsyncResult AsyncResult {get; private set;}
    public MetadataService.AsyncResult asyncResult {get; private set;}
     /**
    * @description Variable to Store dynamicTrigName 
    */
    public static String dynamicTrigName { get; set; } 
      /**
    * @description Variable to Store dynamicTrigName 
    */
    private  static  boolean dynamicTrigCreated = false;
    
    public static boolean triggerCreated {get;set;}
    /**
    * @description Variable to Store History Tracker 
    */
    public boolean editSection {get;set;}
    /**
    * @description Button to Remove Selected Objects 
    */
    public static boolean disableButton {get;set;}
    
    private boolean isActive = false;
    
    private static boolean noRecord = false;
    
    /**
    * @description Default Constructor 
    */
    public SelectedSObjectFieldsController() 
    {       
        listField = new List<FieldWrapper>();       
        dynamicObjList = new List<UserPreference__c>();
        if(HT_Activator__c.getValues('HistoryTracker') != null) 
        {
            system.debug(' HT_Activator__c.getValues '  + HT_Activator__c.getValues('HistoryTracker'));    
            isActive = HT_Activator__c.getValues('HistoryTracker').isActivated__c;
        }
        
        if(isActive == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'HistoryTracker not Enabled. Please Contact Administrator...'));
            
        }
        
       
        if(isActive)
        {
            
            HT_ByPassUsers__c isBypassedUser=  HT_ByPassUsers__c.getValues(UserInfo.getUserId()) ;
            System.debug(' is Bypassed User + ' + isBypassedUser);
            HT_ByPassUsers__c isBypassedProfile=  HT_ByPassUsers__c.getValues(UserInfo.getProfileId()) ;
            System.debug(' is Bypassed Profile + ' + isBypassedProfile);
            
            //by pass the Dupe Preventer configurations for the users added in DP_BypassUsers__c custom setting
            if(isBypassedUser != null  || isBypassedProfile != null)            
                {
                    isActive= false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'HistoryTracker not Enabled for this User/Profile.Please Contact Administrator...'));
                }else{                    
                    isActive= true;
                }
            
            System.debug(' not Bypassed User + ' + isBypassedUser);
            
        }
        
        
    }
   
    Public static string objectApiName;
    /**
    * @description Variable to Store Selected Object 
    * @return String 
    */
    public static string objectLabel {get;set;}
    
   /**
    * @description  Find all sObjects available in the organization
    * @return List<SelectOption>  
    */ 
    public  List<SelectOption> getListObejectName() 
    {        
         List < SelectOption > options = new List < SelectOption > ();
         options.add(new SelectOption('','-- Select --'));
        
        if(isActive == true)
        {
        for (Schema.SObjectType itemType: Schema.getGlobalDescribe().values()) {
            String name = itemType.getDescribe().getName();
            boolean b = itemType.getDescribe().isQueryable();
            system.debug('sobject : '+itemType.getDescribe().getName()+' : '+itemType.getDescribe().getSobjectType());
            // Exclude all the unwanted Sobjects e.g. CustomSettings, History, Share, Feed, ApexClass, Pages etc..
            if (!itemType.getDescribe().isCustomSetting() && itemType.getDescribe().getRecordTypeInfos().size() > 0 && itemType.getDescribe().isCreateable() &&
                !name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed') && !name.containsignorecase('BNT_HT')) {
                options.add(new SelectOption(itemType.getDescribe().getName(), itemType.getDescribe().getLabel()));
            }
        }
        }
        
        //***************************************************
        
        system.debug('inside getShowFields');
        disableButton = false;
        if(selectedObject.contains('__c')){
            system.debug('selectedObject :'+selectedObject);
            objectLabel = selectedObject.removeEnd('__c');
            system.debug('objectLabel :'+objectLabel);
            if(objectLabel.contains('BNT_HT__')){
                objectLabel = objectLabel.removeStartIgnoreCase('BNT_HT__');
                system.debug('objectLabel :'+objectLabel);
            }
        }else{
            objectLabel = selectedObject;
        }
        
        objectApiName = selectedObject;
        
        Map <String, Schema.SObjectField> fieldMap;
        listField.clear();
      system.debug('# showFields selectedObject ' + selectedObject);
     dynamicTrigName = 'HT'+selectedObject+'trigger';
        //dynamicObjList.clear();
        if(selectedObject != null)
        {
           system.debug('inside getShowFields selectedObject ' + selectedObject);
            fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
            system.debug('Inside fieldMap:'+fieldMap);
            if (Schema.sObjectType.UserPreference__c.fields.Trigger_Created__c.isAccessible() && Schema.sObjectType.UserPreference__c.fields.Fields__c.isAccessible()&& Schema.sObjectType.UserPreference__c.fields.Name.isAccessible()){
             dynamicObjList= [select id, Name, Fields__c,Trigger_Created__c from UserPreference__c where name = : String.escapeSingleQuotes(String.ValueOf(selectedObject)) ];
              system.debug('Inside dynamicObjList:'+ dynamicObjList);
             }
        }
         
      if(fieldMap != null)
      {
           for(Schema.SObjectField sField : fieldMap.Values())
        {
          system.debug(' sField ' + sField);  
          schema.describefieldresult dField = sField.getDescribe();
          system.debug(' dField ' + dField);  
           
        if(dField.getName ()!='Id' && dField.getName ()!='IsDeleted' && dField.getName ()!='CreatedDate' && dField.getName ()!='SystemModstamp' && dField.getName ()!='LastModifiedById' && dField.getName ()!='CreatedById' && dField.getName ()!='LastModifiedDate')
        {
            FieldWrapper wObj = new FieldWrapper();
            wObj.fieldName = dField.getLabel ();
            system.debug(' wObj ' + wObj);  
            wObj.fieldAPIName = dField.getName();
            system.debug(' wObj ' + wObj);  
           
          
           if(dynamicObjList != null && dynamicObjList.size()>0 &&dynamicObjList[0].Fields__c!=null)
            {
                List<String> fieldsStringList = dynamicObjList[0].Fields__c.split(',');
                system.debug(' fieldsStringList ' + fieldsStringList);  
                   
                if(fieldsStringList.contains(wObj.fieldAPIName))
                {
                    wObj.isSelected = true;
                }
            }
            else
            {
                
                wObj.isSelected = false;
                
            }
            
            listField.add(wObj);
            system.debug(' listField ' + listField);  
        } 
            
        }
        
      }
      
        //***************************************************
        options.sort();
        return options;
    }
    
     /**
    * @description  Find the fields for the selected object
    */ 
    @AuraEnabled
    public static void getShowFields() 
    {   
        system.debug('inside getShowFields');
        disableButton = false;
        if(selectedObject.contains('__c')){
            system.debug('selectedObject :'+selectedObject);
            objectLabel = selectedObject.removeEnd('__c');
            system.debug('objectLabel :'+objectLabel);
            if(objectLabel.contains('BNT_HT__')){
                objectLabel = objectLabel.removeStartIgnoreCase('BNT_HT__');
                system.debug('objectLabel :'+objectLabel);
            }
        }else{
            objectLabel = selectedObject;
        }
        
        objectApiName = selectedObject;
        
        Map <String, Schema.SObjectField> fieldMap;
        listField.clear();
      system.debug('# showFields selectedObject ' + selectedObject);
     dynamicTrigName = 'HT'+selectedObject+'trigger';
        //dynamicObjList.clear();
        if(selectedObject != null)
        {
           system.debug('inside getShowFields selectedObject ' + selectedObject);
            fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
            system.debug('Inside fieldMap:'+fieldMap);
            if (Schema.sObjectType.UserPreference__c.fields.Trigger_Created__c.isAccessible() && Schema.sObjectType.UserPreference__c.fields.Fields__c.isAccessible()&& Schema.sObjectType.UserPreference__c.fields.Name.isAccessible()){
             dynamicObjList= [select id, Name, Fields__c,Trigger_Created__c from UserPreference__c where name = : String.escapeSingleQuotes(String.ValueOf(selectedObject)) ];
              system.debug('Inside dynamicObjList:'+ dynamicObjList);
             }
        }
         
      if(fieldMap != null)
      {
           for(Schema.SObjectField sField : fieldMap.Values())
        {
          system.debug(' sField ' + sField);  
          schema.describefieldresult dField = sField.getDescribe();
          system.debug(' dField ' + dField);  
           
        if(dField.getName ()!='Id' && dField.getName ()!='IsDeleted' && dField.getName ()!='CreatedDate' && dField.getName ()!='SystemModstamp' && dField.getName ()!='LastModifiedById' && dField.getName ()!='CreatedById' && dField.getName ()!='LastModifiedDate')
        {
            FieldWrapper wObj = new FieldWrapper();
            wObj.fieldName = dField.getLabel ();
            system.debug(' wObj ' + wObj);  
            wObj.fieldAPIName = dField.getName();
            system.debug(' wObj ' + wObj);  
           
          
           if(dynamicObjList != null && dynamicObjList.size()>0 &&dynamicObjList[0].Fields__c!=null)
            {
                List<String> fieldsStringList = dynamicObjList[0].Fields__c.split(',');
                system.debug(' fieldsStringList ' + fieldsStringList);  
                   
                if(fieldsStringList.contains(wObj.fieldAPIName))
                {
                    wObj.isSelected = true;
                }
            }
            else
            {
                wObj.isSelected = false;
                
            }
            
            listField.add(wObj);
            system.debug(' listField ' + listField);  
        } 
            
        }
        
      }
      
    }
    
     
    

   /**
    * @description  Wrapper class to show fields selected on page load and save the user preference is the object 
    
   */ 
   
    public class FieldWrapper
    {
        /**
         * @description Variable to store fieldName
         */
        public String fieldName {get; set;}
        /**
         * @description Variable to store fieldAPIName
         */
        public String fieldAPIName {get; set;}
        /**
         * @description Variable to store isSelected
         */
        public Boolean isSelected {get; set;}
        
        
    }
    
    

   
    
    
    /**
    * @description Save the Selected Object in User Preference Object's
    */
    @AuraEnabled
    public static void saveMethod(String selectedObject) {
        list<sObject> lstSObj = new list<sObject>();
        string query = 'select id from '+ String.escapeSingleQuotes(selectedObject);
        lstSObj = Database.query(query);
        
        if(lstSObj.size()>0){
            saveUserPreferences();
        }else{
            noRecord = true;
        }
        
         getPackageXml(selectedObject);
         getTriggerMetadata();
         getTriggerBody(selectedObject);
    }
    
    /**
     *@description  saves the selected fields sets in the user preference object . 
     */
      public static void saveUserPreferences() {
        system.debug('#inside save' );
        String selectedFields='';
          disableButton = true;
        for(FieldWrapper cCon: listField) {
            if(cCon.isSelected) {
                
                if(selectedFields=='')
                {
                    selectedFields= cCon.fieldAPIName;                
                }
                else
                {
                        selectedFields=selectedFields+','+cCon.fieldAPIName;                
                }
                
            }
        }
      
      
    UserPreference__c dynamicObj = new UserPreference__c();
     system.debug('#inside save selectedObject '+ selectedObject);
      if(dynamicObjList.size()>0)
      {
          dynamicObjList[0].Fields__c=selectedFields;
          
          if(!dynamicObjList[0].Trigger_Created__c)
          {
             dynamicObjList[0].Trigger_Created__c=true;
              
          }
          
          triggerCreated = true;
          
          update dynamicObjList[0];
      }
      else
      {
          if (Schema.sObjectType.UserPreference__c.fields.name.isCreateable()) 
            {
                dynamicObj.name=selectedObject;
               
            }
            if (Schema.sObjectType.UserPreference__c.fields.Fields__c.isCreateable()) 
            {
                
                if(selectedFields =='')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select atleast one field to track history.'));
                
                }
                else
                {
                    dynamicObj.Fields__c=selectedFields;
                    
                }
            }
            if (Schema.sObjectType.UserPreference__c.fields.Trigger_Created__c.isCreateable()) 
            {
                 dynamicObj.Trigger_Created__c=true;
            }           
            
            try
           {
               
                insert dynamicObj;
                triggerCreated = false;

            }
            catch(Exception e)
            {
                 System.debug(' error while inserting dynamic object '+ e.getMessage());
            }
         
      }

    }
/**
    * @description Deploy Zip file Store the dynamicTrigName of Selected Record
    * @return PageReference prObj
    */    
    
   public PageReference deployZip()
    {   
           
        if(triggerCreated == true || noRecord == true){
            PageReference prObj = new PageReference('/apex/SampleRedirectClass');
            prObj.setRedirect(true);
            return prObj; 
            
            
        }
        if(triggerCreated == false && noRecord == false){
        system.debug('#inside deployZip');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please wait...'));

        // Deploy zip file posted back from the page action function                
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.testLevel = 'RunSpecifiedTests';
        list<string> testclasses = new list<string>();
        testclasses.add('HT_'+objectLabel+'TriggerTest');
        deployOptions.runTests = testclasses;
        deployOptions.singlePackage = true;    
            system.debug('#zipData '+ zipData);
        asyncResult = service.deploy(zipData, DeployOptions);
        
        system.debug('#asyncResult '+ asyncResult.id);
         MetadataService.DeployResult deployResult = service.checkDeployStatus(asyncResult.Id, true);
        system.debug('#asyncResult deployResult '+ deployResult);
         if(deployResult.status == 'In progress')
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Data Saved Succesfully...'));

                 
                  dynamicTrigCreated = true;
                 
             }
        return null;
        }else if(noRecord == false){
            PageReference prObj = new PageReference('/apex/HT_ObjectHistory');
           
            prObj.setRedirect(true);
            return prObj; 
             
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Atleast one record should be created for the object'));
            return null;
        }
    }   
/**
    * @description Class Create MetaData Service
    * @return MetadataService.MetadataPort
    */     
    private static MetadataService.MetadataPort createService()
    { 
        system.debug('#inside createService');
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        system.debug('service '+service);
        return service;     
    }
/**
    * @description Class Check Deploy Result for Retrieved Request
    * @return PageReference prObj
    */     
    public PageReference checkAsyncRequest()
    {   
        system.debug('#inside checkAsyncRequest');
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(asyncResult.Id, true);
     
        if(deployResult.done == true)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Data Saved Succesfully...'));
            system.debug(' deployResult.done ' + deployResult.done );
            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null){
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                {
                    if(deployMessage.problem!=null){
                        ApexPages.addMessage(
                            new ApexPages.Message(ApexPages.Severity.Error, 
                                deployMessage.fileName + 
                                    ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + 
                                        deployMessage.problem));
                                        }
                 }
            asyncResult = null;
            }
        }
     
     //PageReference prObj = new PageReference('/apex/HT_ObjectHistory');
     //prObj.setRedirect(true);
     //return prObj;
     PageReference prObj = new PageReference('/apex/SampleRedirectClass');
     prObj.setRedirect(true);
     return prObj; 
    
    }
/**
    * @description Class Store XML File For Retrieved Request
    * @return String
    */ 
     @AuraEnabled
    public static String getPackageXml(String objectLabel)
    {system.debug('************inside getPackageXml');
     system.debug('#objectLabel '+ objectLabel);
        return '<?xml version="1.0" encoding="UTF-8"?>' + 
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
                '<types>' + 
                    '<members>HT_'+objectLabel+'Trigger</members>' +
                    '<name>ApexTrigger</name>' + 
                '</types>' + 
                '<types>' + 
                  '<members>HT_'+objectLabel+'TriggerTest</members>' +
                   '<name>ApexClass</name>' + 
                '</types>' + 
                '<version>47.0</version>' + 
            '</Package>';       
    }
/**
    * @description Class Store MetaData File and Trigger For Retrieved Request
    * @return String
    */ 
     @AuraEnabled
    public static String getTriggerMetadata()
    {system.debug('************inside getTestTrigger2Metadata');
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>47.0</apiVersion>' + 
                '<status>Active</status>' +
            '</ApexTrigger>';       
    }
    
/**
    * @description Class Create Trigger Body For dynamicTrigName
    * @return String
    */  
 @AuraEnabled    
    public static String getTriggerBody(String objectLabel) 
    {system.debug('************inside getTriggerBody objectLabel' + objectLabel + ' ' + objectApiName);
     
      String body =  'trigger HT_'+objectLabel+'Trigger on ' + objectLabel + '(after update,before delete)' + 
            
        
            '{' + 'HT_FieldTrackingReport instanceObj = new HT_FieldTrackingReport' + 
            '('+'\''+ objectApiName+'\','+
            ' Trigger.new, Trigger.oldMap);'+
            'if(Trigger.isUpdate)'+
        '{instanceObj.onUpdate();}'+
            'if(Trigger.isDelete)'+
          '{instanceObj.onDelete();}}';
        system.debug('#body '+ body);
        return body;
    }
/**
    * @description Class Test For dynamicTrigName
    * @return String
    */   
 @AuraEnabled    
    public static string getTriggerTest(String objectLabel){
        return '@isTest ' + 
            'private without sharing class HT_'+objectLabel+'TriggerTest { ' +
            '@istest (SeeAllData=true)' +
            'private static void myTestMethod(){'+
            'sobject testdata = TestDataGenerator.generateTestData('+objectLabel+'.getSObjectType());'+
            'Test.startTest();'+
            'Insert testData;'+
            'update testData;'+
            'delete testData;'+
            'system.assert(testdata!=null);'+
            'Test.stopTest();'+
            ' }' +
            '}';
    }
/**
    * @description Class Store Test Metadata dynamicTrigName 
    * @return String
    */      
     @AuraEnabled
    public static string getTriggerTestMetadata(){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>47.0</apiVersion>' + 
                '<status>Active</status>' +
            '</ApexClass>';
       }
    
    
     @AuraEnabled
    public static void SavePopupClick()
    {
       
        list<sObject> lstSObj = new list<sObject>();
        string query = 'select id from '+ String.escapeSingleQuotes(selectedObject);
        lstSObj = Database.query(query);
        
        if(lstSObj.size()>0){
            //saveUserPreferences();
        }else{
            noRecord = true;
        }
    }
        
    
    

}
