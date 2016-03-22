public with sharing class OrderTriggerHandler 
{
    public void onAfterInsert(List<Order__c> orderList) //Method accepting Trigger.new as List of Order
    {
        String insertAccountError, insertContactError, insertOpportunityError;
        List<Account> accountList = new List<Account>(); // Creating List of Account
        List<Contact> contactList = new List<Contact>(); // Creating List of Contact
        List<Opportunity> opportunityList = new List<Opportunity>(); // Creating List of Opportunity
        Map<Id, Account> accountMap = new Map<Id, Account>(); // Creating Map of Account
        for(Order__c tempOrder : orderList)
        {
            Account accountOne = new Account();                 //Assigning the values of order to Account
            accountOne.External_Accounts_ID__c = tempOrder.Id;
            accountOne.Billing_Email__c = tempOrder.Email__c;
            accountOne.Phone = tempOrder.Phone__c;
            accountOne.Name  = tempOrder.Last_Name__c;
            accountList.add(accountOne);
        }
        
        insert accountList; // Performing DML Operation on Account
            
        for(Account accountTemp : accountList)
        {
            accountMap.put(accountTemp.External_Accounts_ID__c , accountTemp);  // Making a Map of External Id to Account
        }
        
        for(Order__c tempOrder : orderList)
        {
            if(accountMap.containsKey(tempOrder.ID))
            {
                Contact contactOne = new Contact();                 //Making Contact according to AccountId
                contactOne.LastName = tempOrder.Last_Name__c;
                contactOne.FirstName = tempOrder.First_Name__c;
                contactOne.Phone = tempOrder.Phone__c;
                contactOne.AccountId = accountMap.get(tempOrder.ID).ID;
                contactOne.Email = tempOrder.Email__c;
                contactList.add(contactOne);
                
                Opportunity opportunityOne = new Opportunity();        //Making Opportunity according to AccountId
                opportunityOne.Amount = tempOrder.Sale_amount__c;
                opportunityOne.Name = String.valueOf(tempOrder.CreatedDate);
                opportunityOne.CloseDate = Date.valueOf(tempOrder.CreatedDate);
                opportunityOne.AccountId = accountMap.get(tempOrder.ID).ID;
                opportunityOne.StageName = tempOrder.Order_status__c;
                opportunityList.add(opportunityOne);
            }
        }
        
        insert contactList;  // Performing DML Operation on Contact
        insert opportunityList;  // Performing DML Operation on Opportunity
    }
    
    public void onBeforeUpdate(List<Order__c> orderList)
    {
        String updateAccountError, updateContactError, updateOpportunityError;
        Set<String> orderSet = new Set<String>();   //Creating Set of Id for Query
        Map<Id, Contact> contactMap = new Map<Id, Contact>();        //Creating Map for storing Contact Details
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();   //Creating Map for storing Opportunity Details
        Map<id, Order__c> orderMap = new Map<id, Order__c>();   //Creating Map for storing Order Details
        List<Account> accountList = new List<Account>();        //Creating List of Account for Update
        List<Contact> contactList = new List<Contact>();        //Creating List of Contact for Update
        List<Opportunity> OpportunityList = new List<Opportunity>();        //Creating List of Opportunity for Update
        
        for(Order__c tempOrder : orderList)
        {
            orderSet.add(tempOrder.Id);     //getting all Id of Order
            orderMap.put(tempOrder.id , tempOrder);     //Making Map of Order id and Order
        }
        
        for(Contact tempContact : [Select id, AccountId from Contact])
        {
            contactMap.put(tempContact.AccountId , tempContact);        //Making Map of Contact id to Contact
        }
        
        for(Opportunity tempOpportunity : [Select id, AccountId from Opportunity])
        {
            OpportunityMap.put(tempOpportunity.AccountId , tempOpportunity);        ////Making Map of Opportunity id to Contact
        }
        
        for(Account tempAccount : [select id, External_Accounts_ID__c from Account where External_Accounts_ID__c =: orderSet])
        {
            if(orderMap.containsKey(tempAccount.External_Accounts_ID__c))
            {
                Account accountOne = new Account(); //Making Account Object to be added to List
                accountOne.Id = tempAccount.Id;
                accountOne.Billing_Email__c = orderMap.get(tempAccount.External_Accounts_ID__c).Email__c;
                accountOne.Phone = orderMap.get(tempAccount.External_Accounts_ID__c).Phone__c;
                accountOne.Name  = orderMap.get(tempAccount.External_Accounts_ID__c).Last_Name__c;
                accountList.add(accountOne);
                
                if(contactMap.containsKey(tempAccount.Id))
                {
                    Contact contactOne = new Contact();    //Making Contact Object to be added to List
                    contactOne.Id = contactMap.get(tempAccount.ID).Id;
                    contactOne.LastName = orderMap.get(tempAccount.External_Accounts_ID__c).Last_Name__c;
                    contactOne.FirstName = orderMap.get(tempAccount.External_Accounts_ID__c).First_Name__c;
                    contactOne.Phone = orderMap.get(tempAccount.External_Accounts_ID__c).Phone__c;
                    contactOne.Email = orderMap.get(tempAccount.External_Accounts_ID__c).Email__c;
                    contactList.add(contactOne);
                }
                
                if(OpportunityMap.containsKey(tempAccount.Id))
                {
                    Opportunity opportunityone = new Opportunity(); //Making Opportunity Object to be added to List
                    opportunityOne.Id = OpportunityMap.get(tempAccount.ID).Id;
                    opportunityOne.Amount = orderMap.get(tempAccount.External_Accounts_ID__c).Sale_amount__c;
                    opportunityOne.Name = String.valueOf(orderMap.get(tempAccount.External_Accounts_ID__c).CreatedDate);
                    opportunityOne.CloseDate = Date.valueOf(orderMap.get(tempAccount.External_Accounts_ID__c).CreatedDate);
                    opportunityOne.StageName = orderMap.get(tempAccount.External_Accounts_ID__c).Order_status__c;
                    opportunityList.add(opportunityOne);
                }
            }
        }
        update accountList;         //Updating List of Account
        update contactList;         //Updating List of Contact
        update opportunityList;     //Updating List of Opportunity
    }
}