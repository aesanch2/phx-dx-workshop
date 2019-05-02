/*
 * @author: anthony@cleanbeach.co
 * @created: 2019/05/02
 * @description: Passes context to TriggerHandlers that are registered with this TriggerEvent
 */

public with sharing class TriggerEvent {
    private List<TriggerHandler__mdt> configs;
    private TriggerOperation operation;

    public TriggerEvent(String sObjectName, TriggerOperation operation) {
        this.operation = operation;

        String operationFilter;
        switch on operation {
            when AFTER_DELETE {
                operationFilter = 'AND IsAfter__c = TRUE AND IsDelete__c = TRUE ';
            } when AFTER_INSERT {
                operationFilter = 'AND IsAfter__c = TRUE AND IsInsert__c = TRUE ';
            } when AFTER_UNDELETE {
                operationFilter = 'AND IsAfter__c = TRUE AND IsUndelete__c = TRUE ';
            } when AFTER_UPDATE {
                operationFilter = 'AND IsAfter__c = TRUE AND IsUpdate__c = TRUE ';
            } when BEFORE_DELETE {
                operationFilter = 'AND IsBefore__c = TRUE AND IsDelete__c = TRUE ';
            } when BEFORE_INSERT {
                operationFilter = 'AND IsBefore__c = TRUE AND IsInsert__c = TRUE ';
            } when BEFORE_UPDATE {
                operationFilter = 'AND IsBefore__c = TRUE AND IsUpdate__c = TRUE ';
            }
        }

        String configLoader = 'SELECT Name FROM TriggerHandler__mdt WHERE '
                + 'IsActive__c = TRUE AND SObject__c = ' + sObjectName + ' '
                + operationFilter
                + 'ORDER BY Priority';

        configs = (List<TriggerHandler__mdt>) Database.query(
                configLoader
        );
    }

    public void dispatch() {
        for (TriggerHandler__mdt config : configs) {
            TriggerHandler handler = (TriggerHandler) Type.forName(config.DeveloperName)
                    .newInstance();
            invokeHandler(handler);
        }
    }

    private void invokeHandler(TriggerHandler handler) {
        switch on operation {
            when AFTER_DELETE {
                handler.afterDelete(Trigger.oldMap);
            } when AFTER_INSERT {
                handler.afterInsert(Trigger.newMap);
            } when AFTER_UNDELETE {
                handler.afterUndelete(Trigger.newMap);
            } when AFTER_UPDATE {
                handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
            } when BEFORE_DELETE {
                handler.beforeDelete(Trigger.oldMap);
            } when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            } when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }
    }
}