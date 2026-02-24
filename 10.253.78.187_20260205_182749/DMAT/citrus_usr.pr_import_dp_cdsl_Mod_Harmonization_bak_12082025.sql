-- Object: PROCEDURE citrus_usr.pr_import_dp_cdsl_Mod_Harmonization_bak_12082025
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------






--select * from sub_ctgry_mstr  where subcm_clicm_id = 26--2156,2155,2150,082104
--select * from dp_acct_mstr order by 1 descf
--select * from dp_Acct_mstr where dpam_batch_no = 75
--update dp_Acct_mstr set dpam_batch_no = null where dpam_batch_no = 75
--delete from batchno_cdsl_mstr where batchc_status ='P' and batchc_no = 75
--select * from bitmap_ref_mstr where bitrm_parent_cd = 'NSDL_BTCH_CLT_CURNO'
--update bitmap_ref_mstr set bitrm_values = '112022' where bitrm_parent_cd = 'NSDL_BTCH_CLT_CURNO'
--select * from client_mstr  where clim_crn_no = 101
--pr_import_dp '','CDSL','02/02/2007','13/02/2008','ALL',''                     
--begin tran 
--rollback
--commit 
--UPDATE DP_ACCT_MSTR SET DPAM_BATCH_NO = NULL WHERE DPAM_ID = 64147
--[pr_import_dp_cdsl_Mod] '359753|*~|36214|*~|*|~*','CDSL','01/04/2010','12/10/2010','M','76',3,'HO',''   
--select * from dp_acct_mstr order by 1 desc  
--CDSL	01/05/2008	02/05/2008	N	45	3	HO	 -- original
create PROCeDURE [citrus_usr].[pr_import_dp_cdsl_Mod_Harmonization_bak_12082025]( @pa_crn_no      varchar(8000)                 
                            , @pa_exch        VARCHAR(10)                  
                            , @pa_from_dt     VARCHAR(50)                  
                            , @pa_to_dt       VARCHAR(50)                  
                            , @pa_tab         CHAR(3)                  
                            , @PA_BATCH_NO    VARCHAR(25)  
                            , @PA_EXCSM_ID     NUMERIC   
                            , @PA_LOGINNAME    VARCHAR(25)
                            , @pa_mod_typ		varchar(50) 
                            , @pa_ref_cur     VARCHAR(8000) OUTPUT                  
                             )                  
AS                  
/*                  
*********************************************************************************                  
 SYSTEM         : CITRUS                  
 MODULE NAME    : PR_IMPORT_DP                  
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR STATUS MASTER                  
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT LTD                  
 VERSION HISTORY: 1.0                  
 VERS.  AUTHOR            DATE          REASON                  
 -----  -------------     ------------  --------------------------------------------------                  
 2.0    TUSHAR            17-aug-2007   VERSION.                  
-----------------------------------------------------------------------------------*/                  
BEGIN                  
--      


-- set @pa_from_dt = @pa_from_dt + +' 00:00:00.000'
--  set @pa_to_dt   = @pa_to_dt + +' 23:59:59.999'
            
  DECLARE @crn TABLE (crn          numeric                  
                     ,acct_no      varchar(25)                  
                     ,clim_stam_cd varchar(25)                  
                     ,fm_dt        datetime                  
                     ,to_dt        datetime                  
                     )            
                       
                       
    DECLARE @c_cursor            cursor      
    declare @l_nom_gua_ind       varchar(3)      
           ,@l_nom_gua_name      varchar(500)      
           ,@l_mapin             varchar(10)                                                  
           , @l_sms              char(1)      
           , @l_secondmapin      varchar(10)                                                           
           , @l_secondsms        char(1)                                                                        
           , @l_thirdmapin       varchar(10)                                                                  
           , @l_thirdsms         char(1)      
           , @l_thirdemail       varchar(50)      
           , @l_fh_panflag       varchar(10)      
           , @l_rbi_appdate      datetime      
           , @l_authid           char(8)      
           , @l_counter          NUMERIC  
           , @L_DPM_ID           BIGINT  
           ,@l_06cnt		     bigint
    --            
    DECLARE @@rm_id              VARCHAR(8000)                    
          , @@cur_id             VARCHAR(8000)                    
          , @@foundat            INT                    
          , @@delimeterlength    INT                   
          , @@delimeter          CHAR(1)               
          , @c_crn_no            numeric                     
          , @c_dpam_id           numeric                                                                   
          , @c_acct_no           varchar(25)                                                                     
          , @c_sba_no            varchar(20)          
          , @l_crn_no            NUMERIC                  
          , @l_acct_no           VARCHAR(25)                    
          , @l_Value             VARCHAR(8000)                  
          , @l_client_type       VARCHAR(100)                  
          , @l_chk               NUMERIC                  
          , @l_ctgry_chk         NUMERIC   
          
          
          Update dpam set dPAM_SUBCM_CD = CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  ELSE CONVERT(VARCHAR(10),ProdCode)   END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  + CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END   
			from   dp_acct_mstr dpam
			, DPs8_PC1
			where  dpam_sba_no =  BOID and  dpam_stam_cd not in ('02_BILLSTOP' , '05' )
			and dpam_subcm_cd = ''                     
                                             
  IF @pa_exch = 'CDSL'                  
    BEGIN                  
    --      
    print 'm1'   
    
   
 exec [citrus_usr].[pr_auto_nrn_poaid_mod] @pa_crn_no      
                            , @pa_exch                        
                            , @pa_from_dt     
                            , @pa_to_dt       
                            , @pa_tab         
                            , @PA_BATCH_NO    
                            , @PA_EXCSM_ID    
                            , @PA_LOGINNAME   
                            , @pa_ref_cur 
                            
                                     
    declare @line2 table (ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,product_number          varchar(4) --numeric(4,0)                  
                         ,bo_name                 char(100)                  
                         ,bo_middle_name          char(20)                  
                         ,cust_search_name        char(20)                  
                         ,bo_title                char(10)                  
                         ,bo_suffix               char(10)                  
                         ,hldr_fth_hsd_nm         char(50)                  
                         ,cust_addr1              char(300)--char(30)                  
                         ,cust_addr2              char(300)--char(30)                  
                         ,cust_addr3              char(300)--char(30)                  
                         ,cust_addr_city          char(300)--char(25)                  
                         ,cust_addr_state         char(300)--char(25)                  
                         ,cust_addr_cntry         char(300)--char(25)                  
                         ,cust_addr_zip           char(10)                  
                         ,cust_ph1_ind            char(6)                  
                         ,cust_ph1                char(17)                  
                         ,cust_ph2_ind            char(6)                  
                         ,cust_ph2                char(17)                  
                         ,cust_addl_ph            char(100)                  
                         ,cust_fax                char(17)                  
                         ,hldr_pan                char(25) 
						 ,cust_uid				  char(16)--char(15)                 
						 ,name_ch_reason_cd		  char(2)
                         ,it_crl                  char(15)                  
                         ,cust_email              char(100) -- 50                  
                         ,bo_usr_txt1             char(50)                  
                         ,bo_usr_txt2             char(50)                  
                         ,bo_user_fld3            varchar(20)                  
                         ,bo_user_fld4            char(4)                  
                         ,bo_user_fld5            varchar(20)                  
                         ,sign_bo                 varchar(8000)          
                         ,sign_fl_flag            char(1),sign_old_bo varchar(800)
                         ,Borequestdt varchar(14)
						  --Sep1818
						 ,cust_adr_cntry_cd  char(2)
						 ,cust_state_code varchar(6)
						 ,city_seq_no char(2)
						 ,Smart char(1)
						 ,Pri_mob_ISD varchar(6)
						 ,Sec_mobile varchar(17)
						 ,Sec_mob_ISD varchar(6)
						 --Sep1818
						 
						 )                  
      declare @line3 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                      
                         ,acct_no                 varchar(20)                  
                         ,bo_name1                 char(100)                  
                         ,bo_mid_name1             char(20)                  
                         ,cust_search_name1        char(20)                  
                         ,bo_title1                char(10)                  
                         ,bo_suffix1               char(10)                  
                         ,hldr_fth_hsd_nm1         char(50)                  
                         ,hldr_pan1                char(10)
						 ,cust_uid1				   char(16)--13
                         ,cust_name_ch_code1	   char(2)                   
                         ,it_crl1                  char(15)
                         ,sh_mob char(17)-- 10
,sh_email char(100)--50
,sh_mob_phone_isd varchar(6)
)                   
                                           
      declare @line4 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,bo_name2                 char(100)                  
                         ,bo_mid_name2             char(20)                  
                         ,cust_search_name2        char(20)                  
                         ,bo_title2                char(10)                  
                         ,bo_suffix2               char(10)                  
                         ,hldr_fth_hsd_nm2         char(50)                  
                         ,hldr_pan2                char(10)
						 ,cust_uid2				   char(16) -- 13
                         ,cust_name_ch_code2	   char(2)                   
                         ,it_crl2                  char(15)
                         ,th_mob char(17) -- 10
,th_email char(100) -- 50
,th_mob_phone_isd varchar(6)
)                   
                                           
                                           
      declare @line5 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,dt_of_maturity          varchar(20)--datetime                  
                         ,dp_int_ref_no           char(10)                    
                         ,dob                     varchar(20)--datetime                  
                         ,sex_cd                  char(1)                  
                         ,occp                    char(4)                  
                         ,life_style              char(4)                  
                         ,geographical_cd         char(4)                  
                         ,edu                     char(4)                  
                         ,ann_income_cd           varchar(20)                  
                         ,nat_cd                  char(3)                  
                         ,legal_status_cd         varchar(20)                  
                         ,bo_fee_type             varchar(20)                  
                         ,lang_cd                 varchar(20)                  
                         ,category4_cd            varchar(20)                  
                         ,bank_option5            varchar(20)                  
                         ,staff                   char(1)                  
                         ,staff_cd                char(10)                  
--                         ,bo2_usr_txt1            char(50)  
						--changed by tushar  on jan 09 2015
                         ,bo2_usr_txt1            char(40) 
						,EMAIL_STATEMENT_FLAG            char(1)                  
                         ,CAS_MODE char(2)                  
                         ,MENTAL_DISABILITY char(1)                  
                         ,Filler1            char(1)                  
                         --changed by tushar  on jan 09 2015
						 ,rgss_flg				  char(1)
						 ,annual_rpt_flg		  char(1)
						 ,pldg_std_inst_flg		  char(1)
						 ,email_rta_down_flg	  char(1)
						 ,bsda_flg				  char(1)                
                         ,bo2_usr_txt2            char(50)                  
                         ,dummy1                  varchar(20)                  
                         ,dummy2                  varchar(20)                  
                         ,dummy3                  varchar(20)                  
                         ,secur_acc_cd            varchar(20)                  
                         ,bo_catg                 varchar(20)                  
                         ,bo_settm_plan_fg        char(1)                  
                         ,voice_mail         char(15)                   
                         ,rbi_ref_no              char(30)                  
                         ,rbi_app_dt              varchar(20)--datetime                  
                         ,sebi_reg_no             char(24)                  
                         ,benef_tax_ded_sta       varchar(20)                  
                         ,smart_crd_req           char(1)                  
                         ,smart_crd_no            char(20)                  
                         ,smart_crd_pin           varchar(20)                  
                         ,ecs                     char(1)                  
                         ,elec_confirm            char(1)                  
                         ,dividend_curr           varchar(20)                  
                         ,group_cd                char(8)                  
                         ,bo_sub_status           varchar(20)                  
                         ,clr_corp_id             varchar(20)                  
                         ,clr_member_id           char(8)                  
                         ,stoc_exch               varchar(20)                  
                         ,confir_waived           char(1)                  
                         ,trading_id              char(8)                  
                         ,bo_statm_cycle_cd       char(2)                  
                         ,benf_bank_code          char(12)                  
                         ,benf_brnch_numb         char(18)                  
                         ,benf_bank_acno          char(20)                  
                         ,benf_bank_ccy           varchar(20)                  
                         ,divnd_brnch_numb        char(12)                  
                         ,divnd_bank_code         char(12)                  
                         ,divnd_acct_numb         char(20)                  
                         ,divnd_bank_ccy          varchar(20))                  
                                           
      declare @line6 table (ln_no CHAR(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,poa_id                  char(25)                  
                         ,setup_date              datetime                  
                         ,poa_to_opr_ac           char(1)                  
                         ,gpa_bpa_fl              char(1)                  
                         ,eff_frm_dt              datetime                  
                         ,eff_to_dt               datetime                  
                         ,usr_fld1                varchar(20)                  
						 ,usr_fld2               varchar(20)                  
                         ,ca_charfld              char(50)                  
                         ,bo_name3                char(100)                  
                         ,bo_mid_name3            char(20)                   
                         ,cust_srh_name3          char(20)                  
                         ,bo_title3               char(10)                  
                         ,bo_suffix3              char(10)                  
                         ,hldr_fth_hsb_nm3        char(50)                  
                         ,cus_addr1               char(300)--char(30)                 
                         ,cust_addr2              char(300)--char(30)                  
                         ,cust_addr3              char(300)--char(30)                  
                         ,cust_city               char(300)--char(25)                  
                         ,cust__state             char(300)--char(25)                  
                         ,cust_cntry              char(25)       
                         ,cust_zip                char(10)                  
                         ,cust_ph1_ind            char(1)                  
                         ,cust_ph1                char(17)                  
    ,cust_ph2_ind            char(1)                  
                         ,cust_ph2                char(17)                  
                         ,cust_addl_ph            char(100)                  
                         ,cust_fax                char(17)                  
                         ,pan_no                  char(25)                  
                         ,it_crc                  char(15)                  
                         ,cust_email              char(50)                  
                         ,bo3_usr_txt1            char(50)                  
                         ,bo3_usr_txt2            char(50)                  
                         ,bo3_usr_fld3            varchar(20)                  
                         ,bo3_usr_fld4            varchar(20)                  
                         ,bo3_usr_fld5            varchar(20)                  
                         ,sign_poa                varchar(8000)                  
                         ,sign_file_fl            char (1))                                    
                        
                                           
      declare @line7 table(ln_no                   char(2)                  
                         ,crn_no                  numeric                  
                         ,acct_no                 varchar(20)                  
                         ,Purpose_code            CHAR(3)--numeric                  
                         ,bo_name                 char(100)                    
                         ,bo_middle_nm            char(100)                   
                         ,cust_search_name        char(100)                  
                         ,bo_title             char(100)                   
                         ,bo_suffix               char(100)                   
                         ,hldr_fth_hs_name        char(100)                   
                         ,cust_addr1              char(100)                  
                         ,cust_addr2              char(100)                  
                         ,cust_addr3              char(100)                  
                         ,cust_city               char(100)                  
                         ,cust_state              char(100)                  
                         ,cust_cntry              char(100)                   
                         ,cust_zip                char(100)                  
                         ,cust_ph1_id             char(100)                   
                         ,cust_ph1                char(100)                  
                         ,cust_ph2_in             char(100)                    
                         ,cust_ph2                char(100)                   
                         ,cust_addl_ph            char(92)
						 ,dob					  varchar(8)                         
						 ,cust_fax                char(100)                   
                         ,hldr_in_tax_pan         char(100)
						 ,uid					 char(13)
						 ,name_ch_reason_cd		  char(2)                     
                         ,it_crl                  char(100)                   
                         ,cust_email              char(100)                  
                         ,usr_txt1                char(100)                    
                         ,usr_txt2                char(100)                   
                         ,usr_fld3                numeric                  
                         ,usr_fld4                char(4)--numeric                      
						,usr_fld5                numeric
						,nom_serial_no char(2)
						,rel_withbo    char(2)
						,sharepercent char(5)
						,res_sec_flag char(1)         	,ln7_cust_adr_cntry_cd char(2)
,ln7_cust_adr_state_cd varchar(6)
,ln7_city_seq_no char(2)
,ln7_Pri_mob_ISD varchar(6)            
                         )                     
                        
                        
              declare @line8 table(ln_no CHAR(2)                  
                         ,crn_no                  numeric 
                         ,acct_no                 varchar(20)                  
                         ,purposecode             char(2)
                         ,flag                    char(1)                  
                         ,mobile                  char(17)                  
                         ,email                   char(100)                  
                         ,remarks                 char(100)                  
                         ,push_flg                char(1)                  
                       )             
                                      
                                                    
       
      IF ISNULL(@pa_crn_no, '') <> ''                  
      BEGIN--n_n                  
      --                  
        SET @@rm_id  =  @pa_crn_no                  
        --                  
                          
        --                  
        WHILE @@rm_id <> ''                    
        BEGIN--w_id                    
        --              
          SET @@foundat = 0                    
          SET @@foundat =  PATINDEX('%*|~*%',@@rm_id)                    
          --                  
          IF @@foundat > 0                    
          BEGIN                    
          --                    
            SET @@cur_id  = SUBSTRING(@@rm_id, 0,@@foundat)                    
            SET @@rm_id   = SUBSTRING(@@rm_id, @@foundat+4,LEN(@@rm_id)- @@foundat+4)                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            SET @@cur_id      = @@rm_id                    
            SET @@rm_id = ''                    
          --                    
          END                  
          --                  
          IF @@cur_id <> ''                  
          BEGIN                  
          --                  
            SET @l_crn_no  = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@cur_id,1))                  
            SET @l_acct_no = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,2))                  
            --       
                      
            INSERT INTO @crn                   
            SELECT clim_crn_no,@l_acct_no, clim_stam_cd, clim_created_dt, clim_lst_upd_dt                  
            FROM   client_mstr WITH (NOLOCK)                  
            WHERE  clim_crn_no = CONVERT(numeric, @l_crn_no)   
            
                  
          --                  
          END                  
        --                    
        END                  
      --                  
      END                  
      --   
               
--      IF  @pa_crn_no = ''                  
--      BEGIN                  
--        -- 
--        print 'mmmmmm'  
        
        
-- exec [citrus_usr].[pr_auto_nrn_poaid_mod] @pa_crn_no      
--                            , @pa_exch                        
--                            , @pa_from_dt     
--                            , @pa_to_dt       
--                            , @pa_tab         
--                            , @PA_BATCH_NO    
--                            , @PA_EXCSM_ID    
--                            , @PA_LOGINNAME   
--                            , @pa_ref_cur 
--                 print 'lin2 up'   
                 
                 
                                      
--        insert into @line2( ln_no                  
--                           ,crn_no                  
--                           ,acct_no                  
--                           ,product_number                       
--                           ,bo_name                              
--                           ,bo_middle_name                       
--                           ,cust_search_name                     
--                           ,bo_title                             
--                           ,bo_suffix                            
--                           ,hldr_fth_hsd_nm                      
--                           ,cust_addr1                           
--                           ,cust_addr2                           
--                           ,cust_addr3                           
--                           ,cust_addr_city                       
--                           ,cust_addr_state                      
--                           ,cust_addr_cntry                      
--                           ,cust_addr_zip                        
--                           ,cust_ph1_ind                         
--                           ,cust_ph1                             
--                           ,cust_ph2_ind                         
--                           ,cust_ph2                             
--                           ,cust_addl_ph                         
--                           ,cust_fax                             
--                           ,hldr_pan
--						   ,cust_uid --new added pankaj
--						   ,name_ch_reason_cd	                             
--                           ,it_crl                               
--                           ,cust_email                           
--                           ,bo_usr_txt1                          
--                           ,bo_usr_txt2                          
--                           ,bo_user_fld3                         
--                           ,bo_user_fld4                         
--                           ,bo_user_fld5  -- for pan verf flag                 
--                           ,sign_bo                                   
--                           ,sign_fl_flag,sign_old_bo,Borequestdt
						   
--						   ,cust_adr_cntry_cd  
--							,cust_state_code 
--							,city_seq_no 
--							,Smart 
--							,Pri_mob_ISD 
--							,Sec_mobile 
--							,Sec_mob_ISD 
--						   )                  
--                           SELECT distinct '02'                  
--                                , clim_crn_no                  
--                                , dpam_sba_no--dpam_acct_no                  
--                                --, MAX(case when subcm_cd = '082104' then '0001' else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') end) --product no   --As per latesh sir suggested on 16/08/2013              
--                                , MAX(citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')) --product no   --As per latesh sir suggested on 16/08/2013              
--                                --, citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0')
--                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME1 else '' end )--'' --bo name
--                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME2 else '' end )--'' --bo middle name
--                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME3 else '' end )--'' -- bo seach name
--                                , MAX(case when clic_mod_action = 'CLIENT SALUTATION' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SLT',''),'') else '' end)--'' --MAX(case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end)  --bo title
--                                , '' --bo suffix                 
--                                ,MAX(case when clic_mod_action = 'F FATHERNAMECHANGE' then ISNULL(dphd_fh_fthname,'') else '' end)  --father/husband name                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) else '' end)--end --adr1                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) else '' end)--end--adr2                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3) else '' end) -- end--adr3                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) else '' end)--end--adr_city                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) else '' end)--end--adr_state                  
--                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) else '' end)--end--adr_country                  
--                                ,MAX(replace(case when clic_mod_action = 'C Address' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7)else '' end,' ','')) --end --adr_zip                
--                                ,MAX(case when clic_mod_action in ('First MobileNo','First MobileNo Delete') then  case when clic_mod_action = 'First MobileNo Delete' then replicate('@',1) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')end else '' end)  --CUST PH 1 INDC
--                                , MAX(case when clic_mod_action in ('First MobileNo','First MobileNo Delete')  then  case when clic_mod_action = 'First MobileNo Delete' then replicate('@',17) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') end else '' end) --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
--                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
--                                , MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',1) else case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') = '' then '' else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'') end  end else '' end) --'0' CUST PH 2 INDC                 
--                                , MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',17) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') end else '' end)  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
--                                , MAX(case when clic_mod_action in ('First ResidenceNo','First ResidenceNo Delete') then  case when clic_mod_action = 'First ResidenceNo Delete' then replicate('@',100) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'') end else '' end)  --CUST ADDL PHONE             
--                                , MAX(case when clic_mod_action = 'Contacts' then CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END else '' end) --fax                  
--                                --, MAX(case when clic_mod_action in ('CLIENT MAIN PROPERTIES','GENERAL') then isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') else  '' end)  --pan card                  
--								, MAX(case when (clic_mod_action in ('PAN DETAILS') and ISNULL(clic_mod_pan_no,'')='' ) then isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') else  '' end)  --pan card                  
--                                , MAX(case when clic_mod_action in ('FST HOLDER UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') else ''  end)--UID 
--                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then isnull (nmcrcd_reason_cd,'') else '' end )
--								, '' --IT CIRCLE
--                                , MAX(case when clic_mod_action in ('First EmailId','First EmailId Delete') then case when clic_mod_action = 'First EmailId Delete' then replicate('@',100) else CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END end else '' end) --email                  
--                                , '' --USER TEXT 1                 
--                                , '' --USER TEXT 2                 
--                                , '0000' --USER FIELD 3                  
--                                , ''                  
--                                , MAX(case when clic_mod_action in ('CLIENT MAIN PROPERTIES','GENERAL') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'  
--								  when clic_mod_action in ('PAN DETAILS') then case when isnull(clic_mod_pan_no,'') <> '' then isnull(clic_mod_pan_no,'') else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'   
--								  else '' end)              
--                                , MAX(case when clic_mod_action = 'SIGNATURE' then replace(ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') ,'B'+dpam_sba_no,'') else '' end)  --ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
								
--                                --, ''      
--								--, case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
--								, MAX(case when clic_mod_action = 'SIGNATURE' then case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end else '' end) --signature file flag                  
--								--, MAX(case when clic_mod_action = 'SIGNATURE' then replace(ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'') ,'B'+dpam_sba_no,'') else '' end)
--								 --,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/KJ94.BMP' END )
--								 ,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/'+ ISNULL ([citrus_usr].[fn_sing_old_name](dpam.dpam_sba_no),'') else '' end)
--								,MAX(REPLACE(CONVERT(VARCHAR(10), clic_mod_created_dt, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), clic_mod_created_dt, 114),':','') ,6))

--								,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'')else '' end)-- addr cntry code
--,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'')else '' end) -- state code
--,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' )else '' end)-- city seq no
--								--,max(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'') ) 
--,max(case when clic_mod_action = 'SMART REGISTRATION' then case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'') = 'YES' then 'Y' else 'N'end else '' end) 
--,max(case when clic_mod_action = 'First MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) else space(6) END) else '' end)
--,max(case when clic_mod_action = 'Second MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END)else '' end)
--,max(case when clic_mod_action = 'Second MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) else space(6) END) else '' end)


--								FROM   dp_acct_mstr              dpam                  
--                                  left outer join      
--                                  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
--                                  --left outer join    
--                                  --client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
--                                  --left outer join           
--                                  --bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)  
--                                  left outer join 
--                                  name_change_reason_cd     nmcrc  on dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no  
--                                  and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--									--and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--									and    nmcrc.nmcrcd_deleted_ind = 1
--                                , client_mstr               clim                  
--                                , entity_type_mstr          enttm                  
--                                , client_ctgry_mstr         clicm                  
--                                , sub_ctgry_mstr            subcm                   
--                                , exch_seg_mstr             excsm  
--                                , client_list_modified  climmod 
                                                              
--                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
--                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd
--						   AND    dpam.dpam_deleted_ind   = 1                  
--                           AND    dpam.dpam_excsm_id      = excsm_id                  
--                           AND    isnull(dpam.dpam_batch_no,0) <> 0   
--                           AND    excsm_exch_cd           = @pa_exch  
--                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
--                           AND    subcm.subcm_deleted_ind = 1                  
--                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
--                           AND    clim.clim_deleted_ind   = 1                  
--                           --AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
--                           --AND    isnull(banm.banm_deleted_ind,1)   = 1 
--                           and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
--                           --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                           AND    climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--						   AND	  climmod.clic_mod_action in ('C Address','Client Main Properties','General','Signature','PAN DETAILS','FIRST MOBILENO','First ResidenceNo','First OfficeNo','First EmailId','First EmailId Delete','First MobileNo Delete','First ResidenceNo Delete','First OfficeNo Delete','FST HOLDER NAME','F FATHERNAMECHANGE','CLIENT SALUTATION','FST HOLDER UID','SMART REGISTRATION')
--						   and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--                           and    climmod.clic_mod_deleted_ind = 1
--                           and	isnull(climmod.clic_mod_batch_no,0) = 0
--                           --and    nmcrc.nmcrcd_crn_no = dpam.dpam_crn_no
--                           --and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
--                           --and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--                           --and    nmcrc.nmcrcd_deleted_ind = 1
--						   GROUP BY DPAM_ID,CLIM_CRN_NO,DPAM_CRN_NO, DPAM_SBA_NO	

                  
--insert into @line2( ln_no                  
--                           ,crn_no                  
--                           ,acct_no                  
--                           ,product_number                       
--                           ,bo_name                              
--                           ,bo_middle_name                       
--                           ,cust_search_name                     
--                           ,bo_title                             
--                           ,bo_suffix                            
--                           ,hldr_fth_hsd_nm                      
--                           ,cust_addr1                           
--                           ,cust_addr2                           
--                           ,cust_addr3                           
--                           ,cust_addr_city                       
--                           ,cust_addr_state                      
--                           ,cust_addr_cntry                      
--                           ,cust_addr_zip                        
--                           ,cust_ph1_ind                         
--                           ,cust_ph1                             
--                           ,cust_ph2_ind                         
--                           ,cust_ph2                             
--                           ,cust_addl_ph                         
--                           ,cust_fax                             
--                           ,hldr_pan
--						   ,cust_uid --new added pankaj
--						   ,name_ch_reason_cd	                             
--                           ,it_crl                               
--                           ,cust_email                           
--                           ,bo_usr_txt1                          
--                           ,bo_usr_txt2                          
--                           ,bo_user_fld3                         
--                           ,bo_user_fld4                         
--                           ,bo_user_fld5                   
--                           ,sign_bo                                   
--                           ,sign_fl_flag,sign_old_bo,Borequestdt
						   
--						    ,cust_adr_cntry_cd  
--							,cust_state_code 
--							,city_seq_no 
--							,Smart 
--							,Pri_mob_ISD 
--							,Sec_mobile 
--							,Sec_mob_ISD 

--						   )                  
--                          SELECT distinct '02'                  
--										, '0'--clim_crn_no                  
--										, dpam_sba_no--dpam_acct_no                  
--										--, case when subcm_cd = '082104' then '0001' else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') end --product no   --As per latesh sir suggested on 16/08/2013
--										, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no   --As per latesh sir suggested on 16/08/2013
--										--, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no                 
--										--, citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0')
--										, '' --bo name
--										, '' --bo middle name
--										, '' -- bo seach name
--										, ''--case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end  --bo title
--										, '' --bo suffix                 
--										, ''--ISNULL(dphd_fh_fthname,'')  --father/husband name                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) --end --adr1                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) --end--adr2                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3)-- end--adr3                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) --end--adr_city                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) --end--adr_state                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) --end--adr_country                  
--										, ''--replace(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7),' ','') --end --adr_zip                
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  --CUST PH 1 INDC
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')  --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')  --CUST ADDL PHONE             
--										, ''--CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                  
--										, ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--										, ''--isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') --UID 
--										, ''--reason code for name change
--										, '' --IT CIRCLE
--										, ''--CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                  
--										, '' --USER TEXT 1                 
--										, '' --USER TEXT 2                 
--										, space(4) --USER FIELD 3                  
--										, ''                  
--										, ''--case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
--										, ''--ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
--										, ''--case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end --signature file flag                  
--										--, replace(ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'') ,'B'+dpam_sba_no,'')    --ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'')    
--										--,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/KJ94.BMP' END )
--										,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/'+ ISNULL ([citrus_usr].[fn_sing_old_name](dpam.dpam_sba_no),'') else '' end)
--										,max(REPLACE(CONVERT(VARCHAR(10), clic_mod_created_dt, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), clic_mod_created_dt, 114),':','') ,6))

--										,''--max(isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'') )-- addr cntry code
--								,''--max(isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'')) -- state code
--								,''--max(isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' ))-- city seq no
--								,''--max(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'')  )
--								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) else space(6) END)
--								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END)
--								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) else space(6) END)


--								FROM   dp_acct_mstr              dpam                  
--                                  left outer join      
--                                  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
--                                  left outer join    
--                                  client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
--                                  left outer join           
--                                  bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
--                                  --left outer join 
--         --                         name_change_reason_cd     nmcrc  on dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
--         --                         and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
--									----and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--									--and    nmcrc.nmcrcd_deleted_ind = 1
--                                , client_mstr               clim                  
--                                , entity_type_mstr          enttm                  
--                                , client_ctgry_mstr         clicm                  
--                                , sub_ctgry_mstr            subcm                   
--                                , exch_seg_mstr             excsm  
--                                , client_list_modified  climmod 
--                                --, name_change_reason_cd nmcrc
--                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
--                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd
--						   AND    dpam.dpam_deleted_ind   = 1                  
--                           AND    dpam.dpam_excsm_id      = excsm_id                  
--                           AND    isnull(dpam.dpam_batch_no,0) <> 0   
--                           AND    excsm_exch_cd           = @pa_exch  
--                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
--                           AND    subcm.subcm_deleted_ind = 1      
--and	isnull(climmod.clic_mod_batch_no,0) = 0            
--                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
--                           AND    clim.clim_deleted_ind   = 1                  
--                           AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
--                           AND    isnull(banm.banm_deleted_ind,1)   = 1
--         --                  and    nmcrc.nmcrcd_crn_no = dpam.dpam_crn_no
--         --                  and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
--						   --and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--						   --and    nmcrc.nmcrcd_deleted_ind = 1 
----                           and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
----                           --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
----                           AND    climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
----						   AND	  climmod.clic_mod_action in ('C Address','Client Main Properties','General','Signature')
----                           and    climmod.clic_mod_deleted_ind = 1
--and not exists (select 1 from @line2 o where o.acct_no = dpam_sba_no and o.crn_no  = clim_crn_no )
--group by DPAM_SBA_NO,SUBCM_CD,DPAM_ID
                  
--                   insert into @line3(ln_no                   
--                                     ,crn_no                   
--                                     ,acct_no                  
--                                     ,bo_name1                                
--                                     ,bo_mid_name1                            
--                                     ,cust_search_name1                       
--                                     ,bo_title1                               
--                                     ,bo_suffix1                              
--                                     ,hldr_fth_hsd_nm1                        
--                                     ,hldr_pan1
--									 ,cust_uid1
--									 ,cust_name_ch_code1		                                
--                                     ,it_crl1
--                                     ,sh_mob
--									,sh_email
--									,sh_mob_phone_isd
--									)                  
--                                     SELECT distinct '03'                  
--                                                  ,clim_crn_no                  
--                                                  ,dpam_sba_no                  
--												  ,case when clic_mod_action = 'SH NameChange' then isnull(dphd_sh_fname,'') else '' end 
--												  ,case when clic_mod_action = 'SH NameChange' then isnull(dphd_sh_mname,'') else '' end
--												  ,case when clic_mod_action = 'SH NameChange' then (case when isnull(dphd_sh_lname,'')='' then '.' else isnull(dphd_sh_lname,'.') end) else '' end --isnull(dphd_sh_lname,'')                      
--                                                  ,case when clic_mod_action = '2nd Holder Title' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SEC_HLD_TITLE',''),'') else '' end--, ''         -- then (case when DPHD_SH_GENDER in ('M','MALE') then 'MR'  when DPHD_SH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end) else '' end                            
--                                                  ,case when clic_mod_action = '2nd Holder Suffix' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SEC_HLD_SUFFIX',''),'') else '' end--, ''         
--                                                  ,case when clic_mod_action = 'SH FatherNameChange' then ISNULL(DPHD_SH_FTHNAME,'') else '' end--''--isnull(dphd_sh_fthname,'')                  
--                                                  ,case when clic_mod_action = 'SH PANChange' then DPHD_SH_PAN_NO else '' end --''--isnull(dphd_sh_pan_no,'')                  
--												  , case when clic_mod_action in ('SEC HOLDER UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARSECHLDR',''),'') else ''  end --''
--												  ,case when clic_mod_action = 'SH NameChange' then isnull (nmcrcd_reason_cd,'') else '' end     --name change code
--                                                  , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle                  
--                                                  ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOB'),'')
--												  ,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),''))
--												  ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')
--                                      FROM   dp_acct_mstr              dpam  
--											 left outer join
--											 name_change_reason_cd     nmcrc   
--											 on nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--											 --and   nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--											 and nmcrc.nmcrcd_deleted_ind = 1
--											 and dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
--											 and upper(nmcrc.nmcrcd_holder_type) = 'IIND HOLDER'	                
--                                             left outer join   
--                                             dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
--                                             left outer join                       
--                                             client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
--                                             left outer join           
--                                             bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
--                                           , client_mstr               clim                  
--                                           , entity_type_mstr         enttm                  
--                                           , client_ctgry_mstr         clicm                  
--                                             left outer join                  
--                                             sub_ctgry_mstr            subcm                   
--                                             on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--                                           ,exch_seg_mstr 
--                                           , client_list_modified  climmod  
--                                      WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
--                                      AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--                                      AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--                                      AND    dpam.dpam_deleted_ind   = 1                  
--                                      AND    isnull(dpam.dpam_batch_no,0) <> 0   
--                                      AND    dpam.dpam_excsm_id      = excsm_id                  
--                                      AND    excsm_exch_cd           = @pa_exch  
--                                      AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
--                                      AND    clim.clim_deleted_ind   = 1                  
--                                      AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
--                                      AND    isnull(banm.banm_deleted_ind,1)   = 1    
--                                      AND    isnull(dphd.dphd_sh_fname,'') <> ''  
--                                      and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
--                                      --AND   CLIM_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59' 
--									  AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--									  and	isnull(climmod.clic_mod_batch_no,0) = 0
--									  AND   climmod.clic_mod_action in ('SH Address','SH NameChange','SH FatherNameChange','SH DOBChange','SH PANChange','SH GenderChange','SH MobChange','SH EmailChange','2nd Holder Suffix','2nd Holder Title') 
--									  and   climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end                        
--									  and   climmod.clic_mod_deleted_ind = 1
                  
                  
                 
--                insert into  @line4(ln_no                   
--                                   ,crn_no                  
--                                   ,acct_no                  
--                                   ,bo_name2                  
--                                   ,bo_mid_name2                  
--                                   ,cust_search_name2                   
--                                   ,bo_title2                           
--                                   ,bo_suffix2                          
--                                   ,hldr_fth_hsd_nm2                    
--                                   ,hldr_pan2 
--								   ,cust_uid2
--								   ,cust_name_ch_code2                          
--                                   ,it_crl2
--                                   ,th_mob
--								   ,th_email
--								   ,th_mob_phone_isd
--								   )                   
--                                   SELECT distinct '04'                  
--                                               , clim_crn_no                  
--                                               , dpam_sba_no                  
--										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_fname,'') else '' end
--										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_mname,'') else '' end    
--										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_lname,'') else '' end               
--                                               ,case when clic_mod_action = 'TH GenderChange' then (case when DPHD_TH_GENDER in ('M','MALE') then 'MR'  when DPHD_TH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end) else '' end                               
--                                               , ''                  
--                                               ,case when clic_mod_action = 'TH FatherNameChange' then ISNULL(DPHD_TH_FTHNAME,'') else '' end
--                                               ,case when clic_mod_action = 'TH PANChange' then DPHD_TH_PAN_NO else '' end --pan
--											   ,case when clic_mod_action in ('Trd Holder UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARTHRDHLDR',''),'') else ''  end --''--uid
--											   ,case when clic_mod_action = 'TH NameChange' then isnull (nmcrcd_reason_cd,'') else '' end     --name change code
--                                               , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle  
--                                               ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'th_mob'),'')
--												,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),''))    
--												,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')              
--                                    FROM   dp_acct_mstr              dpam 
--											left outer join
--											 name_change_reason_cd     nmcrc   
--											 on   nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--											 --and   nmcrc.nmcrcd_crn_no = clim.clim_crn_no
--											 and   nmcrc.nmcrcd_deleted_ind = 1
--										   and  dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
--										   and	upper(nmcrc.nmcrcd_holder_type) = 'IIIRD HOLDER'                 
--                                           left outer join   
--                                           dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
--                                           left outer join                       
--                                           client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
--                                           left outer join           
--                                           bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
--                                         , client_mstr               clim                  
--                                         , entity_type_mstr          enttm                  
--                                         , client_ctgry_mstr         clicm                  
--                                           left outer join                  
--                                           sub_ctgry_mstr            subcm                   
--                                           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--                                         , exch_seg_mstr   
--                                           , client_list_modified  climmod  
--                                    WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
--                                    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--                                    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--                                    AND    isnull(dpam.dpam_batch_no,0) <> 0   
--                                    AND    dpam.dpam_deleted_ind   = 1            
--                                    AND    dpam.dpam_excsm_id      = excsm_id                  
--                                    AND    excsm_exch_cd           = @pa_exch  
--                                    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
--                                    AND    clim.clim_deleted_ind   = 1                  
--                                    AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
--                                    AND    isnull(banm.banm_deleted_ind,1)   = 1    
--                                    AND    isnull(dphd.dphd_th_fname,'') <> ''  
--                                    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
--									AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--									and	isnull(climmod.clic_mod_batch_no,0) = 0
--									AND    climmod.clic_mod_action in ('TH Address','TH MobChange','TH EmailChange','TH NameChange','TH FatherNameChange','TH DOBChange','TH PANChange','TH GenderChange','Trd Holder UID')     
--									and   climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end                        
--									and   climmod.clic_mod_deleted_ind = 1
--                                    --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--                       --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
----                         and    climmod.clic_mod_deleted_ind = 1
                         
--               insert into @line5( ln_no                   
--                                          ,crn_no                              
--                                          ,acct_no                  
--                                          ,dt_of_maturity                      
--                                          ,dp_int_ref_no                       
--                                          ,dob                                 
--                                          ,sex_cd                              
--                                          ,occp                                
--                                          ,life_style                          
--                                          ,geographical_cd                     
--                                          ,edu                                 
--                                          ,ann_income_cd                       
--                                          ,nat_cd             
--                                          ,legal_status_cd                     
--                                          ,bo_fee_type                         
--                                          ,lang_cd                             
--                                          ,category4_cd                        
--                                          ,bank_option5                        
--                                          ,staff                               
--                                          ,staff_cd                            
--                                          --,bo2_usr_txt1  
--                                           ,bo2_usr_txt1                        
                                                         
--											--changed by tushar on jan 09 2015
--           									,EMAIL_STATEMENT_FLAG            
--											,CAS_MODE   
--											,MENTAL_DISABILITY                          
--											,Filler1            
--                                --changed by tushar on jan 09 2015
--										  ,rgss_flg				--added by pankaj
--										  ,annual_rpt_flg		--added by pankaj
--										  ,pldg_std_inst_flg	--added by pankaj	
--										  ,email_rta_down_flg	--added by pankaj
--										  ,bsda_flg				
--                                          ,bo2_usr_txt2                        
--                                          ,dummy1                              
--                                          ,dummy2                              
--                                          ,dummy3                              
--                                          ,secur_acc_cd                        
--                                          ,bo_catg                             
--                                          ,bo_settm_plan_fg                    
--                                          ,voice_mail                          
--                                          ,rbi_ref_no                          
--                                          ,rbi_app_dt                          
--                                          ,sebi_reg_no                         
--                                          ,benef_tax_ded_sta                   
--                                          ,smart_crd_req                       
--                                          ,smart_crd_no                
--                                          ,smart_crd_pin                       
--                                          ,ecs                                 
--                                          ,elec_confirm                                                                
--                                          ,dividend_curr                       
--										  ,group_cd                            
--                                          ,bo_sub_status                       
--                                          ,clr_corp_id                         
--                                          ,clr_member_id                       
--                                          ,stoc_exch                           
--                                          ,confir_waived                       
--                                          ,trading_id                          
--                                          ,bo_statm_cycle_cd                   
--                                          ,benf_bank_code                      
--                                          ,benf_brnch_numb                     
--                                          ,benf_bank_acno                      
--                                          ,benf_bank_ccy                       
--                                          ,divnd_brnch_numb                    
--                                          ,divnd_bank_code                     
--                                          ,divnd_acct_numb                     
--                                          ,divnd_bank_ccy)                  
--									   SELECT distinct '05'                  
--                                       , clim_crn_no                  
--                                       , dpam_sba_no                  
--                                       --, case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
--                                       ,'' --DATE OF MATURITY
--									   ,'' --left(dpam_acct_no,8)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
--                                       --, case when dpam_subcm_cd in ('2156','2155','2150','082104') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                end
--                                       ,max(case when clic_mod_action = 'FST HOLDER DOB' then (case when dpam_subcm_cd in ('2156','2155','2150') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end   end) ELSE space(8) END)
--                                       --, isnull(clim.clim_gender,'')  --SEX CODE                
--                                       --,max(case when clic_mod_action = 'FST HOLDER GENDER' then (case when citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') = '0004' then SPACE(1) else isnull(clim.clim_gender,'') end) else '' end)
--                                       ,max(case when SUBSTRING( dpam.dpam_subcm_cd, 1 , 2) = '01' then ( case when clic_mod_action = 'FST HOLDER GENDER' then (case when citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') = '0004' then SPACE(1) else isnull(clim.clim_gender,'') end) else '' end ) else '' end)
--                                       --, ''--CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END --occupation          
--                                       ,max(case when clic_mod_action = 'OCCUPATION' then (CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END)ELSE '' END) --occupation          
--                                       , ''--LIFE STYLE  
--                                       , ''--citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
--                                       , ''--citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
--                                       --, SPACE(4)--'0000'--citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  
--									   ,max(case when clic_mod_action = 'INCOME DETAILS' then citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),'')) else '' end)--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  )
--                                       , ''--citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
--                                       --, CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
--                                       , SPACE(2)--'00' --LEGAL STATUS CODE
--                                       --, CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
--                                       , SPACE(2)--'00' --BO FEE TYPE
--                                       , SPACE(2)--'00'-- citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
--                                       , SPACE(2)--'00' --CATEGORY 4 CODE
--                                       , SPACE(2)--'00' --BANK OPTION 5
--                                       , ''--case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end     --STAFF / RELATIVE
--                                       , '' -- staff_cd                  
--									   , '' --ALPHANUMERIC CODE 1 USER TEXT 1
--									   --changed by tushar on jan 09 2015
--                                        ,max(case when clic_mod_action = 'EMAIL STMT FLAG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end) else '' end)  --EMAIL_STATEMENT_FLAG            
--                                        ,max(case when clic_mod_action = 'CAS FLAG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'cas_flag',''),'')  =  'CAS NOT REQUIRED' OR  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')='YES' then 'NO' else 'PH' end )  else '' end) --cas_flag
--										--,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end  --CAS_MODE   
--										,max(case when clic_mod_action = 'mental_flag' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  IN ( 'NO') then 'N' else '' end) else '' end ) --CAS_MODE  
--										--,''            
--										,''--case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PDF',''),'')  ='CDSL' then 'C' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PDF',''),'')  ='NSDL'  then 'N' else '' end  --CAS_MODE  
--                                         --changed by tushar on jan 09 2015
--									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')='NO' THEN 'N' ELSE 'Y' END --RGESS FLAG
--									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')=0 THEN 'N' ELSE 'Y' END --RGESS FLAG
--									   ,max(case when clic_mod_action = 'RGESS FLAG' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')='NO' THEN 'N' ELSE 'Y' END) else '' end )--RGESS FLAG)
--									   --, '' --ANNUAL REPORT FLAG
--									   --, '' --PLEDGE STANDING INSTRUCTION FLAG
--									    , max(case when clic_mod_action = 'ANNUAL RPT FLG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'ELECTRONIC'     then '2'
--											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'PHYSICAL'     then '1'
--											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'BOTH'     then '3' else '' end) else '' end )
--									   ,max(case when clic_mod_action = 'PLEDGE STANDING INSTRUCTION FLG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PLEDGE_STANDING',''),'00')  = 'YES'     then 'Y' else 'N' end) else '' end )
--									   , max(case when clic_mod_action = 'RTA Email Flg' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RTA_EMAIL',''),'')='YES' THEN 'Y' ELSE 'N' END) else '' end )--'' --EMAIL RTA DOWNLOAD FLAG
--									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BSDA',''),'') ='NO' THEN 'N' ELSE 'Y' END--BSDA FLAG
--									   , max(case when clic_mod_action = 'BSDA FLAG' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BSDA',''),'') ='NO' THEN 'N' ELSE 'Y' END) else '' end)--BSDA FLAG
--									   , '' --ALPHANUMERIC CODE 2 USER TEXT 2
--									   , SPACE(4)--'0000' --dummy1
--									   , SPACE(4)--'0000' --dummy2
--									   , SPACE(4)--'0000' --dummy3           
--                                       , SPACE(2)--'00'--'' -- secur_acc_cd                  
----                                     , left(enttm_cd,2)  
--									   , SPACE(2)--'00' --BO CATEGORY
--                                       , ''--case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
--                                       --, isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
--                                       --, '' --DIVIDEND BANK IFS CODE
--                                       , max(case when clic_mod_action = 'BANK' then (case when banm_rtgs_cd in ('0','000000000')  then space(15) 
--                                              when  banm_rtgs_cd not in ('0','000000000')   then convert(char(15),banm_rtgs_cd)
--                                              else space(15) end ) else SPACE (15) end ) voice_mail
--                                       , max(case when clic_mod_action = 'RBI DETAILS' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RBI_REF_NO',''),'') else ''  end )    ---rbi refere no --CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'rbi_ref_no',''),'') ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') END  --rbi_ref_no                               
--                                       , max(case when clic_mod_action = 'RBI DETAILS' then isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') else SPACE(8) end) --rbi app dt--CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') ELSE  isnull(citrus_usr.fn_ucc_entpD(clim.clim_crn_no,'rbi_ref_no','rbi_app_dt',''),'00000000') END  --rbi_app_dt                               
--                                       , '' --isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no                              
--                                       --, citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                        
--									   , SPACE(2) --'00'--case when citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),'')) = '00' then space(2) else citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  end--benef_tax_ded_sta --modify by pankajon 10042013 for address modfication
--                                       --                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
----                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
----                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
--									   , '' --SMART CARD REQUIRED
--									   , '' --SMART CARD NUMBER
--									   , space(10)--'0000000000' -- smart pin
--                                       , ''--Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
--                                       , ''--Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
--                                       , SPACE(6)--'000000'--citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
--                                       , '' --GROUP CODE  
--                                       --, ''--citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') --, isnull(right(subcm.subcm_cd,2),'') --BO SUB STATUS                         --isnull(right(subcm.subcm_cd,2),'') --BO SUB STATUS                         
--									   ,MAX( case when clic_mod_action = 'SUB STATUS' then citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') else '' end)
--									   , SPACE(6)--'000000' --CLEARING CORPORATION ID
--									   , '' --CLEARING MEMBER ID
--									   , SPACE(2)--'00' --STOCK EXCHANGE

--                                       , max(case when clic_mod_action = 'CONF WAIVED FLAG' then 'Y' else '' end)--CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
----                                       ,isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TRADINGID_NO',''),'')           
--									   , '' --TRADING ID
--                                       , ''--citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
----                                       , case when banm_micr in ('0','000000000')  then space(12) 
----                                              --when  banm_micr not in ('0','000000000')   then isnull(banm_micr,space(12)) 
----											  when  banm_micr not in ('0','000000000')   then space(12) 
----                                              else space(12) end  
--									   , '' --BENF_BANK_CODE                
--                                       , ''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                  
--                                       , ''--isnull(cliba_ac_no ,'')                 
----                                       , '000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
--									   , SPACE(6) --'000000' -- BENF Bank CCY
--                                       , max(case when clic_mod_action = 'Bank' then (case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END) else '' end )--''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                                  
--                                       , max(case when clic_mod_action = 'Bank' then (case when banm_micr in ('0','000000000')  then space(12) 
--                                              when  banm_micr not in ('0','000000000')   then banm_micr 
--                                              else space(12) end) else '' end  )
--                                       , max(case when clic_mod_action = 'Bank' then (isnull(cliba_ac_no ,'')) else '' end )--''--isnull(cliba_ac_no ,'')                 
--                                       ,  SPACE(6) -- citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''--'000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                  

--                                  FROM   dp_acct_mstr              dpam                  
--                                         left outer join   
--										   dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
--										   left outer join                       
--										   client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    AND    isnull(cliba.cliba_deleted_ind,1)     = 1   AND isnull(cliba_flg,'0') IN ('1','3')                
--										   left outer join           
--                                           bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)            AND    isnull(banm.banm_deleted_ind,1)       = 1         
--                                       , client_mstr               clim                  
--                                       , entity_type_mstr          enttm        
--                                       , client_ctgry_mstr         clicm                  
--                                         left outer join                  
--                                         sub_ctgry_mstr            subcm                   
--                                         on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--                                         ,exch_seg_mstr  
--                                              , client_list_modified  climmod  
--                                  WHERE  dpam.dpam_crn_no            = clim.clim_crn_no                   
--                                  AND    dpam.dpam_enttm_cd          = enttm.enttm_cd                  
--                                  AND    dpam.dpam_clicm_cd          = clicm.clicm_cd        
--                                  AND    dpam.dpam_subcm_cd          = subcm.subcm_cd        
--                                  AND    isnull(dpam.dpam_batch_no,0) <> 0   
--                                  AND    dpam.dpam_crn_no            = clim.clim_crn_no        
--                                  AND    dpam.dpam_excsm_id      = excsm_id                  
--                                  AND    excsm_exch_cd           = @pa_exch  
--                                  --AND    cliba.cliba_clisba_id       = clisba.clisba_id                    
--                                  AND    dpam.dpam_deleted_ind       = 1                  
--                                  AND    isnull(dphd.dphd_deleted_ind,1)       = 1                   
--                                  AND    isnull(clim.clim_deleted_ind,1)       = 1                  
--                                  and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
--                                  --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--								  and    climmod.clic_mod_deleted_ind = 1              
--								  --AND   CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--								  AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--								  and	isnull(climmod.clic_mod_batch_no,0) = 0
--								  AND	  climmod.clic_mod_action in ('Bank','GENERAL','INCOME DETAILS','SUB STATUS','BSDA FLAG','RGESS FLAG','FST HOLDER UID','EMAIL STMT FLAG','CAS FLAG','CONF WAIVED FLAG','FST HOLDER DOB','RTA Email Flg','FST HOLDER GENDER','OCCUPATION','RBI DETAILS','PLEDGE STANDING INSTRUCTION FLG','ANNUAL RPT FLG')
--								  --and    climmod.clic_mod_action = @pa_mod_typ
--								  and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--								 group by  clim_crn_no                  
--                                       , dpam_sba_no  
								  
--  SELECT distinct dpam.dpam_crn_no   into #tmp06
--												FROM   dp_acct_mstr              dpam          
--												left outer join                  
--												dp_poa_dtls                   dppd                  
--												on dpam.dpam_id             = dppd.dppd_dpam_id                  
--												, client_mstr               clim                  
--												, entity_type_mstr          enttm                  
--												, client_ctgry_mstr         clicm                  
--														left outer join                  
--														sub_ctgry_mstr            subcm                   
--														on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--														,exch_seg_mstr  
--														 , client_list_modified  climmod  
--							WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                  
--							AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--							AND    isnull(dpam.dpam_batch_no,0) <> 0   
--							AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--							AND    dpam.dpam_excsm_id      = excsm_id                  
--						AND    excsm_exch_cd           = @pa_exch  
--						AND    dpam.dpam_deleted_ind   = 1                  
--						AND    clim.clim_deleted_ind   = 1  
--and	isnull(climmod.clic_mod_batch_no,0) = 0
--						AND    dppd.dppd_deleted_ind   =1   
--						AND    isnull(dppd.dppd_fname,'')  <> ''
--						--AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
--						and    dppd_eff_to_dt <= getdate()
--						--AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--						--AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
--						and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
--                        AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                        and    climmod.clic_mod_deleted_ind = 1
--                        AND	  climmod.clic_mod_action in ('POA DEACTIVATION','POA ACTIVATION')	
--                        --and    climmod.clic_mod_action = @pa_mod_typ	
--                        and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--                        print '11'							  
--                        select identity(numeric,1,1) id , dpam_crn_no into #tmp06_1 from #tmp06
--								  --select * into tmp_06072015 from #tmp06_2
--								  select @l_06cnt=  count(1) from #tmp06_1
								  
--								create index ix_11 on   #tmp06_1 (dpam_crn_no)
								
--                               insert into @line6(ln_no                   
--                                         ,crn_no                  
--                                         ,acct_no                  
--                                         ,poa_id                                    
--                                         ,setup_date                                
--                                         ,poa_to_opr_ac                             
--                                         ,gpa_bpa_fl                                
--                                         ,eff_frm_dt                                
--                                         ,eff_to_dt                                 
--                                         ,usr_fld1                                  
--                                         ,usr_fld2                                  
--                                         ,ca_charfld                                
--                                         ,bo_name3                                
--                                         ,bo_mid_name3                               
--                                         ,cust_srh_name3                            
--                                         ,bo_title3                                 
--                                         ,bo_suffix3                                
--                                         ,hldr_fth_hsb_nm3                          
--                                         ,cus_addr1                                 
--                                         ,cust_addr2                                
--                                         ,cust_addr3                                
--                                         ,cust_city                                 
--                                         ,cust__state                               
--                                         ,cust_cntry                                
--                                         ,cust_zip                                  
--                                         ,cust_ph1_ind                              
--                                         ,cust_ph1                                  
--                                         ,cust_ph2_ind                              
--                                         ,cust_ph2                                  
--                                         ,cust_addl_ph                              
--                                         ,cust_fax                                  
--                                         ,pan_no                                    
--                                         ,it_crc                                    
--                                         ,cust_email                                
--                                         ,bo3_usr_txt1                              
--                                         ,bo3_usr_txt2                              
--                                         ,bo3_usr_fld3                                  
--                                         ,bo3_usr_fld4                              
--                                         ,bo3_usr_fld5                  
--                                         ,sign_poa                  
--                                         ,sign_file_fl)                  
--                                        SELECT distinct '06'                  
--												,clim_crn_no                  
--												,isnull(dpam.dpam_sba_no,'')                  
----												,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id--isnull(dppd_poa_id,replicate(0,16)) dppd_poa_id              
----												,convert(char(11),dppd_setup)    
--												--, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then  convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID()) ELSE '0' END)--''	
--												, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then 'M' + CONVERT(varchar, convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID())) ELSE '0' END)--''	
--												,convert(char(11),getdate())         
--												,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
--												,dppd_gpabpa_flg  
--												,convert(char(11), getdate()) --,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--												,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--												,'0000'--''--usr_fld1                                  
--                                               ,'0000'--''--usr_fld2                                  
--                                                ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end--,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,''--isnull(dppd.dppd_fname,'') 
--                                               ,''--isnull(dppd.dppd_mname,'')                         
--                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
--                                               ,''--bo_title3                                 
--                                               ,''--bo_suffix3                                
--                                               ,''--isnull(dppd.dppd_fthname,'')                              
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
--                                               ,''--cust_ph2_ind                              
--                                               ,''  
--                                               ,''  
--                                               ,''  
--                                               ,''--dppd_pan_no  
--                                               ,''  
--                                               ,''  
--                                               ,isnull(dppd_master_id,'0')
--                                               ,''--bo3_usr_txt2                              
--                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
--													WHEN dppd_hld = '2nd holder' THEN  '0002'
--													WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
----												,'0000'--''--bo3_usr_fld4   
--												--,'M'                           
--												, case when clic_mod_action = 'POA DEACTIVATION' then 'D' when clic_mod_action =  'POA ACTIVATION'  then 'S' else  'M' end
--												,'0000'--''--bo3_usr_fld5                         
--												,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
----												,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
--												,''
--												FROM   dp_acct_mstr              dpam          with(nolock) 
--												left outer join                  
--												dp_poa_dtls                 dppd                with(nolock)   
--												on dpam.dpam_id             = dppd.dppd_dpam_id                  
--												, client_mstr                clim             with(nolock)     
--												, entity_type_mstr          enttm                  
--												, client_ctgry_mstr         clicm                  
--														left outer join                  
--														sub_ctgry_mstr            subcm                   
--														on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--														,exch_seg_mstr  
--														 , client_list_modified  climmod  ,#tmp06 t
--							WHERE  dpam.dpam_crn_no        = clim.clim_crn_no       and    t.dpam_crn_no=dpam.dpam_crn_no        
--							AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--							AND    isnull(dpam.dpam_batch_no,0) <> 0   
--							AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--							AND    dpam.dpam_excsm_id      = excsm_id                  
--						AND    excsm_exch_cd           = @pa_exch  
--						AND    dpam.dpam_deleted_ind   = 1                  
--						AND    clim.clim_deleted_ind   = 1  
--						AND    dppd.dppd_deleted_ind   =1   
--						AND    isnull(dppd.dppd_fname,'')  <> ''
--						--AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
--						AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--						and    dppd_eff_to_dt <> '1900-01-01 00:00:00.000'
--						--AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--						AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
--						and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
--                        AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                        and    climmod.clic_mod_deleted_ind = 1
--                        AND	  climmod.clic_mod_action in ('POA DEACTIVATION')
--                        --and    climmod.clic_mod_action = @pa_mod_typ
--                        and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--						and	isnull(climmod.clic_mod_batch_no,0) = 0
--						and not exists(select 1 from dps8_pc5 where MasterPOAId = dppd_master_id and boid = DPAM_SBA_NO and HolderNum = case when ltrim(rtrim(DPPD_HLD)) = '1ST HOLDER' then '1' when ltrim(rtrim(DPPD_HLD)) = '2ND HOLDER' then '2' else '3' end and TypeOfTrans in ('','1') AND	  climmod.clic_mod_action in ('POA ACTIVATION'))
						
--						UNION 
--						  SELECT distinct '06'                  
--												,clim_crn_no                  
--												,isnull(dpam.dpam_sba_no,'')                  
----												,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id--isnull(dppd_poa_id,replicate(0,16)) dppd_poa_id              
----												,convert(char(11),dppd_setup)    
--												--, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID()) ELSE '0' END)--''	
--												, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then 'M' + CONVERT(varchar, convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID())) ELSE '0' END)--''	
--												,convert(char(11),getdate())         
--												,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
--												,dppd_gpabpa_flg  
--												,convert(char(11), getdate()) --,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--												,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--												,'0000'--''--usr_fld1                                  
--                                               ,'0000'--''--usr_fld2                                  
--                                                ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end--,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
--                                               ,''--isnull(dppd.dppd_fname,'') 
--                                               ,''--isnull(dppd.dppd_mname,'')                         
--                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
--                                               ,''--bo_title3                                 
--                                               ,''--bo_suffix3                                
--                                               ,''--isnull(dppd.dppd_fthname,'')                              
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
--                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
--                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
--                                               ,''--cust_ph2_ind                              
--                                               ,''  
--                                               ,''  
--                                               ,''  
--                                               ,''--dppd_pan_no  
--                                               ,''  
--                                               ,''  
--                                               ,isnull(dppd_master_id,'0')
--                                               ,''--bo3_usr_txt2                              
--                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
--													WHEN dppd_hld = '2nd holder' THEN  '0002'
--													WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
----												,'0000'--''--bo3_usr_fld4   
--												--,'M'                           
--												, case when clic_mod_action = 'POA DEACTIVATION' then 'D' when clic_mod_action =  'POA ACTIVATION'  then 'S' else  'M' end
--												,'0000'--''--bo3_usr_fld5                         
--												,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
----												,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
--												,''
--												FROM   dp_acct_mstr              dpam          with(nolock) 
--												left outer join                  
--												dp_poa_dtls                 dppd                with(nolock)   
--												on dpam.dpam_id             = dppd.dppd_dpam_id                  
--												, client_mstr                clim             with(nolock)     
--												, entity_type_mstr          enttm                  
--												, client_ctgry_mstr         clicm                  
--														left outer join                  
--														sub_ctgry_mstr            subcm                   
--														on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--														,exch_seg_mstr  
--														 , client_list_modified  climmod  ,#tmp06 t
--							WHERE  dpam.dpam_crn_no        = clim.clim_crn_no       and    t.dpam_crn_no=dpam.dpam_crn_no        
--							AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--							AND    isnull(dpam.dpam_batch_no,0) <> 0   
--							AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--							AND    dpam.dpam_excsm_id      = excsm_id                  
--						AND    excsm_exch_cd           = @pa_exch  
--						AND    dpam.dpam_deleted_ind   = 1                  
--						AND    clim.clim_deleted_ind   = 1  
--						AND    dppd.dppd_deleted_ind   =1   
--						AND    isnull(dppd.dppd_fname,'')  <> ''
--						--AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
--						and    dppd_eff_to_dt = '1900-01-01 00:00:00.000'
--						--AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--						AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
--						and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
--                        AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                        and    climmod.clic_mod_deleted_ind = 1
--                        AND	  climmod.clic_mod_action in ('POA ACTIVATION')
--                        --and    climmod.clic_mod_action = @pa_mod_typ
--                        and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--						and	isnull(climmod.clic_mod_batch_no,0) = 0
--						and not exists(select 1 from dps8_pc5 where MasterPOAId = dppd_master_id and boid = DPAM_SBA_NO and HolderNum = case when ltrim(rtrim(DPPD_HLD)) = '1ST HOLDER' then '1' when ltrim(rtrim(DPPD_HLD)) = '2ND HOLDER' then '2' else '3' end and TypeOfTrans in ('','1') AND	  climmod.clic_mod_action in ('POA ACTIVATION'))
						
--                           --update bitmap_ref_mstr set bitrm_values=bitrm_values + convert(varchar,@l_06cnt ) where BITRM_PARENT_CD = 'POAID_AUTO'  
                 
                 
--                                 insert into  @line7(ln_no                                    
--                                  ,crn_no                   
--                                  ,acct_no                  
--                                  ,Purpose_code                             
--                                  ,bo_name                  
--                                  ,bo_middle_nm                             
--                                  ,cust_search_name                         
--                                  ,bo_title                                 
--                                  ,bo_suffix                                
--                                  ,hldr_fth_hs_name                         
--                                  ,cust_addr1                               
--                                  ,cust_addr2                               
--                                  ,cust_addr3                                                         
--                                  ,cust_city                                
--                                  ,cust_state                               
--                                  ,cust_cntry                               
--                                  ,cust_zip                                 
--                                  ,cust_ph1_id                              
--                                  ,cust_ph1                                 
--                                  ,cust_ph2_in                              
--                                  ,cust_ph2                                 
--                                  ,cust_addl_ph 
--								  ,dob                               
--                                  ,cust_fax                                 
--                                  ,hldr_in_tax_pan
--								  ,uid
--								  ,name_ch_reason_cd                          
--                                  ,it_crl                                   
--                                  ,cust_email                               
--                                  ,usr_txt1                                 
--                                  ,usr_txt2                                 
--                                  ,usr_fld3                                 
--                                  ,usr_fld4                                 
--                                  ,usr_fld5    
--                                   ,nom_serial_no
--									,rel_withbo
--									,sharepercent
--									,res_sec_flag      
									
--									,ln7_cust_adr_cntry_cd 
--									,ln7_cust_adr_state_cd 
--									,ln7_city_seq_no 
--									,ln7_Pri_mob_ISD 									                        
--                                  )                     
--                                   SELECT ln_no                                    
--                                  ,crn_no                   
--                                  ,acct_no                  
--								  ,Purpose_code                             
--                                  ,bo_name                  
--                                  ,bo_middle_nm                             
--                                  ,cust_search_name                         
--                                  ,bo_title                                 
--                                  ,bo_suffix                                
--                                  ,hldr_fth_hs_name                         
--                                  ,cust_addr1                               
--                                  ,cust_addr2                               
--                                  ,cust_addr3                                                         
--                                  ,cust_city                                
--                                  ,cust_state                               
--                                  ,cust_cntry                               
--                                  ,cust_zip                                 
--                                  ,''--cust_ph1_id                              
--                                  ,cust_ph1                                 
--                                  ,cust_ph2_in                              
--                                  ,cust_ph2                                 
--                                  ,cust_addl_ph
--								  ,dob                                
--                                  ,cust_fax                                 
--                                  ,hldr_in_tax_pan  
--								  ,uid
--								  ,name_ch_reason_cd                        
--                                  ,it_crl                                   
--                                  ,cust_email                               
--                                  ,usr_txt1                                 
--                                  ,usr_txt2                                 
--                                  ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
--                                  ,CASE WHEN usr_fld4='0' THEN '0000' ELSE usr_fld4 END                                  
--                                  ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END 
--                                   ,nom_serial_no
--									,case when rel_withbo = ''then space (2) else rel_withbo end rel_withbo
--									,sharepercent
--									,res_sec_flag   ,ln7_cust_adr_cntry_cd,ln7_cust_adr_state_cd,ln7_city_seq_no,ln7_Pri_mob_ISD        
--                                  FROM  client_list_modified  climmod ,
--								  citrus_usr.fn_cdsl_export_line_7_extract_newversion_mod(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm   
--								  --citrus_usr.fn_cdsl_export_line_7_extract_newversion(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm   
--                                  WHERE dpam_acct_no = acct_no AND dpam_excsm_id =  excsm_id 
--                                  AND   excsm_exch_cd = @pa_exch
--                                  AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                                  and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
--								  and    climmod.clic_mod_deleted_ind = 1
--								  and	isnull(climmod.clic_mod_batch_no,0) = 0
--								  --and    climmod.clic_mod_action = @pa_mod_typ
--								  and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--                                  ORDER BY Purpose_code  DESC 
                                            
                                            
--                                               INSERT INTO  @line8 (ln_no               
--														,crn_no            
--														,acct_no                    
--														,purposecode           
--														,flag                   
--														,mobile                      
--														,email                  
--														,remarks                  
--														,push_flg                      
--												)    
--											SELECT distinct '08'                  
--														,dpam_crn_no                  
--														,dpam_acct_no                  
--														,'16' --''--Purpose_code                             
--														--,'S'
--														--,CASE WHEN not exists (select 1 from client_main_properties where cmp_accp_clisba_id = dpam_id ) THEN 'S' ELSE 'M' END
--														--,CASE WHEN not exists (select 1 from client_main_properties where BOid = DPAM_SBA_NO and mobile_no <> '' and  PurposeCode = '16') THEN 'S' ELSE 'M' END
--														--,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')
--																				--ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END
														
--														--,CASE WHEN (select mobile_no from client_main_properties where dpam_sba_no = BOid) <> (SELECT CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS'))
--														--THEN (CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')
--														--						ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END) ELSE '' END
														
--														--,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')<> '' THEN ISNULL(lower(CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')),'')
--																				--ELSE ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'') END 
--														--,CASE WHEN not exists (select 1 from dps8_pc16 where BOid = DPAM_SBA_NO and MobileNum <> '' and  PurposeCode16 = '16') THEN 'S' ELSE 'M' END
--														,case when clic_mod_action = 'MOBILE SMS DELETE' then 'D' else (CASE WHEN exists (select 1 from dps8_pc16 where BOid = DPAM_SBA_NO and MobileNum <> '' and  PurposeCode16 = '16' and (TypeOfTrans = '1' or TypeOfTrans = '2' or TypeOfTrans = '')) THEN 'M' ELSE 'S' END) end
																		
--													    ,case when clic_mod_action = 'MOBILE SMS DELETE' then REPLICATE('@',10) else (CASE WHEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')<> '' THEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')																				
--													    ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END ) END
--														,CASE WHEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')<> '' THEN ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'')
--																				ELSE ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'') END 
														
--														--,CASE WHEN (select SmsEmailId from client_main_properties where dpam_sba_no = BOid) <> (SELECT ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'')) then
--														--  (CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')<> '' THEN ISNULL(lower(CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')),'')
--														--						ELSE ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'') END) ELSE '' END 
--														,''
--														,case when clic_mod_action = 'MOBILE SMS DELETE' then '@' else 'P' end
--														FROM   dp_acct_mstr              dpam ,client_list_modified  climmod   ,account_properties accp,EXCH_SEG_MSTR esm      , @crn                       crn           
--															WHERE 
--															    dpam.dpam_sba_no       = crn.acct_no 
--															AND   dpam_excsm_id = excsm_id 
--															AND   accp_clisba_id = dpam_id
--															AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
--															--AND    isnull(dpam.dpam_batch_no,0) = 0
--															AND    accp.accp_value = '1'-- and 1 = 0 
--															AND   excsm_exch_cd = @pa_exch
--															 AND dpam_excsm_id =  excsm_id 
--															-- and    DPAM_DPM_ID = @L_DPM_ID     
--															--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
--														 --AND     CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                      
--														 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                                                     and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
--                                                     AND	  climmod.clic_mod_action in ('MOBILE SMS','MOBILE SMS DELETE')
--                                                     --and    climmod.clic_mod_action = @pa_mod_typ
--                                                     and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
--                                                     and	isnull(climmod.clic_mod_batch_no,0) = 0
--                                                    and    climmod.clic_mod_deleted_ind = 1
                                                    




                                         
--									--                  
--      END                  
--      ELSE 
	  IF @pa_crn_no <> ''                  
      BEGIN                  
      --    
 
                 
        insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no                  
                           ,product_number                       
                           ,bo_name                              
                           ,bo_middle_name                       
                           ,cust_search_name                     
                           ,bo_title                             
                           ,bo_suffix                            
                           ,hldr_fth_hsd_nm                      
                           ,cust_addr1                           
                           ,cust_addr2                           
                           ,cust_addr3                           
                           ,cust_addr_city                       
                           ,cust_addr_state                      
                           ,cust_addr_cntry                      
                           ,cust_addr_zip                        
                           ,cust_ph1_ind                         
                           ,cust_ph1                             
                           ,cust_ph2_ind                         
                           ,cust_ph2                             
                           ,cust_addl_ph                         
                           ,cust_fax                             
                           ,hldr_pan
						   ,cust_uid --new added pankaj	
						   ,name_ch_reason_cd                             
                           ,it_crl                               
                           ,cust_email                           
                           ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                         
                           ,bo_user_fld5                   
                           ,sign_bo                                   
                           ,sign_fl_flag,sign_old_bo,Borequestdt
                            ,cust_adr_cntry_cd  
							,cust_state_code 
							,city_seq_no 
							,Smart 
							,Pri_mob_ISD 
							,Sec_mobile 
							,Sec_mob_ISD 
                           )                  
                           SELECT distinct '02'                  
                                , clim_crn_no                  
                                , dpam_sba_no--dpam_acct_no                  
                                --, MAX(case when subcm_cd = '082104' then '0001' else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') end) --product no   --As per latesh sir suggested on 16/08/2013
                                , MAX(citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0')) --product no   --As per latesh sir suggested on 16/08/2013
                                --, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no                 
                                --, citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0')
                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME1 else '' end )--'' --bo name
                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME2 else '' end )--'' --bo middle name
                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then CLIM_NAME3 else '' end )--'' -- bo seach name
                                , MAX(case when clic_mod_action = 'CLIENT SALUTATION' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SLT',''),'') else '' end)--, '' --MAX(case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end)  --bo title
                                , '' --bo suffix                 
                                ,MAX(case when clic_mod_action = 'F FATHERNAMECHANGE' then ISNULL(dphd_fh_fthname,'') else '' end)  --father/husband name                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) --end --adr1                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) --end--adr2                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3)-- end--adr3                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) --end--adr_city                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) --end--adr_state                  
                                --, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) --end--adr_country                  
                                --, replace(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7),' ','') --end --adr_zip                
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) else '' end)--end --adr1                  
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) else '' end)--end--adr2                  
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3) else '' end) -- end--adr3                  
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) else '' end)--end--adr_city                  
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) else '' end)--end--adr_state                  
                                ,MAX(case when clic_mod_action = 'C Address' then  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) else '' end)--end--adr_country                  
                                ,MAX(replace(case when clic_mod_action = 'C Address' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7)else '' end,' ','')) --end --adr_zip                
                                --, MAX(case when clic_mod_action = 'First MobileNo' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'') else '' end)  --CUST PH 1 INDC
                                --, MAX(case when clic_mod_action = 'First MobileNo' then isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') else '' end)  --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                ----, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
                                --, MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',1) else case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') = '' then '' else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'') end  end else '' end) --'0' CUST PH 2 INDC                 
                                --, MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',17) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') end else '' end)  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                --, MAX(case when clic_mod_action in ('First ResidenceNo','First ResidenceNo Delete') then  case when clic_mod_action = 'First ResidenceNo Delete' then replicate('@',100) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'') end else '' end)  --CUST ADDL PHONE             
                                ,MAX(case when clic_mod_action in ('First MobileNo','First MobileNo Delete') then  case when clic_mod_action = 'First MobileNo Delete' then replicate('@',1) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')end else '' end)  --CUST PH 1 INDC
                                , MAX(case when clic_mod_action in ('First MobileNo','First MobileNo Delete')  then  case when clic_mod_action = 'First MobileNo Delete' then replicate('@',17) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'') end else '' end) --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
                                --, isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
                                , MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',1) else case when isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') = '' then '' else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'') end  end else '' end) --'0' CUST PH 2 INDC                 
                                , MAX(case when clic_mod_action in ('First OfficeNo','First OfficeNo Delete') then case when clic_mod_action = 'First OfficeNo Delete' then replicate('@',17) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'') end else '' end)  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
                                , MAX(case when clic_mod_action in ('First ResidenceNo','First ResidenceNo Delete') then  case when clic_mod_action = 'First ResidenceNo Delete' then replicate('@',100) else isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'') end else '' end)  --CUST ADDL PHONE             
                                , MAX(case when clic_mod_action = 'Contacts' then CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END else '' end) --fax                  
                                --, MAX(case when clic_mod_action in ('CLIENT MAIN PROPERTIES','GENERAL') then isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') else  '' end)  --pan card                  
								, MAX(case when (clic_mod_action in ('PAN DETAILS') and ISNULL(clic_mod_pan_no,'')='' ) then isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') else  '' end)  --pan card                  
                                , MAX(case when clic_mod_action in ('FST HOLDER UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') else '' end)--UID
                                , MAX(case when clic_mod_action = 'FST HOLDER NAME' then isnull (nmcrcd_reason_cd,'') else '' end ) 
								, '' --IT CIRCLE
                                , MAX(case when clic_mod_action in ('First EmailId','First EmailId Delete') then case when clic_mod_action = 'First EmailId Delete' then replicate('@',50) else CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END end else '' end) --email                  
                                , '' --USER TEXT 1                 
                                , '' --USER TEXT 2                 
                                , '0000' --USER FIELD 3                  
                                , ''                  
                                , MAX(case when clic_mod_action in ('CLIENT MAIN PROPERTIES') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'  
								 when clic_mod_action in ('PAN DETAILS') then case when isnull(clic_mod_pan_no,'') <> '' then isnull(clic_mod_pan_no,'') else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'   
								else '' end)              
                                , MAX(case when clic_mod_action = 'SIGNATURE' then ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')  else '' end)                 
								--, case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end --signature file flag                  
                                --, ''      
								--, case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'') = '' then 'N' else 'Y'   end --signature file flag                  
								 , MAX(case when clic_mod_action = 'SIGNATURE' then case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end else '' end )--signature file flag                  
								 --,MAX(case when clic_mod_action = 'SIGNATURE' then replace(ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'') ,'B'+dpam_sba_no,'') else '' end)    --ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'')
								 --,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/KJ94.BMP' END )
								 ,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/'+ ISNULL ([citrus_usr].[fn_sing_old_name](dpam.dpam_sba_no),'') else '' end)
								 ,max(REPLACE(CONVERT(VARCHAR(10), clic_mod_created_dt, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), clic_mod_created_dt, 114),':','') ,6))

								 ,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'')else '' end)-- addr cntry code
,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'')else '' end) -- state code
,max(case when clic_mod_action ='C ADDRESS' then isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' )else '' end)-- city seq no
,max(case when clic_mod_action = 'SMART REGISTRATION' then case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'') = 'YES' then 'Y' else 'N'end else '' end) 
,max(case when clic_mod_action = 'First MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) else space(6) END) else '' end)
,max(case when clic_mod_action = 'Second MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END)else '' end)
,max(case when clic_mod_action = 'Second MobileNo' then (CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) else space(6) END) else '' end)

                           FROM   dp_acct_mstr              dpam                  
                                  left outer join      
                                  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                  --left outer join    
                                  --client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                  --left outer join           
                                  --bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                  left outer join 
                                  name_change_reason_cd     nmcrc  on dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
                                  and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
									--and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
									and    nmcrc.nmcrcd_deleted_ind = 1
                                , client_mstr               clim                  
                                , entity_type_mstr          enttm                  
                                , client_ctgry_mstr         clicm                  
                                , sub_ctgry_mstr            subcm                   
                                , exch_seg_mstr             excsm  
                                , client_list_modified  climmod 
                                --, name_change_reason_cd nmcrc
								, @crn                       crn  ,dps8_pc1
                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                    and boid = dpam_sba_no
                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd
						   AND    crn.crn                  = clim.clim_crn_no              
						   --and    dpam.dpam_acct_no       = crn.acct_no 
						   and    (dpam.DPAM_SBA_NO       = crn.acct_no or dpam.DPAM_acct_NO       = crn.acct_no) 
						   AND    dpam.dpam_deleted_ind   = 1                  
                           AND    dpam.dpam_excsm_id      = excsm_id                  
                           AND    isnull(dpam.dpam_batch_no,0) <> 0   
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
                           AND    subcm.subcm_deleted_ind = 1                  
                           AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                           --AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                           --AND    isnull(banm.banm_deleted_ind,1)   = 1 
                           and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then PANGIR else '0' end = clic_mod_pan_no)              
                           --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                           AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                           and    climmod.clic_mod_deleted_ind = 1
                           and	isnull(climmod.clic_mod_batch_no,0) = 0
						   AND	  climmod.clic_mod_action in ('C Address','Client Main Properties','General','Signature','PAN DETAILS','First MobileNo','First ResidenceNo','First OfficeNo','First EmailId','First EmailId Delete','First MobileNo Delete','First ResidenceNo Delete','First OfficeNo Delete','FST HOLDER NAME','F FATHERNAMECHANGE','CLIENT SALUTATION','FST HOLDER UID','SMART REGISTRATION')
						   --and    climmod.clic_mod_action = @pa_mod_typ
						   and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
						   --and    nmcrc.nmcrcd_crn_no = dpam.dpam_crn_no
         --                  and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
						   --and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no 
						   --and    nmcrc.nmcrcd_deleted_ind = 1
						   GROUP BY DPAM_ID,CLIM_CRN_NO,DPAM_CRN_NO, DPAM_SBA_NO
                           

                          insert into @line2( ln_no                  
                           ,crn_no                  
                           ,acct_no                  
                           ,product_number                       
                           ,bo_name                              
                           ,bo_middle_name                       
                           ,cust_search_name                     
                           ,bo_title                             
                           ,bo_suffix                            
                           ,hldr_fth_hsd_nm                      
                           ,cust_addr1                           
                           ,cust_addr2                           
                           ,cust_addr3                           
                           ,cust_addr_city                       
                           ,cust_addr_state                      
                           ,cust_addr_cntry                      
                           ,cust_addr_zip                        
                           ,cust_ph1_ind                         
                           ,cust_ph1                             
                           ,cust_ph2_ind                         
                           ,cust_ph2                             
                           ,cust_addl_ph                         
                           ,cust_fax                             
                           ,hldr_pan
						   ,cust_uid --new added pankaj
						   ,name_ch_reason_cd	                             
                           ,it_crl                               
                           ,cust_email                           
                           ,bo_usr_txt1                          
                           ,bo_usr_txt2                          
                           ,bo_user_fld3                         
                           ,bo_user_fld4                         
                           ,bo_user_fld5                   
                           ,sign_bo                                   
                           ,sign_fl_flag,sign_old_bo,Borequestdt
                           
                           ,cust_adr_cntry_cd  
							,cust_state_code 
							,city_seq_no 
							,Smart 
							,Pri_mob_ISD 
							,Sec_mobile 
							,Sec_mob_ISD 
                           )                  
                          SELECT distinct '02'                  
										, '0'--clim_crn_no                  
										, dpam_sba_no--dpam_acct_no                  
										--, case when subcm_cd = '082104' then '0001' else citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') end --product no   --As per latesh sir suggested on 16/08/2013
										, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no   --As per latesh sir suggested on 16/08/2013
										--, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no                 
										--, citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0')
										, '' --bo name
										, '' --bo middle name
										, '' -- bo seach name
										, ''--case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end  --bo title
										, '' --bo suffix                 
										, ''--ISNULL(dphd_fh_fthname,'')  --father/husband name                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) --end --adr1                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) --end--adr2                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3)-- end--adr3                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) --end--adr_city                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) --end--adr_state                  
										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) --end--adr_country                  
										, ''--replace(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7),' ','') --end --adr_zip                
										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  --CUST PH 1 INDC
										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')  --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')  --CUST ADDL PHONE             
										, ''--CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                  
										, ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
										, ''--isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') --UID 
										, ''--name change reason code
										, '' --IT CIRCLE
										, ''--CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                  
										, '' --USER TEXT 1                 
										, '' --USER TEXT 2                 
										, space(4) --USER FIELD 3                  
										, ''                  
										, ''--case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
										, ''--ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
										, ''--case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end --signature file flag                  
										--,replace(ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'') ,'B'+dpam_sba_no,'')     --ISNULL(citrus_usr.fn_ucc_doc_old(dpam_id,'SIGN_BO',''),'')
										--,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/KJ94-' END )
										,MAX(case when clic_mod_action = 'SIGNATURE' then '../CCRSDocuments/'+ ISNULL ([citrus_usr].[fn_sing_old_name](dpam.dpam_sba_no),'') else '' end)
										,max(REPLACE(CONVERT(VARCHAR(10), clic_mod_created_dt, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), clic_mod_created_dt, 114),':','') ,6))
										
								,''--max(isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6 )),'') )-- addr cntry code
								,''--max(isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5 )),'')) -- state code
								,''--max(isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4)),'' ))-- city seq no
								,''--max(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_REG',''),'')  )
								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) else space(6) END)
								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secmob'),'')) else space(17) END)
								,''--max(CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'secic'),'')) else space(6) END)
										
                           FROM   dp_acct_mstr              dpam                  
                                --  left outer join      
                                --  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                --  left outer join    
                                --  client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                --  left outer join           
                                --  bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
         --                       left outer join 
         --                         name_change_reason_cd     nmcrc  on dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
         --                         and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
									----and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
									--and    nmcrc.nmcrcd_deleted_ind = 1
                                , client_mstr               clim                  
                                , entity_type_mstr          enttm                  
                                , client_ctgry_mstr         clicm                  
                                , sub_ctgry_mstr            subcm                   
                                , exch_seg_mstr             excsm  
                                , client_list_modified  climmod 
                                --, name_change_reason_cd nmcrc
								, @crn                       crn  ,dps8_pc1 
                           WHERE  dpam.dpam_crn_no        = clim.clim_crn_no and boid = dpam_sba_no                    
                           AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                           AND    dpam.dpam_clicm_cd      = clicm.clicm_cd
						   AND    crn.crn                  = clim.clim_crn_no              
						   and    dpam.DPAM_SBA_NO       = crn.acct_no 
						   AND    dpam.dpam_deleted_ind   = 1                  
                           AND    dpam.dpam_excsm_id      = excsm_id                  
                           AND    isnull(dpam.dpam_batch_no,0) <> 0   
                           AND    excsm_exch_cd           = @pa_exch  
                           AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
                           AND    subcm.subcm_deleted_ind = 1                  
                          -- AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                           AND    clim.clim_deleted_ind   = 1                  
                          -- AND    isnull(cliba.cliba_deleted_ind,1) = 1 
and	isnull(climmod.clic_mod_batch_no,0) = 0                 
                          -- AND    isnull(banm.banm_deleted_ind,1)   = 1 
                           and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then PANGIR else '0' end = clic_mod_pan_no)              
--                           --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                           AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                           and    climmod.clic_mod_deleted_ind = 1
         --                  and    nmcrc.nmcrcd_crn_no = dpam.dpam_crn_no
						   --and    nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
					    --   and    nmcrc.nmcrcd_crn_no = clim.clim_crn_no
					       --and    nmcrc.nmcrcd_deleted_ind = 1
--						   AND	  climmod.clic_mod_action in ('C Address','Client Main Properties','General','Signature')
--                          
and not exists (select 1 from @line2 o where o.acct_no = dpam_sba_no and o.crn_no  = clim_crn_no )
group by DPAM_SBA_NO,SUBCM_CD,DPAM_ID


insert into @line3(ln_no                   
                                     ,crn_no                   
                                     ,acct_no                  
                                     ,bo_name1                                
                                     ,bo_mid_name1                            
                                     ,cust_search_name1                       
                                     ,bo_title1                               
                                     ,bo_suffix1                              
                                     ,hldr_fth_hsd_nm1                        
                                     ,hldr_pan1
									 ,cust_uid1
									 ,cust_name_ch_code1		                                
                                     ,it_crl1
                                      ,sh_mob
                                      ,sh_email
									  ,sh_mob_phone_isd
									  )                  
                                     SELECT distinct '03'                  
                                                  ,clim_crn_no                  
                                                  ,dpam_sba_no                  
												  ,case when clic_mod_action = 'SH NameChange' then isnull(dphd_sh_fname,'') else '' end 
												  ,case when clic_mod_action = 'SH NameChange' then isnull(dphd_sh_mname,'') else '' end
												  ,case when clic_mod_action = 'SH NameChange' then (case when isnull(dphd_sh_lname,'')='' then '.' else isnull(dphd_sh_lname,'.') end) else '' end --isnull(dphd_sh_lname,'')                      
                                                  ,case when clic_mod_action = '2nd Holder Title' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SEC_HLD_TITLE',''),'') else '' end--, ''         -- then (case when DPHD_SH_GENDER in ('M','MALE') then 'MR'  when DPHD_SH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end) else '' end                            --,case when clic_mod_action = 'SH GenderChange' then (case when DPHD_SH_GENDER in ('M','MALE') then 'MR'  when DPHD_SH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end) else '' end                            
                                                  ,case when clic_mod_action = '2nd Holder Suffix' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SEC_HLD_SUFFIX',''),'') else '' end--, ''         
                                                  ,case when clic_mod_action = 'SH FatherNameChange' then ISNULL(DPHD_SH_FTHNAME,'') else '' end--''--isnull(dphd_sh_fthname,'')                  
                                                  ,case when clic_mod_action = 'SH PANChange' then DPHD_SH_PAN_NO else '' end --''--isnull(dphd_sh_pan_no,'')                  
												  ,  case when clic_mod_action in ('SEC HOLDER UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARSECHLDR',''),'') else ''  end --''--''
												  ,case when clic_mod_action = 'SH NameChange' then isnull (nmcrcd_reason_cd,'') else '' end     --name change code
                                                  , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle                  
                                                  ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_MOB'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_EMAIL1'),''))
,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'secmic'),'')
                                      FROM   dp_acct_mstr              dpam  
											 left outer join
											 name_change_reason_cd     nmcrc   
											 on nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
											 --and   nmcrc.nmcrcd_crn_no = clim.clim_crn_no
											 and nmcrc.nmcrcd_deleted_ind = 1  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
											 and dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
											 and upper(nmcrc.nmcrcd_holder_type) = 'IIND HOLDER'	                
                                             left outer join   
                                             dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                             left outer join                       
                                             client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                             left outer join           
                                             bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                           , client_mstr               clim                  
                                           , entity_type_mstr         enttm                  
                                           , client_ctgry_mstr         clicm                  
                                             left outer join                  
                                             sub_ctgry_mstr            subcm                   
                                             on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                           ,exch_seg_mstr 
                                           , client_list_modified  climmod 
										   , @crn                   crn 
                                      WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
                                      AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                      AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                      AND    dpam.dpam_deleted_ind   = 1    
									  AND    crn.crn                = clim.clim_crn_no
									  and    dpam.dpam_sba_no       = crn.acct_no              
                                      AND    isnull(dpam.dpam_batch_no,0) <> 0   
                                      AND    dpam.dpam_excsm_id      = excsm_id                  
                                      AND    excsm_exch_cd           = @pa_exch  
                                      AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                      AND    clim.clim_deleted_ind   = 1                  
                                      AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                      AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                      --AND    isnull(dphd.dphd_sh_fname,'') <> ''  
                                      and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                          
                                      --AND   CLIM_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59' 
									  AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
									  and	isnull(climmod.clic_mod_batch_no,0) = 0
									  AND   climmod.clic_mod_action in ('SH Address','SH NameChange','SH FatherNameChange','SH DOBChange','SH PANChange','SH GenderChange','SH MobChange','SH EmailChange','2nd Holder Suffix','2nd Holder Title','SEC HOLDER UID') 
									  and   climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end                        
									  and   climmod.clic_mod_deleted_ind = 1
                  
                  
                 
                insert into  @line4(ln_no                   
                                   ,crn_no                  
                                   ,acct_no                  
                                   ,bo_name2                  
                                   ,bo_mid_name2                  
                                   ,cust_search_name2                   
                                   ,bo_title2                           
                                   ,bo_suffix2                          
                                   ,hldr_fth_hsd_nm2                    
                                   ,hldr_pan2 
								   ,cust_uid2
								   ,cust_name_ch_code2                          
                                   ,it_crl2
                                   ,th_mob
                                   ,th_email
								   ,th_mob_phone_isd
								   )                   
                                   SELECT distinct '04'                  
                                               , clim_crn_no                  
                                               , dpam_sba_no                  
										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_fname,'') else '' end
										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_mname,'') else '' end    
										       ,case when clic_mod_action = 'TH NameChange' then isnull(dphd_Th_lname,'') else '' end               
                                               ,case when clic_mod_action = 'TH GenderChange' then (case when DPHD_TH_GENDER in ('M','MALE') then 'MR'  when DPHD_TH_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end) else '' end                               
                                               , ''                  
                                               ,case when clic_mod_action = 'TH FatherNameChange' then ISNULL(DPHD_TH_FTHNAME,'') else '' end
                                               ,case when clic_mod_action = 'TH PANChange' then DPHD_TH_PAN_NO else '' end --pan
											   ,case when clic_mod_action in ('Trd Holder UID') then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARTHRDHLDR',''),'') else ''  end --''--uid--''--uid
											   ,case when clic_mod_action = 'TH NameChange' then isnull (nmcrcd_reason_cd,'') else '' end     --name change code
                                               , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_IT',''),'')  --it circle                    
                                                ,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'th_mob'),'')
,lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_EMAIL1'),''))
,isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'THMIC'),'')
                                    FROM   dp_acct_mstr              dpam 
											left outer join
											 name_change_reason_cd     nmcrc   
										  	 on   nmcrc.nmcrcd_sba_no = dpam.DPAM_SBA_NO
										   	 --and   nmcrc.nmcrcd_crn_no = clim.clim_crn_no
										   and   nmcrc.nmcrcd_deleted_ind = 1  and nmcrcd_created_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
										   and  dpam.dpam_crn_no =  nmcrc.nmcrcd_crn_no
										   and	upper(nmcrc.nmcrcd_holder_type) = 'IIIRD HOLDER'                 
                                           left outer join   
                                           dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                           left outer join                       
                                           client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
                                           left outer join           
                                           bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
                                         , client_mstr               clim                  
                                         , entity_type_mstr          enttm                  
                                         , client_ctgry_mstr         clicm                  
                                           left outer join                  
                                           sub_ctgry_mstr            subcm                   
                                           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                         , exch_seg_mstr   
                                         , client_list_modified  climmod  
										 , @crn                   crn
                                    WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
                                    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                    AND    isnull(dpam.dpam_batch_no,0) <> 0   
									AND    crn.crn                = clim.clim_crn_no
									and    dpam.dpam_sba_no       = crn.acct_no  
                                    AND    dpam.dpam_deleted_ind   = 1            
                                    AND    dpam.dpam_excsm_id      = excsm_id                  
                                    AND    excsm_exch_cd           = @pa_exch  
                                    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                    AND    clim.clim_deleted_ind   = 1                  
                                    AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                    AND    isnull(banm.banm_deleted_ind,1)   = 1    
                                    AND    isnull(dphd.dphd_th_fname,'') <> ''  
                                    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
									AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
									and	isnull(climmod.clic_mod_batch_no,0) = 0
									AND    climmod.clic_mod_action in ('TH Address','TH MobChange','TH EmailChange','TH NameChange','TH FatherNameChange','TH DOBChange','TH PANChange','TH GenderChange','Trd Holder UID')     
									and   climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end                        
									and   climmod.clic_mod_deleted_ind = 1
                                    --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                       --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--                         and    climmod.clic_mod_deleted_ind = 1


                       insert into @line5( ln_no                   
                                          ,crn_no                              
                                          ,acct_no                  
                                          ,dt_of_maturity                      
                                          ,dp_int_ref_no                       
                                          ,dob                                 
                                          ,sex_cd                              
                                          ,occp                                
                                          ,life_style                          
                                          ,geographical_cd                     
                                          ,edu                                 
                                          ,ann_income_cd                       
                                          ,nat_cd             
                                          ,legal_status_cd                     
                                          ,bo_fee_type                         
                                          ,lang_cd                             
                                          ,category4_cd                        
                                          ,bank_option5                        
                                          ,staff                               
                                          ,staff_cd                            
                                          --,bo2_usr_txt1  
                                           ,bo2_usr_txt1                        
                                                         
									--changed by tushar on jan 09 2015
           								  ,EMAIL_STATEMENT_FLAG            
										  ,CAS_MODE   
										  ,MENTAL_DISABILITY                          
										  ,Filler1            
                                --changed by tushar on jan 09 2015
										  ,rgss_flg				--added by pankaj
										  ,annual_rpt_flg		--added by pankaj
										  ,pldg_std_inst_flg	--added by pankaj	
										  ,email_rta_down_flg	--added by pankaj
										  ,bsda_flg				
                                          ,bo2_usr_txt2                        
                                          ,dummy1                              
                                          ,dummy2                              
                                          ,dummy3                              
                                          ,secur_acc_cd                        
                                          ,bo_catg                             
                                          ,bo_settm_plan_fg                    
                                          ,voice_mail                          
                                          ,rbi_ref_no                          
                                          ,rbi_app_dt                          
                                          ,sebi_reg_no                         
                                          ,benef_tax_ded_sta                   
                                          ,smart_crd_req                       
                                          ,smart_crd_no                
                                          ,smart_crd_pin                       
                                          ,ecs                                 
                                          ,elec_confirm                                                                
                                          ,dividend_curr                       
										  ,group_cd                            
                                          ,bo_sub_status                       
                                          ,clr_corp_id                         
                                          ,clr_member_id                       
                                          ,stoc_exch                           
                                          ,confir_waived                       
                                          ,trading_id                          
                                          ,bo_statm_cycle_cd                   
                                          ,benf_bank_code                      
                                          ,benf_brnch_numb                     
                                          ,benf_bank_acno                      
                                          ,benf_bank_ccy                       
                                          ,divnd_brnch_numb                    
                                          ,divnd_bank_code                     
                                          ,divnd_acct_numb                     
                                          ,divnd_bank_ccy)                  
									   SELECT distinct '05'                  
                                       , clim_crn_no                  
                                       , dpam_sba_no                  
                                       --, case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000')= '' then '00000000' else isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'date_of_maturity',''),'00000000') end  --dt_of_maturity                  
                                       ,'' --DATE OF MATURITY
									   ,'' --left(dpam_acct_no,8)--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'dp_int_ref_no',''),'')  --dp_int_ref_no                  
                                       --, case when dpam_subcm_cd in ('2156','2155','2150','082104') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end                end
                                       ,max(case when clic_mod_action = 'FST HOLDER DOB' then (case when dpam_subcm_cd in ('2156','2155','2150') then case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'') = '' then '00000000' else isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',''),'00000000') end  else case when isnull(convert(varchar(11),clim.clim_dob,103),'00000000') = '01/01/1900' then '00000000' else   isnull(convert(varchar(11),clim.clim_dob,103),'00000000')  end   end) ELSE SPACE(8) END)
                                       --, isnull(clim.clim_gender,'')  --SEX CODE                
                                       --,case when citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') = '0004' then SPACE(1) else isnull(clim.clim_gender,'') end
                                       --,max(case when clic_mod_action = 'FST HOLDER GENDER' then (case when citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') = '0004' then SPACE(1) else isnull(clim.clim_gender,'') end) else '' end)
                                       ,max(case when SUBSTRING( dpam.dpam_subcm_cd, 1 , 2) = '01' then ( case when clic_mod_action = 'FST HOLDER GENDER' then (case when citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') = '0004' then SPACE(1) else isnull(clim.clim_gender,'') end) else '' end ) else '' end)
                                       --, ''--CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END --occupation          
                                       ,max(case when clic_mod_action = 'OCCUPATION' then (CASE WHEN citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) = '' THEN 'O' ELSE citrus_usr.fn_get_listing('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),'')) END)ELSE '' END) --occupation          
                                       , ''--LIFE STYLE  
                                       , ''--citrus_usr.fn_get_listing('GEOGRAPHICAL',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'GEOGRAPHICAL',''),''))   --geographical_cd                  
                                       , ''--citrus_usr.fn_get_listing('EDUCATION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'EDUCATION',''),''))    --edu                  
                                       --, SPACE(4) --'0000'--citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),''))--isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,''),'')   --ann_income_cd                  
									   ,max(case when clic_mod_action = 'INCOME DETAILS' then citrus_usr.fn_get_listing('ANNUAL_INCOME',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'ANNUAL_INCOME',''),'')) else '' end)
                                       , ''--citrus_usr.fn_get_listing('NATIONALITY',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'NATIONALITY',''),''))   --nat_cd                  
                                       --, CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'legal_sta',''),'00') END  --legal_status_cd                  
                                       , SPACE(2)--'00' --LEGAL STATUS CODE
                                       --, CASE WHEN citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype','')='' THEN '00' ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'bofeetype',''),'00') END    --bo_fee_type                  
                                       , SPACE(2)--'00' --BO FEE TYPE
                                       , SPACE(2)--'00'-- citrus_usr.fn_get_listing('LANGUAGE',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'LANGUAGE',''),''))    --lang_cd                  
                                       , SPACE(2)--'00' --CATEGORY 4 CODE
                                       , SPACE(2)--'00' --BANK OPTION 5
                                       , ''--case when dpam_clicm_cd in ('21' , '24' , '27') then  left(isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'STAFF',''),''),1) else '' end     --STAFF / RELATIVE
                                       , '' -- staff_cd                  
									   , '' --ALPHANUMERIC CODE 1 USER TEXT 1
									   --changed by tushar on jan 09 2015
                                        ,max(case when clic_mod_action = 'EMAIL STMT FLAG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end) else '' end)  --EMAIL_STATEMENT_FLAG            
                                        ,max(case when clic_mod_action = 'CAS FLAG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'cas_flag',''),'')  =  'CAS NOT REQUIRED' OR  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'Email_st_flag',''),'')='YES' then 'NO' else 'PH' end )  else '' end) --cas_flag
										--,case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' else 'N' end  --CAS_MODE   
										,max(case when clic_mod_action = 'mental_flag' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  NOT IN ( 'NO','') then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'mental_flag',''),'')  IN ( 'NO') then 'N' else '' end) else '' end ) --CAS_MODE  
										--,''            
										,''--case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PDF',''),'')  ='CDSL' then 'C' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PDF',''),'')  ='NSDL'  then 'N' else '' end  --CAS_MODE  
                                         --changed by tushar on jan 09 2015
									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')='NO' THEN 'N' ELSE 'Y' END --RGESS FLAG
									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')=0 THEN 'N' ELSE 'Y' END --RGESS FLAG
									   --,CASE WHEN isnull(citrus_usr.fn_ucc_accp(2723,'RGESS_FLAG',''),'')='NO' THEN '' ELSE 'Y' END --RGESS FLAG
									   ,max(case when clic_mod_action = 'RGESS FLAG' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RGESS_FLAG',''),'')='NO' THEN 'N' ELSE 'Y' END) else '' end )--RGESS FLAG
									   --, '' --ANNUAL REPORT FLAG
									   --, '' --PLEDGE STANDING INSTRUCTION FLAG
									    , max(case when clic_mod_action = 'ANNUAL RPT FLG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'ELECTRONIC'     then '2'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'PHYSICAL'     then '1'
											when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ANNUAL_REPORT',''),'00')  = 'BOTH'     then '3' else '' end) else '' end )
									   ,max(case when clic_mod_action = 'PLEDGE STANDING INSTRUCTION FLG' then (case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'PLEDGE_STANDING',''),'00')  = 'YES'     then 'Y' else 'N' end) else '' end )
									   , max(case when clic_mod_action = 'RTA Email Flg' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RTA_EMAIL',''),'')='YES' THEN 'Y' ELSE 'N' END) else '' end )--'' --EMAIL RTA DOWNLOAD FLAG
									   --, CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BSDA',''),'') ='NO' THEN 'N' ELSE 'Y' END--BSDA FLAG
									   ,max( case when clic_mod_action = 'BSDA FLAG' then (CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BSDA',''),'') ='NO' THEN 'N' ELSE 'Y' END) ELSE '' END)--BSDA FLAG
									   , '' --ALPHANUMERIC CODE 2 USER TEXT 2
									   , SPACE(4)--'0000' --dummy1
									   , SPACE(4)--'0000' --dummy2
									   , SPACE(4)--'0000' --dummy3           
                                       , SPACE(2)--'00'--'' -- secur_acc_cd                  
--                                     , left(enttm_cd,2)  
									   , SPACE(2)--'00' --BO CATEGORY
                                       , ''--case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bosettlflg',''),'')  <>  '' then 'Y' else 'N' end --bo_settm_plan_fg                  
                                       --, isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'voice_mail',''),'')  --voice_mail                               
                                       --, '' --DIVIDEND BANK IFS CODE
                                       , max(case when clic_mod_action = 'BANK' then (case when banm_rtgs_cd in ('0','000000000')  then space(15) 
                                              when  banm_rtgs_cd not in ('0','000000000')   then convert(char(15),banm_rtgs_cd)
                                              else space(15) end ) else SPACE (15) end )voice_mail 
                                              
--                                       , '' --CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'rbi_ref_no',''),'') ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') END  --rbi_ref_no                               
--                                       , SPACE(8)--rbi app dt--CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') ELSE  isnull(citrus_usr.fn_ucc_entpD(clim.clim_crn_no,'rbi_ref_no','rbi_app_dt',''),'00000000') END  --rbi_app_dt                               

                                       , max(case when clic_mod_action = 'RBI DETAILS' then isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'RBI_REF_NO',''),'') else ''  end )   ---rbi refere no --CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'rbi_ref_no',''),'') ELSE isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') END  --rbi_ref_no                               
                                       , max(case when clic_mod_action = 'RBI DETAILS' then isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') else SPACE(8) end) --rbi app dt--CASE WHEN isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'rbi_ref_no',''),'') = '' THEN isnull(citrus_usr.fn_ucc_accpD(dpam.dpam_id,'rbi_ref_no','rbi_app_dt',''),'00000000') ELSE  isnull(citrus_usr.fn_ucc_entpD(clim.clim_crn_no,'rbi_ref_no','rbi_app_dt',''),'00000000') END  --rbi_app_dt                               

                                       
                                       , ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'sebi_regn_no',''),'')  --sebi_reg_no                              
                                       --, citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  --benef_tax_ded_sta                        
									   , SPACE(2)--'00'--case when citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),'')) = '00' then space(2) else citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TAX_DEDUCTION',''),''))  end--benef_tax_ded_sta --modify by pankajon 10042013 for address modfication
                                       --                                       , case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'SMART_CARD_REQ',''),'') <> '' then 'Y' else '' end                           
--                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_NO',''),'')                             
--                                       , isnull(citrus_usr.fn_ucc_accpd(dpam.dpam_id,'SMART_CARD_REQ','SMART_CARD_PIN',''),'0000000000')--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')  --smart_crd_pin                            
									   , '' --SMART CARD REQUIRED
									   , '' --SMART CARD NUMBER
									   , space(10)--'0000000000' -- smart pin
                                       , ''--Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then 'N' else 'N' end  --ecs                                   
                                       , ''--Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=1 THEN '' ELSE  Case when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'elec_conf',''),'')=1 then 'Y' when isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ecs_flg',''),'')=0 then '' else '' end  END --elec_confirm                             
                                       , SPACE(6)--'000000'--citrus_usr.fn_get_listing('dividend_currency',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'dividend_currency',''),''))  --dividend_curr                            
                                       , '' --GROUP CODE  
                                       --, isnull(right(subcm.subcm_cd,2),'') --BO SUB STATUS                         
                                       --,''--  citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') --isnull(right(subcm.subcm_cd,2),'') --BO SUB STATUS                         
									   , max(case when clic_mod_action = 'SUB STATUS' then citrus_usr.FN_FORMATSTR(convert(varchar(4),right(subcm_cd,2)),4,0,'L','0') else '' end)
									   , SPACE(6)--'000000' --CLEARING CORPORATION ID
									   , '' --CLEARING MEMBER ID
									   , SPACE(2)--'00' --STOCK EXCHANGE

                                       , max(case when clic_mod_action = 'CONF WAIVED FLAG' then 'Y' else '' end)--'' --CASE WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='1' THEN 'Y' WHEN isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'confirmation',''),'')='0' THEN 'N'  ELSE 'N' END   --confir_waived                  
--                                       ,isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'TRADINGID_NO',''),'')           
									   , '' --TRADING ID
                                       ,''-- citrus_usr.fn_get_listing('bostmntcycle',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'bostmntcycle',''),''))  --bo_statm_cycle_cd                  
--                                       , case when banm_micr in ('0','000000000')  then space(12) 
--                                              --when  banm_micr not in ('0','000000000')   then isnull(banm_micr,space(12)) 
--											  when  banm_micr not in ('0','000000000')   then space(12) 
--                                              else space(12) end  
									   , '' --BENF_BANK_CODE                
                                       , ''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                  
                                       , ''--isnull(cliba_ac_no ,'')                 
--                                       , '000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))               
									   , SPACE(6) --'000000' -- BENF Bank CCY
                                       , max(case when clic_mod_action = 'Bank' then (case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END) else '' end) --''--case when cliba_ac_type='SAVINGS' THEN '10' WHEN  cliba_ac_type='CURRENT' THEN '11' WHEN cliba_ac_type='OTHERS' THEN '13' ELSE '13' END                 --convert(char(12),banm_branch)                                  
                                       ,max( case when clic_mod_action = 'Bank' then (case when banm_micr in ('0','000000000')  then space(12) 
                                              when  banm_micr not in ('0','000000000')   then banm_micr 
                                              else space(12) end ) else '' end   )                              
                                       ,max( case when clic_mod_action = 'Bank' then (isnull(cliba_ac_no ,'')) else '' end) --''--isnull(cliba_ac_no ,'')                 
                                       ,  SPACE(6) -- citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''--'000000'--citrus_usr.fn_get_listing('BANKCCY',isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'BANKCCY',''),''))--''                  
                                       
                                          FROM   dp_acct_mstr              dpam                  
                                                -- left outer join   
                                               --  dp_holder_dtls            dphd                 on dpam.dpam_id            = dphd.dphd_dpam_id                      
                                                 left outer join                       
                                                 client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    AND    isnull(cliba.cliba_deleted_ind,1)     = 1   AND isnull(cliba_flg,'0') IN ('1','3') 
                                                 left outer join           
                                                bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)  AND    isnull(banm.banm_deleted_ind,1)       = 1      --AND isnull(cliba_flg,'0') IN ('1','3')           
                                               , client_mstr               clim                  
                                               ,@crn                       crn  
                                               , entity_type_mstr          enttm        
                                               , client_ctgry_mstr         clicm                  
                                                 left outer join                  
                                                 sub_ctgry_mstr            subcm                   
                                                  on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                  ,exch_seg_mstr  
                                                   , client_list_modified  climmod  ,dps8_pc1
                                          WHERE  dpam.dpam_crn_no        = clim.clim_crn_no   and boid = dpam_sba_no                
                                          AND    crn.crn                  = clim.clim_crn_no                  
                                          --AND    cliba.cliba_clisba_id   = clisba.clisba_id                  
                                          AND    dpam.dpam_enttm_cd      = enttm.enttm_cd   
											 and    dpam.dpam_sba_no       = crn.acct_no--and    dpam.dpam_acct_no       = crn.acct_no               
                                          AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                          AND    dpam.dpam_subcm_cd      = subcm.subcm_cd                  
                                          AND    isnull(dpam.dpam_batch_no,0) <> 0   
                                          AND    dpam.dpam_excsm_id      = excsm_id                  
                                          AND    excsm_exch_cd           = @pa_exch  
                                          AND    dpam.dpam_deleted_ind   = 1                  
                                         -- AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
                                          AND    clim.clim_deleted_ind   = 1                  
                                          AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
                                          AND    isnull(banm.banm_deleted_ind,1)   = 1        
                                           and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then pangir else '0' end = clic_mod_pan_no)              
                          
                                          --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                          AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                          and    climmod.clic_mod_deleted_ind = 1
                          and	isnull(climmod.clic_mod_batch_no,0) = 0
						  AND	  climmod.clic_mod_action in ('Bank','GENERAL','INCOME DETAILS','SUB STATUS','BSDA FLAG','RGESS FLAG','FST HOLDER UID','EMAIL STMT FLAG','CAS FLAG','CONF WAIVED FLAG','FST HOLDER DOB','RTA Email Flg','FST HOLDER GENDER','OCCUPATION','RBI DETAILS','PLEDGE STANDING INSTRUCTION FLG','ANNUAL RPT FLG')
						  --and    climmod.clic_mod_action = @pa_mod_typ
						  and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
                          group by clim_crn_no                  
                                       , dpam_sba_no
                          --identity(numeric,1,1) id ,
				SELECT  distinct dpam.dpam_crn_no   into #tmp06_2
												FROM   dp_acct_mstr              dpam          
												left outer join                  
												dp_poa_dtls                   dppd                  
												on dpam.dpam_id             = dppd.dppd_dpam_id                  
												, client_mstr               clim                  
												, entity_type_mstr          enttm                  
												, client_ctgry_mstr         clicm                  
														left outer join                  
														sub_ctgry_mstr            subcm                   
														on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
														,exch_seg_mstr  
														 , client_list_modified  climmod  ,dps8_pc1
														 ,@crn                       crn 
							WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   and boid = dpam_sba_no 
							AND    dpam.dpam_enttm_cd      = enttm.enttm_cd  AND crn.CRN = DPAM_CRN_NO                 
							--AND    isnull(dpam.dpam_batch_no,0) = 0   
							AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
							AND    dpam.dpam_excsm_id      = excsm_id                  
						AND    excsm_exch_cd           = @pa_exch  
						AND    dpam.dpam_deleted_ind   = 1                  
						AND    clim.clim_deleted_ind   = 1  
						AND    dppd.dppd_deleted_ind   =1   
						AND    isnull(dppd.dppd_fname,'')  <> ''
						--AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')           
						and    dppd_eff_to_dt <= getdate()
						--AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
						--AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY')         
						and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then pangir else '0' end = clic_mod_pan_no)              
                          
                        AND   climmod.clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                        and    climmod.clic_mod_deleted_ind = 1
and	isnull(climmod.clic_mod_batch_no,0) = 0
                        AND	  climmod.clic_mod_action in ('POA DEACTIVATION','POA ACTIVATION')	
                        --and    climmod.clic_mod_action = @pa_mod_typ
                        and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
                        --print '12'							  
                        --select * into tmp_06072015 from #tmp06_2	
                        --SELECT * into temp_crn_11032016 FROM @crn	
                         
                        select identity(numeric,1,1) id , dpam_crn_no into #tmp06_21 from #tmp06_2					  
								  
								  select @l_06cnt=  count(1) from #tmp06_21
								  --select * into crn_06072015 from @crn
								  
								print '06112015'  
								                            
                       insert into @line6(ln_no                   
                                         ,crn_no                  
                                         ,acct_no                  
                                         ,poa_id                                    
                                         ,setup_date                                
                                         ,poa_to_opr_ac                             
                                         ,gpa_bpa_fl                                
                                         ,eff_frm_dt                                
                                         ,eff_to_dt                                 
                                         ,usr_fld1                                  
                                         ,usr_fld2                                  
                                         ,ca_charfld                                
                                         ,bo_name3                                
                                         ,bo_mid_name3                               
                                         ,cust_srh_name3                            
                                         ,bo_title3                                 
                                         ,bo_suffix3                                
                                         ,hldr_fth_hsb_nm3                          
                                         ,cus_addr1                                 
                                         ,cust_addr2                                
                                         ,cust_addr3                                
                                         ,cust_city                                 
                                         ,cust__state                               
                                         ,cust_cntry                                
                                         ,cust_zip                                  
                                         ,cust_ph1_ind                              
                                         ,cust_ph1                                  
                                         ,cust_ph2_ind                              
                                         ,cust_ph2                                  
                                         ,cust_addl_ph                              
                                         ,cust_fax                                  
                                         ,pan_no                                    
                                         ,it_crc                                    
                                         ,cust_email                                
                                         ,bo3_usr_txt1                              
                                         ,bo3_usr_txt2                              
                                         ,bo3_usr_fld3                              
                                         ,bo3_usr_fld4                              
                                         ,bo3_usr_fld5                  
                                         ,sign_poa                  
                                         ,sign_file_fl)                  
                                          SELECT distinct '06'                  
                                               ,clim_crn_no                  
                                               ,isnull(dpam.dpam_sba_no,'')                  
--                                               ,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id --isnull(dppd_poa_id,replicate(0,16))  dppd_poa_id            
--                                               ,convert(char(11),dppd_setup)   
											   --,case when clic_mod_action = 'POA ACTIVATION' then citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID() ELSE '' END --''
											   --, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID()) ELSE '0' END)--''	
											   , convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then 'M' + convert(varchar,convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID())) ELSE '0' END)--''	
											   , convert(char(11),getdate()) 
                                               ,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
                                               ,dppd_gpabpa_flg  
                                               ,convert(char(11), getdate()) --,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,'0000'--''--usr_fld1                                  
                                               ,'0000'--''--usr_fld2                                  
                                               ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end--,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    --,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,''--isnull(dppd.dppd_fname,'') 
                                               ,''--isnull(dppd.dppd_mname,'')                         
                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
                                               ,''--bo_title3                                 
                                               ,''--bo_suffix3                                
                                               ,''--isnull(dppd.dppd_fthname,'')                              
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
                                               ,''--cust_ph2_ind                              
                                               ,''  
                                               ,''  
                                               ,''  
                                               ,''--dppd_pan_no  
                                               ,''  
                                               ,''  
                                               ,isnull(dppd_master_id,'0')
                                               ,''--bo3_usr_txt2                              
                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
													WHEN dppd_hld = '2nd holder' THEN  '0002'
													WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
--                                               ,'0000'--''--bo3_usr_fld4 
											   --,'M'                             
											   --, case when clic_mod_action = 'POA DEACTIVATION' then 'D' else 'M' end
											   , case when clic_mod_action = 'POA DEACTIVATION' then 'D' when clic_mod_action =  'POA ACTIVATION'  then 'S' else  'M' end
                                               ,'0000'--''--bo3_usr_fld5                               
                                               ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
--                                              ,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
											   ,''
                                        FROM   dp_acct_mstr               dpam          with (nolock)
                                               left outer join                  
                                               dp_poa_dtls                   dppd       with (nolock)            
                                               on dpam.dpam_id             = dppd.dppd_dpam_id                  
                                             , client_mstr              clim             with (nolock)     
                                             , @crn                       crn  
                                             , entity_type_mstr          enttm                  
                                             , client_ctgry_mstr         clicm                  
                                               left outer join                  
                                               sub_ctgry_mstr            subcm                   
                                                on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                , exch_seg_mstr  
                                                 , client_list_modified  climmod  ,#tmp06_21 t,dps8_pc1
                                         WHERE  dpam.dpam_crn_no        = clim.clim_crn_no          and boid = dpam_sba_no
                                         AND    crn.crn                 = clim.clim_crn_no                  
                                         AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                         AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                         AND    isnull(dpam.dpam_batch_no,0) <> 0   
                                         AND    dpam.dpam_excsm_id      = excsm_id  
                						 and    dpam.dpam_sba_no       = crn.acct_no--and    dpam.dpam_acct_no       = crn.acct_no 
                                         AND    excsm_exch_cd           = @pa_exch  
                                         AND    dpam.dpam_deleted_ind   = 1                  
                                         AND    clim.clim_deleted_ind   = 1     
                                         AND    dppd.dppd_deleted_ind   =1 
                                         AND    isnull(dppd.dppd_fname,'')  <> ''
                                         and    convert(numeric,t.dpam_crn_no)=dpam.dpam_crn_no
                                         and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then pangir else '0' end = clic_mod_pan_no)              
                          
                                         --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                                         --AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')   
                                         AND    dppd_eff_to_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
										 and    dppd_eff_to_dt<>'1900-01-01 00:00:00.000' --or dppd_eff_to_dt<>'2049-01-01 00:00:00.000')
                                         AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY') 
                                         AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                                         --AND   dppd_eff_to_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, '24/05/2017',103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,'24/05/2017',103),106)+' 23:59:59'   -- added by tp sir on 25/05/2017
										 and    climmod.clic_mod_deleted_ind = 1
										 AND	  climmod.clic_mod_action in ('POA DEACTIVATION')
										 --and    climmod.clic_mod_action = @pa_mod_typ
										 										 and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
										 and	isnull(climmod.clic_mod_batch_no,0) = 0
										 and not exists(select 1 from dps8_pc5 where MasterPOAId = dppd_master_id and boid = DPAM_SBA_NO and HolderNum = case when ltrim(rtrim(DPPD_HLD)) = '1ST HOLDER' then '1' when ltrim(rtrim(DPPD_HLD)) = '2ND HOLDER' then '2' else '3' end and TypeOfTrans in ('','1') AND	  climmod.clic_mod_action in ('POA ACTIVATION'))
										 --and DPPD_LST_UPD_DT >= (select top 1 clic_mod_lst_upd_dt from client_list_modified b where climmod.clic_mod_action= b.clic_mod_action and b.clic_mod_batch_no <> '0' order by clic_mod_lst_upd_dt desc )
                                         --order by  dppd_eff_fr_dt   
                                         UNION 
                                          SELECT distinct '06'                  
                                               ,clim_crn_no                  
                                               ,isnull(dpam.dpam_sba_no,'')                  
--                                               ,CITRUS_USR.FN_FORMATSTR(dppd_poa_id,16-len(dppd_poa_id),len(dppd_poa_id),'R',' ') dppd_poa_id --isnull(dppd_poa_id,replicate(0,16))  dppd_poa_id            
--                                               ,convert(char(11),dppd_setup)   
											   --,case when clic_mod_action = 'POA ACTIVATION' then citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID() ELSE '' END --''
											   --, convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID()) ELSE '0' END)--''	
											   , convert(varchar,case when clic_mod_action = 'POA ACTIVATION' then 'M' + convert(varchar, convert(numeric,id)+convert(numeric,citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID())) ELSE '0' END)--''	
											   , convert(char(11),getdate()) 
                                               ,case when dppd_poa_type = 'FULL' then 'Y' else 'N' END                  
                                               ,dppd_gpabpa_flg  
                                               ,convert(char(11), getdate()) --,dppd_eff_fr_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,dppd_eff_to_dt--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,'0000'--''--usr_fld1                                  
                                               ,'0000'--''--usr_fld2                                  
                                               ,case when dppd_gpabpa_flg = 'B' then dppd_poa_type else '' end--,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    --,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'',''),'')                    
                                               ,''--isnull(dppd.dppd_fname,'') 
                                               ,''--isnull(dppd.dppd_mname,'')                         
                                               ,''--convert(char(20),isnull(dppd.dppd_lname,''))     
                                               ,''--bo_title3                                 
                                               ,''--bo_suffix3                                
                                               ,''--isnull(dppd.dppd_fthname,'')                              
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),1)--adr1                       
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),2)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),3)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),4)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),5)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),6)--adr1                  
                                               ,''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.dpam_id,'POA_ADR1'),''),7)--adr1                  
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  'O'    ELSE ''                                                     end                
                                               ,''--case when isnull(citrus_usr.fn_dp_import_conc(dpam.dpam_id,'POA_OFF_PH1'),'') <> '' then  isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'POA_OFF_PH1'),'')                                    end                                   
                                               ,''--cust_ph2_ind                              
                                               ,''  
                                               ,''  
                                               ,''  
                                               ,''--dppd_pan_no  
                                               ,''  
                                               ,''  
                                               ,isnull(dppd_master_id,'0')
                                               ,''--bo3_usr_txt2                              
                                               ,CASE WHEN dppd_hld = '1st holder' THEN  '0001'
													WHEN dppd_hld = '2nd holder' THEN  '0002'
													WHEN dppd_hld = '3rd holder' THEN  '0003' ELSE '0000' end                            
--                                               ,'0000'--''--bo3_usr_fld4 
											   --,'M'                             
											   --, case when clic_mod_action = 'POA DEACTIVATION' then 'D' else 'M' end
											   , case when clic_mod_action = 'POA DEACTIVATION' then 'D' when clic_mod_action =  'POA ACTIVATION'  then 'S' else  'M' end
                                               ,'0000'--''--bo3_usr_fld5                               
                                               ,ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'')                  
--                                              ,case when ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_POA',''),'') = '' then 'N' else 'Y'   end  --signature file flag           
											   ,''
                                        FROM   dp_acct_mstr               dpam          with (nolock)
                                               left outer join                  
                                               dp_poa_dtls                   dppd       with (nolock)            
                                               on dpam.dpam_id             = dppd.dppd_dpam_id                  
                                             , client_mstr              clim             with (nolock)     
                                             , @crn                       crn  
                                             , entity_type_mstr          enttm                  
                                             , client_ctgry_mstr         clicm                  
                                               left outer join                  
                                               sub_ctgry_mstr            subcm                   
                                                on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
                                                , exch_seg_mstr  
                                                 , client_list_modified  climmod  ,#tmp06_21 t,dps8_pc1
                                         WHERE  dpam.dpam_crn_no        = clim.clim_crn_no          and boid = dpam_sba_no
                                         AND    crn.crn                 = clim.clim_crn_no                  
                                         AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
                                         AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
                                         AND    isnull(dpam.dpam_batch_no,0) <> 0   
                                         AND    dpam.dpam_excsm_id      = excsm_id  
                						 and    dpam.dpam_sba_no       = crn.acct_no--and    dpam.dpam_acct_no       = crn.acct_no 
                                         AND    excsm_exch_cd           = @pa_exch  
                                         AND    dpam.dpam_deleted_ind   = 1                  
                                         AND    clim.clim_deleted_ind   = 1     
                                         AND    dppd.dppd_deleted_ind   =1 
                                         AND    isnull(dppd.dppd_fname,'')  <> ''
                                         and    convert(numeric,t.dpam_crn_no)=dpam.dpam_crn_no
                                         and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then pangir else '0' end = clic_mod_pan_no)              
                                                                   --AND    CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
                                         --AND    getdate() between dppd_eff_fr_dt and  CASE WHEN isnull(dppd_eff_to_dt,'01/01/2100') ='01/01/1900' THEN '01/01/2100' ELSE isnull(dppd_eff_to_dt,'01/01/2100') END --isnull(dppd_eff_to_dt,'01/01/2100')   
										 --and  dppd_eff_to_dt ='1900-01-01 00:00:00.000'
										 and    (dppd_eff_to_dt ='1900-01-01 00:00:00.000'or  dppd_eff_to_dt='2049-01-01 00:00:00.000')
                                         AND    isnull(dppd_poa_type,'') IN ('FULL','PAYIN ONLY') 
                                         AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
										 and    climmod.clic_mod_deleted_ind = 1
										 AND	  climmod.clic_mod_action in ('POA ACTIVATION')
										 --and    climmod.clic_mod_action = @pa_mod_typ
										 and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
										 and	isnull(climmod.clic_mod_batch_no,0) = 0
										 and not exists(select 1 from dps8_pc5 where MasterPOAId = dppd_master_id and boid = DPAM_SBA_NO and HolderNum = case when ltrim(rtrim(DPPD_HLD)) = '1ST HOLDER' then '1' when ltrim(rtrim(DPPD_HLD)) = '2ND HOLDER' then '2' else '3' end and TypeOfTrans in ('','1') AND	  climmod.clic_mod_action in ('POA ACTIVATION'))
                                         --order by  dppd_eff_fr_dt   
 
--update bitmap_ref_mstr set bitrm_values=bitrm_values + convert(varchar,@l_06cnt ) where BITRM_PARENT_CD = 'POAID_AUTO'  

                                 insert into  @line7(ln_no                                    
                                           ,crn_no                   
                                           ,acct_no                  
                                           ,Purpose_code                             
                                           ,bo_name                                  
                                           ,bo_middle_nm                             
                                           ,cust_search_name                         
                                           ,bo_title                                 
                                           ,bo_suffix                                
                                           ,hldr_fth_hs_name                         
                                           ,cust_addr1                      
                                           ,cust_addr2                               
                                           ,cust_addr3                               
                                           ,cust_city                                
                                           ,cust_state                               
                                           ,cust_cntry                               
                                           ,cust_zip                                 
                                           ,cust_ph1_id                              
                                           ,cust_ph1                                 
                                           ,cust_ph2_in                              
                                           ,cust_ph2                                 
                                           ,cust_addl_ph  
										   ,dob                              
                                           ,cust_fax                                 
                                           ,hldr_in_tax_pan
										   ,uid
											,name_ch_reason_cd                           
                                           ,it_crl                                   
                                           ,cust_email                               
                                           ,usr_txt1          
                                           ,usr_txt2                                 
                                           ,usr_fld3                                 
                                           ,usr_fld4                                 
                                           ,usr_fld5   
                                            ,nom_serial_no
									,rel_withbo
									,sharepercent
									,res_sec_flag      
									,ln7_cust_adr_cntry_cd 
									,ln7_cust_adr_state_cd 
									,ln7_city_seq_no 
									,ln7_Pri_mob_ISD                          
                                           )                     
                                            SELECT distinct ln_no                                    
                                            ,crn_no                   
                                            ,acct_no                  
                                            ,Purpose_code                             
                                            ,bo_name                  
                                            ,bo_middle_nm                             
                                            ,cust_search_name                         
                                            ,bo_title                                 
                                            ,bo_suffix                                
                                            ,hldr_fth_hs_name                         
                                            ,cust_addr1                               
                                            ,cust_addr2                               
                                            ,cust_addr3                                                         
                                            ,cust_city                                
                                            ,cust_state                               
                                            ,cust_cntry                               
                                            ,cust_zip                                 
                                            ,''--cust_ph1_id                              
                                            ,cust_ph1                                 
                                            ,cust_ph2_in                              
                                            ,cust_ph2                                 
                                            ,cust_addl_ph 
											,dob                               
                                            ,cust_fax                                 
                                            ,hldr_in_tax_pan 
											,uid
											,name_ch_reason_cd                          
                                            ,it_crl                                   
                                            ,cust_email                               
                                            ,usr_txt1                                 
                                            ,usr_txt2                                 
                                            ,CASE WHEN usr_fld3=0 THEN '0000' ELSE usr_fld3 END                                 
                                            ,CASE WHEN usr_fld4='0' THEN '0000' ELSE usr_fld4 END                                  
                                            ,CASE WHEN usr_fld5=0 THEN '0000' ELSE usr_fld5 END 
                                             ,nom_serial_no
									,case when rel_withbo = ''then space (2) else rel_withbo end rel_withbo--rel_withbo
									,sharepercent
									,res_sec_flag   ,ln7_cust_adr_cntry_cd,ln7_cust_adr_state_cd,ln7_city_seq_no,ln7_Pri_mob_ISD      
                                            FROM   client_list_modified  climmod ,
											--fn_cdsl_export_line_7_extract_newversion(@pa_crn_no, @pa_from_dt, @pa_to_dt), dp_acct_mstr , EXCH_SEG_MSTR esm
											fn_cdsl_export_line_7_extract_newversion_mod(@pa_crn_no, @pa_from_dt, @pa_to_dt)
											 , dp_acct_mstr
											 , EXCH_SEG_MSTR esm  
                                            WHERE  dpam_sba_no       = acct_no-- --dpam_acct_no = acct_no 
                                            AND dpam_excsm_id =  excsm_id 
                                            AND   excsm_exch_cd = @pa_exch
                                            and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '' end = clic_mod_pan_no)              
                                            AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                                            and    climmod.clic_mod_deleted_ind = 1
                                            and	isnull(climmod.clic_mod_batch_no,0) = 0
                                            --and    climmod.clic_mod_action = @pa_mod_typ
                                            and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
                                            AND   climmod.clic_mod_action in ('G Address','G NameNDtls','G Contacts','Guardian Suffix', 'G NameChange','G FatherNameChange' ,'G MobChange', 'G ResPhChange', 'G OffPhChange', 'G DOBChange', 'G PANChange','GUARDIAN TITLE','NG Address','NG NameNDtls','NG Contacts','P ADDRESS','NOMINEE3 GAURDIAN','NOMINEE3','NOMINEE2 GAURDIAN','NOMINEE2','NOMINEE1 GAURDIAN','NOMINEE1') 
                                            ORDER BY Purpose_code  DESC
                                           
                                           
                                           INSERT INTO  @line8 (ln_no               
														,crn_no            
														,acct_no                    
														,purposecode           
														,flag                   
														,mobile                      
														,email                  
														,remarks                  
														,push_flg                      
												)    
											SELECT distinct '08'                  
														,dpam_crn_no                  
														,dpam_sba_no                  
														,'16' --''--Purpose_code                             
														--,'S'
														--,CASE WHEN not exists (select 1 from client_main_properties where cmp_accp_clisba_id = dpam_id ) THEN 'S' ELSE 'M' END
														--,CASE WHEN not exists (select 1 from client_main_properties where BOid = DPAM_SBA_NO and mobile_no <> '' and  PurposeCode = '16') THEN 'S' ELSE 'M' END
														--,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')<> '' THEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBSMS')
														--						ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END
														--,CASE WHEN CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')<> '' THEN ISNULL(lower(CITRUS_USR.fn_acct_conc_value(DPAM_ID,'SMSEMAIL')),'')
														--						ELSE ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'') END 
														--,CASE WHEN not exists (select 1 from dps8_pc16 where BOid = DPAM_SBA_NO and MobileNum <> '' and  PurposeCode16 = '16') THEN 'S' ELSE 'M' END
														--,CASE WHEN exists (select 1 from dps8_pc16 where BOid = DPAM_SBA_NO and MobileNum <> '' and  PurposeCode16 = '16' and (TypeOfTrans = '1' or TypeOfTrans = '2' or TypeOfTrans = '')) THEN 'M' ELSE 'S' END
														--,CASE WHEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')<> '' THEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')
														--						ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END
														,case when clic_mod_action = 'MOBILE SMS DELETE' then 'D' else (CASE WHEN exists (select 1 from dps8_pc16 where BOid = DPAM_SBA_NO and MobileNum <> '' and  PurposeCode16 = '16' and (TypeOfTrans = '1' or TypeOfTrans = '2' or TypeOfTrans = '')) THEN 'M' ELSE 'S' END) end
																		
													    ,case when clic_mod_action = 'MOBILE SMS DELETE' then REPLICATE('@',10) else (CASE WHEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')<> '' THEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS')																				
													    ELSE CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBSMS') END ) END
														,CASE WHEN CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')<> '' THEN ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'')
																				ELSE ISNULL(lower(CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'SMSEMAIL')),'') END 
														,''
														,case when clic_mod_action = 'MOBILE SMS DELETE' then '@' else 'P' end
														FROM   dp_acct_mstr              dpam ,client_list_modified  climmod   ,account_properties accp,EXCH_SEG_MSTR esm      , @crn                       crn           
															WHERE 
															    dpam.dpam_sba_no       = crn.acct_no 
															AND   dpam_excsm_id = excsm_id 
															AND   accp_clisba_id = dpam_id
															AND    accp.accp_accpm_prop_cd = 'SMS_FLAG'
															--AND    isnull(dpam.dpam_batch_no,0) = 0
															AND    accp.accp_value = '1'-- and 1 = 0 
															AND   excsm_exch_cd = @pa_exch
															 AND dpam_excsm_id =  excsm_id 
															 --and    DPAM_DPM_ID = @L_DPM_ID     
															--AND   (CITRUS_USR.fn_acct_conc_value(DPAM_ID,'MOBILE1')<>'' OR CITRUS_USR.fn_conc_value(DPAM_CRN_NO,'MOBILE1')<>'')
														 --AND     CLIM_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                      
														 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
                                                     and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
                                                     AND	  climmod.clic_mod_action in ('MOBILE SMS','MOBILE SMS DELETE')
                                                     --and    climmod.clic_mod_action = @pa_mod_typ
                                                     and    climmod.clic_mod_action like case when upper(@pa_mod_typ) = 'ALL' then '%%' else @pa_mod_typ end
                                                     and	isnull(climmod.clic_mod_batch_no,0) = 0
                                                    and    climmod.clic_mod_deleted_ind = 1
                                            
                                      
      --                  
      END        
--		declare @record numeric
--		set @record = case when exists (select 1 from @line2) then 1 else 0 end
--		if (@record = 0)
--		begin
--			insert into @line2( ln_no                  
--								   ,crn_no                  
--								   ,acct_no                  
--								   ,product_number                       
--								   ,bo_name                              
--								   ,bo_middle_name                       
--								   ,cust_search_name                     
--								   ,bo_title                             
--								   ,bo_suffix                            
--								   ,hldr_fth_hsd_nm                      
--								   ,cust_addr1                           
--								   ,cust_addr2                           
--								   ,cust_addr3                           
--								   ,cust_addr_city                       
--								   ,cust_addr_state                      
--								   ,cust_addr_cntry                      
--								   ,cust_addr_zip                        
--								   ,cust_ph1_ind                         
--								   ,cust_ph1                             
--								   ,cust_ph2_ind                         
--								   ,cust_ph2                             
--								   ,cust_addl_ph                         
--								   ,cust_fax                             
--								   ,hldr_pan
--								   ,cust_uid --new added pankaj	                             
--								   ,it_crl                               
--								   ,cust_email                           
--								   ,bo_usr_txt1                          
--								   ,bo_usr_txt2                          
--								   ,bo_user_fld3                         
--								   ,bo_user_fld4                         
--								   ,bo_user_fld5                   
--								   ,sign_bo                                   
--								   ,sign_fl_flag)                  
--								   SELECT distinct '02'                  
--										, '0'--clim_crn_no                  
--										, dpam_sba_no--dpam_acct_no                  
--										, citrus_usr.Fn_FormatStr(left(subcm_cd,2),4,0,'L','0') --product no                 
--										, '' --bo name
--										, '' --bo middle name
--										, '' -- bo seach name
--										, ''--case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end  --bo title
--										, '' --bo suffix                 
--										, ''--ISNULL(dphd_fh_fthname,'')  --father/husband name                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),1) --end --adr1                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),2) --end--adr2                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),3)-- end--adr3                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),4) --end--adr_city                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),5) --end--adr_state                  
--										, ''--citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),6) --end--adr_country                  
--										, ''--replace(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'cor_ADR1'),''),7),' ','') --end --adr_zip                
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  --CUST PH 1 INDC
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')  --convert(varchar(17),isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))--ph1                  
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  --'0' CUST PH 2 INDC                 
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  --isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH2'),'')--ph2                  
--										, ''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')  --CUST ADDL PHONE             
--										, ''--CASE WHEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') <> '' THEN isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCFAX1'),'') ELSE isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'FAX1'),'') END --fax                  
--										, ''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--										, ''--isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADHAARFLAG',''),'') --UID 
--										, '' --IT CIRCLE
--										, ''--CASE WHEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) <> '' THEN lower(isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'ACCEMAIL1'),'')) ELSE lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')) END --email                  
--										, '' --USER TEXT 1                 
--										, '' --USER TEXT 2                 
--										, space(4) --USER FIELD 3                  
--										, ''                  
--										, ''--case when isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'') <> '' then '1' else '0' end + case when isnull(DPHD_SH_PAN_NO,'') <> '' then '1' else '0' end + case when  isnull(DPHD_TH_PAN_NO,'') <> '' then '1' else '0' end + '0'                
--										, ''--ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO',''),'')                  
--										, ''--case when ISNULL(citrus_usr.fn_ucc_doc_mod(dpam_id,'SIGN_BO','',@pa_from_dt,@pa_to_dt),'') = '' then 'N' else 'Y'   end --signature file flag                  
--								   FROM   dp_acct_mstr              dpam                  
--										  left outer join      
--										  dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id                      
--										  left outer join    
--										  client_bank_accts         cliba                on dpam.dpam_id            = cliba.cliba_clisba_id    
--										  left outer join           
--										  bank_mstr                 banm                 on  convert(int,cliba.cliba_banm_id)     = convert(int,banm.banm_id)          
--										, client_mstr               clim                  
--										, entity_type_mstr          enttm                  
--										, client_ctgry_mstr         clicm                  
--										, sub_ctgry_mstr            subcm                   
--										, exch_seg_mstr             excsm  
--										--, client_list_modified  climmod 
--										,@crn                       crn  
--								   WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
--								   AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--								   AND    dpam.dpam_clicm_cd      = clicm.clicm_cd
--								   AND    crn.crn                  = clim.clim_crn_no              
--								   and    dpam.dpam_sba_no       = crn.acct_no 
--								   AND    dpam.dpam_deleted_ind   = 1                  
--								   AND    dpam.dpam_excsm_id      = excsm_id                  
--								   AND    isnull(dpam.dpam_batch_no,0) <> 0   
--								   AND    excsm_exch_cd           = @pa_exch  
--								   AND    subcm.subcm_CD          = DPAM.DPAM_SUBCM_CD  
--								   AND    subcm.subcm_deleted_ind = 1                  
--								   AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
--								   AND    clim.clim_deleted_ind   = 1                  
--								   AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
--								   AND    isnull(banm.banm_deleted_ind,1)   = 1 
--								   --and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)              
--								   --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--								   --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
--								   --and    climmod.clic_mod_deleted_ind = 1
--								   --AND	  climmod.clic_mod_action in ('C Address','Client Main Properties','General','Signature')
--		end
          
		 delete a  from  @line3 a where cust_name_ch_code1 ='' and 
		  exists (select 1 from @line3 b where a.acct_no = b.acct_no and b.cust_name_ch_code1='06')
                  
 select dpam_sba_no into #tempdata from dp_acct_mstr where dpam_sba_no in (select acct_no from @line2) 
or dpam_sba_no in (select acct_no from @line3) 
or dpam_sba_no in (select acct_no from @line4) 
or dpam_sba_no in (select acct_no from @line5) 
or dpam_sba_no in (select acct_no from @line6) 
or dpam_sba_no in (select acct_no from @line7) 
or dpam_sba_no in (select acct_no from @line8) 

select * ,  acct_no boidorder,'1' id  into #tmp_line2 from @line2
select * , acct_no boidorder,'2' id   into #tmp_line3 from @line3
select * , acct_no boidorder,'3' id   into #tmp_line4 from @line4
select * , acct_no boidorder,'4' id   into #tmp_line7_PADr from @line7 where Purpose_code ='212'
select * , acct_no boidorder ,'5' id  into #tmp_line7_NOM from @line7 where Purpose_code ='206'
select * , acct_no boidorder ,'6' id  into #tmp_line7_gr_remove from @line7 where Purpose_code ='107'
select * ,  acct_no  boidorder ,'7' id  into #tmp_line5 from @line5
select pc6.* ,  acct_no  boidorder, mSTRPOAFLG  ,'8' id   into #tmp_line6 from @line6 pc6 , dps8_pc1   a 
where boid = bo3_usr_txt1






--select clic_mod_dpam_sba_no, MAX(clic_mod_created_dt) maxdt from client_list_modified where clic_mod_created_dt between @pa_from_dt and @pa_to_dt and clic_mod_batch_no is null 
--group by 

select  boidorder , DENSE_RANK () over(order by boidorder asc) orderId    into #tmp_order from (
select boidorder from #tmp_line2
union 
select boidorder from #tmp_line7_PADr
union 
select boidorder  from #tmp_line5
union 
select boidorder  from #tmp_line3
union 
select boidorder  from #tmp_line4
union 
select boidorder from #tmp_line6
union 
select boidorder from #tmp_line7_NOM 
union 
select boidorder from #tmp_line7_gr_remove ) a 



----select * from #tmp_line5 

----return 

select *,row_number() over (partition by orderId order by orderId, id  )  subid into #tempdata_for_sub from (

select  substring(a.acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(Borequestdt,5,4)+'-'+substring(Borequestdt,3,2)+'-'+substring(Borequestdt,1,2) +','+substring(Borequestdt,5,4)+'-'+substring(Borequestdt,3,2)+'-'+substring(Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+'@@@@@'+''+','+'BOMOD'+','+a.acct_no +','+case when product_number <> '' then Citrus_usr.fn_get_standard_value_harm('PrdNb',case when isnumeric(product_number)=1 then convert(varchar(100),convert(numeric,product_number) ) else '' end ) else '' end +''+','+case when bo_sub_status  <> '' then Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp',case when isnumeric(bo_sub_status)=1 then convert(varchar(100),convert(numeric,bo_sub_status) ) else '' end ) else '' end+''+''+','+'FH'+','+ltrim(rtrim(isnull(bo_title,'')))+','+case when a.bo_name <> '' then ltrim(rtrim(isnull(a.bo_name,''))) else '' end +','+case when a.bo_middle_name  <> '' then ltrim(rtrim(isnull(bo_middle_name,''))) else '' end +','+case when a.cust_search_name  <> '' then ltrim(rtrim(isnull(a.cust_search_name,''))) else '' end +',,,'+ltrim(rtrim(isnull(hldr_fth_hsd_nm,'')))+','+case when dob <> '' then convert(varchar(10),convert(datetime,dob,103),126) else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('Gndr',b.sex_cd)+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty',ltrim(rtrim(smart)))+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd',Pri_mob_ISD)+','+ltrim(rtrim(ISNULL(cust_ph1,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+ltrim(rtrim(ISNULL(cust_email,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg',ann_income_cd )+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+','+ltrim(rtrim(isnull(CONVERT(varchar(100),voice_mail),'')))+','+ltrim(rtrim(isnull(CONVERT(varchar(100),divnd_bank_code),''))) +',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg',annual_rpt_flg )+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd',CAS_MODE )+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+ltrim(rtrim(Citrus_usr.fn_get_standard_value_harm('BkAcctTp',isnull(divnd_brnch_numb,''))))+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+','+ltrim(rtrim(isnull(divnd_acct_numb,'')))+','+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg',bsda_flg)+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn',occp)+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when ltrim(rtrim(isnull(cust_addr1,''))) <> '' then 'CORAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+case when isnull(cust_addr1 ,'') <> '' then ',"' else ',' end +ltrim(rtrim(isnull(cust_addr1,''))) + case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end  +ltrim(rtrim(isnull(cust_addr2,'')))+case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end +ltrim(rtrim(isnull(cust_addr3,'')))+ case when isnull(cust_addr1 ,'') <> '' then '",' else ',' end ++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_addr_cntry)+','+ltrim(rtrim(isnull(cust_addr_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_addr_state  )+','+ltrim(rtrim(isnull(city_seq_no ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+case when name_ch_reason_cd<> '' then Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd',convert(numeric(5),name_ch_reason_cd)) else '' end +','+','+''+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,'   detailshr ,  ord.orderId, '1' id 
from #tmp_order ord , #tmp_line2  a left outer join #tmp_line5 b on  a.acct_no = b.acct_no 
--,  client_list_modified where  a.acct_no = clic_mod_dpam_sba_no and clic_mod_action in ('C ADDRESS','BANK')
and (@pa_mod_typ in ('C ADDRESS') or @pa_mod_typ in ('ALL') ) 
where a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'FH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(ln7_city_seq_no ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id 
from #tmp_order ord ,  #tmp_line7_PADr a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('P ADDRESS')
and (@pa_mod_typ in ('P ADDRESS') or @pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'GD'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else 'DFT' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('','')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('','') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd',isnull(usr_fld4,''))+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id 
from #tmp_order ord ,  #tmp_line7_gr_remove a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('G NAMECHANGE')
and (@pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'NM'+',,'+ltrim(rtrim(isnull(bo_name,'')))+','+ltrim(rtrim(isnull(bo_middle_nm,'')))+','+ltrim(rtrim(isnull(cust_search_name,'')))+',,,'+ltrim(rtrim(isnull(hldr_fth_hs_name,'')))+','+case when dob<> '' then right(dob,4)+'-'+substring(dob,3,2)+'-'+left(dob,2) else '' end +','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+ltrim(rtrim(isnull(hldr_in_tax_pan,'')))+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+','+case when nom_serial_no <> '' then convert(varchar(10),convert(numeric,nom_serial_no)) else '' end +','+case when sharepercent <> '' then convert(varchar(10),convert(numeric(5,2),sharepercent/100)) else '' end +','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg',res_sec_flag)+''+','+case when rel_withbo <>'' then Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr',isnull(convert(numeric,rel_withbo),'')) else '' end +',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='NOMINEE1' then 'NOMAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(ln7_city_seq_no ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+'ADD'+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id 
from #tmp_order ord ,  #tmp_line7_NOM a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('NOMINEE1')
and (@pa_mod_typ in ('NOMINEE1') or @pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),setup_date,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'POALB'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+''+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',0,'+ltrim(rtrim(convert(varchar(100),poa_id)))+','+'Y'+','+''  +','+convert(varchar(10),setup_date,126)+','+convert(varchar(10),eff_frm_dt,126)+','+case when  convert(varchar(10),eff_to_dt,126) ='1900-01-01' then '' else convert(varchar(10),eff_to_dt,126) end +','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg',gpa_bpa_fl)+','+  ltrim(rtrim(isnull(bo3_usr_txt1,'')))+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd',isnull(bo3_usr_fld3,''))+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',''  )+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+'ADD'+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,0,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId, '3' id 
from #tmp_order ord ,  #tmp_line6 a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('POA ACTIVATION')
and (@pa_mod_typ in ('POA ACTIVATION') or @pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'SH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+case when  isnull(cust_name_ch_code1,'') = '06' then 'DSH' else '' end  +''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn',ISNULL(cust_name_ch_code1,''))+','+(select top 1 convert(varchar(10),convert(datetime,dphd_sh_dob,103),126)  from dp_acct_mstr, DP_HOLDER_DTLS where DPAM_ID = DPHD_DPAM_ID 
and DPAM_SBA_NO = acct_no )+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else 'DFT' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('','')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('','') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd',isnull('',''))+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id 
from #tmp_order ord ,  #tmp_line3 a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no 
and clic_mod_action = 'SH NAMECHANGE' 
and (@pa_mod_typ in ('SH NAMECHANGE') or @pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
union all
--select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'@@@@@')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'TH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+case when  isnull(cust_name_ch_code2,'') = '06' then 'DTH' else '' end  +''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn',ISNULL(cust_name_ch_code2,''))+','+(select top 1 convert(varchar(10),convert(datetime,DPHD_TH_DOB,103),126)  from dp_acct_mstr, DP_HOLDER_DTLS where DPAM_ID = DPHD_DPAM_ID 
and DPAM_SBA_NO = acct_no )+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else 'DFT' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'","'+ltrim(rtrim(isnull('','')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('','')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','')+','+ltrim(rtrim(isnull('','') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd',isnull('',''))+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'2' id 
from #tmp_order ord ,  #tmp_line4 a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no 
and clic_mod_action = 'TH NAMECHANGE' 
and (@pa_mod_typ in ('TH NAMECHANGE') or @pa_mod_typ in ('ALL') ) and isnull(clic_mod_batch_no,'0')='0'
and a.boidorder = ord.boidorder
) c


 select detailshr from  ( select 
 'CntrlSctiesDpstryPtcpt,BrnchId,BtchId,SndrId,CntrlSctiesDpstryPtcptRole,SndrDt,RcvDt,RcrdNb,RcdSRNumber,BOTxnTyp,ClntId,PrdNb,BnfcrySubTp,Purpse,Titl,FrstNm,MddlNm,LastNm,FSfx,BnfcryShrtNm,ScndHldrNmOfFthr,BirthDt,Gndr,PAN,PANVrfyFlg,PANXmptnCd,UID,AdhrAuthntcnWthUID,RsnForNonUpdtdAdhr,VID,SMSFclty,PrmryISDCd,MobNb,FmlyFlgForMobNbOf,ScndryISDCd,PhneNb,EmailAdr,FmlyFlgForEmailAdr,AltrnEmailAdr,NoNmntnFlg,MdOfOpr,ClrMmbId,StgInstr,GrssAnlIncmRg,NetWrth,NetWrthAsOnDt,LEI,LEIExp,OneTmDclrtnFlgForGSECIDT,INIFSC,MICRCd,DvddCcy,DvddBkCcy,RBIApprvdDt,RBIRefNb,Mndt,SEBIRegNb,EdctnLvl,AnlRptFlg,BnfclOwnrSttlmCyclCd,ElctrncConf,EmailRTADwnldFlg,GeoCd,Xchg,MntlDsblty,Ntlty,CASMd,AncstrlFlg,PldgStgInstrFlg,BkAcctTp,BnfcryAcctCtgy,BnfcryBkAcctNb,BnfcryBkNm,BnfcryTaxDdctnSts,ClrSysId,BSDAFlg,Ocptn,PMSClntAcctFlg,PMSSEBIRegnNb,PostvConf,FrstClntOptnToRcvElctrncStmtFlg,ComToBeSentTo,DelFlg,RsnCdDeltn,DtOfDeath,AccntOpSrc,CustdPmsEmailId,POAOrDDPITp,TradgId,SndrRefNb1,SndrRefNb2,CtdnFlg,DmtrlstnGtwy,NmneeMnrInd,SrlNbr,NmneePctgOfShr,FlgForShrPctgEqlty,RsdlSecFlg,RltshWthBnfclOwnr,NbOfPOAMppng,POAId,POAToOprtAcct,POAOrDDPIId,SetUpDt,FrDt,ToDt,GPABPAFlg,POAMstrID,PoaLnkPurpCd,Rmk,BOUCCLkFlg,CnsntInd,UnqClntId,Brkr,Sgmt,MapUMapFlg,CmAcctToMap,PurpCd,AdrPrefFlg,Adr1,Adr2,Adr3,Adr4,Ctry,PstCd,CtrySubDvsnCd,CitySeqNb,FaxNb,ITCrcl,ProofOfRes,NbOfCoprcnrs,SgntryId,SgntrSz,BnfclOwnrAcctOfPMSFlg,CrspdngBPId,ClngMbrPAN,LclAddPrsnt,BnkAddPrsnt,NmnorGrdnAddPrsnt,MnrNmnGrdnAddPrsnt,FrgnOrCorrAddPrsnt,NbOfAuthSgnt,AuthFlg,CoprcnrOrMmbr,TypMod,SubTypMod,StsChgRsnOrClsrRsnCd,NmChgRsnCd,ExecDt,AddModDelInd,AppKrta,ChgKrtaRsn,DtIntmnBO,PrfDpstryFldFrCAS,CoprcnrsId,ClsrInitBy,RmngBal,CANm,CertNbr,CertXpryDt,NbrPOASgntryReqSign,DpstryInd,AcctTyp,SrcCMBPID,TrgtDPID,TrgtClntID,SrlFlg,UPIId,SignTyp,NBOID,ChrInstUnvFlg,CtrySubDvsnNm,Rsvd3,Rsvd4' detailshr,convert(numeric(18),0 ) orderId , convert(numeric(18),0 ) subid
union all
select  replace(detailshr,'@@@@@',convert(varchar(100),subid) ) detailshr , orderId, subid from #tempdata_for_sub 
----select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
--select  substring(a.acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+substring(Borequestdt,5,4)+'-'+substring(Borequestdt,3,2)+'-'+substring(Borequestdt,1,2) +','+substring(Borequestdt,5,4)+'-'+substring(Borequestdt,3,2)+'-'+substring(Borequestdt,1,2)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+'1'+''+','+'BOMOD'+','+a.acct_no +','+case when product_number <> '' then Citrus_usr.fn_get_standard_value_harm('PrdNb',case when isnumeric(product_number)=1 then convert(varchar(100),convert(numeric,product_number) ) else '' end ) else '' end +''+','+case when bo_sub_status  <> '' then Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp',case when isnumeric(bo_sub_status)=1 then convert(varchar(100),convert(numeric,bo_sub_status) ) else '' end ) else '' end+''+''+','+'FH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd',Pri_mob_ISD)+','+ltrim(rtrim(ISNULL(cust_ph1,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+ltrim(rtrim(ISNULL(cust_email,'')))+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg',ann_income_cd )+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+','+ltrim(rtrim(isnull(CONVERT(varchar(100),voice_mail),'')))+','+ltrim(rtrim(isnull(CONVERT(varchar(100),divnd_bank_code),''))) +',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+ltrim(rtrim(Citrus_usr.fn_get_standard_value_harm('BkAcctTp',isnull(divnd_brnch_numb,''))))+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+','+ltrim(rtrim(isnull(divnd_acct_numb,'')))+','+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when ltrim(rtrim(isnull(cust_addr1,''))) <> '' then 'CORAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+case when isnull(cust_addr1 ,'') <> '' then ',"' else ',' end +ltrim(rtrim(isnull(cust_addr1,''))) + case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end  +ltrim(rtrim(isnull(cust_addr2,'')))+case when isnull(cust_addr1 ,'') <> '' then '","' else ',' end +ltrim(rtrim(isnull(cust_addr3,'')))+ case when isnull(cust_addr1 ,'') <> '' then '",' else ',' end ++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_addr_cntry)+','+ltrim(rtrim(isnull(cust_addr_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_addr_state  )+','+ltrim(rtrim(isnull(city_seq_no ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId,'1'
--from #tmp_order ord , #tmp_line2  a left outer join #tmp_line5 b on  a.acct_no = b.acct_no 
----,  client_list_modified where  a.acct_no = clic_mod_dpam_sba_no and clic_mod_action in ('C ADDRESS','BANK')
--and (@pa_mod_typ in ('C ADDRESS') or @pa_mod_typ in ('ALL') ) 
--where a.boidorder = ord.boidorder
--union all
----select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
--select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),clic_mod_created_dt,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'2')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'FH'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',"'+ltrim(rtrim(isnull(cust_addr1,'')))+'","'+ltrim(rtrim(isnull(cust_addr2,'')))+'","'+ltrim(rtrim(isnull(cust_addr3,'')))+'",'++','+Citrus_usr.fn_get_standard_value_harm('Ctry',cust_cntry)+','+ltrim(rtrim(isnull(cust_zip ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',cust_state  )+','+ltrim(rtrim(isnull(ln7_city_seq_no ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId, '2'
--from #tmp_order ord ,  #tmp_line7_PADr a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('P ADDRESS')
--and (@pa_mod_typ in ('P ADDRESS') or @pa_mod_typ in ('ALL') )
--and a.boidorder = ord.boidorder
--union all
----select  substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+Citrus_usr.fn_get_standard_value_harm('CntrlSctiesDpstryPtcptRole','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('BOTxnTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrdNb','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcrySubTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Purpse','XXXXXX')+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PurpCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('Ctry','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,Z'
--select  distinct substring(acct_no,4,5)  + ',0,,'+@pa_loginname+','+''+','+convert(varchar(10),clic_mod_created_dt,126)+','+convert(varchar(10),setup_date,126)+'T00:00:00'+','+CONVERT(varchar(100),ord.orderId) +','+CONVERT(varchar(100),'2')+''+','+'BOMOD'+','+acct_no +','+''+''+','+''+''+','+'POALB'+',,,,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Gndr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PANVrfyFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PANXmptnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AdhrAuthntcnWthUID','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnForNonUpdtdAdhr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SMSFclty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PrmryISDCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForMobNbOf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ScndryISDCd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FmlyFlgForEmailAdr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('NoNmntnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MdOfOpr','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('StgInstr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GrssAnlIncmRg','XXXXXX')+',,,,'+','+Citrus_usr.fn_get_standard_value_harm('OneTmDclrtnFlgForGSECIDT','XXXXXX')+',,,,,,'+','+Citrus_usr.fn_get_standard_value_harm('Mndt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('EdctnLvl','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AnlRptFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrSttlmCyclCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ElctrncConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('EmailRTADwnldFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('GeoCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Xchg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MntlDsblty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ntlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CASMd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AncstrlFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PldgStgInstrFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BkAcctTp','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnfcryAcctCtgy','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('BnfcryTaxDdctnSts','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ClrSysId','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BSDAFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('Ocptn','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('PMSClntAcctFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PostvConf','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrstClntOptnToRcvElctrncStmtFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ComToBeSentTo','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DelFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsnCdDeltn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AccntOpSrc','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('POAOrDDPITp',mSTRPOAFLG)+',,,'+','+Citrus_usr.fn_get_standard_value_harm('CtdnFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('DmtrlstnGtwy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmneeMnrInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('FlgForShrPctgEqlty','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RsdlSecFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RltshWthBnfclOwnr','XXXXXX')+',,'+ltrim(rtrim(convert(varchar(100),poa_id)))+','+Citrus_usr.fn_get_standard_value_harm('POAToOprtAcct','XXXXXX')+','+case when mSTRPOAFLG ='D' then  ltrim(rtrim(isnull(bo3_usr_txt1,''))) else '' end  +','+convert(varchar(10),setup_date,126)+','+convert(varchar(10),eff_frm_dt,126)+','+convert(varchar(10),eff_to_dt,126)+','+Citrus_usr.fn_get_standard_value_harm('GPABPAFlg',gpa_bpa_fl)+','+case when mSTRPOAFLG <> 'D' then  ltrim(rtrim(isnull(bo3_usr_txt1,''))) else '' end+','+Citrus_usr.fn_get_standard_value_harm('PoaLnkPurpCd',isnull(bo3_usr_fld4,''))+','+','+Citrus_usr.fn_get_standard_value_harm('BOUCCLkFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CnsntInd','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('Sgmt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MapUMapFlg','XXXXXX')+','+','+Case when clic_mod_action='P ADDRESS' then 'PERAD' else '' end +''+','+Citrus_usr.fn_get_standard_value_harm('AdrPrefFlg','XXXXXX')+',,,,'++','+Citrus_usr.fn_get_standard_value_harm('Ctry','')+','+ltrim(rtrim(isnull('' ,'')))+','+Citrus_usr.fn_get_standard_value_harm('CtrySubDvsnCd',''  )+','+ltrim(rtrim(isnull('' ,'') ))+',,'+','+Citrus_usr.fn_get_standard_value_harm('ProofOfRes','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('BnfclOwnrAcctOfPMSFlg','XXXXXX')+',,'+','+Citrus_usr.fn_get_standard_value_harm('LclAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('BnkAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmnorGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('MnrNmnGrdnAddPrsnt','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('FrgnOrCorrAddPrsnt','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AuthFlg','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('CoprcnrOrMmbr','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('TypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('SubTypMod','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('NmChgRsnCd','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('AddModDelInd','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('AppKrta','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('ChgKrtaRsn','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('PrfDpstryFldFrCAS','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ClsrInitBy','XXXXXX')+''+','+Citrus_usr.fn_get_standard_value_harm('RmngBal','XXXXXX')+',,,,,'+','+Citrus_usr.fn_get_standard_value_harm('AcctTyp','XXXXXX')+',,,'+','+Citrus_usr.fn_get_standard_value_harm('SrlFlg','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('SignTyp','XXXXXX')+','+','+Citrus_usr.fn_get_standard_value_harm('ChrInstUnvFlg','XXXXXX')+',,,', ord.orderId, '2'
--from #tmp_order ord ,  #tmp_line6 a ,  client_list_modified  where acct_no = clic_mod_dpam_sba_no and clic_mod_action =('POA ACTIVATION')
--and (@pa_mod_typ in ('POA ACTIVATION') or @pa_mod_typ in ('ALL') 
--
) main 
order by orderId, subid 

/*Commented old version date sep 10 2024*/ 
/*
  
      select distinct isnull(l2.sign_old_bo,'') sign_old_bo,isnull(l2.sign_bo,'') sign_bo  
			,isnull(sign_fl_flag,'')    sign_fl_flag         
            ,isnull(l6.sign_poa,'')  sign_poa          
            ,dpam_sba_no   Bo_Id                  
            ,ISNULL(l2.ln_no,'02')     ln_no2                  
            ,ISNULL(convert(char(4),l2.product_number)                       
            +convert(char(100),l2.bo_name)                              
            +convert(char(20),l2.bo_middle_name)                      
            +convert(char(20),l2.cust_search_name)                     
            +convert(char(10),l2.bo_title)                             
            +convert(char(10),l2.bo_suffix)                            
            +convert(char(50),l2.hldr_fth_hsd_nm)                      
            +convert(char(55),l2.cust_addr1)                   
            +convert(char(55),l2.cust_addr2)                          
            +convert(char(55),l2.cust_addr3)     
			                     
            --+convert(char(25),l2.cust_addr_city)                  
            --+convert(char(25),l2.cust_addr_state)                     
            --+convert(char(25),l2.cust_addr_cntry)                     
            --+convert(char(10),l2.cust_addr_zip)                     
            --+convert(char(1),l2.cust_ph1_ind)                     
            --+convert(char(17),l2.cust_ph1)                     
            --+convert(char(1),l2.cust_ph2_ind)           
            --+convert(char(17),l2.cust_ph2)                     
            --+convert(char(100),l2.cust_addl_ph)  

			+convert(char(2),l2.cust_adr_cntry_cd) 
			+convert(char(10),l2.cust_addr_zip) 
			+convert(char(6),l2.cust_state_code) 
			+convert(char(25),l2.cust_addr_state) 
            +convert(char(25),l2.cust_addr_city)                  
            --+convert(char(2),l2.city_seq_no)      
            +convert(char(2),case when isnull(l2.city_seq_no,'')='' then '00' else isnull(l2.city_seq_no,'') end )  
			+convert(char(1),l2.Smart)       
			+convert(char(6),l2.Pri_mob_ISD) 
			+convert(char(17),l2.cust_ph1)    
			+convert(char(6),l2.Sec_mob_ISD) 
			+convert(char(17),l2.Sec_mobile)         
			+convert(char(100),'')
			                   
            +convert(char(17),l2.cust_fax)                     
            --+convert(char(25),l2.hldr_pan) 
			+convert(char(10),l2.hldr_pan)      --Changed by pankaj 
			+convert(char(16),l2.cust_uid) 		--Added by pankaj	      --13
			+CASE WHEN l2.cust_uid <> '' THEN '2' ELSE ' ' END -- uid verif flag
			+convert(char(1),space(1)) -- poa flag
              
			+convert(char(2),l2.name_ch_reason_cd)
            +convert(char(15),l2.it_crl)                     
            +convert(char(100),l2.cust_email)                     -- 50
            +convert(char(50),l2.bo_usr_txt1)                     
            +convert(char(50),l2.bo_usr_txt2)                  
            +convert(char(4),l2.bo_user_fld3)                     
            +convert(char(4),l2.bo_user_fld4)                     
            +convert(char(4),l2.bo_user_fld5)                  
            +convert(char(1),l2.sign_fl_flag),'') 

			+convert(char(16),space(16)) 
			+convert(char(72),space(72)) 
			+convert(char(1),space(1)) 
			+convert(char(1),space(1)) 
			+convert(char(10),space(10)) 			
			
			line_two_detail                  
            ,ISNULL(l3.ln_no,'03') ln_no3                  
            ,ISNULL(CONVERT(char(100),l3.bo_name1)                                
            +CONVERT(char(20),l3.bo_mid_name1)                            
            +CONVERT(char(20),l3.cust_search_name1)                       
            +CONVERT(char(10),l3.bo_title1)                   
            +CONVERT(char(10),l3.bo_suffix1)                              
            +CONVERT(char(50),l3.hldr_fth_hsd_nm1)                        
            +CONVERT(char(10),l3.hldr_pan1)
			+CONVERT(char(16),l3.cust_uid1) --13
			+CASE WHEN l3.cust_uid1 <> '' THEN '2' ELSE ' ' END 
			+CONVERT(char(2),l3.cust_name_ch_code1)                               
            +CONVERT(char(15),l3.it_crl1)
			+CONVERT(char(6),l3.sh_mob_phone_isd)
             +CONVERT(char(17),l3.sh_mob)--10
+CONVERT(char(100),l3.sh_email),'') 
+convert(char(16),space(16)) 
			+convert(char(72),space(72)) 
			+convert(char(1),space(1)) 
			+convert(char(1),space(1)) 
			+convert(char(10),space(10))

            line_three_detail                  
            ,ISNULL(l4.ln_no,'04') ln_no4                  
            ,ISNULL(CONVERT(char(100),l4.bo_name2)                  
            +CONVERT(char(20),l4.bo_mid_name2)                  
            +CONVERT(char(20),l4.cust_search_name2 )                  
            +CONVERT(char(10),l4.bo_title2         )                  
            +CONVERT(char(10),l4.bo_suffix2        )                  
            +CONVERT(char(50),l4.hldr_fth_hsd_nm2  )                  
            +CONVERT(char(10),l4.hldr_pan2) 
		    +CONVERT(char(16),l4.cust_uid2) ---13
			+CASE WHEN l4.cust_uid2 <> '' THEN '2' ELSE ' ' END 
			+CONVERT(char(2),l4.cust_name_ch_code2)             
            +CONVERT(char(15),l4.it_crl2)
			+CONVERT(char(6),l4.th_mob_phone_isd) 
            +CONVERT(char(17),l4.th_mob)
+CONVERT(char(100),l4.th_email),'') --50
			+convert(char(16),space(16)) 
			+convert(char(72),space(72)) 
			+convert(char(1),space(1)) 
			+convert(char(1),space(1)) 
			+convert(char(10),space(10)) 


             line_four_detail                  
            ,ISNULL(l5.ln_no,'05') ln_no5                  
            ,ISNULL(CONVERT(char(8),replace(convert(varchar,l5.dt_of_maturity,103),'/',''))                    
            +CONVERT(char(10),l5.dp_int_ref_no   )                    
            +CONVERT(char(8),replace(convert(varchar,l5.dob,103),'/',''))                    
            +CONVERT(char(1),l5.sex_cd)                    
            +CONVERT(char(4),l5.occp)                    
            +CONVERT(char(4),l5.life_style)                    
            +CONVERT(char(4),l5.geographical_cd )                  
            +CONVERT(char(4),l5.edu)                    
            --+citrus_usr.Fn_FormatStr(l5.ann_income_cd,4,0,'L','0') --CONVERT(char(4),l5.ann_income_cd)      -- PROB            
			--+Isnull(CONVERT(char(4),l5.ann_income_cd),SPACE(4))
			+case when l5.ann_income_cd='' then space(4) else citrus_usr.Fn_FormatStr(l5.ann_income_cd,4,0,'L','0') end
			-- +CONVERT(char(4),l5.ann_income_cd)      -- PROB            
            +CONVERT(char(3),l5.nat_cd)                    
            --+Isnull(CONVERT(char(2),l5.legal_status_cd),'00')                    
            +Isnull(CONVERT(char(2),l5.legal_status_cd),SPACE(2))                    
            +Isnull(CONVERT(char(2),l5.bo_fee_type),SPACE(2))   --+Isnull(CONVERT(char(2),l5.bo_fee_type),'00')                    
            +Isnull(CONVERT(char(2),l5.lang_cd),SPACE(2))--citrus_usr.Fn_FormatStr(l5.lang_cd,2,0,'L','0')--CONVERT(char(2),l5.lang_cd)                -- PROB
            +Isnull(CONVERT(char(2),l5.category4_cd),SPACE(2))--+Isnull(CONVERT(char(2),l5.category4_cd),'00')                    
            +Isnull(CONVERT(char(2),l5.bank_option5),SPACE(2))--+Isnull(CONVERT(char(2),l5.bank_option5),'00')
            +CONVERT(char(1),l5.staff           )                    
            +CONVERT(char(10),l5.staff_cd        )                    
            --+CONVERT(char(50),l5.bo2_usr_txt1    )                    
			--+CONVERT(char(45),l5.bo2_usr_txt1    ) --changed by pankaj
			 --changed by tushar on jan 09 2015
            +CONVERT(char(40),l5.bo2_usr_txt1    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
            +CONVERT(char(1),l5.EMAIL_STATEMENT_FLAG    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
            +CONVERT(char(2),l5.CAS_MODE    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
            +CONVERT(char(1),l5.MENTAL_DISABILITY    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
            +CONVERT(char(1),l5.Filler1    )  -- here we need to bifurcate rgess, annual report flag , psi and email rta download , bsda flag - Dec 01 2014                  
--changed by tushar on jan 09 2015     
			+CONVERT(char(1),l5.rgss_flg)
			+CONVERT(char(1),l5.annual_rpt_flg)
			+CONVERT(char(1),l5.pldg_std_inst_flg)
			+CONVERT(char(1),l5.email_rta_down_flg)
			+CONVERT(char(1),l5.bsda_flg)
            +CONVERT(char(50),l5.bo2_usr_txt2)                    
            +Isnull(CONVERT(char(4),l5.dummy1),SPACE(4))--+Isnull(CONVERT(char(4),l5.dummy1),'0000')
            +Isnull(CONVERT(char(4),l5.dummy2),SPACE(4))--+Isnull(CONVERT(char(4),l5.dummy2),'0000')
            +Isnull(CONVERT(char(4),l5.dummy3),SPACE(4))--+Isnull(CONVERT(char(4),l5.dummy3),'0000')                    
            +Isnull(CONVERT(char(2),l5.secur_acc_cd),SPACE(2))--+Isnull(CONVERT(char(2),l5.secur_acc_cd),'00')                    
            +Isnull(CONVERT(char(2),l5.bo_catg),SPACE(2))--+Isnull(CONVERT(char(2),l5.bo_catg),'00')                    
            +CONVERT(char(1),l5.bo_settm_plan_fg)                    
            +CONVERT(char(15),l5.voice_mail      )                    
            +CONVERT(char(30),l5.rbi_ref_no      )                    
            +CASE WHEN CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/',''))='' THEN SPACE(8) ELSE CONVERT(char(8),replace(convert(varchar,l5.rbi_app_dt,103),'/','')) END                     
            +CONVERT(char(24),l5.sebi_reg_no     )                    
            +Isnull(CONVERT(char(2),l5.benef_tax_ded_sta),SPACE(2))
            +CONVERT(char(1),l5.smart_crd_req     )                  
            +CONVERT(char(20),l5.smart_crd_no      )                  
            +CONVERT(char(10),l5.smart_crd_pin     )                  
            +CONVERT(char(1),l5.ecs)                  
            +CONVERT(char(1),l5.elec_confirm)                  
            +Isnull(CONVERT(char(6),l5.dividend_curr),SPACE(6))
            +CONVERT(char(8),l5.group_cd          )                  
            --+Isnull(CONVERT(char(2),l5.bo_sub_status),'00')
            --+Isnull(CONVERT(char(6),l5.clr_corp_id),'000000')
            +CONVERT(char(4),l5.bo_sub_status     )                  
            +CONVERT(char(4),l5.clr_corp_id       )
            +CONVERT(char(8),l5.clr_member_id     )                  
            +Isnull(CONVERT(char(2),l5.stoc_exch),SPACE(2))--+Isnull(CONVERT(char(2),l5.stoc_exch),'00')
--            +CONVERT(char(8),l5.confir_waived     )                  
--            +CONVERT(char(1),l5.trading_id        )    
			+CONVERT(char(1),l5.confir_waived     )                  
            +CONVERT(char(8),l5.trading_id        )              
            +CONVERT(char(2),l5.bo_statm_cycle_cd )                  
            +CONVERT(char(12),l5.benf_bank_code    )                  
            +citrus_usr.Fn_FormatStr(LTRIM(RTRIM(l5.benf_brnch_numb)),12,0,'R','') ---CONVERT(char(12),l5.benf_brnch_numb   )                  
            +CONVERT(char(20),l5.benf_bank_acno    )                  
            +Isnull(CONVERT(char(6),l5.benf_bank_ccy),SPACE(6))--+Isnull(CONVERT(char(6),l5.benf_bank_ccy),'000000')
            +CONVERT(char(12),l5.divnd_brnch_numb  )                  
            +CONVERT(char(12),l5.divnd_bank_code   )                  
            +CONVERT(char(20),l5.divnd_acct_numb   )                  
            +CONVERT(char(6),l5.divnd_bank_ccy ),'') line_fifth_detail                  
            ,ISNULL(l6.ln_no,'06')  ln_no6
            --, '' line_sixth_detail                 
            ,ISNULL(CONVERT(char(16),l6.poa_id)                                    
            +CONVERT(char(8),replace(convert(varchar, l6.setup_date,103),'/','') )                           
            +CONVERT(char(1),l6.poa_to_opr_ac  )                           
            +CONVERT(char(1),l6.gpa_bpa_fl     )                           
            +CONVERT(char(8),replace(convert(varchar,l6.eff_frm_dt,103),'/','')     )                           
            +case when CONVERT(char(8),replace(convert(varchar,l6.eff_to_dt,103),'/','')       )  = '01011900' then '00000000' else CONVERT(char(8),replace(convert(varchar,l6.eff_to_dt,103),'/','')       ) end                        
            +CONVERT(char(4),l6.usr_fld1       )                           
            +CONVERT(char(4),l6.usr_fld2       )                           
            +CONVERT(char(50),l6.ca_charfld     )                           
            +CONVERT(char(100),l6.bo_name3       )                         
            +CONVERT(char(20),l6.bo_mid_name3   )                            
            +CONVERT(char(20),l6.cust_srh_name3 )                           
            +CONVERT(char(10),l6.bo_title3 )                                
            +CONVERT(char(10),l6.bo_suffix3)                                
            +CONVERT(char(50),l6.hldr_fth_hsb_nm3)                  
            +CONVERT(char(30),l6.cus_addr1   )                              
            +CONVERT(char(30),l6.cust_addr2  )                              
            +CONVERT(char(30),l6.cust_addr3  )                              
            +CONVERT(char(25),l6.cust_city   )                              
            +CONVERT(char(25),l6.cust__state )                              
            +CONVERT(char(25),l6.cust_cntry  )                              
            +CONVERT(char(10),l6.cust_zip    )                              
            +CONVERT(char(1),isnull(l6.cust_ph1_ind,'0'))                              
            +CONVERT(char(17),isnull(l6.cust_ph1,''))                              
            +CONVERT(char(1),l6.cust_ph2_ind)                              
            +CONVERT(char(17),l6.cust_ph2    )                              
            +CONVERT(char(100),l6.cust_addl_ph)                              
            +CONVERT(char(17),l6.cust_fax    )                              
            +CONVERT(char(25),l6.pan_no      )                              
            +CONVERT(char(15),l6.it_crc      )                              
            +CONVERT(char(50),l6.cust_email  )                        
            +CONVERT(char(50),l6.bo3_usr_txt1)                              
            +CONVERT(char(50),l6.bo3_usr_txt2)                              
            +CONVERT(char(4),l6.bo3_usr_fld3)                              
            +CONVERT(char(4),l6.bo3_usr_fld4)                              
            +CONVERT(char(4),l6.bo3_usr_fld5)                              
            +CONVERT(char(1),l6.sign_file_fl),'') line_sixth_detail                  
            ,ISNULL(l7.ln_no,'07')  ln_no7                                  
           ,ISNULL(CONVERT(char(2),right(ltrim(rtrim(l7.Purpose_code)),2))                             
           +CONVERT(char(100),l7.bo_name         )                         
           +CONVERT(char(20),l7.bo_middle_nm    )                         
           +CONVERT(char(20),l7.cust_search_name)                         
           +CONVERT(char(10),l7.bo_title        )                         
           +CONVERT(char(10),l7.bo_suffix       )                         
           +CONVERT(char(50),l7.hldr_fth_hs_name)                         
           +CONVERT(char(55),l7.cust_addr1      )                         
           +CONVERT(char(55),l7.cust_addr2      )                         
           +CONVERT(char(55),l7.cust_addr3      )                         
           --+CONVERT(char(25),l7.cust_city       )                         
           --+CONVERT(char(25),l7.cust_state      )                         
           --+CONVERT(char(25),l7.cust_cntry      )                         
           --+CONVERT(char(10),l7.cust_zip        )                         
           --+CONVERT(char(1),isnull(l7.cust_ph1_id,'')     )                       
           --+CONVERT(char(17),isnull(l7.cust_ph1,'')        )                         
           --+CONVERT(char(1),l7.cust_ph2_in     )                         
           --+CONVERT(char(17),l7.cust_ph2        )                         
           --+CONVERT(char(92),l7.cust_addl_ph    )
		   +CONVERT(char(2),l7.ln7_cust_adr_cntry_cd      ) 
		   +CONVERT(char(10),l7.cust_zip        )    
		   +CONVERT(char(6),l7.ln7_cust_adr_state_cd        )   
		   +CONVERT(char(25),l7.cust_state      )    
           +CONVERT(char(25),l7.cust_city       )                         
           --+CONVERT(char(2),l7.ln7_city_seq_no       )                                              
           +CONVERT(char(2),case when isnull(l7.ln7_city_seq_no,'')='' then '00' else isnull(l7.ln7_city_seq_no,'') end        )                                              
           --+CONVERT(char(25),l7.cust_cntry      )                         
                               
           --+CONVERT(char(1),isnull(l7.cust_ph1_id,'')     )                       
		   --+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(6),isnull(l7.ln7_Pri_mob_ISD,''))    else '' end                     
     --      +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(17),isnull(l7.cust_ph1,'')        )   else '' end                      
			+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(6),isnull(l7.ln7_Pri_mob_ISD,''))    else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then space(6) else '' end end                     
           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(17),isnull(l7.cust_ph1,'')        )   else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then space(17) else '' end end                      
           --+CONVERT(char(1),l7.cust_ph2_in     )                         
           --+CONVERT(char(17),l7.cust_ph2        )                         
           --+CONVERT(char(92),l7.cust_addl_ph    )  

		   --+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(8),l7.dob    )        else '' end                    
		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(8),l7.dob) else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then space(8) else '' end end                    
           +CONVERT(char(17),l7.cust_fax        )                         
     --      +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(10),l7.hldr_in_tax_pan ) ELSE '' END 
		   --+CASE when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' THEN CONVERT(char(25),'R'+l7.hldr_in_tax_pan ) ELSE '' end                  --25
		   
		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(10),l7.hldr_in_tax_pan ) when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then CONVERT(char(25),l7.hldr_in_tax_pan ) ELSE case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then  SPACE(10) else char(25) end END 
		   
		   
		   --+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(16),space(16))     else '' end             --uid
		   --+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(1),space(1))      else '' end            --uid flag
 +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(16),space(16)) else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then  space(16) else '' end end             --uid
		   +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(1),space(1))  else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then space(1) else '' end end            --uid flag
           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(varchar(2),l7.name_ch_reason_cd)  else '' end
		   
           +CONVERT(char(15),l7.it_crl          )                         
           --+case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <>'212' then CONVERT(char(100),l7.cust_email      )   else '' end                      -- 50
           +case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <> '212' then CONVERT(varchar(100),l7.cust_email)   else case when CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) <> '212' then space(100) else '' end end                      -- 50
           +CONVERT(char(50),l7.usr_txt1        )                         
           +CONVERT(char(50),l7.usr_txt2        )  
		                    
           +CASE WHEN CONVERT(char(4),l7.usr_fld3) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld3) END                         
           +CASE WHEN CONVERT(char(4),l7.usr_fld4) ='0' THEN '0000' ELSE CONVERT(char(4),l7.usr_fld4) END                         
           +CASE WHEN CONVERT(char(4),l7.usr_fld5) =0 THEN '0000' ELSE CONVERT(char(4),l7.usr_fld5) END,'') 
           
           +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@' else CONVERT(char(2),l7.nom_serial_no) end,'@@','')
           +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@' else CONVERT(char(2),l7.rel_withbo) end,'@@','')
           +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@@@@@' else CONVERT(char(5),l7.sharepercent) end,'@@@@@','')
           +replace(CASE WHEN CONVERT(char(3),right(ltrim(rtrim(l7.Purpose_code)),3)) ='212' then '@' else CONVERT(char(1),l7.res_sec_flag) end,'@','')
           
            + space(100) 

           line_seventh_detail 
           ,l7.purpose_code 
           ,'08' ln_no8
           ,isnull(l8.purposecode,'')           
			+CONVERT(char(1),isnull(l8.flag,'') )                  
			+CONVERT(char(10),isnull(replace(l8.mobile,'@',''),''))                      
			+CONVERT(char(100),isnull(l8.email ,''))                 
			+CONVERT(char(100),isnull(l8.remarks,''))                  
			+CONVERT(char(1),isnull(replace(l8.push_flg,'@',''),'')  )    line_eigth_detail  
			--+CONVERT(char(1),isnull(l8.flag,'') )                  
			--+CONVERT(char(10),isnull(l8.mobile,''))                      
			--+CONVERT(char(100),isnull(l8.email ,''))                 
			--+CONVERT(char(100),isnull(l8.remarks,''))                  
			--+CONVERT(char(1),isnull(l8.push_flg,'')  )        line_eigth_detail    
		   --,''	line_eigth_detail
		  ,ISNULL(Borequestdt,'') Borequestdt
           ,      l7.nom_serial_no  
     from   #tempdata 
			left outer join @line2 l2  on l2.acct_no = dpam_sba_no 
            left outer join @line5 l5  on dpam_sba_no = l5.acct_no                           
            left outer join   
			@line6 l6       on  dpam_sba_no = l6.acct_no 
			left outer join   
			@line7 l7       on                  dpam_sba_no = l7.acct_no  
			left outer join   
            @line8 l8       on                  dpam_sba_no = l8.acct_no   and (isnull(l8.mobile,'') <> '' or  isnull(l8.email,'') <> '')
			left outer join 
            @line3 l3       on                  dpam_sba_no = l3.acct_no                           
            left outer join   
            @line4 l4       on                  dpam_sba_no = l4.acct_no       
             
      --where  NOT EXISTS (select CDSL_ACCT_ID FROM cdsl_dpm_response where CDSL_ACCT_ID = isnull(l2.acct_no,'0'))                
      order by dpam_sba_no asc, line_sixth_detail asc, l7.purpose_code desc,l7.nom_serial_no asc 

	  */
	  /*Commented old version date sep 10 2024*/ 


        
     update dpam set dpam_batch_no =  @PA_BATCH_NO from @line2 , dp_acct_mstr dpam where dpam_acct_no = acct_no  
        
        
     select @l_counter = COUNT(acct_no) from @line2 l2   
  
     SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
  
  
     IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='C')  
     BEGIN  
     --  
      
       INSERT INTO BATCHNO_CDSL_MSTR                                       
       (    
        BATCHC_DPM_ID,  
        BATCHC_NO,  
        BATCHC_RECORDS ,           
        BATCHC_TRANS_TYPE,   
        BATCHC_FILEGEN_DT,   
        BATCHC_TYPE,  
        BATCHC_STATUS,  
        BATCHC_CREATED_BY,  
        BATCHC_CREATED_DT , BATCHC_LST_UPD_BY,  
        BATCHC_LST_UPD_DT ,  
        BATCHC_DELETED_IND  
       )  
       VALUES  
       (  
        @L_DPM_ID,  
        @PA_BATCH_NO,  
        @l_counter,  
        'ACCOUNT MODIFICATION',  
        CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' ,  
        'C',  
        'P',  
        @PA_LOGINNAME,  
        GETDATE(),   @PA_LOGINNAME,  
        GETDATE(),  
        1  
        )  
       
       
       
       --UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
       --WHERE BITRM_PARENT_CD ='CDSL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
       
       update bitmap_ref_mstr set BITRM_BIT_LOCATION=convert(numeric,BITRM_BIT_LOCATION) + convert(numeric,@l_06cnt ) where BITRM_PARENT_CD = 'POAID_AUTO'  
         
     --  
     END  
                                         
                                     
       
--CDSL_BTCH_CLT_CURNO  
        
      
--Added by pankaj for new column in client_list_modified for batch no column on 20/09/2013                        
     UPDATE client_list_modified SET clic_mod_batch_no = @PA_BATCH_NO
	 FROM client_list_modified C1
	 INNER JOIN  @CRN
	 ON C1.clic_mod_dpam_sba_no = ACCT_NO
	 --AND convert(varchar,c1.clic_mod_from_dt,103)  between @pa_from_dt and @pa_to_dt               
	 --AND convert(varchar,c1.clic_mod_to_dt,103)  between @pa_from_dt and @pa_to_dt
	 AND convert(datetime,convert(varchar(11),clic_mod_lst_upd_dt,109))  between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)               
	 --AND convert(datetime,convert(varchar(11),clic_mod_to_dt,109))   between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
	 AND ISNULL(clic_mod_batch_no ,0) = 0
	 AND clic_mod_action like case when upper(@pa_mod_typ )='ALL' then '%%' else @pa_mod_typ end
	 and clic_mod_deleted_ind = 1
--Added by pankaj for new column in client_list_modified for batch no column on 20/09/2013           
              

	if exists(
	select * from client_list_modified 
	where clic_mod_action = 'signature' 
	and ISNULL(clic_mod_batch_no,0) =0
	--AND convert(varchar,clic_mod_from_dt,103)  between @pa_from_dt and @pa_to_dt               
	--AND convert(varchar,clic_mod_to_dt,103)  between @pa_from_dt and @pa_to_dt
	AND convert(datetime,convert(varchar(11),clic_mod_lst_upd_dt,109))  between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)               
	--AND convert(datetime,convert(varchar(11),clic_mod_to_dt,109))   between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
	)
	begin
		UPDATE client_list_modified SET clic_mod_batch_no = @PA_BATCH_NO
		 FROM client_list_modified C1,@CRN,dp_acct_mstr
		 where C1.clic_mod_dpam_sba_no = DPAM_SBA_NO
		 and DPAM_ACCT_NO = ACCT_NO
		 --AND convert(varchar,c1.clic_mod_from_dt,103)  between @pa_from_dt and @pa_to_dt               
		 --AND convert(varchar,c1.clic_mod_to_dt,103)  between @pa_from_dt and @pa_to_dt
		 AND convert(datetime,convert(varchar(11),clic_mod_lst_upd_dt,109))  between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)               
		 --AND convert(datetime,convert(varchar(11),clic_mod_to_dt,109))   between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
		 AND ISNULL(clic_mod_batch_no ,0) = 0    
		 AND clic_mod_action like case when upper(@pa_mod_typ )='ALL' then '%%' else @pa_mod_typ end     
		 and clic_mod_deleted_ind = 1                    
	 end
	                              
    --                  
    END          
                    
--                  
END

GO
