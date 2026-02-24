-- Object: PROCEDURE citrus_usr.pr_get_clientlist_enttmwice
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--	1	20		3				1	Y	HO|*~|HO|*~|*|~*BR|*~|0297|*~|*|~*	dsclient--select * from entity_mstr where entm_enttm_cd = 'BR'  
--exec  pr_get_clientlist_enttmwice 0,0,'','3','','','','1','','HO|*~|HO|*~|*|~*BR|*~|TNIA|*~|*|~*','' 
--exec  pr_get_clientlist_enttmwice 1,20,'','3','','','','1','Y','HO|*~|HO|*~|*|~*BR|*~|0297|*~|*|~*',''  
CREATE  PROC [citrus_usr].[pr_get_clientlist_enttmwice](@pa_startRowIndex int,                                                      
                                    @pa_maximumRows int  ,                                                
                                    @pa_action as varchar(20),                                                     
                                    @pa_cd varchar(20),                                                
                                    @pa_desc varchar(20),                                           
                                    @pa_code varchar(20),                                               
                                    @pa_value varchar(100),                        
                                    @pa_rmks varchar(20),          
									@pa_stat varchar(10)='Y',
                                    @pa_hiercy VARCHAR(2500),     
                                    @pa_ref_cur varchar(20) OUTPUT  )  
as  
begin  
  
  
declare @l_hiercy table(cd varchar(100), shortname varchar(500),hiercy_string varchar(8000))  
   
 declare @l_counter numeric  
  ,@l_count numeric   
 , @l_filter_values varchar(2000)  
        , @l_filter_hiercy varchar(2000)  
  ,@FSTRec BIGINT                
          ,@LSTRec BIGINT  
,@L_DPM_ID NUMERIC          
  set @l_counter  = 1  
  
 set @l_count = citrus_usr.ufn_countstring(@pa_hiercy ,'*|~*')  
  
  while @l_count >= @l_counter  
  begin   
  
  set @l_filter_hiercy =  citrus_usr.fn_splitval_row(@pa_hiercy,@l_counter)  
  
  
  insert into @l_hiercy select citrus_usr.fn_splitval(@l_filter_hiercy,1) , citrus_usr.fn_splitval(@l_filter_hiercy,2),''  
  
  set @l_counter= @l_counter +1   
  end   
  
  update tmp  
  set  tmp.hiercy_string = '' + ENTEM_ENTR_COL_NAME +''+ ' = ' + convert(varchar,entm_id)   
  from @l_hiercy  tmp , enttm_entr_mapping , entity_mstr entm where ENTEM_ENTTM_CD = cd and entm_short_name = shortname  
  
    
  declare @l_sql varchar(2000)  
  , @l_sql_hier varchar(500)  
     
   set @l_sql_hier  = ''  
   set @l_sql  = ''  
   select @l_sql_hier  = isnull(@l_sql_hier ,'') + hiercy_string + ' AND ' from @l_hiercy   

   select @l_sql  = 'IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME = ''TEMP_DATA_cLIENT'' ) DROP TABLE TEMP_DATA_cLIENT ' 
   select @l_sql  = @l_sql   + ' select dpam_sba_no , dpam_sba_name INTO TEMP_DATA_cLIENT from dp_acct_mstr , entity_relationship '  
   select @l_sql  = @l_sql   + ' where dpam_sba_no = entr_sba and entr_deleted_ind =1 and dpam_deleted_ind =  1 '  
   select @l_sql  = @l_sql   + case when @l_sql_hier  <> '' then ' and ' + substring(ltrim(rtrim(@l_sql_hier)),1,len(ltrim(rtrim(@l_sql_hier)))-3)   else '' end  
   print @l_sql  

EXEC(@l_sql)

    SET ROWCOUNT 0            
                -- select @l_dpm_id     
     SELECT  @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_cd and dpm_deleted_ind =1                       

                
     DECLARE @TBLCLLIST  TABLE (TID int IDENTITY PRIMARY KEY,dpam_id numeric,dpam_crn_no numeric  ,dpam_sba_no varchar(16) ,dpam_sba_name varchar(100)  ,acct_type varchar(5))                
    if @pa_stat = 'Y'                 
    BEGIN          
	 --          
	 INSERT INTO @TBLCLLIST                  
	 SELECT  dpam_id                   
	 ,dpam_crn_no                   
	 ,ACCT.dpam_sba_no                  
	 ,ACCT.dpam_sba_name                  
	 ,acct_type                  
	 FROM    CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)  ACCT ,TEMP_DATA_cLIENT     T1                      
	 WHERE   ACCT.dpam_sba_name LIKE @pa_desc +'%'                
	 AND     T1.DPAM_SBA_NO = ACCT.DPAM_SBA_NO            
	 AND     ACCT.dpam_sba_no   LIKE '%' + @pa_code            
	 AND     ACCT.dpam_stam_cd ='ACTIVE'      
	 AND     getdate()  BETWEEN eff_from AND eff_to       
	 --          
    END             
    ELSE          
    BEGIN          
 --         

 
 INSERT INTO @TBLCLLIST                  
 SELECT  dpam_id                   
 ,dpam_crn_no                   
 ,ACCT.dpam_sba_no                  
 ,ACCT.dpam_sba_name                  
 ,acct_type                  
 FROM    CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)  ACCT  ,TEMP_DATA_cLIENT     T1                      
 WHERE   T1.DPAM_SBA_NO = ACCT.DPAM_SBA_NO     
 AND     ACCT.dpam_sba_name LIKE @pa_desc +'%'                  
 AND     ACCT.dpam_sba_no   LIKE '%' + @pa_code                
 AND     getdate()  BETWEEN eff_from AND eff_to             
 --          
    END                                            
                                                   
    IF @pa_startRowIndex = 1                              
    BEGIN                     
    --                              
      SELECT @l_count = COUNT(TID) FROM @TBLCLLIST                  
    --                              
    END                  
                    
    SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
    SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                             

                      
    SELECT distinct T.dpam_sba_name Client_Name                                        
           ,right(T.dpam_sba_no,8)   Acct_no                                                 
           , dpam_crn_no    Client_Id                                
           ,CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'I' ELSE 'P'END  ACCT_TYPE                              
           ,'' CMBPID                          
           ,@l_count   totalrecords                           
    FROM  @TBLCLLIST   T        
    WHERE TID > @FSTRec   
    AND TID < @LSTRec  
    
    ORDER BY  T.dpam_sba_name            
                  
    SET ROWCOUNT 0                 
    SET @FSTRec = 0                
    SET @LSTRec = 0     

end

GO
