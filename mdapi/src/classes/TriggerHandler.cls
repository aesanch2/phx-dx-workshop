/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Defines how trigger logic should be invoked
 */

public interface TriggerHandler {
    void beforeDelete(Map<Id, SObject> deletedRecords);
    void beforeInsert(List<SObject> newRecords);
    void beforeUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords);
    void afterDelete(Map<Id, SObject> deletedRecords);
    void afterInsert(Map<Id, SObject> newRecords);
    void afterUpdate(Map<Id, SObject> updatedRecords, Map<Id, SObject> oldRecords);
    void afterUndelete(Map<Id, SObject> restoredRecords);
}