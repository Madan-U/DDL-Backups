-- Object: PROCEDURE citrus_usr.pr_import_bpm_bak_28032015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SELECT COUNT(*) FROM ENTITY_MSTR --8575
--create table tmp_bp_source(value varchar(8000))  
--select count(*) from entity_mstr--554  
--begin transaction  
--select * from tmp_bp_mstr where tmpbp_role      IN('01','05')--10805  
--rollback transaction  
--pr_import_bpm 'nsdl','MIG','BULK','D:\BULKINSDBFOLDER\BP MASTER\10000000004579_BP_MAST_20110506181509_F_DONE.txt','*|~*','|*~|',''  
--
--select * from entity_mstr where entm_enttm_cd = 'CLM'  
create PROCEDURE  [citrus_usr].[pr_import_bpm_bak_28032015]( @pa_exch          VARCHAR(20)    
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
 MODULE NAME    : Pr_UPD_Entm    
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
  
       declare @@l_count integer  
       delete from tmp_bp_source  
  
       DECLARE @@ssql varchar(8000)  
       SET @@ssql ='BULK INSERT tmp_bp_source from ''' + @pa_db_source + ''' WITH   
       (  
           FIELDTERMINATOR = ''\n'',  
           ROWTERMINATOR = ''\n''  
  
       )'  
  
       EXEC(@@ssql)  
       

       DELETE FROM  tmp_bp_source WHERE LEFT(VALUE,2) = '01'

       
       update tmp_bp_source set value = ltrim(rtrim(value))   
    
       select @@l_count = count(*) from tmp_bp_source   
  
     
       TRUNCATE TABLE tmp_bp_mstr  

       if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd='NEWVER_FLG'  and BITRM_BIT_LOCATION='1')
       begin
       insert into tmp_bp_mstr  
       (TMPBP_ID  
       ,TMPBP_ROLE  
       ,TMPBP_ADD_L1  
       ,TMPBP_ADD_L2  
       ,TMPBP_ADD_L3  
       ,TMPBP_ADD_L4  
       ,TMPBP_ADD_PC  
       ,TMPBP_PH_NO  
       ,TMPBP_FAX_NO  
       ,TMPBP_ASS_CC_ID  
       ,TMPBP_ASS_DP_ID  
       ,TMPBP_ASS_CC_CM_ID  
       ,TMPBP_BP_CAT  
       ,TMPBP_BP_NM  
       ,TMPBP_BP_STAT  
       )  
       select substring(value,10,8)  
             ,substring(value,18,2)  
             ,substring(value,20,36)  
             ,substring(value,56,36)  
             ,substring(value,92,36)  
             ,substring(value,128,36)  
             ,substring(value,164,7)  
             ,substring(value,171,24)  
             ,substring(value,195,24)  
             ,substring(value,219,8)  
             ,substring(value,227,8)  
             ,substring(value,235,16)  
             ,substring(value,251,2)   
             ,substring(value,253,135)  
             ,substring(value,388,2)  
        FROM  tmp_bp_source     
        where isnumeric(substring(value,18,2))<> 0  
        end
        else
        begin
				insert into tmp_bp_mstr  
			   (TMPBP_ID  
			   ,TMPBP_ROLE  
			   ,TMPBP_ADD_L1  
			   ,TMPBP_ADD_L2  
			   ,TMPBP_ADD_L3  
			   ,TMPBP_ADD_L4  
			   ,TMPBP_ADD_PC  
			   ,TMPBP_PH_NO  
			   ,TMPBP_FAX_NO  
			   ,TMPBP_ASS_CC_ID  
			   ,TMPBP_ASS_DP_ID  
			   ,TMPBP_ASS_CC_CM_ID  
			   ,TMPBP_BP_CAT  
			   ,TMPBP_BP_NM  
			   ,TMPBP_BP_STAT  
			   )  
			   select substring(value,10,8)  
					 ,substring(value,18,2)  
					 ,substring(value,20,50)  
					 ,substring(value,70,50)  
					 ,substring(value,120,36)  
					 ,substring(value,156,36)  
					 ,substring(value,192,7)  
					 ,substring(value,199,24)  
					 ,substring(value,223,24)  
					 ,substring(value,247,8)  
					 ,substring(value,255,8)  
					 ,substring(value,263,16)  
					 ,substring(value,279,2)   
					 ,substring(value,281,140)  
					 ,substring(value,421,2)  
				FROM  tmp_bp_source     
				where isnumeric(substring(value,18,2))<> 0   

        end
  --  
  END  
     
     
  CREATE TABLE #temp_sh_name(sh_name VARCHAR(150))   
  CREATE TABLE #temp_dp_name(dp_name VARCHAR(150))   
  CREATE TABLE #temp_cc_name(cc_name VARCHAR(150))   
  CREATE TABLE #temp_sh_name1(sh_name VARCHAR(150))     
    
  DECLARE @c_entm_adr     CURSOR    
  DECLARE @c_entm_conc    CURSOR    
  DECLARE @c_dp_adr     CURSOR    
  DECLARE @c_dp_conc    CURSOR    
  DECLARE @c_access_cursor CURSOR  
    
  DECLARE @l_id           NUMERIC    
        , @l_count        NUMERIC    
        , @l_entm_id_old  INTEGER    
        , @l_dp_id_old  INTEGER    
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
        , @l_conname      VARCHAR(25)    
        , @l_condesg      VARCHAR(25)    
        , @l_access       INT  
        , @l_access1       INT  
        , @l_excsm_id     VARCHAr(25)  
    
    
    
  UPDATE entity_mstr     
  SET    entm_name1      = tmpbp_bp_nm  
       , entm_lst_upd_dt = getdate()  
       , entm_lst_upd_by = @pa_login_name  
  FROM   tmp_bp_mstr    
  WHERE  tmpbp_id        = entm_short_name  
  AND    tmpbp_role      IN('03')  --'01','05',
  
  UPDATE entity_mstr     
		SET    entm_name2      = tmpbp_bp_nm  
		FROM   tmp_bp_mstr    
		   				, cc_mstr 
		   				, exchange_mstr
		   				, exch_seg_mstr
         , bitmap_ref_mstr 
  WHERE tmpbp_id        = entm_short_name  
  AND   excsm_exch_cd = excm_cd
  and   ccm_cd = tmpbp_ass_cc_id
  AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
  AND   tmpbp_role IN ('03')  --'01','05',
  AND   bitrm_parent_cd = 'ACCESS1'
  AND   bitrm_child_cd = excsm_exch_cd + '_' + excsm_seg_cd + '_' + excsm_seg_cd + '_' + convert(varchar,excsm_compm_id)
  AND   power(2,bitrm_bit_location-1) = ccm_excsm_bit
    
    
  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT entm_short_name FROM entity_mstr)  AND  tmpbp_role IN ('01','03')   
      
  
      
  SELECT @l_entm_id_old  = bitrm_bit_location    
  FROM   bitmap_ref_mstr    WITH(NOLOCK)    
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
       
  UPDATE bitmap_ref_mstr        
  SET    bitrm_bit_location = bitrm_bit_location + @l_count  + 1   
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
    
    
  INSERT INTO #temp_sh_name SELECT distinct tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('03')   --'01',
    
    
      
  SELECT IDENTITY(INT, 1, 1) ID1, sh_name INTO #tmp_identity_bpm FROM #temp_sh_name  
    
  
  
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
  SELECT ID1 + @l_entm_id_old   
  ,convert(varchar(100),tmpbp_bp_nm)  
  ,isnull(excm_id,'') 
  ,TMPBP_ASS_DP_ID
  ,convert(varchar(50),tmpbp_id)  
  ,case when tmpbp_role = '01' then '03' when tmpbp_role ='03' then '03'  else 'SR' end  
  ,'NRM'  
  ,null  
  ,''  
  ,@pa_login_name    
  ,getdate()    
  ,@pa_login_name    
  ,getdate()    
  ,1     
  FROM  #tmp_identity_bpm    
       ,tmp_bp_mstr    
						, cc_mstr 
						, exchange_mstr
						, exch_seg_mstr
      , bitmap_ref_mstr 
  WHERE sh_name = tmpbp_id  
  AND   excsm_exch_cd = excm_cd
  and  ccm_cd = tmpbp_ass_cc_id
  AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
  AND   tmpbp_role IN ('03')  --'01','05',
  AND   bitrm_parent_cd = 'ACCESS1'
  AND   bitrm_child_cd = excsm_exch_cd + '_' + excsm_seg_cd + '_' + excsm_seg_cd + '_' + convert(varchar,excsm_compm_id)
  AND   power(2,bitrm_bit_location-1) = ccm_excsm_bit
  

  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT entm_short_name FROM entity_mstr)  AND  tmpbp_role IN ('05','04')   
      
  
      
  SELECT @l_entm_id_old  = bitrm_bit_location    
  FROM   bitmap_ref_mstr    WITH(NOLOCK)    
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
       
  UPDATE bitmap_ref_mstr        
  SET    bitrm_bit_location = bitrm_bit_location + @l_count    + 1 
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
    
    
  INSERT INTO #temp_sh_name1 SELECT distinct tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('05','04')   
    
    
      
  SELECT IDENTITY(INT, 1, 1) ID1, sh_name INTO #tmp_identity_bpm1 FROM #temp_sh_name1  
    
  
  --SELECT ID1 + @l_entm_id_old   
  --,convert(varchar(100),tmpbp_bp_nm)  
  --,''
  --,''
  --,convert(varchar(50),TMPBP_ID)  
  --,'SR'
  --,'NRM'  
  --,null  
  --,''  
  --,@pa_login_name    
  --,getdate()    
  --,@pa_login_name    
  --,getdate()    
  --,1     
  --FROM  #tmp_identity_bpm1    
  --     ,tmp_bp_mstr    
  --WHERE sh_name = tmpbp_id  
  --AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
  --AND   tmpbp_role IN ('05')  
  
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
  SELECT ID1 + @l_entm_id_old   
  ,convert(varchar(100),tmpbp_bp_nm)  
  ,''
  ,''
  ,convert(varchar(50),TMPBP_ID)  
  ,'SR'
  ,'NRM'  
  ,null  
  ,''  
  ,@pa_login_name    
  ,getdate()    
  ,@pa_login_name    
  ,getdate()    
  ,1     
  FROM  #tmp_identity_bpm1    
       ,tmp_bp_mstr    
  WHERE sh_name = tmpbp_id  
  AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
  AND   tmpbp_role IN ('05','04')  
  
  --select * from entity_mstr where entm_short_name ='IN440702'
  
       
         
  SET    @c_entm_adr =  CURSOR fast_forward FOR      
  SELECT entm_id    
       , tmpbp_add_l1  
       , tmpbp_add_l2  
       , tmpbp_add_l3  
       , tmpbp_add_l4  
       , tmpbp_add_pc  
  FROM   entity_mstr    
       , tmp_bp_mstr     
  WHERE  entm_short_name = tmpbp_id  
      
  OPEN @c_entm_adr      
  FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2,  @l_city,@l_state, @l_zip     
      
  WHILE @@fetch_status = 0      
  BEGIN      
  --      
        
    SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL('','') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL('','') + '|*~|' + isnull('','') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*'   
      
    EXEC pr_ins_upd_addr @l_id, 'INS', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''      
       
    FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2,  @l_city,@l_state, @l_zip     
  --      
  END      
     
    
  CLOSE      @c_entm_adr      
  DEALLOCATE @c_entm_adr      
      
      
  SET    @c_entm_conc =  CURSOR fast_forward FOR      
  SELECT entm_id    
       , tmpbp_ph_no  
       , tmpbp_fax_no  
  
  FROM   entity_mstr  
       , tmp_bp_mstr     
  WHERE  entm_short_name = tmpbp_id  
    
  OPEN @c_entm_conc      
  FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_fax  
    
  WHILE @@fetch_status = 0      
  BEGIN      
  --      
    
    --SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*'    
    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') + '|*~|*|~*'    
      
    EXEC pr_ins_upd_conc @l_id, 'INS', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''      
    
    FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_fax  
  --      
  END      
        
     
  CLOSE      @c_entm_conc      
  DEALLOCATE @c_entm_conc     
    
    
      
  drop table #tmp_identity_bpm       
    
  INSERT INTO #temp_sh_name SELECT tmpbp_bp_nm FROM tmp_bp_mstr WHERE  tmpbp_role IN ('04','05')   
  -----dp_mstr   
  UPDATE dp_mstr  
  SET    dpm_name         = tmpbp_bp_nm  
       , dpm_lst_upd_dt  = getdate()  
       , dpm_lst_upd_by  = @pa_login_name  
  FROM   tmp_bp_mstr    
  WHERE  tmpbp_id         = dpm_dpid  
  AND    tmpbp_role      IN('01')  -- '04'
  
  
  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT dpm_dpid FROM dp_mstr)    
  
  
  SELECT @l_dp_id_old  = bitrm_bit_location    
  FROM   bitmap_ref_mstr    WITH(NOLOCK)    
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
  
  UPDATE bitmap_ref_mstr        
  SET    bitrm_bit_location = bitrm_bit_location + @l_count     + 1
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
  
  INSERT INTO #temp_dp_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('01')    ---- '04'
  
  
  
  SELECT IDENTITY(INT, 1, 1) ID1, dp_name INTO #tmp_identity_dp_name FROM #temp_dp_name  
  
  select top 1 @l_excsm_id = excsm_id from exch_seg_mstr where excsm_deleted_ind  = 1 and excsm_exch_cd = 'NSDL' order by 1   
  
  INSERT INTO dp_mstr  
  (dpm_id  
  ,dpm_excsm_id  
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
  SELECT ID1 + @l_dp_id_old   
  ,@l_excsm_id  
  ,tmpbp_id  
  ,tmpbp_id  
  ,tmpbp_bp_nm  
  ,''  
  ,@pa_login_name    
  ,getdate()    
  ,@pa_login_name    
  ,getdate()    
  ,1     
  FROM  #tmp_identity_dp_name    
      , tmp_bp_mstr    
  WHERE dp_name = tmpbp_id  
  AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,dpm_dpid) from dp_mstr)  
  AND   tmpbp_role IN ('01')  ---- '04'
  
  
  
  
  ----------SET    @c_dp_adr =  CURSOR fast_forward FOR      
  ----------SELECT dpm_id    
  ----------     , tmpbp_add_l1  
  ----------     , tmpbp_add_l2  
  ----------     , tmpbp_add_l3  
  ----------     , tmpbp_add_l4  
  ----------     , tmpbp_add_pc  
  ----------FROM   dp_mstr    
  ----------     , tmp_bp_mstr     
  ----------WHERE  dpm_dpid  = tmpbp_id  
  
  ----------OPEN @c_dp_adr      
  ----------FETCH NEXT FROM @c_dp_adr INTO @l_id ,@l_adr1, @l_adr2,  @l_city,@l_state, @l_zip     
  
  ----------WHILE @@fetch_status = 0      
  ----------BEGIN      
  ------------      
  
  ----------  SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL('','') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL('','') + '|*~|' + isnull('','') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*'   
  
  ----------  EXEC pr_ins_upd_addr @l_id, 'INS', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''      
  
  ----------  FETCH NEXT FROM @c_dp_adr INTO @l_id ,@l_adr1, @l_adr2,  @l_city,@l_state, @l_zip     
  ------------      
  ----------END      
  
  
  ----------CLOSE      @c_dp_adr      
  ----------DEALLOCATE @c_dp_adr      
  
  
  ----------SET    @c_dp_conc =  CURSOR fast_forward FOR      
  ----------SELECT dpm_id    
  ----------     , tmpbp_ph_no  
  ----------     , tmpbp_fax_no  
  
  ----------FROM   dp_mstr    
  ----------     , tmp_bp_mstr     
  ----------WHERE  dpm_dpid  = tmpbp_id  
  
  ----------OPEN @c_dp_conc      
  ----------FETCH NEXT FROM @c_dp_conc INTO @l_id ,@l_ph1, @l_fax  
  
  ----------WHILE @@fetch_status = 0      
  ----------BEGIN      
  ------------      
  
  ----------  --SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*'    
  ----------  SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') + '|*~|*|~*'    
  
  ----------  EXEC pr_ins_upd_conc @l_id, 'INS', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''      
  
  ----------  FETCH NEXT FROM @c_dp_conc INTO @l_id ,@l_ph1, @l_fax  
  ------------      
  ----------END      
  
  
  ----------CLOSE      @c_dp_conc      
  ----------DEALLOCATE @c_dp_conc     
  
  
  
     
  
  INSERT INTO #temp_dp_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('04')   
    
  --cc_mstr  
    
  /*UPDATE cc_mstr  
  SET    ccm_name         = tmpbp_bp_nm  
       , ccm_lst_upd_dt  = getdate()  
       , ccm_lst_upd_by  = @pa_login_name  
  FROM   tmp_cc_mstr    
  WHERE  tmpbp_id         = dpm_dpid  
  AND    tmpbp_role      IN('04')*/  
    
    
  SET    @c_access_cursor =  CURSOR fast_forward FOR  
  SELECT  bitrm_bit_location  
  FROM   Exch_Seg_Mstr  
       , exchange_mstr  
       , bitmap_ref_mstr  
       , file_lookup_mstr   
       , tmp_bp_mstr  
  WHERE  excm_cd           = excsm_exch_cd  
  AND    excsm_desc        = bitrm_child_cd  
  AND    fillm_file_value  = tmpbp_BP_nm  
  AND    fillm_db_value    = excsm_exch_cd  
  AND    excsm_deleted_ind = 1  
  AND    excm_deleted_ind  = 1  
  
        OPEN @c_access_cursor  
  FETCH NEXT FROM @c_access_cursor INTO @l_access   
  
  WHILE @@fetch_status = 0  
  BEGIN  
  --  
    SET @l_access1 = POWER(2,@l_access-1) | @l_access1  
  
    FETCH NEXT FROM @c_access_cursor INTO @l_access  
  --  
  END  
  
  CLOSE      @c_access_cursor  
  DEALLOCATE @c_access_cursor  
          
          
  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT ccM_cd FROM cc_mstr)    
  select @l_dp_id_old = max(CCM_ID) from cc_mstr   
  
  INSERT INTO #temp_cc_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('02')   
  
  SELECT IDENTITY(INT, 1, 1) ID1 , cc_name INTO #tmp_identity_cc_name FROM #temp_cc_name  
  
  INSERT INTO cc_mstr  
  (ccm_id  
  ,ccm_cd  
  ,ccm_name  
  ,ccm_excsm_bit  
  ,ccm_created_by  
  ,ccm_created_dt  
  ,ccm_lst_upd_by  
  ,ccm_lst_upd_dt  
  ,ccm_deleted_ind  
  )    
  SELECT ID1 + @l_dp_id_old   
  ,tmpbp_id  
  ,tmpbp_bp_nm  
        ,@l_access1  
  ,@pa_login_name    
  ,getdate()    
  ,@pa_login_name    
  ,getdate()    
  ,1     
  FROM  #tmp_identity_cc_name    
      , tmp_bp_mstr    
  WHERE cc_name = tmpbp_id  
  AND   CONVERT(varchar,tmpbp_id) NOT IN (select CONVERT(varchar,ccm_cd) from cc_mstr)  
  AND   tmpbp_role IN ('02')  
  
    
    
  INSERT INTO #temp_cc_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('02')  
    
--    
END

GO
