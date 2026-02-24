-- Object: PROCEDURE citrus_usr.pr_import_cm_converter
-- Server: 10.253.33.227 | DB: DMAT
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
CREATE PROCEDURE  [citrus_usr].[pr_import_cm_converter]( @pa_exch          VARCHAR(20)    
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
  
  declare @pa_task_id numeric
  ,@l_cnt varchar(8000)
  
  select @pa_task_id=task_id from filetask where status='running' and task_name like '%member%'

  

 	IF  @PA_MODE ='BULK'  and  citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') not like 'mbr_mstr_%'
		BEGIN 
				UPDATE FILETASK
				SET    USERMSG = 'ERROR : File is not proper.Please Check.', STATUS ='FAILED',TASK_END_DATE = GETDATE()
				WHERE  TASK_ID = @PA_TASK_ID
				
				return
		END 




  IF @pa_mode = 'BULK'  
  BEGIN  
  --  
  
       declare @@l_count integer  
       delete from [MBR_MSTR_Converter]  
  
       DECLARE @@ssql varchar(8000)  
       SET @@ssql ='BULK INSERT [MBR_MSTR_Converter] from ''' + @pa_db_source + ''' WITH   
      ( 
						FIELDQUOTE = ''"''
						, FIELDTERMINATOR = '',''
						, ROWTERMINATOR = ''\n''
					
						,FORMAT=''CSV''
						,FIRSTROW = 2 

)'  
       EXEC(@@ssql)  
       

	  -- insert into MBR_MSTR_Converter_log 
			--select * , getdate() from MBR_MSTR_Converter 


      -- DELETE FROM  tmp_bp_source WHERE LEFT(VALUE,2) = '01'

       
       --update MBR_MSTR_Converter set value = ltrim(rtrim(value))   
    
       select @@l_count = count(*) from MBR_MSTR_Converter   
  
     
       TRUNCATE TABLE tmp_bp_mstr  
         
     
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
			    select  DPID
					 ,isnull(case when len(DpTypBpRl.CDSL_Old_Value)=1 then '0' + convert(varchar,DpTypBpRl.CDSL_Old_Value) else  DpTypBpRl.CDSL_Old_Value  end ,'0')
					 ,isnull(ADDR1,'') ADDR1 
					 ,isnull(ADDR2,'') ADDR2
					 ,isnull(ADDR3,'') ADDR3 
					 ,isnull(CITY ,'') + ' '+isnull(STATE,'')+ ' '+ isnull(CNTRY,'')   ADDR4
					 
					  ,isnull(PSTCD,'') 
					 ,isnull(PHNENB1,'') 
					 ,isnull(FAXNB,'') 
					 ,isnull(CLRSYSID,'') 
					 ,isnull(ASSCTDDPID,'') 
					,isnull(ASSCTDCCCMID,'') 
					 ,isnull(case when len(MbrAcctTyp.CDSL_Old_Value)=1 then '0' + convert(varchar,MbrAcctTyp.CDSL_Old_Value) else  MbrAcctTyp.CDSL_Old_Value  end ,'0')
					 ,isnull(DPNM,'') DPNM 
					  ,isnull(MbrStat.CDSL_Old_Value,'0')
				FROM  MBR_MSTR_Converter     left outer join 
			    Harm_source_cdsl  DpTypBpRl on DpTypBpRl.Standard_Value = dptyp and  DpTypBpRl.Field_Description ='DP Type / BP Role'
				 left outer join 
			    Harm_source_cdsl MbrStat  on MbrStat.Standard_Value = STATUS and  MbrStat.Field_Description ='Member Status / BP Status'
					 left outer join 
			    Harm_source_cdsl MbrAcctTyp on MbrAcctTyp.Standard_Value = DPACCTNGTYP and  MbrAcctTyp.Field_Description ='Member Accounting Type / Business Category'
				where isnull (dptyp,'') <> 'DF'
				

				--return   

        
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
  AND    tmpbp_role      IN('02')  --'01','05',
  
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
  AND   tmpbp_role IN ('02')  --'01','05',
  AND   bitrm_parent_cd = 'ACCESS1'
  AND   bitrm_child_cd = excsm_exch_cd + '_' + excsm_seg_cd + '_' + excsm_seg_cd + '_' + convert(varchar,excsm_compm_id)
  AND   power(2,bitrm_bit_location-1) = ccm_excsm_bit
    
    
  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT entm_short_name FROM entity_mstr)  AND  tmpbp_role IN ('01','02')   
      
  
      
  SELECT @l_entm_id_old  = bitrm_bit_location    
  FROM   bitmap_ref_mstr    WITH(NOLOCK)    
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
       
  UPDATE bitmap_ref_mstr        
  SET    bitrm_bit_location = bitrm_bit_location + @l_count  + 1   
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
    
    
  INSERT INTO #temp_sh_name SELECT distinct tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('02')   --'01',
    
     
      
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
  ,case when tmpbp_role = '01' then '02' when tmpbp_role ='02' then '02'  else 'SR' end  
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
  and  ccm_cd = tmpbp_ass_cc_id --and tmpbp_id='IN546884'
  AND   CONVERT(varchar,isnull(tmpbp_id,'')) NOT IN (select CONVERT(varchar,isnull(entm_short_name,'')) from entity_mstr)  
  AND   tmpbp_role IN ('02')  --'01','05',
  AND   bitrm_parent_cd = 'ACCESS1'
  AND   bitrm_child_cd = excsm_exch_cd + '_' + excsm_seg_cd + '_' + excsm_seg_cd + '_' + convert(varchar,excsm_compm_id)
  AND   power(2,bitrm_bit_location-1) = ccm_excsm_bit
  

  SELECT @l_count = COUNT(*) from tmp_bp_mstr WHERE tmpbp_id NOT IN(SELECT entm_short_name FROM entity_mstr)  AND  tmpbp_role IN ('04')   
      
  
      
  SELECT @l_entm_id_old  = bitrm_bit_location    
  FROM   bitmap_ref_mstr    WITH(NOLOCK)    
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
       
  UPDATE bitmap_ref_mstr        
  SET    bitrm_bit_location = bitrm_bit_location + @l_count    + 1 
  WHERE  bitrm_parent_cd = 'ENTITY_ID'    
  AND    bitrm_child_cd  = 'ENTITY_ID'    
    
    
  --INSERT INTO #temp_sh_name1 SELECT distinct tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('04')   
   
  --SELECT IDENTITY(INT, 1, 1) ID1, sh_name INTO #tmp_identity_bpm1 FROM #temp_sh_name1  

   SELECT distinct TMPBP_BP_NM sh_name, TMPBP_ID TMPRTA_ID  INTO #tmp_identity_rta_pre  FROM tmp_bp_mstr WHERE  tmpbp_role IN ('04') 
  
  SELECT IDENTITY(INT, 1, 1) ID1, sh_name , TMPRTA_ID rta_id INTO #tmp_identity_rta FROM #tmp_identity_rta_pre
  
  
    
  
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
  SELECT 
   ID1 + @l_entm_id_old 
  ,convert(varchar(100),TMPBP_BP_NM)
  ,convert(varchar(50),'')
  ,convert(varchar(50),'')
  ,'RTA_'+CONVERT(VARCHAR,TMPBP_ID)
  ,'RTA'
  ,'NRM'
  ,NULL
  ,''
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1   
  FROM  #tmp_identity_rta  
      , tmp_bp_mstr  
  WHERE sh_name = TMPBP_BP_NM and rta_id = TMPBP_ID
  AND   'RTA_'+CONVERT(VARCHAR,TMPBP_ID) not IN (select CONVERT(varchar,entm_short_name) from entity_mstr)  
    and      tmpbp_role IN ('04')  
  
  --select * from entity_mstr where entm_short_name ='IN440702'
  
      SET    @c_entm_adr =  CURSOR fast_forward FOR    
  SELECT entm_id  
       , TMPBP_ADD_L1 tmprta_add1
							, TMPBP_ADD_L2 tmprta_add2
							,TMPBP_ADD_L3  tmprta_add3
							,TMPBP_ADD_L4  tmprta_city
							,'' tmprta_state
							, '' tmprta_country
							, TMPBP_ADD_PC tmprta_zip 
  FROM   entity_mstr  
       , tmp_bp_mstr   
  WHERE  entm_short_name = 'RTA_'+CONVERT(VARCHAR,TMPBP_ID)
  and    tmpbp_role IN ('04')  
    
  OPEN @c_entm_adr    
  FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
    
  WHILE @@fetch_status = 0    
  BEGIN    
  --    
      
    SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_adr3,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + isnull(@l_cntry,'') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*' 
    
    EXEC pr_ins_upd_addr @l_id, 'EDT', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''    
      
    FETCH NEXT FROM @c_entm_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip   
  --    
  END    
   
  
  CLOSE      @c_entm_adr    
  DEALLOCATE @c_entm_adr    
    
    
  SET    @c_entm_conc =  CURSOR fast_forward FOR    
  SELECT entm_id  
       , TMPBP_PH_NO tmprta_ph1
							,'' tmprta_ph2
							,TMPBP_FAX_NO	tmprta_fax
       ,'' tmprta_email
  FROM   entity_mstr
       , tmp_bp_mstr   
  WHERE   entm_short_name = 'RTA_'+CONVERT(VARCHAR,TMPBP_ID)
 and    tmpbp_role IN ('04')  
  
  OPEN @c_entm_conc    
  FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email  
  
  WHILE @@fetch_status = 0    
  BEGIN    
  --    

    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*'  
    print @l_values 
	print @l_id 
	  print '04_conc'
    EXEC pr_ins_upd_conc @l_id, 'EDT', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''    
  
    FETCH NEXT FROM @c_entm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email
  --    
  END    
      
      
  CLOSE      @c_entm_conc    
  DEALLOCATE @c_entm_conc   


--declare @c_entm_entp cursor
--declare @l_id1 numeric
--,@L_ENTP_VALUE varchar(8000)
--  SET    @c_entm_entp =  CURSOR fast_forward FOR        
--   SELECT entm_id  
--    FROM   entity_mstr
--       , TMP_BP_MSTR   
--  WHERE  entm_short_name = 'RTA_'+CONVERT(VARCHAR,TMPBP_ID)

-- OPEN @c_entm_entp    
--  FETCH NEXT FROM @c_entm_entp INTO @l_id1 

--  WHILE @@fetch_status = 0        
--  BEGIN        
--  --    
           
--    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|'   
--                                  + ISNULL(TMPRTA_OPT_CONTACT_NAME,'') + '|*~|*|~*'   
--    FROM TMP_BP_MSTR, ENTITY_PROPERTY_MSTR, ENTITY_MSTR   WHERE entm_short_name = 'RTA_'+CONVERT(VARCHAR,TMPRTA_ID)  
--    and entm_id = @l_id1 AND  entpm_CD   = 'CONTACT_PERSON'  
--    AND ISNULL(TMPRTA_OPT_CONTACT_NAME,'') <> ''  

--    print @L_ENTP_VALUE

--    EXEC pr_ins_upd_entp '1','EDT','MIG',@l_id1,'',@L_ENTP_VALUE,'',0,'*|~*','|*~|',''    
      
--    FETCH NEXT FROM @c_entm_entp INTO @l_id1   
--  --        
--  END        
          
       
--  CLOSE      @c_entm_entp       
--  DEALLOCATE @c_entm_entp    
      
  drop table #tmp_identity_bpm       
    /*Dp master harmon pr_import_dpm*/

	truncate table tmp_dp_mstr 
	--alter table tmp_dp_mstr alter column tmpdp_first_nm varchar(250)
	insert into tmp_dp_mstr(tmpdp_type
							,tmpdp_id
							,tmpdp_first_nm
							,tmpdp_addr1
							,tmpdp_addr2
							,tmpdp_addr3
							,tmpdp_city
							,tmpdp_state
							,tmpdp_country
							,tmpdp_zip
							,tmpdp_phone1
							,tmpdp_phone2
							,tmpdp_fax
							,tmpdp_email)
							select case when DPTYP = 'CM' then '2'
							when DPTYP = 'DP' then '3' 
							when DPTYP = 'CU'  then '6' end , dpid,dpnm, addr1,addr2,addr3,city,state,cntry, pstcd,PHNENB1,	PHNENB2,	FAXNB,	EMAIL

							from MBR_MSTR_Converter  where DPTYP in ('CM','DP','CU' )
	   
  UPDATE dp_mstr   
  SET    dpm_name       = tmpdp_first_nm
       , dpm_lst_upd_dt = getdate()
       , dpm_lst_upd_by = @pa_login_name
		FROM   tmp_dp_mstr  
  WHERE  '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id))) = dpm_dpid 
  and ltrim(rtrim(isnull(tmpdp_first_nm,''))) <> ''
    
   
   declare  @l_exch_id      NUMERIC 
    , @l_dpm_id_old  INTEGER  

  SELECT IDENTITY(INT, 1, 1) ID1, '1' + tmpdp_type + convert(varchar,ltrim(rtrim(tmpdp_id))) dpm_dpid 
  INTO #tmp_identity_dpm FROM tmp_dp_mstr  where tmpdp_type IN ('2','3','6')  and '1' + ltrim(rtrim(tmpdp_type)) + convert(varchar,tmpdp_id)  NOT IN(SELECT dpm_dpid FROM dp_mstr)  
    
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
       
	    DECLARE @c_dpm_adr     CURSOR  
  DECLARE @c_dpm_conc    CURSOR  


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
    
    EXEC pr_ins_upd_addr @l_id, 'EDT', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''    
      
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
    
	print @l_values 
	print @l_id 
	  print '04_conc'


    EXEC pr_ins_upd_conc @l_id, 'EDT', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''    
  
    FETCH NEXT FROM @c_dpm_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email
  --    
  END    
      
      
  CLOSE      @c_dpm_conc    
  DEALLOCATE @c_dpm_conc   
	/**/
    
    
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
  
  INSERT INTO #temp_cc_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('01')   
  
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
  AND   tmpbp_role IN ('01')  
  
    
    
  INSERT INTO #temp_cc_name SELECT tmpbp_id FROM tmp_bp_mstr WHERE  tmpbp_role IN ('01')  
   

   --select @l_cnt = isnull(replace(citrus_usr.fn_merge_str_newvalidation('BP',0,''),',',''),'')

   -- IF @l_cnt  <> ''
			--	BEGIN
			--	--
			--			UPDATE filetask
			--			SET     usermsg =  convert(varchar(100),@l_cnt) ,
			--			 STATUS = 'COMPLETED' 
			--			WHERE  task_id = @pa_task_id

			--			return

			--	--
			--	END
   
--    
END

GO
