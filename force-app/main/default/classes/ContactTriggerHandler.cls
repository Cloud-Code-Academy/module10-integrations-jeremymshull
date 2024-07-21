public with sharing class ContactTriggerHandler extends TriggerHandler {
    private List<Contact> newConList;
    private Map<Id, Contact> newConMap;
    private List<Contact> oldConList;
    private Map<Id, Contact> oldConMap;
    
    public ContactTriggerHandler() {
        this.newConList = (List<Contact>) Trigger.new;
        this.newConMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldConList = (List<Contact>) Trigger.old;
        this.oldConMap = (Map<Id, Contact>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        // When a contact is inserted
	    // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
        for (Contact con : newConList) {
			if (con.DummyJSON_Id__c == null) {
				con.DummyJSON_Id__c = String.valueOf(Math.round(Math.random() * 100));
			}		
		}
    }

    public override void afterInsert() {
        //When a contact is inserted
	    // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
        for (Contact con : newConList) {
			if (con.DummyJSON_Id__c != null && Integer.valueOf(con.DummyJSON_Id__c) <= 100) {
				DummyJSONCallout.getDummyJSONUserFromId(con.DummyJSON_Id__c);
			}
        }
    }

    public override void afterUpdate() {
        //When a contact is updated
	    // if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
        for (Contact con : newConList) {
			Contact oldCon = oldConMap.get(con.Id);
			if (con.DummyJSON_Id__c != null && oldCon.DummyJSON_Id__c != con.DummyJSON_Id__c && Integer.valueOf(con.DummyJSON_Id__c) > 100) {
				DummyJSONCallout.postCreateDummyJSONUser(con.DummyJSON_Id__c);
			}
		}
    }
}