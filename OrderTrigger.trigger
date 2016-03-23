trigger OrderTrigger on Order__c (after insert, before update) 
{
    OrderTriggerrHandler orderTriggerHandlerRef = new OrderTriggerrHandler(); //Making Object of Handler Class
    if(trigger.isAfter && trigger.isinsert)
    {
        orderTriggerHandlerRef.onAfterInsert(trigger.new); // Passing the new List to the method
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {
         orderTriggerHandlerRef.onBeforeUpdate(trigger.new); // Passing the new List to the method
    }
}