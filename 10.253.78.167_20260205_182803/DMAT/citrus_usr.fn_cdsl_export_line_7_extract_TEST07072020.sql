-- Object: FUNCTION citrus_usr.fn_cdsl_export_line_7_extract_TEST07072020
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




--SELECT * FROM fn_cdsl_export_line_7_extract ('','30/05/2008','03/06/2008')
CREATE function [citrus_usr].[fn_cdsl_export_line_7_extract_TEST07072020](@pa_crn_no      VARCHAR(8000)  
                                            , @pa_from_dt     VARCHAR(11)                  
                                            , @pa_to_dt       VARCHAR(11))  
RETURNS @l_table  TABLE (ln_no                   char(2)                  
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
						,cust_Dob 	             datetime
                        ,cust_fax                char(100)                   
                        ,hldr_in_tax_pan         char(100)                    
                        ,it_crl                  char(100)                   
                        ,cust_email              char(100)                  
                        ,usr_txt1                char(100)                    
                        ,usr_txt2                char(100)                   
                        ,usr_fld3                numeric                  
                        ,usr_fld4                numeric                      
                        ,usr_fld5                numeric         
						,nom_serial_no varchar(10)
						,rel_withbo    varchar(10)
						,sharepercent varchar(10)
						,res_sec_flag char(1)   		

						,ln7_cust_adr_cntry_cd char(2)
						,ln7_cust_adr_state_cd varchar(6)
						,ln7_city_seq_no char(2)
						,ln7_Pri_mob_ISD varchar(6)				         
                        )                                        
AS  
BEGIN  
--  
  DECLARE @crn TABLE (crn          numeric                  
                     ,acct_no      varchar(25)                  
                     ,clim_stam_cd varchar(25)                  
                     ,fm_dt        datetime                  
                     ,to_dt        datetime                  
                   )  
    DECLARE @@rm_id              VARCHAR(8000)                    
          , @@cur_id             VARCHAR(8000)                    
          , @@foundat            INT                    
          , @@delimeterlength    INT                   
          , @@delimeter          CHAR(1)   
          , @l_crn_no            NUMERIC                  
          , @l_acct_no           VARCHAR(25)     
            
  
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
        
  IF @pa_crn_no = ''  
  BEGIN  
  --  
    INSERT INTO @l_table  
    (ln_no                     
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
	,cust_Dob   
	,cust_fax      
    ,hldr_in_tax_pan       
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
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,1 --''--Purpose_code                             
--          ,clim_name1 + ' ' + isnull(clim_name2,'') + ' '  + isnull(clim_name3,'')                  
--          ,isnull(clim_name2,'')                   
--          ,isnull(clim_name3,'')                  
--          ,''                  
--          ,''              
--          ,ISNULL(DPHD_FH_FTHNAME,'')  --father/husband name                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7)--adr_zip                               
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')  <> '' then 'R'   
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  <> '' then 'O'  
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  <> '' then 'M' END  
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')    
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  
--                END  
--          ,''                  
--          ,''  
--          ,''  
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),'')--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0--''--usr_fld3                                 
--          ,0--''--usr_fld4                                 
--          ,0--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , client_bank_accts         cliba                  
--         , bank_mstr                 banm                  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_id            = cliba.cliba_clisba_id                  
--    AND    cliba.cliba_banm_id     = banm.banm_id                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    cliba.cliba_deleted_ind = 1                  
--    AND    banm.banm_deleted_ind   = 1                  
--    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--      
--    UNION  
      
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'10' --''--Purpose_code                             
--          ,clim_name1 
--          ,isnull(clim_name2,'')                   
--          ,case when isnull(clim_name3,'') ='' then '.' else isnull(clim_name3,'') end                 
--          ,case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end             
--          ,''              
--          ,ISNULL(DPHD_FH_FTHNAME,'')  --father/husband name     
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),7)--adr_zip                               
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,3,'N'),'')
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                                 
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--              
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    dpam_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    dpam_clicm_cd      = 24  
--    
--    UNION  
--      
--    SELECT distinct '07'                            ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'11' --''--Purpose_code                             
--          ,clim_name1 
--          ,isnull(clim_name2,'')                   
--          ,case when isnull(clim_name3,'')  ='' then '.' else isnull(clim_name3,'')  end                
--          ,case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                            
--          ,''              
--          ,ISNULL(DPHD_FH_FTHNAME,'') --father/husband name                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),7)--adr_zip                               
--           ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,3,'N'),'') 
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                                 
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    dpam_clicm_cd      = 24    
--    UNION  
          
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'212' --''--Purpose_code                             
          ,clim_name1 
          ,isnull(clim_name2,'')                   
          ,case when isnull(clim_name3,'')='' then '.' else  isnull(clim_name3,'.') end                 
          ,case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                            
          ,''              
          ,ISNULL(DPHD_FH_FTHNAME,'')  --father/husband name                  
           , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> '' 
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) 
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),1) end --adr1                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),2)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),2) end--adr2                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),3)
               else  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),3) end--adr3                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),4)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),4) end--adr_city                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),5)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),5) end--adr_state                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),6)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),6) end--adr_country                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),7)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),7) end --adr_zip                
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')  
,isnull(clim_dob       ,'')
          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax 
          
          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
          ,''  
          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5  
		  ,'',''  ,'',''      
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'Per_ADR1'),''),6 )),'') -- cntry code
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'Per_ADR1'),''),5 )),'')  -- state code
		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'Per_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'Per_ADR1'),''),4)),'' ) -- seqno
		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' 
		  THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   
    FROM   dp_acct_mstr              dpam     
           LEFT OUTER JOIN              
           dp_holder_dtls            dphd  ON dpam.dpam_id            = dphd.dphd_dpam_id                      
                 
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
      
    UNION  
      
   
       
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'206' --''--Purpose_code                             
--          ,isnull(DPHD_NOM_FNAME,'') 
--          ,isnull(DPHD_NOM_MNAME,'')   
--          ,case when isnull(DPHD_NOM_LNAME,'')='' then '.' else isnull(DPHD_NOM_LNAME,'.') end  --isnull(DPHD_NOM_LNAME,'')  
--          ,case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
--          ,''              
--          ,isnull(DPHD_NOM_FTHNAME,'')  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip                               
--           ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
--,isnull(dphd_nom_dob,'')
--         , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

--          ,isnull(DPHD_NOM_PAN_NO,'')  
--          ,''  
--          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                                 
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5          
--		  		  ,'01'
--		  , isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
--		  , isnull(citrus_usr.fn_get_perc(isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NPER_SHR',''),'')),'')
--		  ,case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  
--		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'NOMINEE_ADR1'),''),6 )),'') -- cntry code
--		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'NOMINEE_ADR1'),''),5 )),'')  -- state code
--		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'NOMINEE_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'NOMINEE_ADR1'),''),4)),'' ) -- seqno
--		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'GUAIC'),'')) <> '' 
--		  THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'NOMIC'),'')) ),6,0,'L','0'))   else '000000' END -- pri mob isd                                    

--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    ISNULL(DPHD_NOM_FNAME,'') <> ''  
      
	  SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   
		  
    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (1)
 
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (2)
    
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (3)
    UNION  
      
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'107' --''--Purpose_code                             
          ,isnull(DPHD_GAU_FNAME,'') 
          ,isnull(DPHD_GAU_MNAME,'')   
          ,case when isnull(DPHD_GAU_LNAME,'')='' then '.' else isnull(DPHD_GAU_LNAME,'.') end --isnull(DPHD_GAU_LNAME,'')  
          ,case when DPHD_GAU_GENDER in ('M','MALE') then 'MR'  when DPHD_GAU_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end               
          ,''              
          ,DPHD_GAU_FTHNAME  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),1)--adr1                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),2)--adr2                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),3)--adr3                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),4)--adr_city                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),5)--adr_state                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),6)--adr_country                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),7)--adr_zip                               
             ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,1,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,1,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,2,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,2,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,3,'N'),'') 
,isnull(dphd_gau_dob,'')
          ,''  
		
          ,DPHD_GAU_PAN_NO  
          ,''  
          ,''  
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5   
		  ,''
		  --'13',
		   , isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'GAU_RELA',''),'')),'')
		  		,  '00000',''               
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),6 )),'') -- cntry code
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),5 )),'')  -- state code
		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),4)),'' ) -- seqno
		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'GUAIC'),'')) <> ''
		   THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'GUAIC'),'')) ),6,0,'L','0'))   else '000000' END-- pri mob isd                   
    FROM   dp_acct_mstr              dpam                  
         , dp_holder_dtls            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.dphd_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(DPHD_GAU_FNAME,'') <> ''  
      

      
    UNION  
          
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'108' --''--Purpose_code                             
--          ,isnull(DPHD_NOMGAU_FNAME,'') 
--          ,isnull(DPHD_NOMGAU_MNAME,'')   
--          ,case when isnull(DPHD_NOMGAU_LNAME,'')='' then '.' else isnull(DPHD_NOMGAU_LNAME,'.') end--isnull(DPHD_NOMGAU_LNAME,'')  
--           ,case when DPHD_NOMGAU_GENDER in ('M','MALE') then 'MR'  when DPHD_NOMGAU_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                          
--          ,''              
--          ,DPHD_NOMGAU_FTHNAME  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),7)--adr_zip                               
--            ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,3,'N'),'')  
--,isnull(dphd_NOMGAU_dob,'')
--          ,''  
		
--          ,DPHD_NOMGAU_PAN_NO  
--          ,''  
--          ,''  
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                                 
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5  
--		  ,'01','13','00000',''         
--		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NOM_GUARDIAN_ADDR'),''),6 )),'') -- cntry code
--		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NOM_GUARDIAN_ADDR'),''),5 )),'')  -- state code
--		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NOM_GUARDIAN_ADDR'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NOM_GUARDIAN_ADDR'),''),4)),'' ) -- seqno
--		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'NOMGIC'),'')) <> '' THEN  lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'NOMGIC'),'')) else space(6) END-- pri mob isd                   
                      
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    ISNULL(DPHD_NOMGAU_FNAME,'') <> ''
   SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'108' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'01'
		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,'00000'
		  ,''
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (4)
 
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'108' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'01'
		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')\
		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,'00000'
		  ,''
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (5)
    
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'108' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'0
		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,'00000'
		  ,''
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (6)
   
    union
   
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'18' --''--Purpose_code                             
          ,isnull(DPPD_FNAME,'') 
          ,isnull(DPPD_MNAME,'')   
          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end--isnull(DPHD_NOMGAU_LNAME,'')  
           ,''                       
          ,''              
          ,''  
          ,''           
          ,''      
          ,''
          ,''
          ,''
          ,''
          ,''
          ,''
          ,''
,''
          ,''
          ,''
          ,''
          ,''  
          ,''  
          ,''  
          ,''  
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5       
		  ,'','','00000',''   

		  ,''
		  ,''
		  ,''
		  , '000000'                      
    FROM   dp_acct_mstr              dpam                  
         , dp_poa_dtls            dppd                   
         , client_mstr               clim                  
    WHERE  dpam.dpam_id            = dppd.DPPD_DPAM_ID                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dppd.dppd_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(DPPD_POA_TYPE,'') = 'AUTHORISED SIGNATORY'
    AND    ISNULL(DPPD_FNAME,'') <> ''

 union
   
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'122' --''--Purpose_code                             
          ,'0' + isnull(CUDM_CONSENTFLG,'')--isnull(DPPD_FNAME ,'')
          ,case when  isnull(CUDM_EXID,'')='01' then '12' when  isnull(CUDM_EXID,'')='02' then '11' else '29' end  --isnull(DPPD_MNAME,'')   
          ,isnull(CUDM_UCC,'')--case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPHD_NOMGAU_LNAME,'')  
          ,isnull(CUDM_SEGID,'')                                
                       
          ,isnull(CUDM_CMID,'')
          ,isnull(CUDM_TMCD,'')       
          ,''
          ,''    
          ,''  
          ,''       
          ,''     
          ,''   
          ,''                 
           ,''
          ,''
          ,''
          ,''
          ,'',''
          ,''  
          ,''  
          ,''  
          ,''  
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5  
		   ,'','','00000',''          
		   
		  ,''
		  ,''
		  ,''
		  , '000000'
    FROM   dp_acct_mstr              dpam                  
         
         , client_mstr               clim     
         , CDSL_UCC_DTLS_MSTR             
    WHERE  CUDM_BOID=DPAM_SBA_NO                     
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_deleted_ind   = 1                  
    
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                                 
    and    CUDM_lst_upd_DT BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          


  
  
      

  
  
      
      
  --  
  END  
  ELSE  
  BEGIN  
  --  
    INSERT INTO @l_table  
    (ln_no                     
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
    ,cust_dob
    ,cust_fax              
    ,hldr_in_tax_pan       
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
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,1 --''--Purpose_code                             
--          ,clim_name1 + ' ' + isnull(clim_name2,'') + ' '  + isnull(clim_name3,'')                  
--          ,isnull(clim_name2,'')                   
--          ,isnull(clim_name3,'')                  
--          ,''                  
--          ,''              
--          ,ISNULL(DPHD_fH_FTHNAME,'')    --father/husband name                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7)--adr_zip                               
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')  <> '' then 'R'   
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  <> '' then 'O'  
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  <> '' then 'M' END  
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'RES_PH1'),'')    
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'OFF_PH1'),'')  
--                when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'MOBILE1'),'')  
--                END  
--          ,''                  
--          ,''  
--          ,''  
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),'')--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0--''--usr_fld3                                 
--          ,0--''--usr_fld4                                 
--          ,0--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , @CRN                      CRN      
--         , client_bank_accts         cliba                  
--         , bank_mstr                 banm                  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    CRN.CRN                 = clim.CLIM_CRN_NO  
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_id            = cliba.cliba_clisba_id                  
--    AND    cliba.cliba_banm_id     = banm.banm_id                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    cliba.cliba_deleted_ind = 1                  
--    AND    banm.banm_deleted_ind   = 1                  
--    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
--  
--    UNION  
  
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'10' --''--Purpose_code                             
--          ,clim_name1 
--          ,isnull(clim_name2,'')                   
--          ,case when isnull(clim_name3,'')='' then '.' else isnull(clim_name3,'.') end--isnull(clim_name3,'')                  
--          ,case when clim_gender in ('M','MALE') then 'MR'  when clim_gender in ('F','FEMALE') then 'MS' else 'M/S' end                
--          ,''              
--          ,ISNULL(DPHD_FH_FTHNAME,'')    --father/husband name                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'FH_ADR1'),''),7)--adr_zip                               
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,3,'N'),'')
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                                 
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , @CRN                      CRN  
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                             left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    CRN.CRN                 = CLIM_CRN_NO  
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    dpam_clicm_cd      = 24  
--    UNION  
--  
--    SELECT distinct '07'                  
--          ,clim_crn_no                  
--          ,dpam_acct_no                  
--          ,'11' --''--Purpose_code                             
--          ,clim_name1 
--          ,isnull(clim_name2,'')                   
--          ,case when isnull(clim_name3,'')='' then '.' else isnull(clim_name3,'.') end          
--          ,case when clim_gender in ('M','MALE') then 'MR'  when clim_gender in ('F','FEMALE') then 'MS' else 'M/S' end                
--          ,''              
--          ,ISNULL(DPHD_FH_FTHNAME,'')   --father/husband name                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),1)--adr1                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),2)--adr2                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),3)--adr3                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),4)--adr_city                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),5)--adr_state                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),6)--adr_country                  
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'NRI_ADR'),''),7)--adr_zip                               
--         ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,1,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'Y'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,2,'N'),'')
--          ,isnull(citrus_usr.fn_fetch_ph('NRI_F',dpam.dpam_id,3,'N'),'')  
--          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
--          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
--          ,''  
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
--          ,''--usr_txt1                                 
--          ,''--usr_txt2                                 
--          ,0000--''--usr_fld3                              
--          ,0000--''--usr_fld4                                 
--          ,0000--''--usr_fld5                           
--    FROM   dp_acct_mstr              dpam                  
--         , dp_holder_dtls            dphd                   
--         , client_mstr               clim                  
--         , @CRN                       CRN   
--         , entity_type_mstr          enttm                  
--         , client_ctgry_mstr         clicm                  
--           left outer join                  
--           sub_ctgry_mstr            subcm                   
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
--    AND    CRN.CRN                 = CLIM_CRN_NO  
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
--    AND    dpam.dpam_deleted_ind   = 1                  
--    AND    dphd.dphd_deleted_ind   = 1                   
--    AND    clim.clim_deleted_ind   = 1                  
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
--    AND    dpam_clicm_cd      = 24 
-- 
--    UNION  
  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'212' --''--Purpose_code                             
          ,clim_name1 
          ,isnull(clim_name2,'')                   
          ,case when isnull(clim_name3,'')='' then '.' else isnull(clim_name3,'.') end         
          ,case when clim_gender in ('M','MALE') then 'MR'  when clim_gender in ('F','FEMALE') then 'MS' else 'M/S' end                 
          ,''              
          ,ISNULL(DPHD_FH_FTHNAME,'')   --father/husband name                  
           , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> '' 
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) 
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),1) end --adr1                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),2)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),2) end--adr2                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),3)
               else  citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),3) end--adr3                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),4)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),4) end--adr_city                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),5)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),5) end--adr_state                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),6)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),6) end--adr_country                  
        , case when citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),1) <> ''
               then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'AC_PER_ADR1'),''),7)
               else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'PER_ADR1'),''),7) end --adr_zip                               
           ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')
,isnull(clim_dob,'')
          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                  
		
          ,isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                  
          ,''  
          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                             
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5    
		  ,'','','',''                             

		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.CLIM_CRN_NO,'Per_ADR1'),''),6 )),'') -- cntry code
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.CLIM_CRN_NO,'Per_ADR1'),''),5 )),'')  -- state code
		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.CLIM_CRN_NO,'Per_ADR1'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.CLIM_CRN_NO,'Per_ADR1'),''),4)),'' ) -- seqno
		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) <> '' 
		  THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'PRIIC'),'')) ),6,0,'L','0'))   else '000000' END -- pri mob isd                                   
    FROM   dp_acct_mstr              dpam                  
           LEFT OUTER JOIN              
           dp_holder_dtls            dphd  ON dpam.dpam_id            = dphd.dphd_dpam_id             
         , client_mstr               clim                  
         , @CRN                      CRN  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  CRN.CRN                 = CLIM_CRN_NO  
	and    dpam.dpam_acct_no       = crn.acct_no 
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    isnull(dphd.dphd_deleted_ind,1) = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
  
    UNION  
  
  SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1       
           ,@crn CRN            
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id     
    AND  CRN.CRN                 = CLIM_CRN_NO  
	and    dpam.dpam_acct_no       = crn.acct_no                          
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1          
   
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (1)
 
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1
           ,@crn CRN                   
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd  
    AND  CRN.CRN                 = CLIM_CRN_NO  
	and    dpam.dpam_acct_no       = crn.acct_no                         
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (2)
    
      
    UNION  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'206' --''--Purpose_code                             
          ,isnull(nom_fname,'') 
          ,isnull(nom_mname,'')   
          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,isnull(nom_mname,'')  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
            ,nom_adr1
			,nom_adr2
			,nom_adr3
			,nom_city
			,nom_state
			,nom_country
			,nom_zip                              
          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
         , nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
,isnull(nom_dob,'')
         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
          ,''  
          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5          
		  		  ,case when nom_srno = '1' then '01' when  nom_srno = '2' then '02'when nom_srno = '3' then '03' end --'01'
		  , nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
		  , isnull(citrus_usr.fn_get_perc(nom_percentage),'')
		  ,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

    FROM   dp_acct_mstr              dpam                  
         , Nominee_Multi            dphd                   
         , client_mstr               clim                  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1   
           ,@crn CRN                
    WHERE  dpam.dpam_id            = dphd.Nom_dpam_id                      
    AND    dpam.dpam_crn_no        = clim.clim_crn_no 
    AND  CRN.CRN                 = CLIM_CRN_NO  
	and    dpam.dpam_acct_no       = crn.acct_no                           
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.nom_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(nom_fname,'') <> ''  
    and nom_srno in (3) 
    UNION  
  
    SELECT distinct '07'                  
          ,clim_crn_no                  
          ,dpam_acct_no                  
          ,'107' --''--Purpose_code                             
          ,isnull(DPHD_GAU_FNAME,'') 
          ,isnull(DPHD_GAU_MNAME,'')   
          ,case when isnull(DPHD_GAU_LNAME,'')='' then '.' else isnull(DPHD_GAU_LNAME,'.') end --isnull(DPHD_GAU_LNAME,'')  
          ,case when DPHD_GAU_gender in ('M','MALE') then 'MR'  when DPHD_GAU_gender in ('F','FEMALE') then 'MS' else 'M/S' end                     
          ,''              
          ,DPHD_GAU_FTHNAME  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),1)--adr1                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),2)--adr2                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),3)--adr3                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),4)--adr_city                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),5)--adr_state                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),6)--adr_country                  
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'GUARD_ADR'),''),7)--adr_zip                               
           ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,1,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,1,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,2,'Y'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,2,'N'),'')
          ,isnull(citrus_usr.fn_fetch_ph('GUARD',dpam.dpam_id,3,'N'),'')  
		  ,isnull(dphd_Gau_dob,'')
          ,''  
		 
          ,DPHD_GAU_PAN_NO  
          ,''  
          ,''  
          ,''--usr_txt1                                 
          ,''--usr_txt2                                 
          ,0000--''--usr_fld3                                 
          ,0000--''--usr_fld4                                 
          ,0000--''--usr_fld5 
		   ,''
		   --,'13'
		   , isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'GAU_RELA',''),'')),'')
		   ,'00000',''                             

		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),6 )),'') -- cntry code
		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),5 )),'')  -- state code
		  ,isnull(citrus_usr.Fn_Toget_CitySeqno(citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),7) ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam_id,'GUARD_ADR'),''),4)),'' ) -- seqno
		  ,CASE WHEN lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'GUAIC'),'')) <> '' THEN
		  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'GUAIC'),'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   
    FROM   dp_acct_mstr              dpam                  
         , dp_holder_dtls            dphd                   
         , client_mstr               clim    
         , @CRN                      CRN  
         , entity_type_mstr          enttm                  
         , client_ctgry_mstr         clicm                  
           left outer join                  
           sub_ctgry_mstr            subcm                   
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                  
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                      
    AND    CRN.CRN                 = CLIM_CRN_NO  
	and    dpam.dpam_acct_no       = crn.acct_no 
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
    AND    dpam.dpam_deleted_ind   = 1                  
    AND    dphd.dphd_deleted_ind   = 1                   
    AND    clim.clim_deleted_ind   = 1                  
    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
    AND    ISNULL(DPHD_GAU_FNAME,'') <> ''  
  
  
----    UNION  
  

----SELECT distinct '07'                  
----          ,clim_crn_no                  
----          ,dpam_acct_no                  
----          ,'108' --''--Purpose_code                             
----          ,isnull(nom_fname,'') 
----          ,isnull(nom_mname,'')   
----          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
----          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
----          ,''              
----          ,isnull(nom_mname,'')  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
----            ,nom_adr1
----			,nom_adr2
----			,nom_adr3
----			,nom_city
----			,nom_state
----			,nom_country
----			,nom_zip                              
----          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
----         , nom_phone1_ind
----		,nom_phone1
----		,nom_phone2_ind
----		,nom_phone2
----		,nom_Addphone
----,isnull(nom_dob,'')
----         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

----          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
----          ,''  
----          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
----          ,''--usr_txt1                                 
----          ,''--usr_txt2                                 
----          ,0000--''--usr_fld3                                 
----          ,0000--''--usr_fld4                                 
----          ,0000--''--usr_fld5          
----		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'01'
----		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
----		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
----		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
----		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
----		  ,'00000'
----		  ,''
----		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
----,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
----,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
----,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

----    FROM   dp_acct_mstr              dpam                  
----         , Nominee_Multi            dphd                   
----         , client_mstr               clim                  
----         , entity_type_mstr          enttm                  
----         , client_ctgry_mstr         clicm                  
----           left outer join                  
----           sub_ctgry_mstr            subcm                   
----           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1    
----           ,@crn CRN               
----    WHERE  1=0 AND dpam.dpam_id            = dphd.Nom_dpam_id                      
----    AND    dpam.dpam_crn_no        = clim.clim_crn_no 
----     AND    CRN.CRN                 = CLIM_CRN_NO  
---- and    dpam.dpam_acct_no       = crn.acct_no                   
----    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
----    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
----    AND    dpam.dpam_deleted_ind   = 1                  
----    AND    dphd.nom_deleted_ind   = 1                   
----    AND    clim.clim_deleted_ind   = 1                  
----    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
----    AND    ISNULL(nom_fname,'') <> ''  
----    and nom_srno in (4)
 
      
----    UNION  
----    SELECT distinct '07'                  
----          ,clim_crn_no                  
----          ,dpam_acct_no                  
----          ,'108' --''--Purpose_code                             
----          ,isnull(nom_fname,'') 
----          ,isnull(nom_mname,'')   
----          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
----          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
----          ,''              
----          ,isnull(nom_mname,'')  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
----            ,nom_adr1
----			,nom_adr2
----			,nom_adr3
----			,nom_city
----			,nom_state
----			,nom_country
----			,nom_zip                              
----          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
----         , nom_phone1_ind
----		,nom_phone1
----		,nom_phone2_ind
----		,nom_phone2
----		,nom_Addphone
----,isnull(nom_dob,'')
----         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

----          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
----          ,''  
----          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
----          ,''--usr_txt1                                 
----          ,''--usr_txt2                                 
----          ,0000--''--usr_fld3                                 
----          ,0000--''--usr_fld4                                 
----          ,0000--''--usr_fld5          
----		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'01
----		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
----		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
----		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
----		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
----		  ,'00000'
----		  ,''
----		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
----,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
----,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
----,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

----    FROM   dp_acct_mstr              dpam                  
----         , Nominee_Multi            dphd                   
----         , client_mstr               clim                  
----         , entity_type_mstr          enttm                  
----         , client_ctgry_mstr         clicm                  
----           left outer join                  
----           sub_ctgry_mstr            subcm                   
----           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1  
----           ,@crn CRN                 
----    WHERE  1=0 AND dpam.dpam_id            = dphd.Nom_dpam_id                      
----    AND    dpam.dpam_crn_no        = clim.clim_crn_no   
----     AND    CRN.CRN                 = CLIM_CRN_NO  
---- and    dpam.dpam_acct_no       = crn.acct_no                 
----    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
----    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
----    AND    dpam.dpam_deleted_ind   = 1                  
----    AND    dphd.nom_deleted_ind   = 1                   
----    AND    clim.clim_deleted_ind   = 1                  
----    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
----    AND    ISNULL(nom_fname,'') <> ''  
----    and nom_srno in (5)
    
      
----    UNION  
----    SELECT distinct '07'                  
----          ,clim_crn_no                  
----          ,dpam_acct_no                  
----          ,'108' --''--Purpose_code                             
----          ,isnull(nom_fname,'') 
----          ,isnull(nom_mname,'')   
----          ,case when isnull(nom_tname,'')='' then '.' else isnull(nom_tname,'.') end  --isnull(DPHD_NOM_LNAME,'')  
----          ,'' --case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                     
----          ,''              
----          ,isnull(nom_mname,'')  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                  
----          --,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip 
----            ,nom_adr1
----			,nom_adr2
----			,nom_adr3
----			,nom_city
----			,nom_state
----			,nom_country
----			,nom_zip                              
----          -- ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')
----          --,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
----         , nom_phone1_ind
----		,nom_phone1
----		,nom_phone2_ind
----		,nom_phone2
----		,nom_Addphone
----,isnull(nom_dob,'')
----         ,nom_fax--, isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax

----          ,nom_pan--isnull(DPHD_NOM_PAN_NO,'')  
----          ,''  
----          ,nom_email-- isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_MAIL'),'')--fax
----          ,''--usr_txt1                                 
----          ,''--usr_txt2                                 
----          ,0000--''--usr_fld3                                 
----          ,0000--''--usr_fld4                                 
----          ,0000--''--usr_fld5          
----		  		  ,case when nom_srno = '4' then '01' when  nom_srno = '5' then '02'when nom_srno = '6' then '03' end --'01'
----		  --, nom_relation--isnull(citrus_usr.fn_get_cd_rel( isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRELATN_BO',''),'')),'')
----		  , case when  nom_relation = '0' then '00' else nom_relation end nom_relation
----		  --, isnull(citrus_usr.fn_get_perc(nom_percentage),'')
----		  --,nom_res_sec_flag--case when  isnull(citrus_usr.fn_ucc_accp(dpam.dpam_id,'1ST_NRED_SEC_FLG','') ,'')                   ='YES' then 'Y' else 'N' end 
----		  ,'00000'
----		  ,''
----		  ,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('Country',nom_country ),'') -- cntry code
----,isnull(citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE('State',nom_State),'')  -- state code
----,isnull(citrus_usr.Fn_Toget_CitySeqno(nom_zip ,nom_city),'' ) -- seqno
----,case when nom_phone1_ind <> '' THEN  convert(varchar(6),citrus_usr.FN_FORMATSTR(convert(varchar(6),lower(isnull(nom_phone1_ind,'')) ),6,0,'L','0'))  else '000000' END -- pri mob isd                   

----    FROM   dp_acct_mstr              dpam                  
----         , Nominee_Multi            dphd                   
----         , client_mstr               clim                  
----         , entity_type_mstr          enttm                  
----         , client_ctgry_mstr         clicm                  
----           left outer join                  
----           sub_ctgry_mstr            subcm                   
----           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1  
----           ,@crn CRN                 
----    WHERE 1=0 AND  dpam.dpam_id            = dphd.Nom_dpam_id                      
----    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
----    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
----    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd     
----     AND    CRN.CRN                 = CLIM_CRN_NO  
---- and    dpam.dpam_acct_no       = crn.acct_no              
----    AND    dpam.dpam_deleted_ind   = 1                  
----    AND    dphd.nom_deleted_ind   = 1                   
----    AND    clim.clim_deleted_ind   = 1                  
----    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
----    AND    ISNULL(nom_fname,'') <> ''  
----    and nom_srno in (6)
----union

----    SELECT distinct '07'                  
----          ,clim_crn_no                  
----          ,dpam_acct_no                  
----          ,'18' --''--Purpose_code                             
----          ,isnull(DPPD_FNAME ,'')
----          ,isnull(DPPD_MNAME,'')   
----          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPHD_NOMGAU_LNAME,'')  
----          ,''                               
----          ,''              
----          ,''  
----          ,''        
----          ,''    
----          ,''  
----          ,''       
----          ,''     
----          ,''   
----          ,''                 
----           ,''
----          ,''
----          ,''
----          ,''
----          ,'',''
----          ,''  
----          ,''  
----          ,''  
----          ,''  
----          ,''--usr_txt1                                 
----          ,''--usr_txt2                                 
----          ,0000--''--usr_fld3                                 
----          ,0000--''--usr_fld4                                 
----          ,0000--''--usr_fld5  
----		   ,'','','00000',''          
		   
----		  ,''
----		  ,''
----		  ,''
----		  , '000000'
		                     
----    FROM   dp_acct_mstr              dpam                  
----         , dp_poa_dtls            dppd                   
----         , client_mstr               clim                  
----         , @CRN                      CRN  
              
----    WHERE  1=0 AND dpam.dpam_id            = dppd.dppd_dpam_id                      
----    AND    CRN.CRN                 = CLIM_CRN_NO  
----    AND    dpam.dpam_crn_no        = clim.clim_crn_no                   
---- 	and    dpam.dpam_acct_no       = crn.acct_no 
----    AND    dpam.dpam_deleted_ind   = 1                  
----    AND    dpPd.dppd_deleted_ind   = 1                   
----    AND    clim.clim_deleted_ind   = 1                  
        
----    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          
----     AND    ISNULL(DPPD_POA_TYPE,'') = 'AUTHORISED SIGNATORY'
----    AND    ISNULL(DPPD_FNAME,'') <> '' --AND DPAM_CLICM_CD<>'25'
 
----  union
   
----    SELECT distinct '07'                  
----          ,clim_crn_no                  
----          ,dpam_acct_no                  
----          ,'122' --''--Purpose_code                             
----          ,'0' + isnull(CUDM_CONSENTFLG,'')--isnull(DPPD_FNAME ,'')
----          ,case when  isnull(CUDM_EXID,'')='01' then '12' when  isnull(CUDM_EXID,'')='02' then '11' else '29' end  --isnull(DPPD_MNAME,'')   
----          ,isnull(CUDM_UCC,'')--case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPHD_NOMGAU_LNAME,'')  
----          ,isnull(CUDM_SEGID,'')                                
                       
----          ,isnull(CUDM_CMID,'')
----          ,isnull(CUDM_TMCD,'')       
----          ,''
----          ,''    
----          ,''  
----          ,''       
----          ,''     
----          ,''   
----          ,''                 
----           ,''
----          ,''
----          ,''
----          ,''
----          ,'',''
----          ,''  
----          ,''  
----          ,''  
----          ,''  
----          ,''--usr_txt1                                 
----          ,''--usr_txt2                                 
----          ,0000--''--usr_fld3                                 
----          ,0000--''--usr_fld4                                 
----          ,0000--''--usr_fld5  
----		   ,'','','00000',''          
		   
----		  ,''
----		  ,''
----		  ,''
----		  , '000000'
----    FROM   dp_acct_mstr              dpam                  
         
----         , client_mstr               clim     
----         , CDSL_UCC_DTLS_MSTR         
----          , @CRN                      CRN      
----    WHERE 1=0 AND  CUDM_BOID=DPAM_SBA_NO                     
----    AND    dpam.dpam_crn_no        = clim.clim_crn_no   
----    AND    CRN.CRN                 = CLIM_CRN_NO 
----    and    dpam.dpam_acct_no       = crn.acct_no                  
----    AND    dpam.dpam_deleted_ind   = 1                  
    
----    AND    clim.clim_deleted_ind   = 1                  
----    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                                 
----    and    CUDM_lst_upd_DT BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                          


  
  
      
  --  
  END  


  

    
  
  return   
  
  
--  
END

GO
