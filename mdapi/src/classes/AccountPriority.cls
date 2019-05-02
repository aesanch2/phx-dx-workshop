/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Sets the Priority field on Account based on the Account's Annual Revenue
 */

public with sharing class AccountPriority implements TriggerHandler {
    private static final Integer HIGH_PRIORITY = 1000000000;
    private static final Integer MED_PRIORITY = 5000000;
    private static final Integer LOW_PRIORITY = 1000000;

    public void beforeDelete(Map<Id, SObject> deletedRecords) {}

    public void beforeInsert(List<SObject> newRecords) {
        List<Account> newAccounts = (List<Account>) newRecords;

        setPriority(newAccounts);
    }

    public void beforeUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords) {
        Map<Id, Account> newAccounts = (Map<Id, Account>) updatedRecords;

        setPriority(newAccounts.values());
    }

    public void afterDelete(Map<Id, SObject> deletedRecords) {}

    public void afterInsert(Map<Id, SObject> newRecords) {}

    public void afterUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords) {}

    public void afterUndelete(Map<Id, SObject> restoredRecords) {}

    private static void setPriority(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.AnnualRevenue >= HIGH_PRIORITY) {
                acc.Priority__c = 'High';
            } else if (acc.AnnualRevenue >= MED_PRIORITY) {
                acc.Priority__c = 'Medium';
            } else if (acc.AnnualRevenue >= LOW_PRIORITY) {
                acc.Priority__c = 'Low';
            } else {
                acc.Priority__c = 'Zero';
            }
        }
    }
}