@isTest
public with sharing class TestRestContact {

    @TestSetup
    static void prepareTestContact(){
        
    }

    @isTest
    public static void contactWithExistingEmail() {

        //préparation du test
        Contact cttWithExistingEmail = TestDataFactory.createContactWithExistingEmail();

        //appel du test
        Test.startTest();

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/contactAPI/';
        contactRequest.httpMethod = 'POST';
        RestContext.request = contactRequest;

        //insertion d'un nouveau contact
        Contact ctt = RestContact.createContact('test002', 'test001@Test.com', '0017Q000006q3o9QAA');
        System.debug('Id de cttWithExistingMail = ' + cttWithExistingEmail.Id);
        System.debug('Id de ctt = ' + ctt.Id);

        Test.stopTest();

        //vérification du test
        System.assert(ctt != null);
        System.assert(ctt.Id == cttWithExistingEmail.Id);
    }


    @isTest
    public static void contactWithoutExistingEmail (){

        //préparation du test
        Contact cttWithoutExistingEmail = TestDataFactory.createContactWithoutExistingEmail();
        System.debug('cttWithoutExistingEmail Id après factory : ' + cttWithoutExistingEmail);

        //appel du test
        Test.startTest();

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/contactAPI/';
        contactRequest.httpMethod = 'POST';
        RestContext.request = contactRequest;

        //insertion d'un nouveau contact
        Contact ctt = RestContact.createContact('test002', 'test001@Test.com', '0017Q000006q3o9QAA');
        System.debug('cttWithoutExistingMail = ' + cttWithoutExistingEmail);
        System.debug('ctt = ' + ctt);

        Test.stopTest();

        //vérification du test - on vérifie que l'Id du nouveau contact est bien différent.
        System.assert(ctt != null);
        System.debug('ctt après assert : ' + ctt);
        System.assert(ctt.Id != cttWithoutExistingEmail.Id);
        System.debug('ctt.Id après assert : ' + ctt.Id);
        System.debug('cttWithoutEistingEmail.Id after assert : ' + cttWithoutExistingEmail.Id);
        System.assert('ctt AccountId = ' + ctt.AccountId != null);
        
    }

    @isTest
    public static void updateContactWithFieldChange() {

        //préparation du test
        Contact cttWithFieldToBeChanged = TestDataFactory.createContactWithFieldToBeChanged();
        System.debug('cttWithFieldToBeChanged après factory : ' + cttWithFieldToBeChanged);

        //appel du test
        Test.startTest();

        Contact changedContact = new Contact();
        changedContact.Department = 'nouveau département';

        //création de l'uri et du body pour la modification, on change le request body en JSON puis en Blob
        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/contactAPI/' + cttWithFieldToBeChanged.Id;
        contactRequest.httpMethod = 'PATCH';
        contactRequest.requestBody = Blob.valueof(JSON.serialize(changedContact));
        RestContext.request = contactRequest;

        //appel de la méthode pour update
        RestContact.updateContactFields();

        //récupération du contact après les changements
        Contact queriedContact = [SELECT LastName, Email, Id, Department FROM Contact WHERE Id = :cttWithFieldToBeChanged.Id];

        Test.stopTest();

        //vérification
        System.assertEquals('nouveau département',queriedContact.Department);
        System.assertEquals(cttWithFieldToBeChanged.Id, queriedContact.Id);

    }


    @isTest
    public static void deactivateDeletedContact(){

        //préparation du test
        Contact ctt = TestDataFactory.createContactWithExistingEmail();
        System.debug('ctt après factory : ' + ctt);
        //on triche un peu on met le statut en active
        ctt.Active__c = true;
        System.debug('ctt.status = ' + ctt.Active__c);

        //appel du Test
        Test.startTest();

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/contactAPI/' + ctt.Id;
        contactRequest.httpMethod = 'DELETE';
        RestContext.request = contactRequest;

        RestContact.deleteContact();
        ctt = [SELECT Id, Active__c from Contact WHERE Id = :ctt.Id];
        System.debug('ctt after delete = ' + ctt);

        Test.stopTest();

        //vérification
        System.assert(ctt!=Null);
        System.assertEquals(ctt.Active__c, false);
        System.debug('ctt statut = ' + ctt.Active__c);

    }
}
