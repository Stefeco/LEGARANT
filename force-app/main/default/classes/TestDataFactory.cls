@isTest
public with sharing class TestDataFactory {

    @isTest
    public static Contact createContactWithExistingEmail() {

        Contact cttWithExistingEmail = new Contact(
            LastName = 'Test001',
            Email = 'test001@test.com',
            AccountId = '0017Q000006q3o9QAA'
        );

        insert cttWithExistingEmail;
        return cttWithExistingEmail;

    } //end of method

    @isTest
    public static Contact createContactWithoutExistingEmail(){

        Contact cttWithoutExistingEmail = new Contact(
            LastName = 'Test002',
            Email = 'NoEmail@test.com',
            AccountId = '0017Q000006q3o9QAA'
        );

        insert cttWithoutExistingEmail;
        return cttWithoutExistingEmail;

    }// end of method

   @isTest
   public static Contact createContactWithFieldToBeChanged(){

        Contact cttWithFieldToBeChanged = new Contact(
            LastName = 'TestChangeMe001',
            Email = 'Test003@test.com',
            AccountId = '0017Q000006q3o9QAA',
            Department = 'pas de département'
        );

        insert cttWithFieldToBeChanged;
        return cttWithFieldToBeChanged;
   } //end of method

   @isTest
   public static Contract createNewContract(){

        Contract newctr = new Contract(
            AccountId = '0017Q000006q3o9QAA',
            Status = 'Draft',
            StartDate = date.parse('15/02/2022'),
            ContractTerm = 30
        );

        insert newctr;
        return newctr;

   } //end of method

   @isTest
   public static Contract creatteNewContractWithFieldToBeChanged(){

    Contract newctr = new Contract(
        AccountId = '0017Q000006q3oGQAQ',
        Status = 'Draft',
        StartDate = date.parse('21/02/2022'),
        ContractTerm = 12
    );

    insert newctr;
    return newctr;

   }// end of method

} //end of class
