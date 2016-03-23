public with sharing class OrderTriggerrHandler {

    public void onAfterInsert(List<Order__c> orderList) //Method accepting Trigger.new as List of Order
    {
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
        try
        {
            insert accountList; // Performing DML Operation on Account
        }
        catch(Exception e)
        {
            
        }    
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
	    try
	    {    
	        insert contactList;  // Performing DML Operation on Contact
	        insert opportunityList;  // Performing DML Operation on Opportunity
	        
	    }Catch(Exception e){
	        
	    }
    }
    
    public void onBeforeUpdate(List<Order__c> orderList)
    {
        Set<String> orderSet = new Set<String>();   //Creating Set of Id for Query
        List<Account> accountList = new List<Account>();        //Creating List of Account for Update
        List<Contact> contactList = new List<Contact>();        //Creating List of Contact for Update
        List<Opportunity> OpportunityList = new List<Opportunity>();        //Creating List of Opportunity for Update
        
        for(Order__c tempOrder : orderList)
        {
            orderSet.add(tempOrder.Id);     //getting all Id of Order
        }
        
        Map<Id,Account> accountMap = new Map<Id, Account>();
		Map<Id, List<Contact>> contactMap = new Map<Id, List<Contact>>();
		Map<Id, List<Opportunity>> opportunityMap = new Map<Id, List<Opportunity>>();
		        
		for(Account acc : [Select Id, Name, External_Accounts_ID__c, (Select Id, AccountId From Contacts), (Select Id, AccountId From Opportunities) From Account Where External_Accounts_ID__c IN :orderSet])
		{
		    accountMap.put(acc.External_Accounts_ID__c, acc);
		    contactMap.put(acc.Id, acc.Contacts);
		    opportunityMap.put(acc.Id, acc.Opportunities);
		}
		for(Order__c tempOrder : orderList)
		{
		    if(accountMap.containsKey(tempOrder.Id) == true)
		    {
		        Account accountRef = accountMap.get(tempOrder.Id);
		        accountRef.Billing_Email__c = tempOrder.Email__c;
		        accountRef.Phone = tempOrder.Phone__c;
		        accountRef.Name  = tempOrder.Last_Name__c;
		        accountList.add(accountRef);
		        
		        if(contactMap.containsKey(accountRef.Id))
		        {
		            List<Contact> contactListRef = contactMap.get(accountRef.Id);
		            contactListRef[0].LastName = TempOrder.Last_Name__c;
		            contactListRef[0].FirstName = TempOrder.First_Name__c;
		            contactListRef[0].Phone = TempOrder.Phone__c;
		            contactListRef[0].Email = TempOrder.Email__c;
		            contactList.add(contactListRef[0]);
		        }
		        
		        if(opportunityMap.containsKey(accountRef.Id))
		        {
		            List<Opportunity> opportunityListRef = opportunityMap.get(accountRef.Id);
		            opportunityListRef[0].Amount = TempOrder.Sale_amount__c;
		            opportunityListRef[0].Name = String.valueOf(TempOrder.CreatedDate);
		            opportunityListRef[0].CloseDate = Date.valueOf(TempOrder.CreatedDate);
		            opportunityListRef[0].StageName = TempOrder.Order_status__c;
		            opportunityList.add(opportunityListRef[0]);
		        }
		    }
		}
		try
		{
	        update accountList;         //Updating List of Account
	        update contactList;         //Updating List of Contact
	        update opportunityList;     //Updating List of Opportunity
		}
		catch(Exception e)
		{
		    
		}
    }
}