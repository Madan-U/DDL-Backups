-- Object: PROCEDURE citrus_usr.pr_import_Issuer_bakjun2916
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SELECT * FROM ENTITY_MSTR 
CREATE PROCEDURE  [citrus_usr].[pr_import_Issuer_bakjun2916]( @pa_exch          VARCHAR(20)  
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
 MODULE NAME    : Pr_import_Issuer   
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

							truncate table tmp_issuer_mstr

							DECLARE @@ssql varchar(8000)
							SET @@ssql ='BULK INSERT DP.CITRUS_USR.tmp_issuer_mstr	 from ''' + @pa_db_source + ''' WITH 
							(
										FIELDTERMINATOR = ''~'',
										ROWTERMINATOR = ''\n''
							)'

							EXEC(@@ssql)
		--
  END
  
  
  
  DECLARE @c_entm_adr     CURSOR  
  DECLARE @c_entm_conc    CURSOR  
  DECLARE @l_id           NUMERIC  
        , @l_count        NUMERIC  
        , @l_entm_id_old  INTEGER  
        , @l_adr1         VARCHAR(50)  
        , @l_adr2         VARCHAR(50)   
        , @l_adr3         VARCHAR(50)   
        , @l_city         VARCHAR(50)  
        , @l_state        VARCHAR(50)  
        , @l_cntry        VARCHAR(50)  
        , @l_zip          VARCHAR(50)  
        , @cp_adr1        VARCHAR(50)  
								, @cp_adr2        VARCHAR(50)   
								, @cp_adr3        VARCHAR(50)   
								, @cp_city        VARCHAR(50)  
								, @cp_state       VARCHAR(50)  
								, @cp_cntry       VARCHAR(50)  
        , @cp_zip         VARCHAR(50) 
        , @l_values       VARCHAR(500)  
        , @l_ph1          VARCHAR(15)   
        , @l_ph2          VARCHAR(15)  
        , @l_fax          VARCHAR(15)  
        , @l_email        VARCHAR(50)  
        , @cp_ph1          VARCHAR(15)   
        , @cp_ph2          VARCHAR(15)  
        , @cp_fax          VARCHAR(15)  
        , @cp_email        VARCHAR(50) 
        , @l_conname      VARCHAR(25)  
        , @l_condesg      VARCHAR(25)  
  
  UPDATE entity_mstr   
  SET    entm_name1      = tmpiss_name
       , entm_lst_upd_dt = getdate()
       , entm_lst_upd_by = @pa_login_name
  FROM   tmp_Issuer_mstr  
  WHERE  CONVERT(VARCHAR,tmpiss_ID)= entm_short_name
    



  SELECT @l_count = COUNT(*) from tmp_Issuer_mstr WHERE tmpiss_name NOT IN(SELECT entm_short_name FROM entity_mstr)  
    
    
  SELECT @l_entm_id_old  = bitrm_bit_location  
  FROM   bitmap_ref_mstr    WITH(NOLOCK)  
  WHERE  bitrm_parent_cd = 'ENTITY_ID'  
  AND    bitrm_child_cd  = 'ENTITY_ID'  
     
  UPDATE bitmap_ref_mstr      
  SET    bitrm_bit_location = bitrm_bit_location + @l_count   + 10
  WHERE  bitrm_parent_cd = 'ENTITY_ID'  
  AND    bitrm_child_cd  = 'ENTITY_ID'  
    
  SELECT IDENTITY(INT, 1, 1) ID1, tmpiss_ID ID INTO #tmp_identity_Issuer FROM tmp_Issuer_mstr  
  
  INSERT INTO entity_mstr
  (entm_id
		,entm_name1
		,entm_name2
		,entm_name3
		,entm_short_name
		,entm_enttm_cd
		,entm_clicm_cd
		,entm_parent_id
		,entm_rmks
		,entm_created_by
		,entm_created_dt
		,entm_lst_upd_by
		,entm_lst_upd_dt
		,entm_deleted_ind
		)  
  SELECT 
   ID1 + @l_entm_id_old 
  ,convert(VARCHAR(150),tmpiss_name)
  ,''
  ,''
  ,convert(VARCHAR(100),tmpiss_ID)
  ,'ISSUER'
  ,'NRM'
  ,NULL
  ,''
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1   
  FROM  #tmp_identity_Issuer  
      , tmp_Issuer_mstr  
  WHERE ID = tmpiss_ID
  AND   CONVERT(varchar,tmpiss_ID) not IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
       
       
  SET    @c_entm_adr =  CURSOR fast_forward FOR    
  SELECT entm_id  
       , tmpiss_add1
							, tmpiss_add2
							, tmpiss_add3
							, tmpiss_city
							, tmpiss_state
							, tmpiss_country
       , tmpiss_zip
       , tmpiss_cp_add1
							, tmpiss_cp_add2
							, tmpiss_cp_add3
							, tmpiss_cp_city
							, tmpiss_cp_state
							, tmpiss_cp_country
       , tmpiss_cp_zip
  FROM   entity_mstr  
       , tmp_Issuer_mstr   
  WHERE  entm_short_name = tmpiss_name
    
  OPEN @c_entm_adr    
  FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
  ,@cp_adr1, @cp_adr2, @cp_adr3, @cp_city, @cp_state, @cp_cntry, @cp_zip  
    
  WHILE @@fetch_status = 0    
  BEGIN    
  --    
      
    SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_adr3,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + isnull(@l_cntry,'') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*' 
    SET @l_values = @l_values + 'COR_ADR1' + '|*~|' + ISNULL(@cp_adr1,'') + '|*~|' + ISNULL(@cp_adr2,'') + '|*~|' + ISNULL(@cp_adr3,'') + '|*~|' + ISNULL(@cp_city,'') + '|*~|' + ISNULL(@cp_state,'') + '|*~|' + isnull(@cp_cntry,'') + '|*~|' + isnull(@cp_zip,'') + '|*~|*|~*' 
    
    EXEC pr_ins_upd_addr @l_id, 'INS', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''    
      
    FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
    ,@cp_adr1, @cp_adr2, @cp_adr3, @cp_city, @cp_state, @cp_cntry, @cp_zip  
  --    
  END    
   
  
  CLOSE      @c_entm_adr    
  DEALLOCATE @c_entm_adr    
    
    
  SET    @c_entm_conc =  CURSOR fast_forward FOR    
  SELECT entm_id  
       , tmpiss_phone1
							, tmpiss_phone2
							, tmpiss_fax
							, tmpiss_email
							, tmpiss_cp_nm
							, tmpiss_cp_desig
							, tmpiss_cp_ph1
							, tmpiss_cp_ph2
							, tmpiss_cp_fax
       , tmpiss_cp_email
  FROM   entity_mstr
       , tmp_Issuer_mstr   
  WHERE  entm_short_name = tmpiss_name
  
  OPEN @c_entm_conc    
  FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg ,@cp_ph1, @cp_ph2, @cp_fax, @cp_email 
  
  WHILE @@fetch_status = 0    
  BEGIN    
  --    
  
    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*CONNAME|*~|'   + ISNULL(@l_conname,'') + '|*~|*|~*CONDESG|*~|'  + isnull(@l_condesg,'')+ '|*~|*|~*CP_PH1|*~|'  + isnull(@cp_ph1,'')+ '|*~|*|~*CP_PH2|*~|'  + isnull(@cp_ph2,'')+ '|*~|*|~*CP_FAX|*~|'  + isnull(@cp_fax,'')+ '|*~|*|~*CP_EMAIL|*~|'  + isnull(@cp_email,'') + '|*~|*|~*'  
    
    EXEC pr_ins_upd_conc @l_id, 'INS', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''    
  
    FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg ,@cp_ph1, @cp_ph2, @cp_fax, @cp_email 
  --    
  END    
      
      
  CLOSE      @c_entm_conc    
  DEALLOCATE @c_entm_conc   
    
--  
END

GO
