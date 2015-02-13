/**
 * This class is a mock BVM web service response for LMT usage. 
 *
 */
@isTest
global class LMT_BVMComplet_WS_MK  implements WebServiceMock {

    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
             
             
             
       Rforce_BVMComplet_WS.DetVehInfoMsg detVehInfoMsg1=new  Rforce_BVMComplet_WS.DetVehInfoMsg();
       detVehInfoMsg1.bvmso24CodeRetour='AA';
       detVehInfoMsg1.bvmso24MsgRetour='success';
       
       Rforce_BVMComplet_WS.DetVeh detvehmock=new Rforce_BVMComplet_WS.DetVeh();
       
     detvehmock.bvmso24Version='Version';
     detvehmock.bvmso24Tvv='tvv';
     detvehmock.bvmso24TypeMot='typeMot';
       detvehmock.bvmso24IndMot='indMot';
        detvehmock.bvmso24NMot='NMot';
         detvehmock.bvmso24TypeBoi='typeBoi';
       detvehmock.bvmso24IndBoi='indBoi';
          detvehmock.bvmso24NBoi='NBoi';
         detvehmock.bvmso24DateTcmFab='11.02.2008';
         detvehmock.bvmso24DateLiv='11.02.2008';
         detvehmock.bvmso24LibModel='ligne2P12';
         detvehmock.bvmso24LibCarrosserie='BERLINE 4PRTES';
         
         detvehmock.bvmso24DataCrit = '019002';

         Rforce_BVMComplet_WS.ApvGetDetVehResponse responseMock=new  Rforce_BVMComplet_WS.ApvGetDetVehResponse();
         responseMock.detVehInfoMsg=detVehInfoMsg1;
         responseMock.detVeh=detvehmock;
        
        Rforce_BVMComplet_WS.getApvGetDetVehResponse_element element_mock= new Rforce_BVMComplet_WS.getApvGetDetVehResponse_element();
        
        
        element_mock.getApvGetDetVehReturn=responseMock;
        

         Rforce_BVMComplet_WS.getApvGetDetVehResponse_element response_x=new Rforce_BVMComplet_WS.getApvGetDetVehResponse_element();

        response.put('response_x', element_mock); 

   }
}