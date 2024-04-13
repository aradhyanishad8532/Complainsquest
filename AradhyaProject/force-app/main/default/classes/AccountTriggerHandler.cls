public class AccountTriggerHandler {
    public static void accountTrigger(List<Account> newAccounts, Map<Id, Account> oldMap) {
        List<Contact> newContacts = new List<Contact>();
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : newAccounts) {
            if (acc.Type == 'Customer - Direct' && acc.AGActive__c && (Trigger.isInsert || (Trigger.isUpdate && oldMap.get(acc.Id).AGActive__c == false))) {
                accountIds.add(acc.Id);
            }
        }
   List<Account>accountList = [SELECT Id,Name,Phone,Company_Email__c FROM Account WHERE Id IN :accountIds];
        if (!accountIds.isEmpty()) {
            for (Account acc :accountList) {
                newContacts.add(new Contact(
                    FirstName = acc.Name,
                    LastName = 'Customer Representative',
                    Phone = acc.Phone,
                    Email = acc.Company_Email__c,
                    AccountId = acc.Id
                ));
            }
        }

        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
}