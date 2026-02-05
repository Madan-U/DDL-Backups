-- Object: PROCEDURE citrus_usr.pr_import_dpm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--PR_IMPORT_DPM 'cdsl','ho','bulk','c:\BulkInsDbfolder\DP MASTER\CD010514U.001','*|~*','|*~|',''
CREATE PROCEDURE  [citrus_usr].[pr_import_dpm]( @pa_exch          VARCHAR(20)  
											,@pa_login_name    VARCHAR(20)  
											,@pa_mode          VARCHAR(10)  																																
											,@pa_db_source     VARCHAR(250)  
											,@rowdelimiter     CHAR(4) =     '*|~*'    
											,@coldelimiter     CHAR(4) =     '|*~|'    
											,@pa_errmsg        VARCHAR(8000) output  
																			)    
AS  
/*  
*********************************************************************************  
 SYSTEM         : Dp  
 MODULE NAME    : Pr_import_Dpm
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables  
 COPYRIGHT(C)   : Marketplace Technologies   
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  --------------------------------------------------  
 1.0    TUSHAR            08-OCT-2007   VERSION.  
-----------------------------------------------------------------------------------*/  
BEGIN  
--
		IF @pa_mode = 'BULK'
		BEGIN
		--

							truncate table tmp_dp_mstr

							DECLARE @@ssql varchar(8000)
							SET @@ssql ='BULK INSERT tmp_dp_mstr from ''' + @pa_db_source + ''' WITH 
							(
										FIELDTERMINATOR = ''~'',
										ROWTERMINATOR = ''\n''
							)'

							EXEC(@@ssql)
		--
		END





  
  
  DECLARE @c_dpm_adr     CURSOR  
  DECLARE @c_dpm_conc    CURSOR  
  DECLARE @l_id           NUMERIC  
        , @l_count        NUMERIC  
        , @l_dpm_id_old  INTEGER  
        , @l_adr1         VARCHAR(50)  
        , @l_adr2         VARCHAR(50)   
        , @l_adr3         VARCHAR(50)   
        , @l_city         VARCHAR(50)  
        , @l_state        VARCHAR(50)  
        , @l_cntry        VARCHAR(50)  
        , @l_zip          VARCHAR(50)  
        , @l_values       VARCHAR(500)  
        , @l_ph1          VARCHAR(15)   
        , @l_ph2          VARCHAR(15)  
        , @l_fax          VARCHAR(15)  
        , @l_email        VARCHAR(50) 
        , @l_exch_id      NUMERIC
        
  UPDATE dp_mstr   
  SET    dpm_name       = tmpdp_first_nm
       , dpm_lst_upd_dt = getdate()
       , dpm_lst_upd_by = @pa_login_name
		FROM   tmp_dp_mstr  
  --WHERE  '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id))) = dpm_dpid and ltrim(rtrim(isnull(tmpdp_first_nm,''))) <> ''
  where       '1' + tmpdp_type + CASE WHEN LEN(convert(varchar,tmpdp_id)) = 5 THEN '0'+convert(varchar,ltrim(rtrim(tmpdp_id)))
WHEN LEN(convert(varchar,tmpdp_id)) = 4 THEN '00'+convert(varchar,ltrim(rtrim(tmpdp_id)))
WHEN LEN(convert(varchar,tmpdp_id)) = 3 THEN '000'+convert(varchar,ltrim(rtrim(tmpdp_id)))
WHEN LEN(convert(varchar,tmpdp_id)) = 2 THEN '0000'+convert(varchar,ltrim(rtrim(tmpdp_id))
) ELSE convert(varchar,ltrim(rtrim(tmpdp_id))) END  = DPM_DPID   
and TMPDP_FIRST_NM <> DPM_NAME  
  AND   tmpdp_type IN ('2','3','6')  
    
   


  SELECT IDENTITY(INT, 1, 1) ID1, '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id))) dpm_dpid INTO #tmp_identity_dpm FROM tmp_dp_mstr  where tmpdp_type IN ('2','3','6')  and '1' + ltrim(rtrim(tmpdp_type)) + convert(varchar,tmpdp_id)  NOT IN(SELECT dpm_dpid FROM dp_mstr)  
    
  SELECT @l_count = COUNT(*) from #tmp_identity_dpm 
  
  SELECT @l_exch_id = excsm_id FROM exch_seg_mstr WHERE excsm_exch_cd =  @pa_exch
    
  SELECT @l_dpm_id_old  = bitrm_bit_location  
  FROM   bitmap_ref_mstr    WITH(NOLOCK)  
  WHERE  bitrm_parent_cd = 'ENTITY_ID'  
  AND    bitrm_child_cd  = 'ENTITY_ID'  
     
  UPDATE bitmap_ref_mstr      
  SET    bitrm_bit_location = bitrm_bit_location + isnull(@l_count,0)   + 1
  WHERE  bitrm_parent_cd = 'ENTITY_ID'  
  AND    bitrm_child_cd  = 'ENTITY_ID'  
    

  INSERT INTO dp_mstr
  (dpm_id
		,	dpm_excsm_id
		,dpm_dpid
		,dpm_short_name
		,dpm_name
		,dpm_rmks
		,dpm_created_by
		,dpm_created_dt
		,dpm_lst_upd_by
		,dpm_lst_upd_dt
		,dpm_deleted_ind
  )  
  SELECT ID1 + @l_dpm_id_old 
  ,@l_exch_id 
  ,'1' + tmpdp_type + CASE WHEN LEN(convert(varchar,tmpdp_id)) = 5 THEN '0'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 4 THEN '00'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 3 THEN '000'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 2 THEN '0000'+convert(varchar,ltrim(rtrim(tmpdp_id))) ELSE convert(varchar,ltrim(rtrim(tmpdp_id))) END
  ,convert(varchar(20),ID1 + @l_dpm_id_old )
  ,tmpdp_first_nm
  ,''
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1   
  FROM  #tmp_identity_dpm  
      , tmp_dp_mstr  
  WHERE dpm_dpid  = '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id)))
  AND   '1' + tmpdp_type + CASE WHEN LEN(convert(varchar,tmpdp_id)) = 5 THEN '0'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 4 THEN '00'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 3 THEN '000'+convert(varchar,ltrim(rtrim(tmpdp_id)))
                      WHEN LEN(convert(varchar,tmpdp_id)) = 2 THEN '0000'+convert(varchar,ltrim(rtrim(tmpdp_id))) ELSE convert(varchar,ltrim(rtrim(tmpdp_id))) END not IN (select CONVERT(varchar,dpm_dpid) from dp_mstr)  
  AND   tmpdp_type IN ('2','3','6')    
       
  SET    @c_dpm_adr =  CURSOR fast_forward FOR    
  SELECT dpm_id  
       , tmpdp_addr1
							, tmpdp_addr2
							, tmpdp_addr3
							, tmpdp_city
							, tmpdp_state
							, tmpdp_country
							, tmpdp_zip
  FROM   dp_mstr  
       , tmp_dp_mstr   
  WHERE  dpm_dpid = '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id)))
  AND   tmpdp_type IN ('2','3','6')    
    
  OPEN @c_dpm_adr    
  FETCH NEXT FROM @c_dpm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
    
  WHILE @@fetch_status = 0    
  BEGIN    
  --    
      
    SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_adr3,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + isnull(@l_cntry,'') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*' 
    
    EXEC pr_ins_upd_addr @l_id, 'INS', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''    
      
    FETCH NEXT FROM @c_dpm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
  --    
  END    
   
  
  CLOSE      @c_dpm_adr    
  DEALLOCATE @c_dpm_adr    
    
    
  SET    @c_dpm_conc =  CURSOR fast_forward FOR    
  SELECT dpm_id  
       , tmpdp_phone1
							, tmpdp_phone2
							, tmpdp_fax
							, tmpdp_email
  FROM   dp_mstr  
       , tmp_dp_mstr   
  WHERE  dpm_dpid = '1' + tmpdp_type + convert(varchar,tmpdp_id)
  AND   tmpdp_type IN ('2','3','6')    
  
  OPEN @c_dpm_conc    
  FETCH NEXT FROM @c_dpm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email
  
  WHILE @@fetch_status = 0    
  BEGIN    
  --    
  
    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*'  
    
    EXEC pr_ins_upd_conc @l_id, 'INS', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''    
  
    FETCH NEXT FROM @c_dpm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email
  --    
  END    
      
      
  CLOSE      @c_dpm_conc    
  DEALLOCATE @c_dpm_conc   
    
--  
END

GO
