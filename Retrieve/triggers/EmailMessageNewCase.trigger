trigger EmailMessageNewCase on EmailMessage (Before insert) {
   Case c = new Case();
   Case c1, c2;
   EmailMessage msg, msg2;
   String Subject;
   String description;
   GroupMember member=null;
   String owid;
   
   public List<AssignmentRule> AssRule {get;set;}
   AssRule = new List<AssignmentRule>();
   AssRule = [Select Id from AssignmentRule where Name='Renault Case assignment' and Active=true];

   for(EmailMessage message : trigger.new){
       System.debug('#####TEST SUBSTRING START #####'+message.Subject);
       c=[SELECT id,RecordType.name, Description, AccountId, ContactId, OwnerId, CaseNumber, RecordTypeId, CountryCase__c, status, Origin, Subject, VIN__c, Device_Brand__c, Device_Type__c, Language__c FROM Case WHERE Id = :message.ParentId];           
       if (c.Status=='Closed' && AssRule.size()>0 && message.Incoming && c.RecordType.name==System.Label.Case_RT_Name){
         Database.Dmloptions dmlOpts = new Database.Dmloptions();
         dmlOpts.assignmentRuleHeader.assignmentRuleId= AssRule[0].id;
         System.debug('#####Avant#####'+c.RecordType.name);
         owid=c.OwnerId;
         If (owid.startsWith('005')){
            member = [select Group.id, Group.Name from GroupMember where userorgroupid=:c.OwnerId LIMIT 1];
            Subject ='Email entering on closed case n°'+c.caseNumber+' / '+member.Group.Name;
            description ='Email entering on closed case n°'+c.caseNumber+' / '+member.Group.Name;
            c.OwnerId=member.Group.id;
            System.debug('#####Person#####'+c.OwnerId);
         } else {
                Subject ='Email entering on closed case n°'+c.caseNumber;
                description ='Email entering on closed case n°'+c.caseNumber;
                System.debug('#####Queue#####'+owid);
         }
         
         if (c.Device_Brand__c=='Media Nav' || c.Device_Brand__c=='TomTom' ){
         System.debug('#####Device#####'+c.Device_Brand__c);
             c1=new Case(ParentId=c.id, Description=description, Origin=c.Origin, Subject=Subject, AccountId=c.AccountId, ContactId=c.ContactId, OwnerId=c.OwnerId, RecordTypeId=c.RecordTypeId, VIN__c=c.VIN__c, Device_Brand__c=c.Device_Brand__c, Language__c=c.Language__c, CountryCase__c=c.CountryCase__c, Device_Type__c= c.Device_Type__c);
         } else {
             c1=new Case(ParentId=c.id, Description=description, Origin=c.Origin, Subject=Subject, AccountId=c.AccountId, ContactId=c.ContactId, OwnerId=c.OwnerId, RecordTypeId=c.RecordTypeId, VIN__c=c.VIN__c, Device_Brand__c=c.Device_Brand__c, Language__c=c.Language__c, CountryCase__c=c.CountryCase__c, Device_Type__c= '');
         }
         
           c1.setOptions(dmlOpts);
           insert c1; 
           System.debug('#####EmailMessage#####'+c1.Id);
            msg= new EmailMessage(ParentId=c1.Id, FromAddress=message.FromAddress, ToAddress=message.ToAddress, Subject=message.Subject, TextBody=message.TextBody, HtmlBody=message.HtmlBody, MessageDate=message.MessageDate);
            insert msg;
        } else if (message.Subject.contains('500')){
            System.debug('#####TEST MESSAGE SUBSTRING#####'+message.Subject);
            Integer it = message.Subject.indexOf('500');
            String test = message.Subject.substring(it, it+10);
            System.debug('#####TEST SUBSTRING#####'+test);
            String ts = test.substring(0, 5);
            String te = test.substring(5);
            String tt = ts+'00000'+te;
            System.debug('#####TEST ID SALESFORCE #####'+tt);
            System.debug('#####SUBJECTTTTTTT #####'+message.Subject);
            try {
            c2=[SELECT id,RecordType.name, Description, AccountId FROM Case WHERE Tech_ExternalID__c = :tt];}
            catch(Exception e) {}
            if (c2 != null && message.Incoming && c.RecordType.name==System.Label.Case_RT_Name){
                msg2= new EmailMessage(ParentId=c2.Id, FromAddress=message.FromAddress, ToAddress=message.ToAddress, Subject=message.Subject, TextBody=message.TextBody, HtmlBody=message.HtmlBody, MessageDate=message.MessageDate);
                insert msg2;
            }
        }
    }
 }