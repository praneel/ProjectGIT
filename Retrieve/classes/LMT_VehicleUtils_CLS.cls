public with sharing class LMT_VehicleUtils_CLS {
	
	public static final Map<String, String> MAP_ENERGY = new Map<String, String>();
	static{
		MAP_ENERGY.put('019001', 'ELEC');
		MAP_ENERGY.put('019002', 'FLEXFL');
		MAP_ENERGY.put('019003', 'CNGS');
		MAP_ENERGY.put('019004', 'BIODIE');
		MAP_ENERGY.put('019006', 'BIOESS');
		MAP_ENERGY.put('019008', 'GNV');
		MAP_ENERGY.put('019010', 'ESS');
		MAP_ENERGY.put('019011', 'ESSSPB');
		MAP_ENERGY.put('019020', 'DIESEL');
		MAP_ENERGY.put('019030', 'GPL');
		MAP_ENERGY.put('019035', 'BICARB');
		MAP_ENERGY.put('019999', 'SAN019');	
	}
	
	public static Rforce_BVMComplet_WS.ApvGetDetVehResponse searchBVMComplet(String ValeurChamp, String ChampIn)
    {
        Boolean Success ;
        string strDebut = 'Début Trace Réponse WS';
        string strFin = 'Fin Trace Réponse WS';
        
        Rforce_BVMComplet_WS.ApvGetDetVehRequest request = new Rforce_BVMComplet_WS.ApvGetDetVehRequest();               
        Rforce_BVMComplet_WS.ServicePreferences servicePref = new Rforce_BVMComplet_WS.ServicePreferences();
        Rforce_BVMComplet_WS.ApvGetDetVeh VehWS = new Rforce_BVMComplet_WS.ApvGetDetVeh();
        Rforce_BVMComplet_WS.ApvGetDetVehResponse VEH_WS = new Rforce_BVMComplet_WS.ApvGetDetVehResponse();
       
        try
        {  
            servicePref.bvmsi24CodeChampIn  = ChampIn;
            servicePref.bvmsi24CodeChampOut  = 'OF';
            servicePref.bvmsi24ValeurChamp = ValeurChamp;
            servicePref.bvmsi24CodePaysLang = UserInfo.getLanguage().substring(0, 2).toUpperCase(); //FRA 
            servicePref.bvmsi24CodeLang = UserInfo.getLanguage().substring(0, 2).toUpperCase(); //FR
            request.ServicePreferences = servicePref;
              
            VehWS.endpoint_x = System.label.Url_BVM_Complet; 
            VehWS.clientCertName_x = System.label.RenaultCertificate;           
            VehWS.timeout_x=40000;
            
            return (Rforce_BVMComplet_WS.ApvGetDetVehResponse)VehWS.getApvGetDetVeh(request);
        }            
        catch (Exception e)
        {                    
            system.debug(VEH_WS);
            system.debug('erreur : ' + String.valueOf(e));
            return null;
        }
    }
    
    
    
    public static VEH_Veh__c createVehicleBVM(Rforce_BVMComplet_WS.ApvGetDetVehResponse vehBVM)
    {
        VEH_Veh__c veh = new VEH_Veh__c();
        
         if (vehBVM.detVeh.bvmso24Vin != null)
            veh.Name = vehBVM.detVeh.bvmso24Vin;
            
        if (vehBVM.detVeh.bvmso24NImmat != null)
            veh.VehicleRegistrNbr__c = vehBVM.detVeh.bvmso24NImmat;
            
         if (vehBVM.detVeh.bvmso24DateImmat1 != null && vehBVM.detVeh.bvmso24DateImmat1.length() > 7)
            veh.FirstRegistrDate__c = date.newinstance(Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat1.substring(6, 10)), Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat1.substring(3, 5)), Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat1.substring(0, 2)));
                    
          if (vehBVM.detVeh.bvmso24DateImmat != null && vehBVM.detVeh.bvmso24DateImmat.length() > 7)
            veh.LastRegistrDate__c = date.newinstance(Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat.substring(6, 10)), Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat.substring(3, 5)), Integer.valueOf(vehBVM.detVeh.bvmso24DateImmat.substring(0, 2)));
                    
         //VersionCode__c p460:version
         if (vehBVM.detVeh.bvmso24Version != null)
            veh.VersionCode__c = vehBVM.detVeh.bvmso24Version;
            
         //DeliveryDate__c p460:dateLiv
        if (vehBVM.detVeh.bvmso24DateLiv != null && vehBVM.detVeh.bvmso24DateLiv.length() > 7)
            veh.DeliveryDate__c = date.newinstance(Integer.valueOf(vehBVM.detVeh.bvmso24DateLiv.substring(6, 10)), Integer.valueOf(vehBVM.detVeh.bvmso24DateLiv.substring(3, 5)), Integer.valueOf(vehBVM.detVeh.bvmso24DateLiv.substring(0, 2)));
        
        if (vehBVM.detVeh.bvmso24PaysLiv != null)
            veh.CountryOfDelivery__c = vehBVM.detVeh.bvmso24PaysLiv;
                       
        //AfterSalesType__c p460:tvv
        if (vehBVM.detVeh.bvmso24Tvv != null)
            veh.AfterSalesType__c = vehBVM.detVeh.bvmso24Tvv;
        
        //BodyType__c p460:libCarrosserie
        if (vehBVM.detVeh.bvmso24LibCarrosserie != null)
            veh.BodyType__c = vehBVM.detVeh.bvmso24LibCarrosserie;
        
        //DateofManu__c p460:dateTcmFab 
        if (vehBVM.detVeh.bvmso24DateTcmFab != null && vehBVM.detVeh.bvmso24DateTcmFab.length() > 7)
            veh.DateofManu__c = date.newinstance(Integer.valueOf(vehBVM.detVeh.bvmso24DateTcmFab.substring(6, 10)), Integer.valueOf(vehBVM.detVeh.bvmso24DateTcmFab.substring(3, 5)), Integer.valueOf(vehBVM.detVeh.bvmso24DateTcmFab.substring(0, 2)));
        
        //Description__c p460:libModel + p460:ligne2P12 + p460:ligne3P12 + p460:ligne4P12
            veh.Description__c = vehBVM.detVeh.bvmso24LibModel + ' ' + vehBVM.detVeh.bvmso24Ligne2P12 + ' ' + vehBVM.detVeh.bvmso24Ligne3P12 + ' ' + vehBVM.detVeh.bvmso24Ligne4P12;
        
        //EngineIndex__c p460:indMot
        if (vehBVM.detVeh.bvmso24IndMot != null)
            veh.EngineIndex__c = vehBVM.detVeh.bvmso24IndMot;
            
        //EngineManuNbr__c p460:NMot
        if (vehBVM.detVeh.bvmso24NMot != null)
            veh.EngineManuNbr__c = vehBVM.detVeh.bvmso24NMot;
                
        //EngineType__c p460:typeMot 
        if (vehBVM.detVeh.bvmso24TypeMot != null)
            veh.EngineType__c = vehBVM.detVeh.bvmso24TypeMot;
            
        //GearBoxIndex__c p460:indBoi 
        if (vehBVM.detVeh.bvmso24IndBoi != null)
            veh.GearBoxIndex__c = vehBVM.detVeh.bvmso24IndBoi;
            
        //GearBoxManuNbr__c p460:NBoi
        if (vehBVM.detVeh.bvmso24NBoi != null)
            veh.GearBoxManuNbr__c = vehBVM.detVeh.bvmso24NBoi;
            
        //GearBoxType__c p460:typeBoi
        if (vehBVM.detVeh.bvmso24TypeBoi != null)
            veh.GearBoxType__c = vehBVM.detVeh.bvmso24TypeBoi;
        
        //Model__c p460:libModel 
        if (vehBVM.detVeh.bvmso24LibModel != null)
            veh.Model__c = vehBVM.detVeh.bvmso24LibModel;
            
        //VehicleBrand__c p460:marqCom 
        if (vehBVM.detVeh.bvmso24MarqCom != null)
            veh.VehicleBrand__c = vehBVM.detVeh.bvmso24MarqCom;
            
        //VehicleManuNbr__c p460:NFab
        if (vehBVM.detVeh.bvmso24NFab != null)
            veh.VehicleManuNbr__c = vehBVM.detVeh.bvmso24NFab;        
           
        if (vehBVM.detVeh.bvmso24CodeModel2 != null)
            veh.ModelCode__c = vehBVM.detVeh.bvmso24CodeModel2;
                     
   
        if (vehBVM.detVeh.bvmso24DataCrit != null)
        {
        	 String nrj;
        	 String cdnrj;
        	 
        	  
        	  	for (integer i = 0; i < vehBVM.detVeh.bvmso24DataCrit.length(); i++)
        {
         
                if (vehBVM.detVeh.bvmso24DataCrit.substring(i, i + 3) == '019')
                {
                            nrj = vehBVM.detVeh.bvmso24DataCrit.substring(i, i + 6);
                              
                }
                i = i + 97;
         }
        	 
        	 cdnrj=MAP_ENERGY.get(nrj);
        	
        	 veh.EnergyType__c =cdnrj;
        	 
        }
        
        insert veh;
        return veh;
    }
}