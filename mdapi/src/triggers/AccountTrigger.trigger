/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Handles DML events on Account
 */

trigger AccountTrigger on Account (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete
) {
    new TriggerEvent(
            Account.SObjectType.getDescribe().getName(),
            Trigger.operationType
    ).dispatch();
}