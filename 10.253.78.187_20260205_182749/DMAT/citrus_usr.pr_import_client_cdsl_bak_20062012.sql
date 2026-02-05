-- Object: PROCEDURE citrus_usr.pr_import_client_cdsl_bak_20062012
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran
--exec pr_import_client_cdsl 'CDSL','HO','normal','','*|~*','|*~|',''  
--select * from dp_holder_dtls order by 1 desc
--pr_delete_client 146380  
--begin transaction  
--[pr_import_client_cdsl] 'CDSL','HO','normal','','*|~*','|*~|',''  
--SELECT * FROM DP_CLIENT_SUMMARY where isnull(bank_micr,'') = ''  
--select distinct entpm_cd  from entity_property_mstr  
--SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL  
--select * from account_properties order by 1 desc  
--select * from dp_acct_mstr order  by 1 desc   
--select * from client_bank_accts order  by 2 desc   
--COMMIT transaction  
--rollback   
--|*~||*~||*~|10000158|*~|SHYLA  V MRS|*~||*~|ACTIVE|*~|02|*~|01|*~|0101|*~|0|*~|A|*~|*|~*  
create PROCEDURE  [citrus_usr].[pr_import_client_cdsl_bak_20062012]
			(
			 @pa_exch          VARCHAR(20)    
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
 MODULE NAME    : p  
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables    
 COPYRIGHT(C)   : Marketplace Technologies     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            08-OCT-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
--  
set nocount ON  
  
 

 declare @c_client_summary cursor  
           , @c_ben_acct_no    VARCHAR(16)  
           , @L_CLIENT_VALUES  VARCHAR(8000)  
           , @l_crn_no numeric  
           , @l_dpm_dpid varchar(20)  
           , @l_compm_id numeric  
           , @l_dp_acct_values varchar(8000)  
           , @l_excsm_id numeric  
           , @L_ADR varchar(8000)  
           , @L_CONC varchar(8000)  
           , @l_br_sh_name varchar(50)  
           , @l_entr_value varchar(8000)  
           , @l_dpba_values varchar(8000)  
           , @l_entp_value varchar(8000)  
           , @c_cx_panno  varchar(50)  
           , @l_entpd_value varchar(8000)  
           , @L_ACCP_VALUE  VARCHAR(8000)  
           , @L_ACCPD_VALUE  VARCHAR(8000)  
           , @L_DPAM_ID NUMERIC  
           , @L_BANK_NAME VARCHAR(150)  
           , @L_ADDR_VALUE VARCHAR(8000)  
           , @L_BANM_BRANCH VARCHAR(250)  
           , @L_MICR_NO VARCHAR(20)  
           , @L_BANM_ID NUMERIC  
           , @L_acc_conc VARCHAR(8000)   
           , @l_cli_exists_yn char(1)  
		   , @@BOCTGRY VARCHAR(10)  
		   , @@ho_cd varchar(20)  
		   , @l_dppd_details varchar(8000)  
		  
       
  select top 1 @@ho_cd = ltrim(rtrim(isnull(entm_short_name,'HO'))) from entity_mstr where entm_enttm_cd = 'HO'  
                         
  IF @pa_mode = 'BULK'  
  BEGIN  
  --
  
       truncate table TMP_CLIENT_DTLS_MSTR_CDSL  
  
        DECLARE @@ssql varchar(8000)  
        SET @@ssql ='BULK INSERT CITRUS_USR.TMP_CLIENT_DTLS_MSTR_CDSL  from ''' + @pa_db_source + ''' WITH   
        (  
           FIELDTERMINATOR = ''~'',  
           ROWTERMINATOR = ''\n''  
        )'  
  
        EXEC(@@ssql)  
         
         
 --  
  END        
         
     INSERT INTO [TMP_POA_DTLS_MSTR_CDSL]  
     SELECT  * FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_CUST_PROD_NO IN ('48','49')  
--   return -- did by latesh on mar 13 2012 to get client data in temp table , need to remove on mar 14 2012

     DELETE FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_CUST_PROD_NO IN ('48','49')  
       
       
     IF EXISTS(SELECT BITRM_ID FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD = 'POA_CLIENT_IMPORT_YN' AND BITRM_BIT_LOCATION = 1)  
     BEGIN
        
          update clim  
          set clim_name1 = case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'1')   
                                       else LTRIM(RTRIM(dpam_sba_name))  end  
             ,clim_name2 =  case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'2')  
                                       else '' end  
             ,clim_name3 =  case when dpam_clicm_cd in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(DPAM_SBA_NAME)),'3')  
                                       else '.' end   
             ,clim_dob = convert(datetime,TMPCLI_BO_DOB,103)  
             ,clim_gender = TMPCLI_BO_SEX  
          from  client_mstr CLIM  
               ,dp_acct_mstr ,TMP_CLIENT_DTLS_MSTR_CDSL  
          where  dpam_sba_no =  TMPCLI_BOID  
          and    clim_crn_no =  dpam_crn_no   
  
  
			Update dpam 
			set    dpam_stam_cd = case when TMPCLI_ACCT_STAT = '01' or TMPCLI_ACCT_STAT = 'ACTIVE' then 'ACTIVE' 
							   when TMPCLI_ACCT_STAT = 'CLOSED' then '05' 
                               when TMPCLI_ACCT_STAT = 'To Be Closed' then '04' 
   							when TMPCLI_ACCT_STAT in('REQUESTED FOR CLOSUR','REQUESTED FOR CLOSURE') then 'CLOS' 
								else TMPCLI_ACCT_STAT end
			,DPAM_CLICM_CD = citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_BO_STAT,''),'CLICM')
			,DPAM_ENTTM_cD = citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_ACCT_CTRGY,''),'enttm')
			,DPAM_SUBCM_CD = citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_BO_SUB_STAT,''),'SUBCM')
            ,dpam_lst_upd_dt = getdate()
			from   dp_acct_mstr dpam
			, TMP_CLIENT_DTLS_MSTR_CDSL
			where  dpam_sba_no =  TMPCLI_BOID and  dpam_stam_cd <> '02_BILLSTOP'

                   
  
  
          update dphd  
          set    DPHD_FH_FTHNAME  = isnull(ltrim(rtrim(TMPCLI_FRST_HLDR_FATH_HUSB_NM)),'')   
                , DPHD_SH_FNAME   = CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),1)  
                , DPHD_SH_MNAME   = CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),2)  
                , DPHD_SH_LNAME   = CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),3)  
                ,DPHD_SH_PAN_NO  = isnull(ltrim(rtrim(TMPCLI_SND_HLDR_PAN_N0)),'')  
                ,DPHD_TH_FNAME   =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),1)  
                ,DPHD_TH_MNAME   =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),2)  
                ,DPHD_TH_LNAME   =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),3)  
                ,DPHD_TH_PAN_NO  = isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_PAN_N0)),'')  
--                ,DPHD_NOM_FNAME  =  citrus_usr.fn_splitval_by(replace(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),' ','|'),1,'|')  
--                ,DPHD_NOM_mNAME  =  citrus_usr.fn_splitval_by(replace(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),' ','|'),2,'|')  
--                ,DPHD_NOM_lNAME  =  citrus_usr.fn_splitval_by(replace(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),' ','|'),3,'|')  
				,DPHD_NOM_FNAME  =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),1)  
                ,DPHD_NOM_mNAME  =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),2)  
                ,DPHD_NOM_lNAME  =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),3) 
				,DPHD_NOM_DOB = CONVERT(DATETIME,TMPCLI_DOB_MINOR_DT,103)
               ,dphd_nomgau_fname = case when PURPOSE_CD = '8' then CITRUS_USR.inside_trim(isnull(ltrim(rtrim(HLDR_NAME)),''),1) else '' end
				,dphd_nomgau_mname = case when PURPOSE_CD = '8' then CITRUS_USR.inside_trim(isnull(ltrim(rtrim(HLDR_NAME)),''),2) else '' end
				,dphd_nomgau_lname = case when PURPOSE_CD = '8' then CITRUS_USR.inside_trim(isnull(ltrim(rtrim(HLDR_NAME)),''),3) else '' end
                ,dphd_lst_upd_dt = getdate()
          from dp_holder_dtls dphd  
          ,    dp_acct_mstr   
          ,    TMP_CLIENT_DTLS_MSTR_CDSL  
		  ,    TMP_CDSL_AUTH_SIGNATORY
          where dphd_dpam_sba_no  = dpam_sba_no 
		  and   BO_ID = TMPCLI_BOID 
          and   dphd_dpam_id = dpam_id   
          and   TMPCLI_BOID = dpam_sba_no 
                

          declare @c_client_summary1  cursor  
                 ,@c_ben_acct_no1  varchar(20)  
  
                 set @c_client_summary1  = CURSOR fast_forward FOR                
                 select TMPCLI_BOID    from TMP_CLIENT_DTLS_MSTR_CDSL   
                 where TMPCLI_BOID in (select dpam_sba_no from dp_Acct_mstr) and TMPCLI_ACCT_STAT <> '10'  
          
          open @c_client_summary1  
          
          fetch next from @c_client_summary1 into @c_ben_acct_no1   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor                                                                                                          
        --  
          select @l_crn_no = clim_crn_no from client_mstr,  DP_ACCT_MSTR where DPAM_CRN_NO = CLIM_CRN_NO AND DPAM_SBA_NO =  @c_ben_acct_no1  
  
     
          SET @L_ACCP_VALUE = ''  
          SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_SEBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_CM_ID)),'')) + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'CMBP_ID'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','GROUP_CD',upper(ISNULL(LTRIM(RTRIM(TMPCLI_GROUP_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'group_cd'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + case when upper(ISNULL(LTRIM(RTRIM(TMPCLI_ELECTRONOC_DIV)),''))='Y' then '1' else '0' end  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'ECS_FLG'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','BANKCCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BENF_ACCT_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'BANKCCY'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','DIVBANKCCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_ACCT_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','DIVIDEND_CURRENCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_TAX_DEDUC_STAT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_ACCT_OPNG_DT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'BILL_START_DT'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_CLO_APP_DT)),''))  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'ACC_CLOSE_DT'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + case when upper(ISNULL(LTRIM(RTRIM(TMPCLI_PURC_WAIVER)),''))='Y' then '1' else '0' end  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'CONFIRMATION'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','BOSTMNTCYCLE',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BO_STMT_CYL_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
          SET @L_accpd_VALUE = ''  
  
          SELECT DISTINCT @L_accpd_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + RIGHT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),4)  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND ACCPM_PROP_CD = 'RBI_REF_NO' AND ACCDM_CD = 'RBI_APP_DT' AND ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID  
  
            
          SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  TMP_CLIENT_DTLS_MSTR_CDSL WHERE DPAM_SBA_NO = TMPCLI_BOID  AND TMPCLI_BOID  = @c_ben_acct_no1  
            
          EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,@L_accpd_VALUE ,0,'*|~*','|*~|',''  
                                                     
          --account_properties  
  
          --entity_properties  
              
         
          SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO'  
                             
          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','NATIONALITY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BO_NATIONALITY)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'NATIONALITY'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','OCCUPATION',upper(ISNULL(LTRIM(RTRIM(TMPCLI_PROFESSION_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'OCCUPATION'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','GEOGRAPHICAL',upper(ISNULL(LTRIM(RTRIM(TMPCLI_GEO_AREA_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'GEOGRAPHICAL'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','EDUCATION',upper(ISNULL(LTRIM(RTRIM(TMPCLI_EDU_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'EDUCATION'  
          --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_TAX_DEDUC_STAT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'TAX_DEDUCTION'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','LANGUAGE',upper(ISNULL(LTRIM(RTRIM(TMPCLI_LANG_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'LANGUAGE'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CASE WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'N' THEN 'NONE'   
                                                                                                        WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'R' THEN 'RELATIVE'  
                                                                                                        WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'STAFF'  
          SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','ANNUAL_INCOME',upper(ISNULL(LTRIM(RTRIM(TMPCLI_INCOME_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no1 AND entpm_CD   = 'ANNUAL_INCOME'  
                             
          SET @L_ENTPD_VALUE = ''  
          --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID  
                              
                  
	
                             
            
           
  
           EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''    
  
						

           UPDATE ENTP SET ENTP_VALUE = TMPCLI_FRST_HLDR_PAN_N0 FROM   
           ENTITY_PROPERTIES ENTP   
         , DP_ACCT_MSTR   
         , TMP_CLIENT_DTLS_MSTR_CDSL   
           WHERE DPAM_CRN_NO = ENTP_ENT_ID   
           AND DPAM_SBA_NO = TMPCLI_BOID   
           AND DPAM_SBA_NO =  @c_ben_acct_no1   
           AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_DELETED_IND = 1  
			
			             
             

           UPDATE accp SET accp_VALUE = TMPCLI_ACCT_OPNG_DT FROM   
           account_properties accp   
         , DP_ACCT_MSTR   
         , TMP_CLIENT_DTLS_MSTR_CDSL   
           WHERE DPAM_id = accp_clisba_id  
           AND DPAM_SBA_NO = TMPCLI_BOID   
           AND DPAM_SBA_NO =  @c_ben_acct_no1   
           AND accp_accpm_prop_cd = 'BILL_START_DT' AND accp_DELETED_IND = 1  

			 
             
           UPDATE accp SET accp_VALUE = TMPCLI_ACCT_CLO_SUSP_DT FROM   
           account_properties accp   
         , DP_ACCT_MSTR   
         , TMP_CLIENT_DTLS_MSTR_CDSL   
           WHERE DPAM_id = accp_clisba_id  
           AND DPAM_SBA_NO = TMPCLI_BOID   
           AND DPAM_SBA_NO =  @c_ben_acct_no1   
           AND accp_accpm_prop_cd = 'ACC_CLOSE_DT' AND accp_DELETED_IND = 1  
           AND isnull(TMPCLI_ACCT_CLO_SUSP_DT,'') <> '' 

			  
  
           SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN1)),'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN_1)),'') <> ''  
  
           EXEC pr_ins_upd_addr @l_crn_no,'EDT','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''   
     --addresses  
        
--      EXEC pr_reset_bill_printing @c_ben_acct_no1  
                          
      --contact channels  
        
           SELECT @L_CONC = 'OFF_PH1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
		   +'MOBILE1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
		   +'OFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'
		   +'FAX1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_FAX_NO)),'')
		   +'*|~*'+'FAX2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1  
             
  
           SELECT @L_CONC = isnull(@L_CONC,'') + 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_EMAIL_ID)),'')+'*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1  
			 
  
           EXEC pr_ins_upd_conc @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
  
  
  
           set @L_CONC  = ''  
           SET @L_ADR  = ''  
           SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and isnull(TMPCLI_BO_ADDP_LIN1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and isnull(TMPCLI_BO_ADD_LIN_1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'NOMINEE_ADR1|*~|' +ISNULL(ltrim(rtrim(TMPCLI_NOMI_ADD_LN123)),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(citrus_usr.fn_splitval_by(replace(TMPCLI_NOMI_CITY_STATE_CNTRY,' ','|'),1,'|'))),'')+'|*~|'+ISNULL(citrus_usr.fn_splitval_by(replace(TMPCLI_NOMI_CITY_STATE_CNTRY,' ','|'),2,'|'),'')+'|*~|'+ISNULL(citrus_usr.fn_splitval_by(replace(TMPCLI_NOMI_CITY_STATE_CNTRY,' ','|'),3,'|'),'')+'|*~|'+ISNULL(ltrim(rtrim(citrus_usr.fn_splitval_by(replace(TMPCLI_NOMI_CITY_STATE_CNTRY,' ','|'),4,'|'))),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and isnull(TMPCLI_NOMI_ADD_LN123,'') <> ''  
                           
                            
        
           EXEC  pr_dp_ins_upd_addr @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ADR,0,'*|~*','|*~|',''   
                            
                           
           set @L_ADR   = ''  
  
           SET @L_acc_conc = ''  
  
                 SELECT @L_acc_conc = 'ACCOFF_PH1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'+'ACCOFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'   FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and isnull(TMPCLI_BO_ADDP_LIN1,'') <> ''  
                  
                   
  
                 --EXEC  pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''   
                 set @L_acc_conc = ''  
                  
  
  
                 SELECT @L_BANK_NAME = ltrim(rtrim(TMPCLI_BANK_NM))   
                      , @L_BANM_BRANCH = ltrim(rtrim(TMPCLI_BANK_ADD_LN1)) + '('+ ltrim(rtrim(TMPCLI_BANK_ADD_PIN)) +')'  
                      ,@L_MICR_NO = TMPCLI_BANK_CD   
                 FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1  
   
                             
                 IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO)  
                  BEGIN  

				 

                     SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO  
                    
                    
                  END  
                  ELSE   
                  BEGIN  
				 
          
                    EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,'','','',0,0,'',0,'','*|~*','|*~|',''  
                    SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO  
                    
                    
                  END  
                         

--if not exists (Select cliba_clisba_id from client_bank_accts cliba, dp_acct_mstr ,TMP_CLIENT_DTLS_MSTR_CDSL  where cliba_clisba_id = dpam_id   and  TMPCLI_BOID = dpam_sba_no and  TMPCLI_BOID = @c_ben_acct_no1)
--begin
--  select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)
--            select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
--         select @l_crn_no = dpam_crn_no from dp_acct_mstr,  TMP_CLIENT_DTLS_MSTR_CDSL  where dpam_sba_no  =  tmpcli_boid and tmpcli_boid = @c_ben_acct_no1  
-- 
--  print @c_ben_acct_no1
-- -- print TMPCLI_FRST_HLDR_NM
--
--         select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no1)) +'|*~|' + LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+ case when TMPCLI_BENF_BANK_ACCT_TYP = '10' then 'SAVINGS' when TMPCLI_BENF_BANK_ACCT_TYP = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + convert(varchar,LTRIM(RTRIM(TMPCLI_BANK_ACCT_N0))) + '|*~|1|*~|0|*~|A*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL where TMPCLI_BOID = @c_ben_acct_no1  
--  print @l_dpba_values
--  print 'dn'
--        exec pr_ins_upd_dpba '0','INS','MIG',@l_crn_no,@l_dpba_values,0,'*|~*','|*~|',''  
-- end 
                   update cliba  
                   set    CLIBA_AC_NO   = TMPCLI_BANK_ACCT_N0  
                   ,      cliba_banm_id = @L_BANM_ID  ,CLIBA_AC_TYPE =  case when TMPCLI_BENF_BANK_ACCT_TYP = '10' then 'SAVINGS' when TMPCLI_BENF_BANK_ACCT_TYP = '11' then 'CURRENT' else 'OTHERS' end
                   ,      cliba_lst_upd_dt = getdate()
                   from client_bank_accts cliba  
                   ,    dp_acct_mstr   
                   ,     TMP_CLIENT_DTLS_MSTR_CDSL   
                
                   where cliba_clisba_id = dpam_id   
                   and   TMPCLI_BOID = dpam_sba_no   
                   and  TMPCLI_BOID = @c_ben_acct_no1   
  
  
  
                     
if not exists(select dppd_id from dp_poa_dtls , TMP_CLIENT_DTLS_MSTR_CDSL 
, dp_acct_mstr 
where dpam_id = dppd_dpam_id 
and TMPCLI_BOID = dpam_sba_no 
and dpam_sba_no = @c_ben_acct_no1
and DPPD_FNAME =  TMPCLI_POA_NM
)  
  
begin  
   

 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)
  
 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
  
 select distinct @l_crn_no = clim_crn_no from client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1   
  
 SET @l_dppd_details = ''  
  
 SELECT @l_dppd_details = isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ ISNULL(ltrim(rtrim('1ST HOLDER')),'') +'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_NM)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_ID)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_TYPE)),'')  
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_SETUP_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_SETUP_DT,103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_POA_START_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_POA_START_DT,103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_POA_END_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_POA_END_DT,103),103) ELSE '' END   
  
 +'|*~|'+ltrim(rtrim(poam_master_id))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
  
 FROM TMP_CLIENT_DTLS_MSTR_CDSL , poa_mstr WHERE ltrim(rtrim(poam_name1)) = ltrim(rtrim(TMPCLI_POA_NM)) and  tmpcli_boid = @c_ben_acct_no1 AND TMPCLI_POA_ID <>''   
  
 
  EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
  
end   

if not exists(select dppd_id from dp_poa_dtls , TMP_CDSL_AUTH_SIGNATORY , dp_acct_mstr 
              where dpam_id = dppd_dpam_id and BO_ID = dpam_sba_no and dpam_sba_no = @c_ben_acct_no1 
              --and dppd_poa_type = 'AUTHORISED SIGNATORY'
              and DPPD_FNAME =  HLDR_NAME)  
  
begin  
   

 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)
  
 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
  
 select distinct @l_crn_no = clim_crn_no from client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1   
  print 'start'
print @l_dpm_dpid 
print @l_excsm_id
print @l_compm_id
print @l_crn_no 


 SET @l_dppd_details = ''


 
  
 SELECT @l_dppd_details = isnull(@l_dppd_details,'') + isnull(convert(varchar,@l_compm_id),'')+'|*~|'
+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'
+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'
+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
+'|*~|'+ ISNULL(ltrim(rtrim('1ST HOLDER')),'') +'|*~|'
+ISNULL(ltrim(rtrim(HLDR_NAME)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')
+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('0')),'')
+'|*~|'+ISNULL(ltrim(rtrim('AUTHORISED SIGNATORY')),'')  
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,HLDR_SETUP_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,HLDR_SETUP_DT,103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,'',103))= 1 THEN convert(varchar,CONVERT(datetime,'',103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,'',103))= 1 THEN convert(varchar,CONVERT(datetime,'',103),103) ELSE '' END   
  
 +'|*~|'+ltrim(rtrim('0'))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
  
 FROM TMP_CDSL_AUTH_SIGNATORY where BO_ID = @c_ben_acct_no1 AND PURPOSE_CD = '18'
  

 EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
  
end   

  
   
  
        
  
  
                   fetch next from @c_client_summary1 into @c_ben_acct_no1   
                     
                     
                 --  
                 end  
      
                 close @c_client_summary1    
                 deallocate  @c_client_summary1    
  
                   
  
                            update cliba  
                            set    CLIBA_AC_NO   = TMPCLI_BANK_ACCT_N0  
                            ,      cliba_banm_id = BANM_ID  
                            from client_bank_accts cliba  
                            ,    dp_acct_mstr   
                           ,     TMP_CLIENT_DTLS_MSTR_CDSL   
                            ,    BANK_MSTR   
                            where cliba_clisba_id = dpam_id   
                            AND   cliba_banm_id   = banm_id  
                            and   TMPCLI_BOID = dpam_sba_no AND  
                            (   BANM_NAME = ltrim(rtrim(TMPCLI_BANK_NM))   
                            AND   BANM_BRANCH =  ltrim(rtrim(TMPCLI_BANK_ADD_LN1)) + '('+ ltrim(rtrim(TMPCLI_BANK_ADD_PIN)) +')'   
                            ) and banm_micr = TMPCLI_BANK_CD  
  
  
                            
                                 
          
     
         print 'fdsfsdfdsfsdfs'
                          
        set @c_client_summary  = CURSOR fast_forward FOR                
        select TMPCLI_BOID  from TMP_CLIENT_DTLS_MSTR_CDSL where TMPCLI_BOID not in (select dpam_sba_no from dp_Acct_mstr) 
          
        select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
        where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  
		and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)

        select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
                    
  PRINT 'JITESH'
          
        open @c_client_summary  
          
        fetch next from @c_client_summary into @c_ben_acct_no   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor                                                                                                          
        --  
   
           SELECT @@BOCTGRY = citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_BO_STAT,''),'clicm') FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE  TMPCLI_BOID = @c_ben_acct_no  
            
             
           --SELECT  @L_CLIENT_VALUES = ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_NM)),'') + '|*~|' + '|*~||*~|'+ ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_NM)),'') + '|*~|'+ISNULL(TMPCLI_BO_SEX,'')+'|*~|'+ISNULL(TMPCLI_BO_DOB,'')+'|*~||*~|ACTIVE|*~||*~|1|*~|' + ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_PAN_N0)),'') +'|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE  TMPCLI_BOID = @c_ben_acct_no  
  
  
           SELECT  @L_CLIENT_VALUES = ISNULL(ltrim(rtrim(case when @@BOCTGRY in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'1') else LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) end)),'') + '|*~|' + ISNULL(case when @@BOCTGRY in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'2') else '' end,'') + '|*~|' + ISNULL(case when @@BOCTGRY in ('21' , '24' , '27') then CITRUS_USR.inside_trim(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'3') else '.' end,'') + '|*~|'+ LEFT(ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_NM)),'')+'-'+right(TMPCLI_BOID,8),200) + '|*~|'+ISNULL(TMPCLI_BO_SEX,'')+'|*~|'+CASE WHEN isdate(CONVERT(datetime,TMPCLI_BO_DOB,103)) = 1 THEN  ISNULL(TMPCLI_BO_DOB,'') ELSE '' END +'|*~||*~|ACTIVE|*~||*~|1|*~|' + ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_PAN_N0)),'') +'|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE  TMPCLI_BOID = @c_ben_acct_no  
  
                              
--           IF NOT EXISTS(SELECT entp_ent_id FROM client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1 and ltrim(rtrim(TMPCLI_FRST_HLDR_PAN_N0)) not in ('','N.A.'))  
--           begin  
--
--			print 'jit1' 
--
--           set @l_cli_exists_yn = 'N'  
--           end  
--           else  
--           begin  
--           set @l_cli_exists_yn = 'Y'  
--           end  
  
--           IF NOT EXISTS(SELECT entp_ent_id FROM client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1 and ltrim(rtrim(TMPCLI_FRST_HLDR_PAN_N0)) not in ('','N.A.'))  
--           begin  
			
			print 'jit2'
			 print @L_CLIENT_VALUES
			
            EXEC pr_ins_upd_clim  '0','INS','MIG',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''  
            select distinct @l_crn_no = clim_crn_no from client_mstr, TMP_CLIENT_DTLS_MSTR_CDSL 
			WHERE  TMPCLI_BOID = @c_ben_acct_no 
			and clim_short_name =  LEFT(ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_NM)),'')+'-'+right(TMPCLI_BOID,8),200)        
--           end  
--           else  
--           begin  
--            select distinct @l_crn_no = clim_crn_no from client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL  WHERE  TMPCLI_BOID = @c_ben_acct_no AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 
--AND entp_deleted_ind = 1                      
--           end  
  
  
      --addresses  
           SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+ '|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_BO_ADDP_LIN1,'') <>''  
           SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE ,'') + '|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_BO_ADD_LIN_1,'') <>''  
  
                            
                            
         
--           if @l_cli_exists_yn = 'N'  
--           begin  
           EXEC pr_ins_upd_addr @l_crn_no,'INS','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''   
           --end  
      --addresses  
        
  
      --contact channels  
        
         
           SELECT @L_CONC = 'OFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
							 +'MOBILE1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
							+'OFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'
                           +'FAX1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAX_NO)),'')+'*|~*'+'FAX2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
                           +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_EMAIL_ID)),'')+'*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
          
         
  
--           if @l_cli_exists_yn = 'N'  
--           begin  
             EXEC pr_ins_upd_conc @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
        --   end  
      --contact channels  
                           
        
      --dp_acct_mstr  
                          --select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'  
                          --select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
           select @l_dp_acct_values = isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_FRST_HLDR_NM)),'')+'|*~|'+ ISNULL(ltrim(rtrim(TMPCLI_DP_INTREF_NO)),'') +'|*~|'+case when TMPCLI_ACCT_STAT = '01' or TMPCLI_ACCT_STAT = 'ACTIVE' then 'ACTIVE' 
		   when TMPCLI_ACCT_STAT = 'CLOSED' then '05' 
		   when TMPCLI_ACCT_STAT in('REQUESTED FOR CLOSUR','REQUESTED FOR CLOSURE') then 'CLOS' 
		   when TMPCLI_ACCT_STAT = 'To Be Closed' then '04'  else TMPCLI_ACCT_STAT end+'|*~|'+citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_ACCT_CTRGY,''),'enttm') + '|*~|' + citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(TMPCLI_BO_STAT,''),'clicm')+'|*~|'+citrus_usr.cdsl_ctgry_enttm_subcm_mapping (isnull(ltrim(rtrim(TMPCLI_BO_SUB_STAT)),''),'subcm')+'|*~|0|*~|A|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE  tmpcli_boid = @c_ben_acct_no   
             
            PRINT 'JITESH2'
			PRINT @l_dp_acct_values
			PRINT @l_crn_no
            exec pr_ins_upd_dpam @l_crn_no,'INS','MIG',@l_crn_no,@l_dp_acct_values,0,'*|~*','|*~|',''  
             
          
      --dp_acct_mstr  
           SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADDP_CNTRY)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_BO_ADDP_LIN1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_BO_ADD_LIN_1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'NOMINEE_ADR1|*~|' +ISNULL(ltrim(rtrim(TMPCLI_NOMI_ADD_LN123)),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_NOMI_CITY_STATE_CNTRY)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_NOMI_ADD_LN123,'') <> ''  
                           
                            
           EXEC  pr_dp_ins_upd_addr @l_crn_no,'EDT','MIG',0,@c_ben_acct_no,'dp',@L_ADR,0,'*|~*','|*~|',''   
  
           set @L_ADR   = ''  
          
           SELECT @L_acc_conc = 'ACCOFF_PH1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'+'ACCOFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'   FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no and isnull(TMPCLI_BO_ADDP_LIN1,'') <> ''  
                           
                            
         
           --EXEC  pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''   
  
           set @L_acc_conc = ''  
                            
      --dp_holder_dtls/addresses/conctact_channels  
           declare @pa_fh_dtls varchar(8000)  
                  ,@pa_sh_dtls varchar(8000)  
                  ,@pa_th_dtls varchar(8000)  
                  ,@pa_nomgau_dtls varchar(8000)  
                  ,@pa_nom_dtls varchar(8000)  
                  ,@pa_gau_dtls varchar(8000)  
  
           select @pa_fh_dtls = ''+'|*~|'+''+'|*~|'+''+'|*~|'+isnull(ltrim(rtrim(TMPCLI_FRST_HLDR_FATH_HUSB_NM)),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
           select @pa_sh_dtls =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),1)+'|*~|'+isnull(CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),2),'')+'|*~|'+isnull(CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_SND_HLDR_NM)),''),3),'')+'|*~|'+isnull(ltrim(rtrim('')),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(TMPCLI_SND_HLDR_PAN_N0)),'')+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
           select @pa_th_dtls =  CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),1)+'|*~|'+isnull(CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),2),'')+'|*~|'+isnull(CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_NM)),''),3),'')+'|*~|'+isnull(ltrim(rtrim('')),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(TMPCLI_THRD_HLDR_PAN_N0)),'')+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no   
           select @pa_nomgau_dtls = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no   
           select @pa_nom_dtls = CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),1)+'|*~|'+CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),2)+'|*~|'+CITRUS_USR.inside_trim(isnull(ltrim(rtrim(TMPCLI_NOMI_NM)),''),3)+'|*~|'+'|*~|'+ convert(varchar(11),CONVERT(DATETIME,TMPCLI_DOB_MINOR_DT,103),103)+'|*~|'+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no   
           select @pa_gau_dtls = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
  
           exec pr_ins_upd_dphd '0',@l_crn_no,@c_ben_acct_no,'INS','HO',@pa_fh_dtls,@pa_sh_dtls,@pa_th_dtls,@pa_nomgau_dtls,@pa_nom_dtls,@pa_gau_dtls,0,'*|~*','|*~|',''               
  
           
      --dp_holder_dtls/addresses/conctact_channels  
  
                        -- entity_relationship    
                          -- select @l_br_sh_name  = entm_short_name from entity_mstr ,DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and entm_short_name = br_cd  
            DECLARE @l_activation_dt varchar(20)  
            select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
			where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)
            select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
            SELECT @l_activation_dt = TMPCLI_ACCT_OPNG_DT FROM TMP_CLIENT_DTLS_MSTR_CDSL tcdmc WHERE TMPCLI_BOID = @c_ben_acct_no  
  
  
            select @l_entr_value = convert(varchar,ISNULL(@l_compm_id,0))+'|*~|'+convert(varchar,ISNULL(@l_excsm_id,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@c_ben_acct_no,'')+'|*~|'+CONVERT(varchar,@l_activation_dt)+'|*~|HO|*~|' + @@ho_cd + '|*~|RE|*~||*~|AR|*~||*~|BR|*~|'+ '|*~|SB|*~||*~|RM_BR|*~||*~|FM|*~||*~|SBFR|*~||*~|INT|*~||*~|A*|~*'  
  
            exec pr_ins_upd_dpentr '0','','HO',@l_crn_no,@l_entr_value ,0,'*|~* ','|*~|',''  
         -- entity_relationship   
            SET @l_activation_dt = ''  
  --brokerage
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
						   where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)

                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           

							declare @l_brom_id varchar(100), @l_brkg_val varchar(1000)
							set @l_brom_id  = ''
                            SELECT @l_activation_dt = TMPCLI_ACCT_OPNG_DT FROM TMP_CLIENT_DTLS_MSTR_CDSL tcdmc WHERE TMPCLI_BOID = @c_ben_acct_no and TMPCLI_ACCT_OPNG_DT <> ''  
                            select @l_brom_id = brom_id from brokerage_mstr where BROM_DESC = 'GENERAL'
                            set @l_brkg_val = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|' + @l_activation_dt+'|*~|'+ @l_brom_id +'|*~|A*|~*'
		
							if @l_brom_id  <> ''
							exec pr_ins_upd_client_brkg @l_crn_no,'','MIG',@L_crn_no,@l_brkg_val,0,'*|~*','|*~|',''
                        --brokerage
      --bank_mstr/addresses/conctact_channels  
            SELECT @L_BANK_NAME = ltrim(rtrim(TMPCLI_BANK_NM)) , @L_BANM_BRANCH = ltrim(rtrim(TMPCLI_BANK_ADD_LN1)) + '('+ ltrim(rtrim(TMPCLI_BANK_ADD_PIN)) +')'  FROM TMP_CLIENT_DTLS_MSTR_CDSL   where TMPCLI_BOID = @c_ben_acct_no  
  
  
            SELECT @L_MICR_NO = TMPCLI_BANK_CD FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
  
            SELECT @L_ADDR_VALUE = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_CITY)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_STATE)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_CNTRY)),'')+'|*~|'+'*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
  
             set @L_BANM_ID = 0  
             IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO)  
             BEGIN  
                SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO  
             END  
             ELSE   
             BEGIN  
                
               EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,'','','',0,0,'',0,'','*|~*','|*~|',''  
                 
                
               SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO  
             END  
                              
  
  
    
  
  
        --pr_mak_banm   
      --bank_mstr/addresses/conctact_channels  
              select @l_crn_no = dpam_crn_no from dp_acct_mstr,  TMP_CLIENT_DTLS_MSTR_CDSL  
			where dpam_sba_no  =  tmpcli_boid and tmpcli_boid = @c_ben_acct_no  
         --select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no1)) +'|*~|' + LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+case when TMPCLI_BENF_BANK_ACCT_TYP = '10' then 'SAVINGS' when TMPCLI_BENF_BANK_ACCT_TYP = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + LTRIM(RTRIM(TMPCLI_BANK_ACCT_N0)) + '|*~|1|*~|0|*~|A*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL where TMPCLI_BOID = @c_ben_acct_no1 
		select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|' + LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+ case when TMPCLI_BENF_BANK_ACCT_TYP = '10' then 'SAVINGS' when TMPCLI_BENF_BANK_ACCT_TYP = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + convert(varchar,LTRIM(RTRIM(TMPCLI_BANK_ACCT_N0))) + '|*~|1|*~|0|*~|A*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL where TMPCLI_BOID = @c_ben_acct_no  

       exec pr_ins_upd_dpba '0','INS','MIG',@l_crn_no,@l_dpba_values,0,'*|~*','|*~|',''  
      --client_bank_accts  
                              
 
      --client_bank_accts */  
  
      --account_properties  
         SET @L_ACCP_VALUE = ''  
         SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_SEBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_CM_ID)),'')) + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD  = 'CMBP_ID'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
		 SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_TRADING_ID)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BBO_CODE'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','GROUP_CD',upper(ISNULL(LTRIM(RTRIM(TMPCLI_GROUP_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'group_cd'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + case when upper(ISNULL(LTRIM(RTRIM(TMPCLI_ELECTRONOC_CONFIR)),''))='Y' then '1' else '0' end  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD  = 'ELEC_CONF'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','BANKCCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BENF_ACCT_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BANKCCY'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','DIVBANKCCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_ACCT_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','DIVIDEND_CURRENCY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_CURR)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  


            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_ACCT_OPNG_DT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BILL_START_DT'  
          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_CLO_APP_DT)),''))  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'ACC_CLOSE_DT'  

                                    SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_TAX_DEDUC_STAT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
  
         SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + case when upper(ISNULL(LTRIM(RTRIM(TMPCLI_PURC_WAIVER)),''))='Y' then '1' else '0' end  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'CONFIRMATION'  
                                                    
        SELECT DISTINCT @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','BOSTMNTCYCLE',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BO_STMT_CYL_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
        SET @L_accpd_VALUE = ''  
        SELECT DISTINCT @L_accpd_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + RIGHT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),4)  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD = 'RBI_REF_NO' AND ACCDM_CD = 'RBI_APP_DT' AND ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID  
        AND isdate(RIGHT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_APP_DT)),''),4)) = 1          
  
        SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  TMP_CLIENT_DTLS_MSTR_CDSL WHERE DPAM_SBA_NO = TMPCLI_BOID  AND TMPCLI_BOID  = @c_ben_acct_no  
  
        EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no,'DP',@L_ACCP_value,@L_accpd_VALUE ,0,'*|~*','|*~|',''  
                                     
      --account_properties  
  
      --entity_properties  
  
         
        SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO'  
                             
        SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','NATIONALITY',upper(ISNULL(LTRIM(RTRIM(TMPCLI_BO_NATIONALITY)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'NATIONALITY'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','OCCUPATION',upper(ISNULL(LTRIM(RTRIM(TMPCLI_PROFESSION_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'OCCUPATION'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','GEOGRAPHICAL',upper(ISNULL(LTRIM(RTRIM(TMPCLI_GEO_AREA_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'GEOGRAPHICAL'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','EDUCATION',upper(ISNULL(LTRIM(RTRIM(TMPCLI_EDU_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'EDUCATION'  
          
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','LANGUAGE',upper(ISNULL(LTRIM(RTRIM(TMPCLI_LANG_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'LANGUAGE'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CASE WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'N' THEN 'NONE'   
                                                                                                      WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'R' THEN 'RELATIVE'  
                                                                                                      WHEN upper(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'STAFF'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper([citrus_usr].[fn_reverse_mapping]('CDSL','ANNUAL_INCOME',upper(ISNULL(LTRIM(RTRIM(TMPCLI_INCOME_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND entpm_CD   = 'ANNUAL_INCOME'  
                             
        SET @L_ENTPD_VALUE = ''  
                           --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID  
                              
  
  
         
         EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''    
           
         SET @l_dppd_details = ''  
         SELECT @l_dppd_details =   isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ ISNULL(ltrim(rtrim('1ST HOLDER')),'') +'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_NM)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_ID)),'')+'|*~|'+ISNULL(ltrim(rtrim(TMPCLI_POA_TYPE)),'')  
         +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_SETUP_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_SETUP_DT,103),103) ELSE '' END   
         +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_POA_START_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_POA_START_DT,103),103) ELSE '' END   
         +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,TMPCLI_POA_END_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,TMPCLI_POA_END_DT,103),103) ELSE '' END   
         +'|*~|'+ltrim(rtrim(poam_master_id))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
         FROM TMP_CLIENT_DTLS_MSTR_CDSL , poa_mstr WHERE  ltrim(rtrim(poam_name1)) = ltrim(rtrim(TMPCLI_POA_NM)) and tmpcli_boid = @c_ben_acct_no  AND TMPCLI_POA_ID <>''   
           
         
           
         EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
  
         update dp_acct_mstr set dpam_batch_no =1 where dpam_batch_no is null and dpam_sba_no = @c_ben_acct_no and dpam_deleted_ind = 1  
               
      fetch next from @c_client_summary into @c_ben_acct_no   
    --  
    END  
                        
       CLOSE        @c_client_summary  
    DEALLOCATE   @c_client_summary  
      
     END  
       
   
    SELECT IDENTITY(int,1,1) id1 , * INTO #tmp FROM TMP_POA_DTLS_MSTR_CDSL tpdmc   
      
    DECLARE @L_DPM_ID NUMERIC  
    select @L_DPM_ID = DPM_ID from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  
                   
                   
    DECLARE @l_poam_id numeric  
    SELECT @l_poam_id = ISNULL(max(poam_id),0)+ 1 FROM poa_mstr 

 
      
    INSERT INTO poa_mstr  
    (  
     poam_id,  
     POAM_DPM_ID,  
     poam_ctgry,  
     poam_product_cd,  
     poam_name1,  
     poam_name2,  
     poam_name3,  
     poam_title,  
     poam_suffix,  
     poam_fth_name,  
     poam_adr1,  
     poam_adr2,  
     poam_adr3,  
     poam_city,  
     poam_state,  
     poam_country,  
     poam_zip,  
     poam_ph1,  
     poam_ph2,  
     poam_fax,  
     poam_pan_no,  
     poam_it_circle,  
     poam_email,  
     poam_Date_Of_Maturity,  
     poam_dob,  
     poam_sex,  
     poam_Occupation,  
     poam_Life_Style,  
     poam_Geo_Cd,  
     poam_Edu,  
     poam_Anninc,  
     paom_nationality,  
     poam_leg_status_cd,  
     poam_Lan_Cd,  
     poam_Staff,  
     poam_BO_Ctgry,  
     poam_BO_Sett_Plflg,  
     poam_RBI_Ref_No,  
     poam_RBI_App_Dt,  
     poam_SEBI_Regini,  
     poam_Tax_Dedu_status,  
     poam_Smart_Card_no,  
     poam_Smart_Card_pin,  
     poam_ECS,  
     poam_ElecConf,  
     poam_Dividend_Curr,  
     poam_Group_Code,  
     poam_BOSubStatus,  
     poam_CC_ID,  
     poam_cm_id,  
     poam_stock_exch,  
     poam_Conf_Waived,  
     poam_Trading_ID,  
     poam_BO_stm_Cycle_Cd,  
     poam_created_by,  
     poam_created_dt,  
     poam_lst_upd_by,  
     poam_lst_upd_dt,  
     poam_deleted_ind,  
     poam_batch_no,  
     poam_master_id  
    )  
    SELECT id1 + @l_poam_id  
    ,@L_DPM_ID  
    ,tpdmc.TMPCLI_ACCT_CTRGY  
    ,tpdmc.TMPCLI_CUST_PROD_NO  
    ,tpdmc.TMPCLI_FRST_HLDR_NM  
    ,''  
    ,''  
    ,''  
    ,''  
    ,tpdmc.TMPCLI_FRST_HLDR_FATH_HUSB_NM  
    ,tpdmc.TMPCLI_BO_ADD_LIN_1  
    ,tpdmc.TMPCLI_BO_ADD_LIN2  
    ,tpdmc.TMPCLI_BO_ADD_LIN3  
    ,tpdmc.TMPCLI_BO_ADD_CITY  
    ,tpdmc.TMPCLI_BO_ADD_STATE  
    ,tpdmc.TMPCLI_BO_ADD_CNTRY  
    ,tpdmc.TMPCLI_BO_ADD_PIN  
    ,tpdmc.TMPCLI_BO_TELPH_NO  
    ,tpdmc.TMPCLI_BO_TELPHP_NO  
    ,tpdmc.TMPCLI_BO_FAX_NO  
    ,tpdmc.TMPCLI_FRST_HLDR_PAN_N0  
    ,''  
    ,tpdmc.TMPCLI_EMAIL_ID  
    ,''  
  ,tpdmc.TMPCLI_BO_DOB  
    ,tpdmc.TMPCLI_BO_SEX  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','OCCUPATION',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_PROFESSION_CD)),''))))  
    ,''  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','GEOGRAPHICAL',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_GEO_AREA_CD)),''))))  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','EDUCATION',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_EDU_CD)),''))))  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','ANNUAL_INCOME',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_INCOME_CD)),''))))  
    , upper([citrus_usr].[fn_reverse_mapping]('CDSL','NATIONALITY',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_BO_NATIONALITY)),''))))   
    ,''  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','LANGUAGE',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_LANG_CD)),''))))  
    ,LEFT(tpdmc.TMPCLI_STAFF_RELATIVE_DP,1)  
    ,tpdmc.TMPCLI_BO_STAT  
    ,''  
    ,tpdmc.TMPCLI_RBI_REGI_NO  
    ,tpdmc.TMPCLI_RBI_APP_DT  
    ,tpdmc.TMPCLI_SEBI_REGI_NO  
    ,tpdmc.TMPCLI_TAX_DEDUC_STAT  
    ,''  
    ,''  
    ,''  
    ,case when upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_ELECTRONOC_CONFIR)),''))='Y' then '1' else '0' end  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','DIVIDEND_CURRENCY',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_DIVIDEND_CURR)),''))))  
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','GROUP_CD',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_GROUP_CD)),''))))   
    ,tpdmc.TMPCLI_BO_SUB_STAT  
    ,CASE WHEN tpdmc.TMPCLI_CC_ID = '' THEN '0' END   
    ,CASE WHEN tpdmc.TMPCLI_CM_ID = '' THEN '0' END    
    ,tpdmc.TMPCLI_STOCK_EXCH_ID  
    ,case when upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_PURC_WAIVER)),''))='Y' then '1' else '0' end  
    ,CASE WHEN  tpdmc.TMPCLI_TRADING_ID = '' THEN '0' END    
    ,upper([citrus_usr].[fn_reverse_mapping]('CDSL','BOSTMNTCYCLE',upper(ISNULL(LTRIM(RTRIM(tpdmc.TMPCLI_BO_STMT_CYL_CD)),''))))  
    ,'MIG'  
    ,getdate()  
    ,'MIG'  
    ,getdate()  
    ,1  
    ,'0'  
    ,tpdmc.TMPCLI_BOID  
    FROM TMP_POA_DTLS_MSTR_CDSL tpdmc,#tmp t  
    WHERE tpdmc.TMPCLI_BOID = t.TMPCLI_BOID  
    AND tpdmc.TMPCLI_BOID NOT IN (SELECT isnull(POAM_MASTER_ID ,'') FROM poa_mstr)  
      
      
     
      
    SELECT IDENTITY(int,1,1) id1 , * INTO #tmp2 FROM TMP_CDSL_AUTH_SIGNATORY    
      
    DECLARE @l_poaam_id numeric  
       
     
    SELECT @l_poaam_id = ISNULL(max(poaam_id),0)+ 1 FROM poa_auth_mstr  
      
    INSERT INTO poa_auth_mstr  
    (  
     poaam_id,  
     poaam_poam_id,  
     poaam_name1,  
     poaam_name2,  
     poaam_name3,  
     poaam_created_by,  
     poaam_created_dt,  
     poaam_lst_upd_by,  
     poaam_lst_upd_dt,  
     poaam_deleted_ind,  
     poaam_doc_path  
    )  
   SELECT DISTINCT @l_poaam_id + id1   
   ,poam_id  
   ,a.HLDR_NAME  
   ,''  
   ,''  
   ,'MIG'  
   ,GETDATE()  
   ,'MIG'  
   ,GETDATE()  
   ,1  
   ,''  
   FROM #TMP2 B,POA_MSTR,TMP_CDSL_AUTH_SIGNATORY A  
   WHERE A.BO_ID  = B.BO_ID  
   AND   poam_master_id = B.BO_ID  
   AND   b.HLDR_NAME = a.HLDR_NAME  
   AND   poam_id NOT IN (SELECT poaam_poam_id FROM poa_auth_mstr)  
     
  
  
     
   
--    
END

GO
