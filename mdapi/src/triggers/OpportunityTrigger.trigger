/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Handles DML events on Opportunity
 */

trigger OpportunityTrigger on Opportunity (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete
) {
    new TriggerEvent(
            Opportunity.SObjectType.getDescribe().getName(),
            Trigger.operationType
    ).dispatch();
}