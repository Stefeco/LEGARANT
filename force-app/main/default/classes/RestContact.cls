@RestResource(urlMapping='/ContactAPI/*')
global with sharing class RestContact {

    
    @httpPost
    global static Contact createContact(String lastName, String email, String accountId){

        //recherche d'une liste de contacts avec l'email reçu
        List <Contact> ctt = [SELECT Email from Contact WHERE Email = :email LIMIT 1];
        
        //si la liste est vide on crée un nouveau contact
        if(ctt.isEmpty()){
        
        Contact newContact = new Contact(
            LastName = lastName,
            Email = email,
            AccountId = accountId
            );

        insert newContact;
        return newContact;

        // si non on revoie le contact existant
        } else {
            return ctt[0];
        }
        
    } // end of method

    @httpDelete
    global static void deleteContact(){

        //capture de l'Id du contact dans la query
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        System.debug('RestRequest.DeleteContact.contactId = ' + contactId);
        
        //recherche du contact dans salesforce et on passe le champ active__c à false
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        System.debug('RestRequest thisContact = ' + thisContact);
        thisContact.Active__c = false;
        System.debug('RestRequest thisContact.Active__c = ' + thisContact.Active__c);
        
        update thisContact;
    } //end of method



    
    @httpPatch
    global static Contact updateContactFields(){

        //initializer les paramètres de la requête
        RestRequest contactRequest = RestContext.request;
        String contactRequestURI = ContactRequest.requestURI;

        //capture de l'URI
        String contactId = contactRequestURI.substring(
            contactRequestURI.lastIndexOf('/')+1);
        System.debug('contactId = ' + contactId);
        
        //on sauvegarde le ou les requêtes en paramètre
        String requestBody = contactRequest.requestBody.toString();
        System.debug('requestBody = ' + requestBody);
        
        //création d'une instance de l'objet contact
        Contact thisContact = [SELECT Id from Contact WHERE Id = :contactId];
        System.debug('thisContact after SELECT = ' + thisContact);

        //désérializer le string JSON
        if(String.isNotEmpty(contactId)){
            thisContact = (Contact) JSON.deserialize(requestBody, Contact.class);
            thisContact.Id = contactId;
            update thisContact;
            }

            return thisContact;
    }//end of method
    
} // end of class
