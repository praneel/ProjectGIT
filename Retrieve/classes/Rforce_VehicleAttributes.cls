public with sharing class Rforce_VehicleAttributes 
{

    public Rforce_VehicleAttributes() {
      
    }

    public Rforce_Utils_WarrantyDataSource WarrantyDataSource; // Data source to access the Web Service
    public Rforce_Utils_OTSDataSource OTSDataSource;
    public Rforce_Utils_MaintDataSource MaintDataSource;
    public Rforce_Utils_WarrantyHistoryDataSource WarrantyHistoryDataSource;
    public Rforce_Utils_ContractDataSource ContractDataSource;
    public Rforce_Utils_WarrantyHistoryDetailDataSo WarrantyHistoryDetailDataSource;
    public Rforce_Utils08_RCArchivage CasesDataSource;
    public String modulo {get;set;}
    public String numInt {get;set;}
    public String histoBim {get;set;}
    public String rc {get;set;}
    public String toParse{get;set;}
    public Rforce_ArchivesXMLData xmlData{get;set;}
    
    //XML Data
    public Rforce_ArchivesProperties.ArchivesCases[] ArchCasesList {get;set;}
    public Rforce_ArchivesProperties.ArchivesCases caseDetails {get;set;}
    public Rforce_ArchivesProperties.ArchivesAttachments[] ArchAttachmentsList {get;set;}  
    private VEH_Veh__c vehicle;
    public String IdCase {get;set;}
    public String attachmentURL{get;set;}
    public String attachmentXMLURL{get;set;}
    public String countryInfo{get;set;} 
    
    public Integer showDetail 
    {
        get { if(showDetail == null) {showDetail = 0; return showDetail;} else return showDetail; }
        set { showDetail = value; }
    }
    
           public Integer showValue
        {
            get { if(showValue == null) {showValue = 0; return showValue;} else return showValue; }
            set { showValue = value; }
        }
    
      public Integer showError 
        {
            get { if(showError == null) {showError = 0; return showError;} else return showError; }
            set { showError = value; }
        }
    // Show detail key
    // 0 Choose page
    // 1 Vehicle
    // 2 Warranty
    // 4 Contract
    // 5 OTR
    // 6 Maintenance
    // 7 Warranty History
  
  
    /*=======================================
      CONSTRUCTOR
    =======================================*/     
    public Rforce_VehicleAttributes(ApexPages.StandardController stdController) 
    { 
        WarrantyDataSource = new Rforce_Utils_WarrantyDataSource();
        OTSDataSource = new Rforce_Utils_OTSDataSource();
        MaintDataSource = new Rforce_Utils_MaintDataSource();
        ContractDataSource = new Rforce_Utils_ContractDataSource();
        WarrantyHistoryDataSource = new Rforce_Utils_WarrantyHistoryDataSource();
        WarrantyHistoryDetailDataSource = new Rforce_Utils_WarrantyHistoryDetailDataSo();
        CasesDataSource = new Rforce_Utils08_RCArchivage();
          

       VEH_Veh__c tmp= (VEH_Veh__c)stdController.getRecord();
        //System.debug('### => vehicle.id : ' + vehicle.id);        
        this.vehicle = [select id, name,CountryOfDelivery__c from VEH_Veh__c where id = :tmp.id];
        
        if(vehicle.name !=null && vehicle.CountryOfDelivery__c=='')
        {

           System.debug('Country Of Delivery is null>>>>>>>>>>>>>>');
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_CountryOfDelivery));


        }

        // WARNING: If you comment out this code, the webservices will fail with an error, there are no endpoints yet.
        if (!Test.isRunningTest())
        {
            WarrantyDataSource.test = false; //dummy implementation used       
            OTSDataSource.test = false;
            MaintDataSource.test = false;
            ContractDataSource.test = false;
            WarrantyHistoryDataSource.test = false;
            WarrantyHistoryDetailDataSource.test = false;
        }
    }

    public Rforce_WarrantyProperties[] wpList {get;set;}   
    public Rforce_OTSProperties[] otsPropList {get;set;} 
    public Rforce_MaintProperties maint {get;set;} 
    public Rforce_ContractProperties[] contracts {get;set;}
    public Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics[] whList {get;set;}
    public Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics whd {get;set;}
     
     
     
    public String getCountryInfo()
    
    {   
        if (Test.isRunningTest())
        {
            return 'PTB';
        }
        return 'TUR';
    } 
     
    public void getWarrantyData() 
    {
        try 
        { 
            
            Rforce_servicesBcsDfr.ListDetWarrantyCheck  results = WarrantyDataSource.getWarrantyData(this);
            
                
            if (results == null)
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            else
            {
                showDetail = 2;
             
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'results not null'));
                Rforce_servicesBcsDfr.ArrayOfErrMsg detInfoMsg = results.listErrMsg;
                Rforce_servicesBcsDfr.ListDetWarrantyCheck detWar = results;
                     
                if (detInfoMsg != null)
                {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + detInfoMsg.ErrMsg.zoneMsg));
                }
                    
                if (detWar != null) 
                {
                    wpList = new Rforce_WarrantyProperties[]{};
                    Rforce_WarrantyProperties wp = new Rforce_WarrantyProperties();
                    
                    if (detWar.listGarWarranty != null && detWar.listGarWarranty.ManufacturerWarranty != null)
                    {
                        for (Rforce_servicesBcsDfr.ManufacturerWarranty w : detWar.listGarWarranty.ManufacturerWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'Manufacturer';
                            wp.datFinGar = w.datFinGarGAR;
                            wp.kmMaxGar = w.kmMaxGarGAR;
                            wpList.Add(wp);
                        }
                    }
                    
                    if (detWar.listAssWarranty != null && detWar.listAssWarranty.AssistanceWarranty != null)
                    {   
                        for (Rforce_servicesBcsDfr.AssistanceWarranty w : detWar.listAssWarranty.AssistanceWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'Assistance';
                            wp.datFinGar = w.datFinGarASS;
                            wp.kmMaxGar = w.kmMaxGarASS;
                            wpList.Add(wp);
                        }
                    }
                    
                    if (detWar.listTurWarranty != null && detWar.listTurWarranty.PaintingWarranty != null)
                    {   
                        for (Rforce_servicesBcsDfr.PaintingWarranty w : detWar.listTurWarranty.PaintingWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'Painting';
                            wp.datFinGar = w.datFinGarTUR;
                            wp.kmMaxGar = w.kmMaxGarTUR;
                            wpList.Add(wp);
                        } 
                    }
                    
                    if (detWar.listCorWarranty != null && detWar.listCorWarranty.CorrosionWarranty != null)
                    {
                        for (Rforce_servicesBcsDfr.CorrosionWarranty w : detWar.listCorWarranty.CorrosionWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'Corrosion';
                            wp.datFinGar = w.datFinGarCOR;
                            wp.kmMaxGar = w.kmMaxGarCOR;
                            wpList.Add(wp);
                        }
                    }
                    
                    if (detWar.listBttWarranty != null && detWar.listBttWarranty.BatteryWarranty != null)     
                    {
                        for (Rforce_servicesBcsDfr.BatteryWarranty w : detWar.listBttWarranty.BatteryWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'Battery';
                            wp.datFinGar = w.datFinGarBTT;
                            wp.kmMaxGar = w.kmMaxGarBTT;
                            wpList.Add(wp);
                        }
                    }
                     
                    if (detWar.listGmeWarranty != null &&  detWar.listGmeWarranty.GMPeWarranty != null)
                    {   
                        for (Rforce_servicesBcsDfr.GMPeWarranty w : detWar.listGmeWarranty.GMPeWarranty)
                        {
                            wp = new Rforce_WarrantyProperties();
                            wp.Type = 'GMPe'; 
                            wp.datFinGar = w.datFinGarGME;
                            wp.kmMaxGar = w.kmMaxGarGME;
                            wpList.Add(wp);
                        }
                    }
                }
            }
        }
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Message));
        }
    }    

    public void getOTSData() 
    {
        try 
        {   
            Rforce_otsIcmApvBserviceRenault.ApvGetListOtsResponse  results = OTSDataSource.getOTSData(this);
                
            if (results == null) 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            else 
            {
                        
                showDetail = 5;
            
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'results not null'));
                Rforce_otsIcmApvBserviceRenault.otsInfoMsg otsInfoMsg;
                if (results.apvGetListOtsMsg != null)
                    otsInfoMsg = results.apvGetListOtsMsg[0];
                
                Rforce_otsIcmApvBserviceRenault.Ots[] otsRes = results.apvGetListOts;
                
                    
                if (otsInfoMsg != null) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + otsInfoMsg.code));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + otsInfoMsg.text));
                } 
                
                if (otsRes != null) 
                {
                    otsPropList = new Rforce_OTSProperties[]{};
                    Rforce_OTSProperties otsProp;
                    
                    for (Rforce_otsIcmApvBserviceRenault.Ots WSots : otsRes)
                    {
                        otsProp = new Rforce_OTSProperties();
                        otsProp.OTSType = WSots.libCouleur;
                        otsProp.OTSNo = WSots.numOts;
                        otsProp.OTSDescription = WSots.descOts;
                        otsProp.OTSTechnicalNoteNo = WSots.numNoteTech;
                        otsPropList.Add(otsProp);
                    }
                }  else {
                    showDetail = 99; 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
                }         
            }
        }
        catch (Exception CalloutException) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_General));
        } 
    }  
    
    public void getMaintenanceData() 
    {
        try 
        {    
            Rforce_fullRepApvBserviceRenault.ApvGetDonPgmEntVinFullResponse  results = MaintDataSource.getMaintenanceData(this);
           
            if (results == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            }
                                                             
            else 
            {
                showDetail = 6;
            
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'results not null'));
                Rforce_fullRepApvBserviceRenault.infoMsg infoMsg = results.infoMsg;
                Rforce_fullRepApvBserviceRenault.PgmEnt maintRes = results.PgmEnt;
                    
                if (infoMsg != null) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + infoMsg.codeMsg));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'MessageRetour : ' + infoMsg.libelleMsg));
                }
                 
                if (maintRes != null) 
                {
                    maint = new Rforce_MaintProperties();   
                                         
                    maint.MaintTitle1 = findMaintLabel(maintRes.libFix, '26'); 
                    maint.MaintTitle2 = findMaintLabel(maintRes.libFix, '27');
                    maint.MaintTitle3 = findMaintLabel(maintRes.libFix, '28');
                    maint.MaintTitle4 = findMaintLabel(maintRes.libFix, '43');
                        
                    // build the list of secondary operations
                    String secondaryText = '';
                    String Style = ' style="background-color:#E2E2E2;"';                    
                    if (maintRes.secondary != null)
                    {
                        for (Integer s=0; s<maintRes.secondary.size();s=s+2 )
                        {
                            if ((maintRes.secondary[s].labelSecondary!=null ) && (maintRes.secondary[s].labelSecondary!=''))
                                secondarytext += '<tr><td>' + maintRes.secondary[s].labelSecondary + '</td>';
                            else secondarytext += '<tr><td>Vide</td>';
                                
                            if( (maintRes.secondary[s+1].labelSecondary!=null ) && (maintRes.secondary[s+1].labelSecondary!='') )
                                secondarytext += '<td>' + maintRes.secondary[s+1].labelSecondary + '</td></tr>';
                            else secondarytext += '<td>Vide</td></tr>';
                        }
                    } 
                                        
                    maint.MaintSecondaryOperations = secondarytext;
                        
                    //Build the list of primary operations, km and miles
                    String primaryText;
                    String sTableLine = '';
                    String sStyle = ' style="background-color:#E2E2E2;"';
                    
                    if (maintRes.merePrimary != null)
                    {
                        for (Integer s=0; s<maintRes.merePrimary.size(); s++)
                        {
                            primaryText += maintRes.merePrimary[s].libelle + ' - every ';
                            primaryText += maintRes.merePrimary[s].period_Distan_Toutes + ' year(s) - or every ';
                            primaryText += maintRes.merePrimary[s].period_Km_Toutes + '<br />';
                            
                            // Nouveau traitement
                            if (maintRes.merePrimary[s].libelle != null && maintRes.merePrimary[s].libelle!='')
                            {
                                Integer iLine = Math.mod(s,2);
                                
                                if (iLine!=null && iLine == 0)
                                    sTableLine += '<tr'+sStyle+'>';
                                else
                                    sTableLine += '<tr>';
                                    
                                sTableLine += '<td>' + maintRes.merePrimary[s].libelle + '</td>';
                                
                                if (maintRes.merePrimary[s].period_Km_Toutes != null)
                                    sTableLine += '<td>' + maintRes.merePrimary[s].period_Km_Toutes + '</td>';
                                else
                                    if (maintRes.merePrimary[s].period_Distan_Toutes != null)
                                        sTableLine += '<td>' + maintRes.merePrimary[s].period_Distan_Toutes + '</td>';
                                    else
                                        sTableLine += '<td>&nbsp;</td>';
                                    
                                sTableLine += '<td>&nbsp;</td>';
                                // Mettre les autres Valeurs pour chaque année
                                sTableLine += '';
                                
                                if (maintRes.merePrimary[s].period_Distan_Toutes != null && Integer.valueOf(maintRes.merePrimary[s].period_Distan_Toutes.trim()) != 0)
                                {
                                    for (Integer i = 1; i < 13; i++)
                                    {
                                        if (Math.mod(i, Integer.valueOf(maintRes.merePrimary[s].period_Distan_Toutes.trim())) == 0)
                                            sTableLine += '<td width="10">X</td>';
                                        else
                                            sTableLine += '<td width="10">&nbsp;</td>';
                                    }
                                }
                                /*
                                    sTableLine += '<td width="10"></td>'+
                                                  '<td width="10"></td>'+
                                                  
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>'+
                                                  '<td width="10">&nbsp;</td>';
                                */
                                sTableLine += '</tr>';
                            }
                        }
                    }
                    
                    maint.MaintPrimaryOperations = sTableLine;
                    //maint.MaintPrimaryOperations = primaryText;
                }       
            }          
        }
        catch (Exception CalloutException) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_General));
        }  
    }  

    public void getWarrantyHistoryData() 
    {
        try 
        {   
            Rforce_ApvGetDonIran1.ApvGetDonIran1Response  results = WarrantyHistoryDataSource.getWarrantyHistoryData(this);
          
            if (results == null)
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            else 
            {
                showDetail = 7;
            
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'results not null'));
                Rforce_ApvGetDonIran1.DonIran1InfoMsg InfoMsg;
                if (results.listDonIran1InfoMsg != null)
                    InfoMsg = results.listDonIran1InfoMsg[0];
                
                Rforce_ApvGetDonIran1.DonIran1 donIran1Res = results.donIran1;
                
                if (InfoMsg != null) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + InfoMsg.code));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + InfoMsg.text));
                } 
                
                if (donIran1Res != null) 
                {
                    whList = new Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics[]{};
                    Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics wh;

                    
                    if (donIran1Res.sortie != null)
                    {

                        for (Rforce_ApvGetDonIran1.DonIran1Sortie WSsortie : donIran1Res.sortie)
                        {
                            wh = new Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics();
                            wh.datOuvOr = WSsortie.datOuvOr;
                            wh.km = WSsortie.km;
                            wh.libRc = WSsortie.libRc;
                            wh.rc = WSsortie.rc;
                            wh.libInt = WSsortie.libInt;
                            wh.numOts = WSsortie.numOts;
                            wh.numInt = WSsortie.numInt;
                            wh.modulo = WSsortie.outmodulo;
                            wh.histoBim = WSsortie.BHistoBim;
                            wh.rc = WSsortie.rc;
                            whList.add(wh);
                        }
                    }
                }    
            }
        }
        catch (Exception CalloutException) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_General));
        } 
    }
      
    
    Rforce_iran2BimIcmApvBserviceRenault.ApvGetDonIran2Response  results {get;set;}
    
    public void getWarrantyHistoryDetailData() 
    {
        try 
        { 
            system.debug('valeur numInt : ' + numInt);
            system.debug('valeur modulo : ' + modulo);
            system.debug('valeur histoBim : ' + histoBim);
            system.debug('valeur rc : ' + rc);
            
            WarrantyHistoryDetailDataSource.numInt = numInt;
            WarrantyHistoryDetailDataSource.modulo = modulo;
            WarrantyHistoryDetailDataSource.histoBim = histoBim;
            WarrantyHistoryDetailDataSource.rc = rc;
            
            results = WarrantyHistoryDetailDataSource.getWarrantyHistoryDetailData(this);
           
            if (results==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            }                  
            else 
            {
                showDetail = 7;

                Rforce_iran2BimIcmApvBserviceRenault.DonIran2InfoMsg InfoMsg;
                
                if (results.listDonIran2InfoMsg != null)
                    InfoMsg = results.listDonIran2InfoMsg.get(0);
                    
                Rforce_iran2BimIcmApvBserviceRenault.DonIran2 donIran2Res = results.donIran2;
                
                if (InfoMsg != null) 
                {
                    System.debug('###### InfoMsg.code '+InfoMsg.code+' InfoMsg.text '+InfoMsg.text);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + InfoMsg.code));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + InfoMsg.text));
                } 
                
                if (donIran2Res != null) 
                {
                    whd = new Rforce_WarrantyHistoryProperties.WarrantyHistoryBasics();
                    whd.PandO = new Rforce_WarrantyHistoryProperties.PiecesandOeuvres[]{};
                         
                    whd.constClient = results.donIran2.constClient;
                    whd.diag = results.donIran2.diag;
                        
                    Rforce_WarrantyHistoryProperties.PiecesandOeuvres whdProp;
                    
                    if (results.donIran2 != null && results.donIran2.pieces != null)
                    {
                        for (Rforce_iran2BimIcmApvBserviceRenault.DonIran2Pieces p : results.donIran2.pieces)
                        {
                            whdProp = new Rforce_WarrantyHistoryProperties.PiecesandOeuvres();
                            whdProp.Code = p.refePidms;
                            whdProp.Quantite = p.qtePi;
                            whdProp.Libelles = p.libePi;
                            whd.PandO.add(whdProp);
                        }
                    }
                       
                    if(results.donIran2 != null && results.donIran2.mainOeuvre != null)
                    {
                        for (Rforce_iran2BimIcmApvBserviceRenault.DonIran2MainOeuvre o : results.donIran2.mainOeuvre)
                        {
                            whdProp = new Rforce_WarrantyHistoryProperties.PiecesandOeuvres();
                            whdProp.Code = o.opecode;
                            whdProp.Temps = o.tpsMo;
                            whdProp.Libelles = o.libOpecode;
                            whd.PandO.add(whdProp);
                        }
                    }
                }
            }
        } 
        catch (Exception CalloutException) 
        {
            System.debug('###### General error (try failed)');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_General));
        } 
    }  
    

    public void getContractData() {
        try {     
            Rforce_CustdataCrmBserviceRenault.GetCustDataResponse  results = ContractDataSource.getContractData(this);
         
            if (results==null) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,system.Label.Error_Rnull));
    
            } else {
                showDetail = 4;
            
                 Rforce_CustdataCrmBserviceRenault.Contract[] conRes = results.clientList[0].vehicleList[0].contractList;
                 Rforce_CustdataCrmBserviceRenault.PersonnalInformation pi = results.clientList[0];
                 
                if (results.responseCode != null) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + results.responseCode));
              //      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'codeRetour : ' + otsInfoMsg.text));

                } 
                if (conRes != null) {
                        contracts = new Rforce_ContractProperties[]{};
                        Rforce_ContractProperties con;
                        for(Rforce_CustdataCrmBserviceRenault.Contract WScon : conRes){
                            con = new Rforce_ContractProperties();
                            con.idContract = WScon.idContrat;
                            con.lastName = pi.lastName;
                            con.firstName = pi.Firstname;
                            con.address = pi.address.strNum + ' ' + pi.address.strName + ' ' + pi.address.zip + ' ' + pi.address.city;
                            con.idContractCard = WScon.idCard;
                            con.productLabel = WScon.productLabel;
                            con.country = pi.address.countryCode;
                            con.status = WScon.status;
                            con.kmMaxSubscription = Wscon.maxSubsKm;
                            contracts.add(con);
                        }
                }                
             
            }
    
        } 
        catch (Exception CalloutException) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_General));
        } 
    }  
    
    //////////////////// Helper functions ////////////////////////
    private String findMaintLabel(Rforce_fullRepApvBserviceRenault.PgmEntLibFix[] labelArray, String requestedNumber)
    {
        Integer i = 0;
        while (requestedNumber != labelArray.get(i).numLib) 
        {
            i++;
            if (i == labelArray.size()) return 'numLib entry not found.';
        }   
        return labelArray.get(i).libelleFix;
    }


        public void getArchives() { 

          System.debug('getCountryInfo()>>>>>>>>>>>>>>>'+getCountryInfo());

           if(getCountryInfo()=='')
           {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_CountryOfDelivery));
           }

             
        try{
            
            Rforce_RcArchivage.caseId[] resultCaseList = CasesDataSource.getCaseIdList(vehicle.Name,getCountryInfo());
           
            
            if (resultCaseList == null){
               showDetail = 15;  
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            }
            else {
                showDetail = 11;   
                
                System.debug('resultCaseList  retrieved for'+vehicle.Id+'is >>>>>>>>>>>>>'+resultCaseList);  
                ArchCasesList = new Rforce_ArchivesProperties.ArchivesCases[]{};
                Rforce_ArchivesProperties.ArchivesCases Arch;
                
                for(Rforce_RcArchivage.caseId myCaseId : resultCaseList)
                {
                    Arch = new Rforce_ArchivesProperties.ArchivesCases();
                    Arch.IdCase = myCaseId.caseId;
                    Arch.country= myCaseId.countryCode;
                    System.debug('CaseIdretrieved for'+vehicle.Id+'is >>>>>>>>>>>>>'+Arch.IdCase);  
                    ArchCasesList.add(Arch);
                }
            }
        }
        catch (System.CalloutException e){
            showDetail = 15;  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_NoCaseFound));
            System.debug('Error message in the caselist method>>>>>>>>>>>'+e);
        }
    }
    
    
  public void getCaseDetails (){
      

      
        try{
            String IdCase = ApexPages.currentPage().getParameters().get('IdCase');
            String country = ApexPages.currentPage().getParameters().get('country');
            
            System.debug('IdCase in getCaseDetails'+IdCase);
            System.debug('country in getCaseDetails'+country);
            // String Output=CasesDataSource.getXmlDetails(getCountryInfo(),IdCase);  
            String Output=CasesDataSource.getXmlDetails(country,IdCase);  
              System.debug('Output in getCaseDetails'+Output);
            if (Output== null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            }
            else  {
                showDetail = 12;
                 Rforce_ArchivageXMLParseEngine parsingEngine =new Rforce_ArchivageXMLParseEngine ();
                    xmlData=parsingEngine.getXMLData(Output);
                    System.debug('xmlData in getCaseDetails>>>>>>>>>>>>>'+xmlData);

            }
  
        }
        catch (CalloutException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.ERR_ARC_CASEDETAILS));
        }
      

    }


    public void getAttachements() {
        try {
            system.debug('## Inside getAttachements () ##');
            IdCase = ApexPages.currentPage().getParameters().get('IdCase');
            String country = ApexPages.currentPage().getParameters().get('country');
            system.debug('## Country is..::'+ country);
            
            Rforce_RcArchivage.attachmentDetailsList[] resultAttachment = CasesDataSource.getAttachmentDetailsList(country, IdCase);
            if (resultAttachment == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
            }
            else {
                showDetail = 13;             
                ArchAttachmentsList = new Rforce_ArchivesProperties.ArchivesAttachments[]{};
                Rforce_ArchivesProperties.ArchivesAttachments Arch;
                              
                for(Rforce_RcArchivage.attachmentDetailsList myAttList : resultAttachment)
                {
                    Arch = new Rforce_ArchivesProperties.ArchivesAttachments();
                    Arch.attachmentName = myAttList.attachmentName;
                    Arch.extension = myAttList.extension;
                    Arch.createdDate = myAttList.createdDate;
                    Arch.Idcase=IdCase;
                    Arch.country=country;
                    ArchAttachmentsList.add(Arch);
                }
                system.debug('## ArchAttachmentsList size is..::'+ ArchAttachmentsList.size());
                system.debug('## ArchAttachmentsList Value is..::'+ ArchAttachmentsList);
            }
        }
        catch (CalloutException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.ERR_ARC_NOATTACHMENT));
             }  
        
     
    }

    
   /* REQ-00258 -- Converted the binary format from webservice into UTF-8 readable format */
    
   public void getAttachementData(){
    system.debug('## Inside getAttachementData ##');    
    try{
        IdCase = ApexPages.currentPage().getParameters().get('IdCase');
        String country = ApexPages.currentPage().getParameters().get('country');
         
        String attachmentName = System.currentPagereference().getParameters().get('attachmentName');
        String strContentType=System.currentPagereference().getParameters().get('contentType');
        
        system.debug('## country is..::'+ country);  
        system.debug('## attachmentName is..::'+ attachmentName);  
        system.debug('## strContentType is..::'+ strContentType);  
        
        
        Blob BlobDec;
        String resultURL = CasesDataSource.getAttachmentContent(country, IdCase, attachmentName);
        System.debug('resultURL'+resultURL);
        String stUrlUTF8 = EncodingUtil.urlEncode(resultURL, 'UTF-8');
        BlobDec = Blob.valueOf(stUrlUTF8);
        String BlobDec1=EncodingUtil.base64Encode(BlobDec);
        BlobDec = EncodingUtil.base64Decode(resultURL);


         if (resultURL == null){
               system.debug('## Inside if part ##');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.Error_Rnull));
         }else {
               system.debug('## Inside else part ##');
               showDetail = 14;     
               attachmentURL=resultURL;
               Document currDoc= new Document(); 
               currDoc.AuthorId = UserInfo.getUserId();    
               
               currDoc.Name = attachmentName;                 
               currDoc.FolderId = UserInfo.getUserId();
               currDoc.Body=BlobDec;
               currDoc.Type = strContentType;
               insert currDoc;
                  
               attachmentURL=currDoc.Id;
                  
             }
          } catch (CalloutException e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,system.Label.ERR_ARC_NOATTACHMENT));
        
             }  
    } 
 
    
   public Void getCaseDetailXML(){
 } 
    
    
    public PageReference OpenXMLPage()
     {
         return Page.Rforce_OpenXMLAttachment;
     }


    public String getVin() 
    {
        if (Test.isRunningTest())
        {
            return 'VF1BGRG0633285766';
        }
        return vehicle.name;
    }
    
}