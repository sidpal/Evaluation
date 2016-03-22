@isTest
public with sharing class OrderTriggerTest 
{
    static testmethod void OrderTrigger_insert()
    {
        String errorMessage;
        List<Order__c> orderList = new List<Order__c>();
        
        Order__c orderOne = new Order__c();
        Order__c orderTwo = new Order__c();
        
        orderOne.Name = 'Order1';
        orderOne.Cost_discount__c = 500;
        orderOne.Cost_shipping__c = 2500;
        orderOne.Cost_tax__c = 1500;
        orderOne.Customer_mobile__c = '98756412';
        orderOne.Email__c = 'nikhil@gmail.com';
        orderOne.First_Name__c = 'Nikhil';
        orderOne.Last_Name__c = 'Pote';
        orderOne.Order_date__c = Date.newInstance(2016, 01, 15);
        orderOne.Order_status__c = 'Prospecting';
        orderOne.Phone__c = '12365478';
        orderOne.Sale_amount__c = 1500;
        
        
        
        orderTwo.Name = 'Order2';
        orderTwo.Cost_discount__c = 1500;
        orderTwo.Cost_shipping__c = 3500;
        orderTwo.Cost_tax__c = 9500;
        orderTwo.Customer_mobile__c = '87564127';
        orderTwo.Email__c = 'bhushan@gmail.com';
        orderTwo.First_Name__c = 'Bhushan';
        orderTwo.Last_Name__c = 'Patil';
        orderTwo.Order_date__c = Date.newInstance(2016, 02, 15);
        orderTwo.Order_status__c = 'Qualification';
        orderTwo.Phone__c = '85476325';
        orderTwo.Sale_amount__c = 3500;
        
        orderList.add(orderOne);
        orderList.add(orderTwo);
        
        Test.startTest();
	        try
	        {
	            insert orderList;
	        }
	        catch(Exception e)
	        {
	            errorMessage = e.getMessage();
	        }
        Test.stopTest();
        
        List<Contact> contactList =  [select id, Phone from Contact];
        List<Opportunity> OpportunityList =  [select id, Amount from Opportunity];
        
        System.assertEquals(2, orderList.size(), 'Required Accounts not found');
        System.assertEquals(2, contactList.size(), 'Required Contacts not present');
        System.assertEquals(2, OpportunityList.size(), 'Required Opportunity not present');
        
        System.assertEquals('12365478', contactList[0].Phone,'Phone Number not equal');
        System.assertEquals('1500.00', String.valueOf(OpportunityList[0].Amount),'Amount not equal');
        System.assertEquals('85476325', contactList[1].Phone,'Phone Number not equal');
        System.assertEquals('3500.00', String.valueOf(OpportunityList[1].Amount),'Amount not equal');
        
    }
    
    static testmethod void OrderTrigger_update()
    {
        String insertErrorMessage, updateErrorMessage;
        List<Order__c> orderList = new List<Order__c>();
        List<Order__c> orderListTwo = new List<Order__c>();
        
        Order__c orderOne = new Order__c();
        Order__c orderThree = new Order__c();
        Order__c orderTwo = new Order__c();
        Order__c orderFour = new Order__c();
        
        orderOne.Name = 'Order1';
        orderOne.Cost_discount__c = 500;
        orderOne.Cost_shipping__c = 2500;
        orderOne.Cost_tax__c = 1500;
        orderOne.Customer_mobile__c = '98756412';
        orderOne.Email__c = 'nikhil@gmail.com';
        orderOne.First_Name__c = 'Nikhil';
        orderOne.Last_Name__c = 'Pote';
        orderOne.Order_date__c = Date.newInstance(2016, 01, 15);
        orderOne.Order_status__c = 'Prospecting';
        orderOne.Phone__c = '12365478';
        orderOne.Sale_amount__c = 1500;
        
        
        
        orderThree.Name = 'Order3';
        orderThree.Cost_discount__c = 500;
        orderThree.Cost_shipping__c = 2500;
        orderThree.Cost_tax__c = 1500;
        orderThree.Customer_mobile__c = '98756412';
        orderThree.Email__c = 'anjali@gmail.com';
        orderThree.First_Name__c = 'Anjali';
        orderThree.Last_Name__c = 'Patel';
        orderThree.Order_date__c = Date.newInstance(2016, 04, 15);
        orderThree.Order_status__c = 'Prospecting';
        orderThree.Phone__c = '112233445';
        orderThree.Sale_amount__c = 3500;
        
        
        
        orderList.add(orderOne);
        orderList.add(orderThree);
        try
        {
            insert orderList;
        }
        catch(Exception e)
        {
            insertErrorMessage = e.getMessage();
        }
        
       
        
        orderTwo.Id = orderList[0].ID;
        orderTwo.Cost_discount__c = 500;
        orderTwo.Cost_shipping__c = 2500;
        orderTwo.Cost_tax__c = 1500;
        orderTwo.Customer_mobile__c = '98756412';
        orderTwo.Email__c = 'nikhil@gmail.com';
        orderTwo.First_Name__c = 'Nikhil';
        orderTwo.Last_Name__c = 'Pote';
        orderTwo.Order_date__c = Date.newInstance(2016, 01, 15);
        orderTwo.Order_status__c = 'Prospecting';
        orderTwo.Phone__c = '987654321';
        orderTwo.Sale_amount__c = 2000;
        
        
        
        orderFour.Id = orderList[1].ID;
        orderFour.Cost_discount__c = 500;
        orderFour.Cost_shipping__c = 2500;
        orderFour.Cost_tax__c = 1500;
        orderFour.Customer_mobile__c = '98756412';
        orderFour.Email__c = 'anjali@gmail.com';
        orderFour.First_Name__c = 'Anjali';
        orderFour.Last_Name__c = 'Patel';
        orderFour.Order_date__c = Date.newInstance(2016, 04, 15);
        orderFour.Order_status__c = 'Prospecting';
        orderFour.Phone__c = '998877665';
        orderFour.Sale_amount__c = 4000;
        
        orderListTwo.add(orderTwo);
        orderListTwo.add(orderFour);
        
        try
        {
	        Test.startTest();
	            update orderListTwo;
	        Test.stopTest();
        }
        catch(Exception e)
        {
            updateErrorMessage = e.getMessage();
        }
        List<Contact> contactList =  [select id, Phone from Contact];
        List<Opportunity> OpportunityList =  [select id, Amount from Opportunity];
        
        System.assertEquals('987654321', contactList[0].Phone,'Phone Number not equal');
        System.assertEquals('2000.00', String.valueOf(OpportunityList[0].Amount),'Amount not equal');
        System.assertEquals('998877665', contactList[1].Phone,'Phone Number not equal');
        System.assertEquals('4000.00', String.valueOf(OpportunityList[1].Amount),'Amount not equal');
        
    }
    
    static testmethod void OrderTrigger_insertError()
    {
        String insertErrorMessage;
        List<Order__c> orderList = new List<Order__c>();
        
        Order__c orderOne = new Order__c();
        Order__c orderTwo = new Order__c();
        
        orderOne.Name = 'Order1';
        orderOne.Cost_discount__c = 500;
        orderOne.Cost_shipping__c = 2500;
        orderOne.Cost_tax__c = 1500;
        orderOne.Customer_mobile__c = '98756412';
        orderOne.Email__c = 'nikhil@gmail.com';
        orderOne.First_Name__c = 'Nikhil';
        orderOne.Last_Name__c = 'Pote';
        orderOne.Order_date__c = Date.newInstance(2016, 01, 15);
        orderOne.Order_status__c = 'Prospecting';
        orderOne.Phone__c = '12365478';
        orderOne.Sale_amount__c = 1500;
        
        
        
        orderTwo.Name = 'Order1';
        orderTwo.Cost_discount__c = 500;
        orderTwo.Cost_shipping__c = 2500;
        orderTwo.Cost_tax__c = 1500;
        orderTwo.Customer_mobile__c = '98756412';
        orderTwo.Email__c = 'nikhil@gmail.com';
        orderTwo.First_Name__c = 'Nikhil';
        orderTwo.Last_Name__c = 'Pote';
        orderTwo.Order_date__c = Date.newInstance(2016, 01, 15);
        orderTwo.Order_status__c = 'Prospecting';
        orderTwo.Phone__c = '12365478';
        orderTwo.Sale_amount__c = 1500;
        
        orderList.add(orderOne);
        orderList.add(orderTwo);
        
        Test.startTest();
	        try
	        {
	            insert orderList;
	        }
	        catch(Exception e)
	        {
	            insertErrorMessage = e.getMessage();
	        }
        Test.stopTest();
        
        System.assertEquals('Insert failed. First exception on row 1; first error: DUPLICATE_VALUE, duplicate value found: <unknown> duplicates value on record with id: <unknown>: []',insertErrorMessage,'Error not matched');
        
    }
}
