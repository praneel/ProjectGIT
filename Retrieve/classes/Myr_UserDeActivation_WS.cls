/*	Desactivation of user (Webservice) 
    Error codes :   OK     			: WS03MS000 
    				OK WITH WARNING : WS03MS001 -> WS03MS500
    				CRITICAL ERROR  : WS03MS501 -> WS03MS999
*************************************************************************************************************
25 August 2014  : Creation
*************************************************************************************************************/
global class Myr_UserDeActivation_WS { 

  /** WebService used to activate a user on a given account
    @param accountSfdcId, the SFDC id of the personal account on which we want activate the user
    @return a msg and the activated user **/
  WebService static Myr_UserDeActivation_WS_Response deActivateUser(String userId) {
    //Check mandatory fields value
    String fieldsLabel=missingMandatory(userId);
    if (fieldsLabel != ''){
      return prepareResponse(null, 'WS03MS500', 'Value missing : Parameter userId');
    }
    //Check the existence of a user
    User u;
    List<User> listUsers = [Select Profile.Name, IsActive From User WHERE Id=:userId];
    if(listUsers.size()==0) { 
		return prepareResponse( null, 'WS03MS501', 'userId not found');
    } else if (listUsers.size() > 1) {
    	return prepareResponse(u,'WS03MS502','An issue occurred during the deactivation of the user:' + listUsers.size() + ' users found');
    } else {
		u=listUsers[0];
		if (u.profile.name != 'HeliosCommunity'){
			return prepareResponse(u,'WS03MS503','The user was existing, but the profile of the user was not the one attempted. Impossible to deactivate the user. Profile name : <profile name>');
		}else{
			if (!u.IsActive){
				return prepareResponse(u,'WS03MS001','The user was already deactivated');
			}else{
				try {
					u.isActive=false;
					update u;
					return prepareResponse(u,'WS03MS000','The deactivation of the user performed OK');
				} catch (Dmlexception e) {
					return prepareResponse(u,'WS03MS502','An issue occurred during the deactivation of the user:'+ e.getMessage());
				}
	    	}
    	}
    }
  }
  
  /** @return the response in case of a bad situation **/
  private static Myr_UserDeActivation_WS_Response prepareResponse(User u, String code, String message) {
    Myr_UserDeActivation_WS_Response response = new Myr_UserDeActivation_WS_Response();
    response.user = u;
    response.info = new Myr_UserDeActivation_WS_Response_Msg();
    response.info.code = code;
    response.info.message = message;
    return response;
  }
  
  /** Global format of the response **/
  global class Myr_UserDeActivation_WS_Response {
    WebService User user;
    WebService Myr_UserDeActivation_WS_Response_Msg info;
  }
  
  global class Myr_UserDeActivation_WS_Response_Msg {
    WebService String code;
    WebService String message;
  }
  
  static String missingMandatory(String userId) {
	String str='';
	if (userId==''){
      str+='userId';
	}
	return str;
  }
}