@isTest
private class SFA_PosteVendeurService_WS_TEST {

    static testMethod void GetClientByIDResponseTest() {
        
        List<Opportunity> opports = initOpportunity();
        initCodeSettings();
        
        Test.startTest();
        SFA_PosteVendeurService_WS.GetClientByIDResponse responseOK = SFA_PosteVendeurService_WS.getClientById(opports[0].Id);
        SFA_PosteVendeurService_WS.GetClientByIDResponse responsePRO = SFA_PosteVendeurService_WS.getClientById(opports[1].Id);
        SFA_PosteVendeurService_WS.GetClientByIDResponse responseART = SFA_PosteVendeurService_WS.getClientById(opports[2].Id);
        SFA_PosteVendeurService_WS.GetClientByIDResponse responseINV = SFA_PosteVendeurService_WS.getClientById('006d0012SZE876tAA4');
        Test.stopTest();
        
        system.assertEquals('0', responseOK.oErreurS.code);
        system.assertEquals('FR', responseOK.getClientByIDResult.codePays);
        system.assertEquals(SFA_PosteVendeurService_WS.EtatCivil.Monsieur, responseOK.getClientByIDResult.etatCivil);
        system.assertEquals(SFA_PosteVendeurService_WS.Categorie.Particulier, responseOK.getClientByIDResult.categorie);
        
        system.assertEquals('0', responsePRO.oErreurS.code);
        system.assertEquals('FR', responsePRO.getClientByIDResult.codePays);
        system.assertEquals(SFA_PosteVendeurService_WS.EtatCivil.Societe, responsePRO.getClientByIDResult.etatCivil);
        system.assertEquals(SFA_PosteVendeurService_WS.Categorie.PersonneMorale, responsePRO.getClientByIDResult.categorie);
        system.assertEquals('111122223', responsePRO.getClientByIDResult.numSIREN);
        system.assertEquals('44455', responsePRO.getClientByIDResult.numNIC);
        
        system.assertEquals('0', responseART.oErreurS.code);
        system.assertEquals('FR', responseART.getClientByIDResult.codePays);
        system.assertEquals(SFA_PosteVendeurService_WS.EtatCivil.Monsieur, responseART.getClientByIDResult.etatCivil);
        system.assertEquals(SFA_PosteVendeurService_WS.Categorie.PersonnePhysique, responseART.getClientByIDResult.categorie);
        
        
        system.assertEquals('1', responseINV.oErreurS.code);
        system.assertEquals(Label.LMT_PosteVendeur_NotFound, responseINV.oErreurS.libelle);
        
    }
    
    static testMethod void exportClient(){
        
        List<Opportunity> opports = initOpportunity();
        initCodeSettings();
        
        // création des clients
        
        // client particulier
        SFA_PosteVendeurService_WS.Client clientPART = new SFA_PosteVendeurService_WS.Client();
        clientPART.idOpportunite = opports[0].Id;
        clientPART.categorie = SFA_PosteVendeurService_WS.Categorie.Particulier;
        clientPART.etatCivil = SFA_PosteVendeurService_WS.EtatCivil.Monsieur;
        clientPART.nom = 'martin';
        clientPART.prenom = 'paul';
        clientPART.adresseEmail = 'paul.martin@xxx.com';
        clientPART.rue = '4 rue des Plantes'; // modifié
        clientPART.codePostal = '35000';
        clientPART.ville = 'RENNES';
        clientPART.codePays = 'FR';
        clientPART.telephone = '0321129999'; // modifié
        clientPART.telephonePortable = '0678766554';

        // client pro
        SFA_PosteVendeurService_WS.Client clientPRO = new SFA_PosteVendeurService_WS.Client();
        clientPRO.idOpportunite = opports[1].Id;
        clientPRO.categorie = SFA_PosteVendeurService_WS.Categorie.PersonneMorale;
        clientPRO.etatCivil = SFA_PosteVendeurService_WS.EtatCivil.Societe;
        clientPRO.nom = 'Garage Lemaître';
        clientPRO.adresseEmail = 'garage.lemaitre@xxxx.com'; // modifié
        clientPRO.rue = '8 rue des Fleurs';
        clientPRO.codePostal = '35700';
        clientPRO.ville = 'RENNES';
        clientPRO.codePays = 'FR';
        clientPRO.telephone = '0321122712';
        clientPRO.telephonePortable = '0645986543';
        clientPRO.numSIREN = '11112233'; // modifié
        clientPRO.numNIC = '344477'; // modifié
        
        List<SFA_PosteVendeurService_WS.Interlocuteur> listInter = new List<SFA_PosteVendeurService_WS.Interlocuteur>();
        SFA_PosteVendeurService_WS.Interlocuteur int1 = new SFA_PosteVendeurService_WS.Interlocuteur();
        int1.nom = 'contact';
        int1.prenom = 'un';
        int1.etatCivil = SFA_PosteVendeurService_WS.EtatCivil.Madame;
        int1.codeFonction = 2;
        SFA_PosteVendeurService_WS.Interlocuteur int2 = new SFA_PosteVendeurService_WS.Interlocuteur();
        int2.nom = 'contact';
        int2.prenom = 'trois';
        int2.etatCivil = SFA_PosteVendeurService_WS.EtatCivil.Monsieur;
        int2.codeFonction = 1;
                
        listInter.add(int1);
        listInter.add(int2);
        clientPRO.interlocuteurs = listInter;
        
        // client artisan
        SFA_PosteVendeurService_WS.Client clientART = new SFA_PosteVendeurService_WS.Client();
        clientART.idOpportunite = opports[2].Id;
        clientART.categorie = SFA_PosteVendeurService_WS.Categorie.PersonnePhysique;
        clientART.etatCivil = SFA_PosteVendeurService_WS.EtatCivil.Monsieur;
        clientART.nom = 'Martin';
        clientART.adresseEmail = 'mart@xxxx.com'; // modifié
        clientART.rue = '8 rue des Fleurs';
        clientART.codePostal = '35700';
        clientART.ville = 'RENNES';
        clientART.codePays = 'FR';
        clientART.telephone = '0321122713';
        clientART.telephonePortable = '0645986548';

        // client inexistant
        SFA_PosteVendeurService_WS.Client clientKO = new SFA_PosteVendeurService_WS.Client();
        clientKO.idOpportunite = '123456789';
        
        Test.startTest();
        SFA_PosteVendeurService_WS.ExportClientResponse responsePART = SFA_PosteVendeurService_WS.exportClient(clientPART);
        SFA_PosteVendeurService_WS.ExportClientResponse responsePRO = SFA_PosteVendeurService_WS.exportClient(clientPRO);
        SFA_PosteVendeurService_WS.ExportClientResponse responseART = SFA_PosteVendeurService_WS.exportClient(clientART);
        SFA_PosteVendeurService_WS.ExportClientResponse responseKO = SFA_PosteVendeurService_WS.exportClient(clientKO);
        Test.stopTest();
        
        Boolean setting = CS02_SFA_Settings__c.getInstance().WS_PVFtoSFA_active__c;
        
        if(setting == true){
            system.assertEquals('0', responsePART.oErreurS.code);
            // requests & asserts
            
            system.assertEquals('0', responsePRO.oErreurS.code);
            // requests & asserts
            
            system.assertEquals('0', responseART.oErreurS.code);
            // requests & asserts
            
            system.assertEquals('1', responseKO.oErreurS.code);
            system.assertEquals(Label.LMT_PosteVendeur_NotFound, responseKO.oErreurS.libelle);
        }
        else {
            system.assertEquals(null, responsePART);
            system.assertEquals(null, responsePRO);
            system.assertEquals(null, responseART);
            system.assertEquals(null, responseKO);
        }
        
    }
    
    static testMethod void exportPropositionTest(){
        List<Opportunity> opports = initOpportunity();
        
        SFA_PosteVendeurService_WS.Proposition p1 = new SFA_PosteVendeurService_WS.Proposition();
        SFA_PosteVendeurService_WS.Proposition p2 = new SFA_PosteVendeurService_WS.Proposition();
        
        
        p1.idOpportunite = opports[0].Id;
        p1.dateOffre = Date.today();
        p1.dateFinValiditeOffre = Date.today() + 15;
        
        p1.complement = new List<SFA_PosteVendeurService_WS.Complement>();
        SFA_PosteVendeurService_WS.Complement comp1 = new SFA_PosteVendeurService_WS.Complement();
        comp1.financier = true;
        comp1.montant = 55.0;
        comp1.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Option;
        comp1.libelleLong = 'Peinture métalisée';
        p1.complement.add(comp1);
        SFA_PosteVendeurService_WS.Complement comp2 = new SFA_PosteVendeurService_WS.Complement();
        comp2.financier = false;
        comp2.montant = 15.0;
        comp2.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Accessoire;
        comp2.libelleLong = 'Tapis de sol';
        p1.complement.add(comp2);
        SFA_PosteVendeurService_WS.Complement comp3 = new SFA_PosteVendeurService_WS.Complement();
        comp3.financier = false;
        comp3.montant = 120.0;
        comp3.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Supplement;
        comp3.libelleLong = 'Carte grise';
        p1.complement.add(comp3);
        SFA_PosteVendeurService_WS.Complement comp4 = new SFA_PosteVendeurService_WS.Complement();
        comp4.financier = false;
        comp4.montant = 40.0;
        comp4.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Supplement;
        comp4.libelleLong = 'Gravage';
        p1.complement.add(comp4);
        SFA_PosteVendeurService_WS.Complement comp5 = new SFA_PosteVendeurService_WS.Complement();
        comp5.financier = true;
        comp5.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Entretien;
        comp5.libelleLong = 'Entretien';
        p1.complement.add(comp5);
        SFA_PosteVendeurService_WS.Complement comp6 = new SFA_PosteVendeurService_WS.Complement();
        comp6.financier = true;
        comp6.typeElement = SFA_PosteVendeurService_WS.TypeComplement.ExtensionGarantie;
        comp6.libelleLong = 'Extension de garantie 2 ans';
        p1.complement.add(comp6);
        SFA_PosteVendeurService_WS.Complement comp7 = new SFA_PosteVendeurService_WS.Complement();
        comp7.financier = true;
        comp7.typeElement = SFA_PosteVendeurService_WS.TypeComplement.NouveauServices;
        comp7.libelleLong = 'Nouveau Service';
        p1.complement.add(comp7);
        SFA_PosteVendeurService_WS.Complement comp8 = new SFA_PosteVendeurService_WS.Complement();
        comp8.financier = true;
        comp8.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Pneus;
        comp8.libelleLong = 'Pneu supplémentaire';
        p1.complement.add(comp8);
        SFA_PosteVendeurService_WS.Complement comp9 = new SFA_PosteVendeurService_WS.Complement();
        comp9.financier = true;
        comp9.typeElement = SFA_PosteVendeurService_WS.TypeComplement.Assurance;
        comp9.libelleLong = 'Assurance bris de glace';
        p1.complement.add(comp9);
        p1.nbEcheance = new List<Integer>();
        p1.montantEcheanceHorsAss = new List<Double>();
        p1.prixVersCat = 8000.0;        
        p1.vehiculePhysique = new SFA_PosteVendeurService_WS.Vehicule();
        p1.repriseVO = new SFA_PosteVendeurService_WS.RepriseVO();
        p1.repriseVO.valeurRepriseTtc = 3500.0;
        p1.repriseVO.vehicule = new SFA_PosteVendeurService_WS.Vehicule();
        p1.vehiculePhysique.Marque = 'Renault';
        p1.vehiculePhysique.Modele = 'Clio';
        p1.vehiculePhysique.typeVPVU = SFA_PosteVendeurService_WS.TypeVPVU.Particulier;
        p1.dureeOffre = 1;
        
        p2.idOpportunite = '006d0012SZE876tAA4';
        p2.dateOffre = Date.today();
        p2.dateFinValiditeOffre = Date.today() + 15;
        p2.vehiculePhysique = new SFA_PosteVendeurService_WS.Vehicule();
        p2.repriseVO = new SFA_PosteVendeurService_WS.RepriseVO();
        p2.repriseVO.valeurRepriseTtc = 3800.0;
        p2.repriseVO.vehicule = new SFA_PosteVendeurService_WS.Vehicule();
        p2.vehiculePhysique.Marque = 'Renault';
        p2.vehiculePhysique.Modele = 'Twingo';
        p2.dureeOffre = 1;
        p2.nbEcheance = new List<Integer>();
        p2.montantEcheanceHorsAss = new List<Double>();
        
        Test.startTest();
        SFA_PosteVendeurService_WS.ExportPropositionResponse responseOK = SFA_PosteVendeurService_WS.exportProposition(p1);
        SFA_PosteVendeurService_WS.ExportPropositionResponse responseKO = SFA_PosteVendeurService_WS.exportProposition(p2);
        Test.stopTest();
        
        system.assertEquals('0', responseOK.oErreurS.code);
        
        system.assertEquals('1', responseKO.oErreurS.code);
        system.assertEquals(Label.LMT_PosteVendeur_NotFound, responseKO.oErreurS.libelle);
    }
    
    
    
    /**
    ** init an opportunity
    **/
    private static List<Opportunity> initOpportunity(){
        
        // Récupération des record types
        List<RecordType> recTypes = [Select id, Name 
                                            from RecordType 
                                            where (Name = :SFA_PosteVendeurService_WS.recordTypePro or Name = :SFA_PosteVendeurService_WS.recordTypePart)
                                            and SobjectType = 'Account' LIMIT 2];
        
        system.assertEquals(2, recTypes.size());                                    
        
        String recordTypeIdPart = null;
        String recordTypeIdPro = null;       
        if(recTypes[0].Name.equals(SFA_PosteVendeurService_WS.recordTypePro)){
             recordTypeIdPro = recTypes[0].Id;
             recordTypeIdPart = recTypes[1].Id;
        }
        else {
             recordTypeIdPro = recTypes[1].Id;
             recordTypeIdPart = recTypes[0].Id;
        }

            
        
        // Creation des accounts
        List<Account> accounts = new List<Account>();

        Account accountPart = new Account(salutation='Mr.', lastname='martin', firstname='paul', personemail='paul.martin@xxx.com', billingstreet='4 rue des Roses',
                            billingpostalcode='35000', billingcity='RENNES', country__c='FRANCE', PersLandline__c='0321122112', 
                            persmobphone__c= '0678766554', recordtypeid = recordTypeIdPart);
        
        Account accountPro = new Account(name='Garage Lemaître', profemailaddress__c='garage.lemaitre@xxx.com', shippingstreet='8 rue des Fleurs',
                            shippingpostalcode='35700', shippingcity='RENNES', country__c='FRANCE', ProfLandline__c='0321122712', 
                            profmobphone__c = '0645986543', SIRET__c = Long.valueOf('11112222344455'), recordtypeid = recordTypeIdPro);
        
        Account accountArt = new Account(name='Martin', profemailaddress__c='x@x.fr', shippingstreet='8 rue des Lilas',
                            shippingpostalcode='35700', shippingcity='RENNES', country__c='FRANCE', ProfLandline__c='0321122787', 
                            profmobphone__c = '0645986590', recordtypeid = recordTypeIdPro);
        
        accounts.add(accountPart);
        accounts.add(accountPro);
        accounts.add(accountArt);
        
        insert accounts;
        
        // Creation des contacts
        List<Contact> contacts = new List<Contact>();
        Contact c1 = new Contact(lastname = 'contact', firstname = 'un', salutation = 'Mrs.', contactposition__c = 'User', accountid = accountPro.Id, email='a@x.fr');
        Contact c2 = new Contact(lastname = 'contact', firstname = 'deux', salutation = 'Mrs.', contactposition__c = 'Fleet Manager', accountid = accountPro.Id, email='a@x.fr');
        Contact c3 = new Contact(lastname = 'contact', firstname = 'artisan', salutation = 'Mr.', contactposition__c = 'User', accountid = accountArt.Id, email='a@x.fr');
        contacts.add(c1);
        contacts.add(c2);
        contacts.add(c3);
        
        insert contacts;
        
        // Creation d'une opportunite liee a un account
        List<Opportunity> opports = new List<Opportunity>();
        
        Opportunity opportPart = new Opportunity(name='paul martin', closedate=Date.today(), stagename='open', Opportunity_Country__c = 'France', accountid=accountPart.Id);
        Opportunity opportPro = new Opportunity(name='Garage Lemaître', closedate=Date.today(), stagename='open', Opportunity_Country__c  = 'Belgique', accountid=accountPro.Id);
        Opportunity opportArt = new Opportunity(name='Client Artisan', closedate=Date.today(), stagename='open', Opportunity_Country__c  = 'France', accountid=accountArt.Id);
        
        opports.add(opportPart);
        opports.add(opportPro);
        opports.add(opportArt);
        insert opports;
        
        system.debug('Chargement des opportunités OK');
        
        return opports;
    }
    
    /**
    ** init codes settings
    **/
    private static void initCodeSettings(){
        List<CS01_Civilite__c> listCiv = new List<CS01_Civilite__c>();
        
        CS01_Civilite__c civ = new CS01_Civilite__c(Name = 'Mr.', Code_Civilite__c= 'Monsieur');
        listCiv.add(civ);
        civ = new CS01_Civilite__c(Name = 'Mrs.', Code_Civilite__c= 'Madame');
        listCiv.add(civ);
        civ = new CS01_Civilite__c(Name = 'Ms.', Code_Civilite__c= 'Madame');
        listCiv.add(civ);
        
        insert listCiv;
        
        system.debug('Chargement des codes civilité OK');
        
        List<Country_Info__c> listPays=new List<Country_Info__c>();
        
        Country_Info__c pays = new Country_Info__c(Name = 'France', Country_Code_2L__c = 'FR', Language__c='French');
        listPays.add(pays);
        pays = new Country_Info__c(Name = 'Malte', Country_Code_2L__c = 'MT', Language__c='French');
        listPays.add(pays);
        pays = new Country_Info__c(Name = 'Suède', Country_Code_2L__c = 'SE', Language__c='French');
        listPays.add(pays);
        
        insert listPays;
        
        system.debug('Chargement des codes pays OK');
        
        List<CS04_SFA_Function__c> listFct = new List<CS04_SFA_Function__c>();
        CS04_SFA_Function__c fct = new CS04_SFA_Function__c(Name = 'User', codeFonction__c = 4);
        listFct.add(fct);
        fct = new CS04_SFA_Function__c(Name = 'Fleet Manager', codeFonction__c = 3);
        listFct.add(fct);
        fct = new CS04_SFA_Function__c(Name = 'Leader', codeFonction__c = 1);
        listFct.add(fct);
        
        insert listFct;
        
        system.debug('Chargement des fonctions OK');
        
        CS02_SFA_Settings__c settings = new CS02_SFA_Settings__c(
                Email_Template_Id__c = '00Xm0000000QEhd', WS_PVFtoSFA_active__c = true, Email_Address_ReplyTo__c = 'x@x.fr'
            );
        insert settings;
        
    }
}