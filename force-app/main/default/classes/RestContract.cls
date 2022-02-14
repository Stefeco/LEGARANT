@RestResource(urlMapping='/ContractAPI/*')
global with sharing class RestContract {

    @httpPost
    global static Id postContract(String accountId, String status, String startDate, String contractTerm){

    //création d'un nouveau contrat qui inclus les attributs passés en paramètre
    Contract ctr = new Contract(
        AccountId = accountId,
        Status = status,
        StartDate = date.parse(startDate),
        ContractTerm = Integer.valueof(contractTerm)
        );
    
        insert ctr;
        return ctr.Id;
    }


    @httpPatch
    global static void patchContract(){

        //initializer les paramètres de la requête
        RestRequest contractRequest = RestContext.request;
        String contractRequestURI = ContractRequest.requestURI;

        //capture de l'URI
        String contractId = contractRequestURI.substring(
            contractRequestURI.lastIndexOf('/')+1);
        System.debug('ContractId = ' + contractId);
        
        //on sauvegarde le ou les requêtes en paramètre
        String requestBody = contractRequest.requestBody.toString();
        System.debug('requestBody = ' + requestBody);

        //création d'une instance de l'objet contact
        Contract thisContract = [SELECT Id from Contract WHERE Id = :contractId];
        System.debug('thisContract after SELECT = ' + thisContract);

        //désérializer le string JSON
        if(String.isNotEmpty(requestBody)){

            //boucler sur les paramètres et faire la mise à jour
            thisContract = (Contract) JSON.deserialize(requestBody, Contract.class);
            thisContract.Id = contractId;
            System.debug('RestContract.thisContract after JSON.deserialize = ' + thisContract);

            update thisContract;
        }
    } // end of method

} // end of class
