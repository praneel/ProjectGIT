public with sharing abstract class LMT_MultiCriteriaFilteredTable_CLS {

    /** Code for Empty option */
    @TestVisible private static final String EMPTY_OPTION = '$EMPTY';
    /** comma separator constant */
	private static final String COMMA_SEP = ',';
	
    /** standard set controller */
    private ApexPages.StandardSetController ssc;
    /** map of checkbox options */
    public Map<String, List<SelectOption>> selectOptions {get; private set;}
    /** map of checkbox options' status string (per column) : the first index of the string corresponds to the selectAll checkbox selection flag, and the following indexes correspond to the checkboxes' selection flag */
    public Map<String, String> optionStatusMap {get; set;}
    /** map of text filter (per column) */
    public Map<String, String> textFilterMap {get; set;}
    /** list of in-memory first-query objects */
    private transient List<sObject> inMemoryFirstQueryObjects; // Performance optimisation: transient
    /** list of sObjects */
    public List<sObject> objects {get{ return ( ssc == null ) ? inMemoryFirstQueryObjects : ssc.getRecords(); } private set;}
    /** status string of comma-separated selected row ids */
    public String selectedRowIdsStatus {get; set;}
    /** all selected flag - not used just for mapping ! */
    public boolean allSelected {get; set;}
    /** list of columns */
    public Column[] columns {
        get{
            return listColumns();
        }
        private set;
    }
    public boolean loaded {get; private set;}
    
    public static final Integer TYPE_STRING  = 0;
    public static final Integer TYPE_BOOLEAN = 1;
    
    public class Column {
        public Column(String name0, String[] displayed0, boolean filtered0, boolean textFiltered0, Integer type0){
            name = name0;
            filtered = filtered0;
            textFiltered = textFiltered0;
            displayed = displayed0;
            thetype = type0;
        }
        public Column(String name0, String displayed0, boolean filtered0, boolean textFiltered0, Integer type0){
            this(name0, new String[]{displayed0}, filtered0, textFiltered0, type0);
        }
        /** column name in database for filtering */
        public String name {get; private set;}
        /** is it filtered or not ? */
        public boolean filtered {get; private set;}
        /** is it text filtered or not ? */
        public boolean textFiltered {get; private set;}
        /** which column are displayed in the select list */
        public String[] displayed {get; private set;}
        /** type of column */
        public Integer thetype {get; private set;}
    }
    
    /**
     * Context to serialize/deserialize.
     * This is used to recover filtering and sorting context when returning to this page
     * after having assigning a lead or an opportunity.
     */
    public class FilteringContext{
        public Map<String, String> optionStatusMap {get; set;}
        public Map<String, Set<String>> predefinedFilteredValues {get; set;} // only set by the initFilteringContext() method
        public Map<String, String> predefinedTextFilters {get; set;} // only set by the initFilteringContext() method
        public String sortColumn {get; set;}
        public Boolean ascending {get; set;}
        public String selectedRowIdsStatus {get; set;}
        
        public String serialize(){
            return EncodingUtil.urlEncode(JSON.serialize(this), 'UTF-8');
        }
    }
    
    public static FilteringContext deserialize(String JSONString){
        return (FilteringContext) JSON.deserialize(EncodingUtil.urlDecode(JSONString, 'UTF-8'), FilteringContext.class);
    }
    
    /** returns the column on which to sort */
    public String sortColumn {get; 
        set{
            //-- side-effect on ascending  
            if (sortColumn == null || !sortColumn.equals(value)){
                ascending = true;
            }else{
                ascending = !ascending;
            }
            sortColumn = value;
        }
    }
    @TestVisible private boolean ascending = true;
    private Map<String, Boolean> filtered0;
    /** indicates whether the column is filtered or not */
    public Map<String, Boolean> isFiltered {
        get{
            for( Column c : columns )
            {
            	if( c.filtered || c.textFiltered )
            	{
            		String columnName = c.name;
                	filtered0.put( columnName, isFiltered( columnName ) );
            	}
            }
            return filtered0;
        } 
        private set;
    }
    
    // ========================== PAGINATION ======================================
    public Integer totalSize0 { get; private set; } 
    /** max number of record per page */
    public Integer maxPageSize { get; private set; } 
    /** total number of records */
    public Integer totalSize { get{ return ( ssc == null ) ? totalSize0 : ssc.getResultSize(); }}
    /** is previous disabled ? */
    public Boolean disablePrevious { get{ return ( ssc == null ) ? true : !ssc.getHasPrevious(); }} 
    /** is next disabled ? */ 
    public Boolean disableNext { get{ return ( ssc == null ) ? ( totalPages <= 1 ) : !ssc.getHasNext(); }} 
    /** current page number */
    public Integer pageNumber { get{ return ( ssc == null ) ? 1 : ssc.getPageNumber(); }} 
    /** total number of pages */
    public Integer totalPages {
        get{
            if( Math.mod( totalSize, maxPageSize ) > 0 )
            {
                return totalSize / maxPageSize + 1;
            }
            return totalSize / maxPageSize;
        }
    }
    /** last record shown */
    public Integer lastShown { get{ return Math.min( pageNumber * maxPageSize, totalSize); }}
    /** first record shown */
    public Integer firstShown { get{ return Math.min( ( pageNumber - 1 ) * maxPageSize + 1, totalSize ); }}
    
    private String fctx;
    
    // ============================================================================
    
    public LMT_MultiCriteriaFilteredTable_CLS(){
        //-- pagination
        maxPageSize = 100;
        //-- create instance variables
        selectOptions = new Map<String, List<SelectOption>>();
        optionStatusMap = new Map<String, String>();
        textFilterMap = new Map<String, String>();
        filtered0 = new Map<String, Boolean>();
        allSelected = false;
        loaded = false;
        totalSize0 = 0;
        fctx = ApexPages.currentPage().getParameters().get('fctx');
    }
    
    /** refreshes the filters */
    public void refreshFilters()
    {
    	//Long startTime = System.currentTimeMillis();
    	
    	buildSelectOptions();
    	loaded = true;
    	
    	//Long endTime = System.currentTimeMillis();
    	//System.debug( LoggingLevel.INFO, '**** LMT_MultiCriteriaFilteredTable_CLS.refreshFilters() duration=' + ( endTime - startTime ) + ' ms' );
    }
    
    /** refreshes the display */
    public void refresh()
    {
    	//Long startTime = System.currentTimeMillis();
    	
        query( pageNumber );
        
        //Long endTime = System.currentTimeMillis();
    	//System.debug( LoggingLevel.INFO, '**** LMT_MultiCriteriaFilteredTable_CLS.refresh() duration=' + ( endTime - startTime ) + ' ms' );
    }
    /** modify the sorting order */
    public void sortBy(){
        query( pageNumber );
    }
    
    /** Number of buttons to display */
    public abstract Integer getNbButtons(); 
    /** button 1 implementation */
    public virtual PageReference button1(){ return null; }
    /** button 2 implementation */
    public virtual PageReference button2(){ return null; }
    /** button 3 implementation */
    public virtual PageReference button3(){ return null; }
	
	/*public PageReference doNothing() { return null; }*/
	
    private void buildSelectOptions()
    {
    	boolean perfFlag = false; // debug performance logs with warning ApexMessage
    	Long startTime0;
    	Long startTime1;
    	Long startTime2;
    	Long startTime3;
    	Long endTime0;
    	Long endTime1;
    	Long endTime2;
    	Long endTime3;
    	
    	if( perfFlag )
        {
        	startTime0 = System.currentTimeMillis();
        }
    	
        //-- build a set to avoid duplicates
        Map<String, Map<String, String>> codesSet = new Map<String, Map<String, String>>();
        
        //-- extracting filtering context
        //String fctx = ApexPages.currentPage().getParameters().get('fctx');
        //System.debug( LoggingLevel.INFO, '**** fctx:' + fctx );
        
        FilteringContext fc = null;
        if( fctx != null )
        {
            fc = deserialize( fctx );
        }
        else
        {
            fc = initFilteringContext();
        }
        
        if( fc != null )
        {
            sortColumn = fc.sortColumn;
            ascending = fc.ascending;
            selectedRowIdsStatus = fc.selectedRowIdsStatus;
        }
        
        //-- build query
        String query = 'SELECT ';
        Boolean commaFlag = false;
        String strSortColumns = null;
        for( Column c : columns )
        {
        	codesSet.put( c.name, new Map<String, String>() );
            if( commaFlag )
            {
        		query += COMMA_SEP;
        	}
        	else
        	{
        		commaFlag = true;
        	}
            query += c.name;
            for( String d : c.displayed )
            {
                if( !d.equals( c.name ) )
                {
                	query += COMMA_SEP;
                    query += d;
                }
            }
            
            if( sortColumn != null && sortColumn == c.name )
            {
            	strSortColumns = '';
            	commaFlag = false;
            	for( String columnName : c.displayed )
            	{
            		if( commaFlag )
		            {
		        		strSortColumns += COMMA_SEP;
		        	}
		        	else
		        	{
		        		commaFlag = true;
		        	}
            		strSortColumns += columnName;
            	}
            }
        }
        query += ' FROM ' + this.getObjectname();
        if( !String.isBlank( getWhereClause() ) )
        {
            query += ' WHERE ' + this.getWhereClause();
        }
        if( !String.isEmpty( strSortColumns ) )
        {
            query += ' ORDER BY ';
            query += strSortColumns;
            query += ascending ? ' ASC' : ' DESC';
        }
        //-- always limit the number of records
        //query += ' LIMIT ' + Limits.getLimitQueryRows(); // Maximum number of records retrieved by SOQL queries: 50000
        query += ' LIMIT ' + Limits.getLimitQueryLocatorRows(); // Maximum number of records retrieved by Database.getQueryLocator: 10000
        
        //System.debug('#### LMT_MultiCriteriaFilteredTable_CLS - buildselectedOptions : ' + query);
        
        if( perfFlag )
        {
        	startTime1 = System.currentTimeMillis();
        }
        
        // database query
        List<sObject> records = Database.query( query );
        
        if( perfFlag )
        {
        	endTime1 = System.currentTimeMillis();
        	startTime2 = endTime1;
        }
        
        // loop over records
        String objectName = this.getObjectName();
        if( objectName == 'Lead' )
        {
        	for( sObject o : records )
	        {
	            for( Column c : columns )
	            {
	                if( c.filtered )
	                {
	                	String columnName = c.name;
					    String value = String.valueOf( o.get( columnName ) );
	                	
	                    Map<String, String> m = codesSet.get( columnName );
	                    if( String.isBlank( value ) )
	                    {
	                    	if( m.get( '' ) != '' )
	                    	{
	                        	m.put( '', '' );
	                    	}
	                    }
	                    else
	                    {
                        	//this.insertNotEmptyValueLabel( o, m, c );
                        	
                        	// Performance optimisation: no insertNotEmptyValueLabel child method call in the records/columns loops (use duplicated code instead)
                        	Lead lead = (Lead) o;
                        	
					        if( 'Id'.equals( columnName ) )
					        {
					        	m.put( value, formatName( lead.FirstName, lead.LastName ) );
					        }
					        else
					        if( 'DealerOfInterest__c'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					        		m.put( value, lead.DealerOfInterest__r.Name );
					        	}
					        }
					        else
					        if( 'Preassigned_Seller__c'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					            	m.put( value, formatName( lead.Preassigned_Seller__r.FirstName, lead.Preassigned_Seller__r.LastName ) );
					        	}
					        }
					        else
					        if( 'OwnerId'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					            	m.put( value, lead.Owner.Name );
					        	}
					        }
					        else
					        {
					        	if( m.get( value ) == null )
					        	{
					        		m.put( value, value );
					        	}
					        }
                        }
	                }
	            }
	        }
        }/**
          * Opportunity part must be commented since it is not tested.
        else
        if( objectName == 'Opportunity' )
        {
        	for( sObject o : records )
	        {
	            for( Column c : columns )
	            {
	                if( c.filtered )
	                {
	                	String columnName = c.name;
					    String value = String.valueOf( o.get( columnName ) );
	                	
	                    Map<String, String> m = codesSet.get( columnName );
	                    if( String.isBlank( value ) )
	                    {
	                    	if( m.get( '' ) != '' )
	                    	{
	                        	m.put( '', '' );
	                    	}
	                    }
	                    else
	                    {
                        	//this.insertNotEmptyValueLabel( o, m, c );
                        	
                        	// Performance optimisation: no insertNotEmptyValueLabel child method call in the records/columns loops (use duplicated code instead)
                        	Opportunity opp = (Opportunity) o;
                        	
                        	if( 'Id'.equals( columnName ) )
					        {
					        	m.put( value, opp.Name );
					        }
					        else
					        if( 'CampaignId'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					        		m.put( value, opp.Campaign.Name );
					        	}
					        }
					        else
					        if( 'DealerOfInterest__c'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					        		m.put( value, opp.DealerOfInterest__r.Name );
					        	}
					        }
					        else
					        if( 'Preassigned_Seller__c'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					            	m.put( value, formatName( opp.Preassigned_Seller__r.FirstName, opp.Preassigned_Seller__r.LastName ) );
					        	}
					        }
					        else
					        if( 'OwnerId'.equals( columnName ) )
					        {
					        	if( m.get( value ) == null )
					        	{
					            	m.put( value, formatName( opp.Owner.FirstName, opp.Owner.LastName ) );
					        	}
					        }
					        else
					        {
					        	if( m.get( value ) == null )
					        	{
					        		m.put( value, value );
					        	}
					        }
                        }
	                }
	            }
	        }
        }
        else
        {
        	for( sObject o : records )
	        {
	            for( Column c : columns )
	            {
	                if( c.filtered )
	                {
	                	String columnName = c.name;
					    String value = String.valueOf( o.get( columnName ) );
	                	
	                    Map<String, String> m = codesSet.get( columnName );
	                    if( String.isBlank( value ) )
	                    {
	                    	if( m.get( '' ) != '' )
	                    	{
	                        	m.put( '', '' );
	                    	}
	                    }
	                    else
	                    {
                        	//this.insertNotEmptyValueLabel( o, m, c );
	                    }
	                }
	            }
	        }
        }*/
        
        if( perfFlag )
        {
        	endTime2 = System.currentTimeMillis();
        	//System.debug( LoggingLevel.INFO, '**** LMT_MultiCriteriaFilteredTable_CLS.refreshFilters():buildSelectOptions:query+loop duration=' + ( endTime2 - startTime1 ) + ' ms' );
        }
    	
        Map<String, Set<String>> filteredValuesMap = new Map<String, Set<String>>();
        for( Column c : columns )
        {
        	String columnName = c.name;
        	
            if( c.filtered )
            {
                List<SelectOption> optionList = new List<SelectOption>();
                List<LMT_SelectOptionWrapper_CLS> listoptionswrapper = new List<LMT_SelectOptionWrapper_CLS>();
                Map<String, String> mapOptions = codesSet.get( columnName );
                
                for( String code : mapOptions.keySet() )
                {
                    if( String.isBlank( code ) )
                    {
                        listoptionswrapper.add(new LMT_SelectOptionWrapper_CLS(EMPTY_OPTION,'(Empty)'));
                    }
                    else
                    {
                        //System.debug( '#### LMT_MultiCriteriaFilteredTable_CLS - buildselectedOptions - columnName:' + columnName + ' code:'+code + ' mapOptions['+code+']:'+mapOptions.get( code ) );
                        listoptionswrapper.add( new LMT_SelectOptionWrapper_CLS( code, mapOptions.get( code ) == null ? '' : mapOptions.get( code ) ) );
                    }
                }
                
                listoptionswrapper.sort();
                
                for( LMT_SelectOptionWrapper_CLS w : listoptionswrapper )
                {
                    optionList.add( w.option );
                }
                
                selectOptions.put( columnName, optionList );
                
                String strColumnStatus = '';
                Integer nbOptions = optionList.size();
                Integer nbSelectedOptions = 0;
                
                if( fc != null )
                {
                    Set<String> selectedValueSet1 = getFilteredValues( fc.optionStatusMap, columnName ); // general case
	                Set<String> selectedValueSet2 = ( fc.predefinedFilteredValues == null ) ? null : fc.predefinedFilteredValues.get( columnName ); // particular case
	                
	                Set<String> selectedValueSet;
	                if( selectedValueSet2 != null && !selectedValueSet2.isEmpty() )
	                {
	                	selectedValueSet = selectedValueSet2;
	                }
	                else
	                {
	                	selectedValueSet = selectedValueSet1;
	                }
	                
	                filteredValuesMap.put( columnName, selectedValueSet );
                    
                    for( SelectOption option : optionList )
                    {
                        if( selectedValueSet == null || selectedValueSet.contains( option.getValue() ) )
                        {
                            strColumnStatus += '1';
                            nbSelectedOptions++;
                        }
                        else
                        {
                        	strColumnStatus += '0';
                        }
                    }
                }
                else
                {
                    for( Integer i = 0; i < nbOptions; i++ )
                    {
                    	strColumnStatus += '1';
                    	nbSelectedOptions++;
                    }
                }
                
                strColumnStatus = ( ( nbSelectedOptions == nbOptions ) ? '1' : '0' ) + strColumnStatus; // add first the selectAll status
                
                optionStatusMap.put( columnName, strColumnStatus );
            }
            
            if( c.textFiltered )
            {
            	String strFilter = null;
            	if( fc != null && fc.predefinedTextFilters != null )
                {
                	strFilter = fc.predefinedTextFilters.get( columnName );
                }

            	if( strFilter == null )
            	{
            		strFilter = ''; // empty string
            	}
            	
            	textFilterMap.put( columnName, strFilter );
            }
        }
        
        if( perfFlag )
        {
        	startTime3 = System.currentTimeMillis();
        }
        
        //Map<String, String> m = new Map<String, String>();
        totalSize0 = 0;
        inMemoryFirstQueryObjects = new List<sObject>();
        for( sObject o : records )
        {
        	Boolean selectedRecordFlag = true; /*( inMemoryFirstQueryObjects.size() < maxPageSize );*/
        	
            for( Column c : columns )
            {
                if( c.filtered )
                {
                	String columnName = c.name;
                	String recordColumnValue = String.valueOf( o.get( columnName ) );
                	
                    if( fc != null /*&& selectedRecordFlag*/ )
	                {
	                	Set<String> selectedValueSet = filteredValuesMap.get( columnName );
	                    selectedRecordFlag = selectedRecordFlag && ( selectedValueSet == null || selectedValueSet.contains( recordColumnValue ) );
	                }
                }
                
                if( c.textFiltered )
                {
                	String columnName = c.name;
                	String strTextFilter = textFilterMap.get( columnName );
                	if( !String.isBlank( strTextFilter ) )
                	{
                		//insertNotEmptyValueLabel( o, m, c );
                		
                		String recordColumnValue;
                		Object value = o.get( columnName );
						if( value == null )
						{
							recordColumnValue = '';
						}
						else
						if( value instanceof Boolean )
						{
							recordColumnValue = String.valueOf( value );
						}
						else
						if( value instanceof DateTime )
						{
							// Format the DateTime according to the Locale of the current user
							recordColumnValue = ((DateTime)value).format( ( UserInfo.getLanguage().substring( 0, 2 ) == 'fr' ) ? 'dd/MM/yyyy' : 'M/d/yyyy' );
						}
						else
						{
							//insertNotEmptyValueLabel( o, m, c );
							Map<String, String> m = codesSet.get( columnName );
							recordColumnValue = m.get( String.valueOf( value ) );
						}
						
						if( recordColumnValue == null )
						{
							recordColumnValue = '';
						}
						
						//String strPattern = strTextFilter.replace( '%', '.*' ) + '.*';
						String strPattern = '\\Q' + strTextFilter.toLowerCase().replace( '\\', '' ).replace( '%', '\\E.*\\Q' ) + '\\E.*';
						selectedRecordFlag = selectedRecordFlag && ( Pattern.matches( strPattern, recordColumnValue.toLowerCase() ) );
                	}
                }
            }
            
            // Performance optimisation: In-memory first query done in the refreshFilters method, in order to avoid calling the query method to retrieve the first page results
            if( selectedRecordFlag )
            {
            	if( inMemoryFirstQueryObjects.size() < maxPageSize )
            	{
            		inMemoryFirstQueryObjects.add( o );
            	}
            	
            	totalSize0++;
            }
        }
        refreshSelected();
        
        if( perfFlag )
        {
        	endTime3 = System.currentTimeMillis();
        	endTime0 = endTime3;
        }
        
        //ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, 'refreshFilters ' + pageNumber ) );
        
        if( perfFlag )
        {
        	ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, 'buildSelectOptions performance logs: global-duration=' + ( endTime0 - startTime0 ) + ' ms ; query-duration= ' + ( endTime1 - startTime1 ) + ' ms ; first-loop-duration=' + ( endTime2 - startTime2 ) + ' ms ; second-loop-duration=' + ( endTime3 - startTime3 ) + ' ms' ) );
        }
    }
    
    /** list of columns */
    protected abstract Column[] listColumns();
    
    /** Initial filtering context */
    protected abstract FilteringContext initFilteringContext();
    
    /** object name */
    public abstract String getObjectName();
    
    /** where clause */
    protected abstract String getWhereClause(); 

    /** insert an option item value/label */
    protected virtual void insertNotEmptyValueLabel(sObject o, Map<String, String> m, Column c){
    	m.put(String.valueOf(o.get(c.name)), String.valueOf(o.get(c.displayed[0])));
    }
    
    private void query( Integer inputPageNumber ){
    	//ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, 'query ' + inputPageNumber ) );
    	
    	inMemoryFirstQueryObjects = null; // important
    	
        String query = '';
        query += 'SELECT ';
        Boolean commaFlag = false;
        for (Column c : columns){
        	if( commaFlag )
            {
        		query += COMMA_SEP;
        	}
        	else
        	{
        		commaFlag = true;
        	}
            query += c.name;
            for( String d : c.displayed )
            {
                if( !d.equals( c.name ) )
                {
                	query += COMMA_SEP;
                    query += d;
                }
            }
        }
        //-- WHERE clause
        query += ' FROM ' + this.getObjectName();
        String whereClause = getWhereClause();
        Boolean iswhere = false;
        if (!String.isBlank(whereClause)){
            query += ' WHERE ' + whereClause;
            iswhere = true;
        }
        //---if codes selected
        //-- TODO Find a solution for a fully dynamic filter building
        List<Object> rv_col1;
        List<Object> rv_col2;
        List<Object> rv_col3;
        List<Object> rv_col4;
        List<Object> rv_col5;
        List<Object> rv_col6;
        List<Object> rv_col7;
        List<Object> rv_col8;
        List<Object> rv_col9;
        List<Object> rv_col10;
        List<Object> rv_col11;
        
        String rv_textFilter1;
        String rv_textFilter2;
        String rv_textFilter3;
        String rv_textFilter4;
        String rv_textFilter5;
        String rv_textFilter6;
        String rv_textFilter7;
        String rv_textFilter8;
        String rv_textFilter9;
        String rv_textFilter10;
        String rv_textFilter11;
        //-- END
        Integer idxF = 0;
        Integer idxT = 0;
        String strSortColumns = null;
        for (Column c : columns){
            if (c.filtered){
                
                if (isFiltered(c.name)){
                    //-- inc counter
                    idxF++;
                    //-- blank value need an appropriate treatment
                    List<Object> l;
                    
                    Set<String> selectedValueSet = getFilteredValues( optionStatusMap, c.name );
                    
                    if (c.thetype == TYPE_STRING){
                        l = new List<String>();
                        for (String f : selectedValueSet){
                            if (EMPTY_OPTION.equals(f)){
                                 l.add(null);
                            }else{
                                l.add(f);
                            }
                        }
                    }
                    else
                    if (c.thetype == TYPE_BOOLEAN){
                        l = new List<Boolean>();
                        for (String f : selectedValueSet){
                            if (EMPTY_OPTION.equals(f)){
                                 l.add(null);
                            }else{
                                l.add( Boolean.valueOf(f) );
                            }
                        }
                    }
                    else
                    {
                    }
                    
                    //-- WARNING: 11 filtered columns are supported. If more add a statement here !
                    if (idxF == 1){
                        rv_col1 = l;
                    }else if (idxF == 2){
                        rv_col2 = l;
                    }else if (idxF == 3){
                        rv_col3 = l;
                    }else if (idxF == 4){
                        rv_col4 = l;
                    }else if (idxF == 5){
                        rv_col5 = l;
                    }else if (idxF == 6){
                        rv_col6 = l;
                    }else if (idxF == 7){
                        rv_col7 = l;
                    }else if (idxF == 8){
                        rv_col8 = l;
                    }else if (idxF == 9){
                        rv_col9 = l;
                    }else if (idxF == 10){
                        rv_col10 = l;
                    }else if (idxF == 11){
                        rv_col11 = l;
                    }
            //-- TODO Find a solution for a dynamic filter building
                    query += iswhere ? ' AND ' : ' WHERE ';
                    query += c.name + ' IN ';
                    query += ':rv_col' + idxF;
                    iswhere = true;
                }//else
            }// if
            
            if( c.textFiltered )
            {
            	String strTextFilter = textFilterMap.get( c.name );
            	if( !String.isBlank( strTextFilter ) )
            	{
            		idxT++;
            		strTextFilter += '%';
            		
            		if (idxT == 1){
                        rv_textFilter1 = strTextFilter;
                    }else if (idxT == 2){
                        rv_textFilter2 = strTextFilter;
                    }else if (idxT == 3){
                        rv_textFilter3 = strTextFilter;
                    }else if (idxT == 4){
                        rv_textFilter4 = strTextFilter;
                    }else if (idxT == 5){
                        rv_textFilter5 = strTextFilter;
                    }else if (idxT == 6){
                        rv_textFilter6 = strTextFilter;
                    }else if (idxT == 7){
                        rv_textFilter7 = strTextFilter;
                    }else if (idxT == 8){
                        rv_textFilter8 = strTextFilter;
                    }else if (idxT == 9){
                        rv_textFilter9 = strTextFilter;
                    }else if (idxT == 10){
                        rv_textFilter10 = strTextFilter;
                    }else if (idxT == 11){
                        rv_textFilter11 = strTextFilter;
                    }
            		
            		query += iswhere ? ' AND ' : ' WHERE ';
            		query += c.displayed[0] + ' LIKE :rv_textFilter' + idxT;
            		iswhere = true;
            	}
            }
            
            if( sortColumn != null && sortColumn == c.name )
            {
            	strSortColumns = '';
            	commaFlag = false;
            	for( String columnName : c.displayed )
            	{
            		if( commaFlag )
		            {
		        		strSortColumns += COMMA_SEP;
		        	}
		        	else
		        	{
		        		commaFlag = true;
		        	}
            		strSortColumns += columnName;
            	}
            }
            
        }// for
        if( !String.isEmpty( strSortColumns ) )
        {
            query += ' ORDER BY ';
            query += strSortColumns;
            query += ascending ? ' ASC' : ' DESC';
        }
        
        query += ' LIMIT ' + Limits.getLimitQueryLocatorRows(); // Maximum number of records retrieved by Database.getQueryLocator: 10000
        
        //ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, query ) );
        
        System.debug('#### LMT_MultiCriteriaFilteredTable_CLS - buildQuery : ' + query);
        //-- load in the standard set controller
        ssc = new ApexPages.StandardSetController( Database.getQueryLocator( query ) );
        ssc.setPageSize( maxPageSize );
        ssc.setPageNumber( inputPageNumber );
        System.debug('#### LMT_MultiCriteriaFilteredTable_CLS - buildQuery : ssc.getResultSize()' + ssc.getResultSize());
        System.debug('#### LMT_MultiCriteriaFilteredTable_CLS - buildQuery : ssc.getRecords()' + ssc.getRecords().size());
        refreshSelected();
    }
    
    private void refreshSelected(){
        // update selected rows ids status string (comma-separated)
        String strStatus = '';
        
        if( objects != null && selectedRowIdsStatus != null )
        {
    		Set<String> selectedRowIds = new Set<String>( selectedRowIdsStatus.split( COMMA_SEP ) );
        	
        	Boolean commaFlag = false;
	        for( sObject o : objects )
	        {
	            if( selectedRowIds.contains( o.Id ) )
	            {
	            	if( commaFlag )
	            	{
	            		strStatus += COMMA_SEP;
	            	}
	            	else
	            	{
	            		commaFlag = true;
	            	}
	            	
	            	strStatus += String.valueOf( o.id );
	            }
	        }
        }
        
        selectedRowIdsStatus = strStatus;
    }
    
    /** generate a custom parameter of ids (comma-separated) */
    protected String customids()
    {
    	return selectedRowIdsStatus;
    }
    
    private boolean isFiltered( String columnName )
    {
    	// status string without selectAll checkbox status: has some checkbox deselections
    	
    	//String textFilter = textFilterMap.get( columnName );
    	String status = optionStatusMap.get( columnName );
    	//return ( !String.isBlank( textFilter ) || ( status != null && status.substring( 1 ).contains( '0' ) ) );
    	return ( status != null && status.substring( 1 ).contains( '0' ) );
    }
    
    public Set<String> getFilteredValues( String columnName )
    {
    	return getFilteredValues( optionStatusMap, columnName );
    }
    
    private Set<String> getFilteredValues( Map<String, String> optionStatusMap1, String columnName )
    {
    	if( optionStatusMap1 != null )
    	{
			Set<String> selectedValueSet = new Set<String>();
			
			List<SelectOption> optionList = selectOptions.get( columnName );
			
	    	String optionStatus0 = optionStatusMap1.get( columnName );
	    	if( !String.isEmpty( optionStatus0 ) )
	    	{
	    		String optionStatus = optionStatus0.substring( 1 ); // status string without selectAll checkbox status
	    		if( !String.isEmpty( optionStatus ) && optionList != null )
	    		{
			    	Integer index = 0;
			    	for( SelectOption option : optionList )
			    	{
			    		String strIsSelected = optionStatus.substring( index, index + 1 );
			    		if( strIsSelected == '1' )
			    		{
			    			selectedValueSet.add( option.getValue() );
			    		}
			    		
			    		index++;
			    	}
			    	
			    	return selectedValueSet;
	    		}
	    	}
    	}
    	
    	return null;
    }
    
    // ============================ PAGINATION ====================================================
    public PageReference cancelFilters(){
    	sortColumn = null;
    	ascending = false;
    	query( 1 );
    	return null;
    }
    
    /** jump to first page */
    public PageReference firstPage(){
    	if( ssc != null )
    	{
        	ssc.first();
        	refreshSelected();
    	}
        return null;
    }
    /** jump to previous page */
    public PageReference previous(){
        if( ssc != null )
    	{
    		ssc.previous();
        	refreshSelected();
    	}
        return null;
    }
    /** jump to next page */
    public PageReference next(){
    	if( ssc != null )
    	{
    		ssc.next();
        	refreshSelected();
    	}
    	else
    	{
    		query( pageNumber + 1 );
    	}
        return null;
    }
    /** jump to last page */
    public PageReference lastPage(){
    	if( ssc != null )
    	{
        	ssc.last();
        	refreshSelected();
    	}
    	else
    	{
    		query( totalPages );
    	}
        return null;
    }
	
    public static String formatName(String firstname, String lastname){
        String userName = lastName;
        if (!String.isBlank(firstname)){
            userName += ' ' + firstname;
        }
        return userName;
    }
    
    /**
     * Build a filtering context and serialize it.
     * This is used to recover filtering and sorting context when returning to this page
     * after having assigning a lead or an opportunity.
     */
    protected String buildFilteringContext(){
        FilteringContext fc = new FilteringContext();
        fc.sortColumn = sortColumn;
        fc.ascending = ascending;
        fc.optionStatusMap = new Map<String, String>();
        fc.predefinedFilteredValues = null;
        fc.predefinedTextFilters = new Map<String, String>();
        fc.selectedRowIdsStatus = selectedRowIdsStatus;
        for (String columnName : selectOptions.keySet()){
        	if (isFiltered(columnName)){
            	fc.optionStatusMap.put(columnName, optionStatusMap.get(columnName));
        	}
        }
        for( String columnName : textFilterMap.keySet() )
        {
        	String strTextFilter = textFilterMap.get( columnName );
        	if( !String.isBlank( strTextFilter ) )
        	{
        		fc.predefinedTextFilters.put( columnName, strTextFilter );
        	}
        }
        
        String fctx = fc.serialize();
        //System.debug( LoggingLevel.INFO, '**** buildFilteringContext fctx:' + fctx );
        return fctx;
    }
    
    public Component.Apex.OutputText getCustomHtmlTable()
	{
		String objectName = getObjectName();
		Schema.DescribeSObjectResult r;
		if( objectName == 'Lead' )
		{
			r = Lead.sObjectType.getDescribe();
		}/*
		else
		if( objectName == 'Opportunity' )
		{
			r = Opportunity.sObjectType.getDescribe();
		}
		else
		{
			r = Lead.sObjectType.getDescribe();
		}*/
		
		String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		String sitePrefix = Site.getPathPrefix();
		if( !String.isEmpty( sitePrefix ) )
		{
			baseUrl += sitePrefix;
		}
		Map<String, String> resourceUrlMap = getResourceUrlMap( new String[]{ 'LMT_StaticResources_STR' } );
		
		String staticResourcesUrlPrefix = baseUrl + resourceUrlMap.get( 'LMT_StaticResources_STR' );
		
		String queuePrefixId = '00G'; //Queue.getSObjectType().getDescribe().getKeyPrefix();
		
		String str = '';
		
		str += '<table class="list" id="theTable" cellpadding="0" cellspacing="0" border="0">';
		str += '<thead class="rich-table-thead">';
		str += '<tr class="headerRow">';
		
		// First column header: checkbox for all records selection
		String checked = allSelected ? 'checked="checked"' : '';
		str += '<th class="headerRow" scope="col">';
		str += '<input id="cb_sa" value="selectAll" '+checked+' onclick="javascript:selectAll0();" type="checkbox" />';
		str += '</th>';
		
		/*
		// Second column header: name
		str += '<th class="headerRow" scope="col">';
		str += '<a href="#" onclick="javascript:sortByColumn(\'Name\');return false;">' + r.fields.getMap().get( 'Name' ).getDescribe().getLabel() + '</a>';
		str += '</th>';
		*/
		
		// Other columns headers:
		for( Column c : columns )
		{
			String headerClassName = ( ( c.filtered || c.textFiltered ) && ( isFiltered.get( c.name ) || !String.isBlank( textFilterMap.get( c.name ) ) ) ) ? 'headerRow filteredRow' : 'headerRow';
			str += '<th id="'+c.name+'_header" class="'+headerClassName+'" scope="col">';
			
			String columnLabel = '';
			
			if( objectName == 'Lead' && c.name == 'Id'){
				columnLabel = Label.LMT_FilteredTable_Name;
			}
			else columnLabel = r.fields.getMap().get( c.name ).getDescribe().getLabel();
			
			// Split a long column name on two lines
			final Integer MAX_LENGTH = 10;
			final String SEP = ' ';
			final Integer COLUMN_LABEL_LENGTH = columnLabel.length();
			if( COLUMN_LABEL_LENGTH > MAX_LENGTH )
			{
				String htmlColumnLabel = '';
				boolean wrapLineFlag = false;
				
				String[] tab = columnLabel.trim().split( SEP );
				Integer size = tab.size();
				for( Integer i = 0; i < size; i++ )
				{
					if( i > 0 )
					{
						htmlColumnLabel += SEP;
						
						if( !wrapLineFlag )
						{
							if( htmlColumnLabel.length() <= COLUMN_LABEL_LENGTH / 2 )
							{
								if( htmlColumnLabel.length() + tab[ i ].length() > COLUMN_LABEL_LENGTH / 2 )
								{
									wrapLineFlag = true;
								}
							}
							else
							{
								wrapLineFlag = true;
							}
							
							if( wrapLineFlag )
							{
								htmlColumnLabel += '<br/>';
							}
						}
					}
					
					htmlColumnLabel += tab[ i ];
				}
				
				columnLabel = htmlColumnLabel;
			}
			
			if( loaded )
			{
				//str += '<span style="text-align:right">';
				str += '<a href="#" onclick="javascript:sortByColumn(\''+c.name+'\');return false;">' + columnLabel + '</a>';
				
				if( c.filtered || c.textFiltered )
				{
					String imgSrc;
					if( isFiltered.get( c.name ) || !String.isBlank( textFilterMap.get( c.name ) ) )
					{
						imgSrc = staticResourcesUrlPrefix + '/images/filtre.jpg';
					}
					else
					{
						imgSrc = staticResourcesUrlPrefix + '/images/fleche-bas.jpg';
					}
					
					str += ' ';
					str += '<img id="'+c.name+'_imgFilter" src="'+imgSrc+'" onclick="javascript:openpopup(this, \''+c.name+'\', \''+c.name+'_id\');" style="margin-left: 5px" />';
				}
				
				//str += '</span>';
			}
			else
			{
				str += columnLabel;
			}
			
			str += '</th>';
		}
		
		str += '</tr>\n';
		str += '</thead>';
		str += '<tbody>';
		
		// Records
		if( objects != null )
		{
			Integer i = 0;
			for( sObject o : objects )
			{
				str += '<tr class="dataRow '+( Math.mod(i,2) == 0 ? 'even' : 'odd' )+'" onmouseover="if (window.hiOn){hiOn(this);}" onmouseout="if (window.hiOff){hiOff(this);}" onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}">';
				
				// First column: checkbox for record selection
				checked = '';
				if( selectedRowIdsStatus != null )
       			{
    				Set<String> selectedRowIds = new Set<String>( selectedRowIdsStatus.split( COMMA_SEP ) );
    				
    				if( selectedRowIds.contains( o.Id ) )
    				{
    					checked = 'checked="checked"';
    				}
       			}
				str += '<td class="dataCell">';
				str += '<input id="'+o.Id+'_spancb" value="" '+checked+' onclick="javascript:checkboxOnChange(this);" type="checkbox" />';
				str += '</td>';
				
				Id id = o.Id;
				String strValue;
				String urlId;
				String retUrlId;
				Boolean minipageFlag;
				
				/*
				// Second column: record name
				id = o.Id;
				strValue = String.valueOf( o.get( 'Name' ) );
				urlId = id;
				retUrlId = '/'+id+'/m?retURL=%2F'+id+'&isAjaxRequest=1';
				minipageFlag = false; // no minipage
				str += '<td class="dataCell">';
				str += '<a href="'+baseUrl+'/'+urlId+'" id="lookup'+i+':'+id+'" target="_new"';
				if( minipageFlag ) // slow performance with minipages
				{
					str += ' onblur="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\').hide();"';
					str += ' onfocus="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\', \''+retUrlId+'\').show();"';
					str += ' onmouseout="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\').hide();"';
					str += ' onmouseover="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\', \''+retUrlId+'\').show();"';
				}
				str += '>' + strValue + '</a>';
				str += '</td>';
				*/
				
				// Other columns:
				Map<String, String> m = new Map<String, String>();
				for( Column c : columns )
				{
					String columnName = c.name;
					
					str += '<td class="dataCell">';
					
					Object value = o.get( columnName );
					if( value == null )
					{
						str += '';
					}
					else
					if( value instanceof Boolean )
					{
						String imgSrc = baseUrl + ( (Boolean)value ? '/img/checkbox_checked.gif' :'/img/checkbox_unchecked.gif' );
						str += '<img src="'+imgSrc+'" />';
					}
					else
					if( value instanceof DateTime )
					{
						// Format the DateTime according to the Locale of the current user
						str += ((DateTime)value).format( ( UserInfo.getLanguage().substring( 0, 2 ) == 'fr' ) ? 'dd/MM/yyyy' : 'M/d/yyyy' );
					}
					else
					{
						insertNotEmptyValueLabel( o, m, c );
						
						/*
						strValue = String.valueOf( value );
						
						if( 'Id'.equals( columnName ) )
				        {
				        	Lead lead = (Lead) o;
				        	m.put( strValue, formatName( lead.FirstName, lead.LastName ) );
				        }
				        else
				        if( 'DealerOfInterest__c'.equals( columnName ) )
				        {
				        	if( m.get( strValue ) == null )
				        	{
				        		Lead lead = (Lead) o;
				        		m.put( strValue, lead.DealerOfInterest__r.Name );
				        	}
				        }
				        else
				        if( 'Preassigned_Seller__c'.equals( columnName ) )
				        {
				        	if( m.get( strValue ) == null )
				        	{
				        		Lead lead = (Lead) o;
				            	m.put( strValue, formatName( lead.Preassigned_Seller__r.FirstName, lead.Preassigned_Seller__r.LastName ) );
				        	}
				        }
				        else
				        if( 'OwnerId'.equals( columnName ) )
				        {
				        	if( m.get( strValue ) == null )
				        	{
				        		Lead lead = (Lead) o;
				            	m.put( strValue, lead.Owner.Name );
				        	}
				        }
				        else
				        {
				        	if( m.get( strValue ) == null )
				        	{
				        		m.put( strValue, strValue );
				        	}
				        }
						*/
						
						strValue = m.get( String.valueOf( value ) );
						
						if( value instanceof Id )
						{
							id = (Id)value;
							
							urlId = id;
							retUrlId = '/'+id+'/m?retURL=%2F'+id+'&isAjaxRequest=1';
							minipageFlag = false; //true;
							
							if( String.valueOf( id ).startsWith( queuePrefixId ) )
							{
								urlId = 'p/own/Queue/d?id='+id;
								minipageFlag = false;
							}
							
							str += '<a href="'+baseUrl+'/'+urlId+'" id="lookup'+i+':'+id+'" target="_new"';
							if( minipageFlag ) // slow performance with minipages
							{
								str += ' onblur="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\').hide();"';
								str += ' onfocus="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\', \''+retUrlId+'\').show();"';
								str += ' onmouseout="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\').hide();"';
								str += ' onmouseover="LookupHoverDetail.getHover(\'lookup'+i+':'+id+'\', \''+retUrlId+'\').show();"';
							}
							str += '>' + strValue + '</a>';
						}
						else
						{
							str += strValue;
						}
					}
					
					str += '</td>';
				}
				
				str += '</tr>\n';
				
				i++;
			}
		}
		
		str += '</tbody>';
		str += '</table>';
		
		
		Component.Apex.OutputText outputText = new Component.Apex.OutputText();
		outputText.value = str;
		outputText.escape = false;
		
		return outputText;
/*
			<apex:pageBlockTable id="theTable" value="{!firstController.objects}" var="o">
				<apex:column >
					<span id="{!o.Id}_spancb">
						<apex:inputCheckbox onclick="javascript:checkboxOnChange(this);" value="{!firstController.selected[o.Id]}" />
					</span>
					<apex:facet name="header">
						<apex:inputCheckbox onclick="javascript:selectAll0();" value="{!firstController.allSelected}" id="cb_sa" />
					</apex:facet>
				</apex:column>
				<apex:column >
					<apex:outputLink value="/{!o.Id}">{!o['Name']}</apex:outputLink>
					<apex:facet name="header">
						<apex:outputPanel >
							<apex:commandLink action="{!firstController.sortBy}" rerender="theBlock">
								<apex:param name="column" assignTo="{!firstController.sortColumn}" value="Name" />
								<apex:outputText value="{!$ObjectType[objectName].fields.Name.label}" />
							</apex:commandLink>
						</apex:outputPanel>
					</apex:facet>
				</apex:column>

				<apex:repeat value="{!firstController.columns}" var="c">
					<apex:column value="{!o[c.name]}">
						<apex:facet name="header">
							<apex:outputPanel style="text-align:right">
								<apex:commandLink action="{!firstController.sortBy}" rerender="theBlock">
									<apex:param name="column" assignTo="{!firstController.sortColumn}" value="{!c.name}" />
									<apex:outputText value="{!$ObjectType[objectName].fields[c.name].label}" />
								</apex:commandLink>
								<apex:image id="flechebas"
									rendered="{!AND(c.filtered, firstController.loaded, NOT(firstController.isFiltered[c.name]))}"
									value="{!URLFOR($Resource.LMT_StaticResources_STR, 'images/fleche-bas.jpg')}"
									onclick="javascript:openpopup(this, '{!c.name}', '{!c.name}_id');"
									style="margin-left: 5px" />
								<apex:image id="filtre"
									rendered="{!AND(c.filtered, firstController.loaded, firstController.isFiltered[c.name])}"
									value="{!URLFOR($Resource.LMT_StaticResources_STR, 'images/filtre.jpg')}"
									onclick="javascript:openpopup(this, '{!c.name}', '{!c.name}_id');"
									style="margin-left: 5px" />
							</apex:outputPanel>
						</apex:facet>
					</apex:column>
				</apex:repeat>
			</apex:pageBlockTable>
*/
	}
	
	private static Map<String, String> getResourceUrlMap( List<String> resourceNameList )
	{
		Map<String, String> resourceUrlMap = new Map<String, String>();
		
	    for( StaticResource res : [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceNameList] )
	    {
	    	if( res != null )
	    	{
		        String url = '/resource/' + res.SystemModStamp.getTime() + '/';
		        if( !String.isEmpty( res.NamespacePrefix ) )
		        {
		            url += res.NamespacePrefix + '__';
		        }
		        url += res.name;
		        
		        resourceUrlMap.put( res.name, url );
	    	}
	    }
	    
	    return resourceUrlMap;
	}
	
	/** Method only defined for testing: auto-select some custom filtered values */
	@TestVisible private void setCustomFilteredValues( String columnName, String[] customFilteredValues )
	{
		Set<String> customFilteredValueSet = ( customFilteredValues == null ) ? null : new Set<String>( customFilteredValues );
		setCustomFilteredValues( columnName, customFilteredValueSet );
	}
	
	/** Method only defined for testing: auto-select some custom filtered values */
	@TestVisible private void setCustomFilteredValues( String columnName, Set<String> customFilteredValueSet )
	{
		List<SelectOption> optionList = selectOptions.get( columnName );
		
		String strColumnStatus = '';
        Integer nbOptions = optionList.size();
        Integer nbSelectedOptions = 0;
		
        if( customFilteredValueSet != null )
        {
            for( SelectOption option : optionList )
            {
                if( customFilteredValueSet.contains( option.getValue() ) )
                {
                	// Select
                    strColumnStatus += '1';
                    nbSelectedOptions++;
                }
                else
                {
                	strColumnStatus += '0';
                }
            }
        }
        else
        {
        	// SelectAll
            for( Integer i = 0; i < nbOptions; i++ )
            {
            	strColumnStatus += '1';
            	nbSelectedOptions++;
            }
        }
        
        strColumnStatus = ( ( nbSelectedOptions == nbOptions ) ? '1' : '0' ) + strColumnStatus; // add first the selectAll status
        
        optionStatusMap.put( columnName, strColumnStatus );
	}
    
}