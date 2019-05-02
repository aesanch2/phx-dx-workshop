/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Activates Accounts based on Opportunity criteria
 */

public with sharing class AccountActivation implements TriggerHandler {
    private static final Set<String> INACTIVE_STAGES = new Set<String>{
            'Prospecting',
            'Qualification',
            'Needs Analysis'
    };

    public void beforeDelete(Map<Id, SObject> deletedRecords) {}

    public void beforeInsert(List<SObject> newRecords) {}

    public void beforeUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords) {}

    public void afterDelete(Map<Id, SObject> deletedRecords) {}

    public void afterInsert(Map<Id, SObject> newRecords) {
        Map<Id, Opportunity> newOpportunities = (Map<Id, Opportunity>) newRecords;

        List<Opportunity> eligibleOpps = new List<Opportunity>();
        for (Opportunity opp : newOpportunities.values()) {
            if (INACTIVE_STAGES.contains(opp.StageName) == false) {
                eligibleOpps.add(opp);
            }
        }

        activateAccounts(eligibleOpps);
    }

    public void afterUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords) {
        Map<Id, Opportunity> newOpportunities = (Map<Id, Opportunity>) updatedRecords;
        Map<Id, Opportunity> oldOpportunities = (Map<Id, Opportunity>) oldRecords;

        List<Opportunity> eligibleOpps = new List<Opportunity>();
        for (Opportunity opp : newOpportunities.values()) {
            Opportunity oldOpp = oldOpportunities.get(opp.Id);
            if (INACTIVE_STAGES.contains(opp.StageName) == false
                    && opp.StageName != oldOpp.StageName) {
                eligibleOpps.add(opp);
            }
        }

        activateAccounts(eligibleOpps);
    }

    public void afterUndelete(Map<Id, SObject> restoredRecords) {}

    private static void activateAccounts(List<Opportunity> opportunites) {
        List<Account> accountsToActivate = new List<Account>();

        for (Opportunity opp : opportunites) {
            accountsToActivate.add(
                    new Account(
                            Id = opp.AccountId,
                            IsActive__c = true
                    )
            );
        }

        Database.update(accountsToActivate);
    }
}