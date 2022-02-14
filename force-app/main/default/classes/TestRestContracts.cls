@isTest
public with sharing class TestRestContracts {

    @TestSetup
    static void prepareTestContract(){
        
    }

@isTest
public static void newContractReturnsId(){

        //appel du test
        Test.startTest();

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/ContractAPI/';
        contactRequest.httpMethod = 'POST';
        RestContext.request = contactRequest;

        Id ctr = RestContract.postContract('0017Q000006q3o9QAA','Draft','15/02/2022','30');
        System.debug('ctr value after creation : ' + ctr);

        Contract createdContract = [SELECT Id 
                                    FROM Contract
                                    WHERE AccountId = '0017Q000006q3o9QAA'];
        System.debug('Id in SELECT = ' + createdContract.Id);

        Test.stopTest();

        //vérification du test
        System.assert(ctr != null);
        System.assertEquals(ctr, createdContract.Id);

    } //end of method

@isTest
public static void contractWithFieldChange(){

    //préparation du test
    Contract ctrWithFieldToBeChanged = TestDataFactory.creatteNewContractWithFieldToBeChanged();
    System.debug('ctrWithFieldToBeChanged après factory : ' + ctrWithFieldToBeChanged);
    
    //appel du test
    Test.startTest();

    Contract changedContract = new Contract();
    changedContract.ContractTerm = 15;
    changedContract.StartDate = Date.parse('01/03/2022');
    System.debug('changedContract après modifs dans test = ' + changedContract);
    
    //création de l'uri et du body pour la modification, on change le request body en JSON puis en Blob
    RestRequest contractRequest = new RestRequest();
    contractRequest.requestURI = 'https://nocompany-27f-dev-ed.my.salesforce.com/services/apexrest/contactAPI/' + ctrWithFieldToBeChanged.Id;
    contractRequest.httpMethod = 'PATCH';
    contractRequest.requestBody = Blob.valueof(JSON.serialize(changedContract));
    RestContext.request = contractRequest;

    //appel de la méthode pour update
    RestContract.patchContract();

    //récupération du contact après les changements
    List<Contract> queriedContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id = :ctrWithFieldToBeChanged.Id];
    System.debug('Liste de contrats trouvée = ' + queriedContract);

    Test.stopTest();

    //vérification du test
    System.assertEquals(15,queriedContract[0].ContractTerm);
    System.assertEquals(ctrWithFieldToBeChanged.Id, queriedContract[0].Id);

    } //end of method

} // end of TestClass
