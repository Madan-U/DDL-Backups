-- Object: FUNCTION citrus_usr.fn_cdsl_export_line_7_extract_newversion_mod_BAK_30092015_AFTERCHANGE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

  
  
  
--select * from citrus_usr.fn_exch_list('5|*~|',33)    
/*    
Purpose code Code Description    
1 First Holder Name and Address--clim_name1     
2 Second Holder Name and Address--dphd_sh_fname    
3 Third Holder Name and Address--dphd_th_fname    
4 Fourth Holder Name and Address--?????????????    
5 POA Name and Address--dppd_fname--first holder     
6 Nominee Name and Address--dphd_nom_fname    
7 Guardian Name and Address--dphd_gau_fname    
8 Nominee's Guardian Name and Address--dphd_nomgau_fname    
9 Corporate Regd. Office Name and Address--?????????    
10 NRI Foreign Address--??????    
11 NRI Indian Address--????????    
12 Permanent Address--????????    
13 2nd Holder's POA--second holder    
14 3rd Holder's POA--third_holder    
15 Corporate Office Address--????????/    
    
*/    
  
--SELECT * FROM fn_cdsl_export_line_7_extract ('','30/05/2008','03/06/2008')  
CREATE function [citrus_usr].[fn_cdsl_export_line_7_extract_newversion_mod_BAK_30092015_AFTERCHANGE](@pa_crn_no      VARCHAR(8000)    
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
						,dob					 char(8)
                        ,cust_fax                char(100)                     
                        ,hldr_in_tax_pan         char(100)                      
                        ,it_crl                  char(100)                     
                        ,cust_email              char(100)                    
                        ,usr_txt1                char(100)                      
                        ,usr_txt2                char(100)                     
                        ,usr_fld3                numeric                    
                        ,usr_fld4                char(4)                        
                        ,usr_fld5                numeric                    
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
	,dob
    ,cust_fax                
    ,hldr_in_tax_pan         
    ,it_crl                  
    ,cust_email              
    ,usr_txt1                
    ,usr_txt2                
    ,usr_fld3                
    ,usr_fld4                
    ,usr_fld5                
    )           
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
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
--   AND    banm.banm_deleted_ind   = 1                    
--    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
--        
--    UNION    
        
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
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
--          ,dpam_sba_no                    
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
          ,dpam_sba_no                    
          ,'212' --''--Purpose_code                               
--          ,clim_name1   
--          ,isnull(clim_name2,'')                     
--          ,case when isnull(clim_name3,'')='' then '.' else  isnull(clim_name3,'.') end     
    ,''  
    ,''  
    ,''                
          ,''--,case when CLIM_GENDER in ('M','MALE') then 'MR'  when CLIM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                              
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
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')    
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,clim.clim_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,clim.clim_dob,103),'/','')),'')  end 
          ,''--isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax                    
          ,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                    
          ,''    
          ,''--lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                               
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4    
    --,'M'                                 
   --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '12') THEN 'S' ELSE 'M' END  
   --,CASE WHEN not exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12') THEN 'S' ELSE 'M' END  
   --,CASE WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '1') THEN 'M' ELSE 'D' END  
   ,CASE WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '3') THEN 'S' WHEN not exists (select 1 from dps8_pc12 where BOId = dpam_sba_no  and PurposeCode12 = '12') then 'S' WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and (TypeOfTrans = '1' or TypeOfTrans ='2' or TypeOfTrans ='')) THEN 'M' ELSE 'D' END  
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam       
           LEFT OUTER JOIN                
           dp_holder_dtls            dphd  ON dpam.dpam_id            = dphd.dphd_dpam_id                        
                   
         , client_mstr               clim                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
             , client_list_modified  climmod   
    WHERE  dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    isnull(dphd.dphd_deleted_ind,1)   = 1                     
    AND    clim.clim_deleted_ind   = 1         
    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('P Address')  
                               
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                              
        
    UNION    
        
   /* SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'02' --''--Purpose_code                               
          ,dphd_sh_fname + ' ' +  isnull(dphd_sh_mname,'') + ' ' +  isnull(dphd_sh_lname,'')    
          ,isnull(dphd_sh_mname,'')     
          ,isnull(dphd_sh_lname,'')    
          ,''                    
          ,''                
          ,ISNULL(DPHD_SH_FTHNAME,'')    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),7)--adr_zip                                 
         ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,3,'N'),'')  
          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_FAX1'),'')--fax     
          ,DPHD_SH_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
          ,0000--''--usr_fld4                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , client_bank_accts         cliba                    
         , bank_mstr                 banm                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
    AND    cliba.cliba_banm_id     = banm.banm_id                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
    AND    cliba.cliba_deleted_ind = 1                    
    AND    banm.banm_deleted_ind   = 1                    
    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
    AND    ISNULL(dphd_sh_fname,'') <> ''    
    
    UNION    
        
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'03' --''--Purpose_code                               
          ,dphd_Th_fname + ' ' +  isnull(dphd_Th_mname,'') + ' ' +  isnull(dphd_Th_lname,'')    
          ,isnull(dphd_Th_mname,'')     
          ,isnull(dphd_Th_lname,'')    
          ,''                    
          ,''                
          ,ISNULL(DPHD_TH_FTHNAME,'')      
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),7)--adr_zip                                 
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,3,'N'),'')  
          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_FAX1'),'')--fax      
          ,DPHD_TH_PAN_NO    
          ,''    
          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'TH_POA_MAIL'),'')--email        
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
          ,0000--''--usr_fld4                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , client_bank_accts         cliba                    
         , bank_mstr                 banm                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
    AND    cliba.cliba_banm_id     = banm.banm_id                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
    AND    cliba.cliba_deleted_ind = 1                    
    AND    banm.banm_deleted_ind   = 1                    
    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
    AND    ISNULL(dphd_Th_fname,'') <> ''    
        
    UNION    
            
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
--          ,5 --''--Purpose_code                               
--          ,DPPD_FNAME + ' ' +  ISNULL(DPPD_MNAME,'') + ' ' +  ISNULL(DPPD_LNAME,'')    
--          ,isnull(DPPD_MNAME,'')     
--          ,isnull(DPPD_LNAME,'')    
--          ,''                    
--          ,''                
--          ,DPPD_FTHNAME    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),1)--adr1                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),2)--adr2                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),3)--adr3                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),4)--adr_city                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),5)--adr_state                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),6)--adr_country                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),7)--adr_zip                                 
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')  <> '' then 'O'     
--                END    
--          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')      
--                END    
--          ,''                    
--          ,''    
--          ,''    
--          ,''    
--          ,DPPD_PAN_NO    
--        ,''    
--          ,''    
--          ,''--usr_txt1                                   
--          ,''--usr_txt2                                   
--          ,0--''--usr_fld3                                   
--          ,0--''--usr_fld4                                   
--          ,0--''--usr_fld5                             
--    FROM   dp_acct_mstr              dpam                    
--         , dp_holder_dtls            dphd                     
--         , client_mstr               clim                    
--         , client_bank_accts         cliba                    
--         , dp_poa_dtls               dppd    
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
--    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
--    AND    dpam.dpam_deleted_ind   = 1                    
--    AND    dphd.dphd_deleted_ind   = 1                     
--    AND    dppd.dppd_deleted_ind   = 1                     
--    AND    clim.clim_deleted_ind   = 1                    
--    AND    cliba.cliba_deleted_ind = 1                    
--    AND    banm.banm_deleted_ind   = 1                    
--    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
--    AND    ISNULL(DPPD_FNAME,'')               <> ''    
--    and    DPPD_HLD                = '1ST HOLDER'    
        
--    UNION  */  
        
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
--          ,'13' --''--Purpose_code                               
--          ,isnull(DPPD_FNAME,'')   
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end    
--          ,case when DPPD_GENDER in ('M','MALE') then 'MR'  when DPPD_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                                 
--          ,''                
--          ,DPPD_FTHNAME    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),1)--adr1                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),2)--adr2                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),3)--adr3                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),4)--adr_city                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),5)--adr_state                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),6)--adr_country                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),7)--adr_zip                                 
--           ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,1,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,1,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,2,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,2,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,3,'N'),'')    
--          ,''    
--          ,DPPD_PAN_NO    
--          ,''    
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'SH_POA_MAIL'),''))--email      
--          ,''--usr_txt1                                   
--          ,''--usr_txt2                                   
--          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4                                   
--          ,0000--''--usr_fld5                             
--    FROM   dp_acct_mstr              dpam                    
--         , dp_holder_dtls            dphd                     
--         , client_mstr               clim                    
--         , client_bank_accts         cliba                    
--         , dp_poa_dtls               dppd    
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
--    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
--    AND    dpam.dpam_deleted_ind   = 1                    
--    AND    dphd.dphd_deleted_ind   = 1                     
--    AND    dppd.dppd_deleted_ind   = 1                     
--    AND    clim.clim_deleted_ind   = 1                    
--    AND    cliba.cliba_deleted_ind = 1                    
--    AND    banm.banm_deleted_ind   = 1                    
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
--    AND    ISNULL(DPPD_FNAME,'')               <> ''    
--    and    DPPD_HLD                = '2ND HOLDER'    
        
--    UNION    
        
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
--          ,'14'--''--Purpose_code                               
--          ,isnull(DPPD_FNAME,'')   
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end    
--          ,case when DPPD_GENDER in ('M','MALE') then 'MR'  when DPPD_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end               
--          ,''                
--          ,DPPD_FTHNAME    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),1)--adr1                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),2)--adr2                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),3)--adr3                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),4)--adr_city                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),5)--adr_state                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),6)--adr_country                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),7)--adr_zip                                 
--           ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,1,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,1,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,2,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,2,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,3,'N'),'')   
--          ,''    
--          ,DPPD_PAN_NO    
--          ,''    
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'TH_POA_MAIL'),''))--email      
--          ,''--usr_txt1                                   
--          ,''--usr_txt2                                   
--          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4                                   
--          ,0000--''--usr_fld5                             
--    FROM   dp_acct_mstr              dpam                    
--         , dp_holder_dtls            dphd                     
--         , client_mstr               clim                    
--         , client_bank_accts         cliba                    
--         , dp_poa_dtls               dppd    
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
--    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
--    AND    dpam.dpam_deleted_ind   = 1                    
--    AND    dphd.dphd_deleted_ind   = 1                     
--    AND    dppd.dppd_deleted_ind   = 1                     
--    AND    clim.clim_deleted_ind   = 1                    
--    AND    cliba.cliba_deleted_ind = 1                    
--    AND    banm.banm_deleted_ind   = 1                    
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
--    AND    ISNULL(DPPD_FNAME,'')               <> ''    
--    and    DPPD_HLD                = '3RD HOLDER'    
--        
--        
--    UNION    
         
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'206' --''--Purpose_code                               
          ,isnull(DPHD_NOM_FNAME,'')   
          ,isnull(DPHD_NOM_MNAME,'')     
          ,case when isnull(DPHD_NOM_LNAME,'')='' then '.' else isnull(DPHD_NOM_LNAME,'.') end  --isnull(DPHD_NOM_LNAME,'')    
    --,''  
    --,''  
    --,''  
          ,''--,case when DPHD_NOM_GENDER in ('M','MALE') then 'MR'  when DPHD_NOM_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                       
          ,''                
          ,isnull(DPHD_NOM_FTHNAME,'')    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip                                 
           ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'') 
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nom_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nom_dob,103),'/','')),'')  end 
         , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax  
          ,isnull(DPHD_NOM_PAN_NO,'')    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4   
    --,'M'                                  
    --,'S'  
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '6') THEN 'S' ELSE 'M' END  
		--,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '6') THEN 'S' ELSE 'M' END) end
		--,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN not exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06') THEN 'S' ELSE 'M' END) end
		--,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and TypeOfTrans = '3') THEN 'S' when exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and (TypeOfTrans = '1'  or TypeOfTrans ='2' or TypeOfTrans = '')) then 'M' else '' END) end
		,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and TypeOfTrans = '3') THEN 'S' when not exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06') then 'S' else 'M' END) end
		
        ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd						
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1        
        and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1              
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    --AND    ISNULL(DPHD_NOM_FNAME,'') <> ''  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('N ADDRESS','NOMINEE DEL','N NAMENDTLS','N CONTACTS')    
        
    UNION    
        
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'107' --''--Purpose_code                               
--          ,isnull(DPHD_GAU_FNAME,'')   
--          ,isnull(DPHD_GAU_MNAME,'')     
--          ,case when isnull(DPHD_GAU_LNAME,'')='' then '.' else isnull(DPHD_GAU_LNAME,'.') end --isnull(DPHD_GAU_LNAME,'')    
    ,''  
    ,''  
    ,''  
          ,''--,case when DPHD_GAU_GENDER in ('M','MALE') then 'MR'  when DPHD_GAU_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                 
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
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_gau_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_gau_dob,103),'/','')),'')  end 
          ,''    
          ,DPHD_GAU_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4     
    --,'M'                                
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '7') THEN 'S' ELSE 'M' END  
    --,CASE WHEN not exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07') THEN 'S' ELSE 'M' END  
    --, CASE WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '3' ) THEN 'S'  WHEN exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '1' ) THEN 'M' ELSE 'D' END
    , CASE WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '3' ) THEN 'S' WHEN not exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' ) THEN 'S'  WHEN exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND (TypeOfTrans = '1' or TypeOfTrans = '2' or TypeOfTrans = '') ) THEN 'M' ELSE 'D' END
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1     
        and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1                    
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    AND    ISNULL(DPHD_GAU_FNAME,'') <> ''  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('G Address','G NameNDtls','G Contacts')    
        
  
        
    UNION    
            
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'108' --''--Purpose_code                               
--          ,isnull(DPHD_NOMGAU_FNAME,'')   
--          ,isnull(DPHD_NOMGAU_MNAME,'')     
--          ,case when isnull(DPHD_NOMGAU_LNAME,'')='' then '.' else isnull(DPHD_NOMGAU_LNAME,'.') end--isnull(DPHD_NOMGAU_LNAME,'')    
    ,''  
    ,''  
    ,''  
          ,''--,case when DPHD_NOMGAU_GENDER in ('M','MALE') then 'MR'  when DPHD_NOMGAU_GENDER in ('F','FEMALE') then 'MS' else 'M/S' end                            
          ,''                
          ,DPHD_NOMGAU_FTHNAME    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),7)--adr_zip                                 
            ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,3,'N'),'')
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nomgau_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nomgau_dob,103),'/','')),'')  end 
          ,''    
          ,DPHD_NOMGAU_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4    
    --,'M'                                 
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '8') THEN 'S' ELSE 'M' END  
   -- ,CASE WHEN not exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08') THEN 'S' ELSE 'M' END  
    --,CASE WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '1') THEN 'M' ELSE 'D' END  
    ,CASE WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '3') THEN 'S' WHEN not exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08') THEN 'S' ELSE 'D' END  
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1      
         and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1                    
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    AND    ISNULL(DPHD_NOMGAU_FNAME,'') <> ''  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('NG Address','NG NameNDtls','NG Contacts')  
  
     
    union  
     
    SELECT distinct '07'                
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'18' --''--Purpose_code                               
--          ,isnull(DPPD_FNAME,'')   
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end--isnull(DPHD_NOMGAU_LNAME,'')    
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
          ,''    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4     
    ,'M'                                
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_poa_dtls            dppd                     
         , client_mstr               clim      
         , client_list_modified  climmod                 
    WHERE  dpam.dpam_id            = dppd.DPPD_DPAM_ID                        
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dppd.dppd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1    
          and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1                      
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    AND    ISNULL(DPPD_POA_TYPE,'') = 'AUTHORISED SIGNATORY'  
    AND    ISNULL(DPPD_FNAME,'') <> ''  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('SIGNATURE')  
  
  
  
    
    
        
        
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
	,dob    
    ,cust_fax                
    ,hldr_in_tax_pan         
    ,it_crl                  
    ,cust_email              
    ,usr_txt1                
    ,usr_txt2                
    ,usr_fld3                
    ,usr_fld4                
    ,usr_fld5                
    )           
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
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
--          ,dpam_sba_no                    
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
--          ,dpam_sba_no                    
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
          ,dpam_sba_no                    
          ,'212' --''--Purpose_code                               
--          ,clim_name1   
--          ,isnull(clim_name2,'')                     
--          ,case when isnull(clim_name3,'')='' then '.' else isnull(clim_name3,'.') end          
    ,''  
    ,''  
    ,''   
          ,''--,case when clim_gender in ('M','MALE') then 'MR'  when clim_gender in ('F','FEMALE') then 'MS' else 'M/S' end                   
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
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'Y'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,1,'N'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'Y'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,2,'N'),'')  
          ,''--isnull(citrus_usr.fn_fetch_ph('PRI',dpam.dpam_id,3,'N'),'')  
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,clim.clim_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,clim.clim_dob,103),'/','')),'')  end 
          ,''--isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'FAX1'),'')--fax               
          ,''--isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),'')  --pan card                    
          ,''    
          ,''--lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'EMAIL1'),''))--email                               
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4    
    --,'M'                                 
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '12') THEN 'S' ELSE 'M' END  
    --,CASE WHEN not exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12') THEN 'S' ELSE 'M' END  
    --,CASE WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '1') THEN 'M' ELSE 'D' END  
    --,CASE WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and (TypeOfTrans = '1' or TypeOfTrans ='2' or TypeOfTrans ='')) THEN 'M' ELSE 'D' END  
	,CASE WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and TypeOfTrans = '3') THEN 'S' WHEN not exists (select 1 from dps8_pc12 where BOId = dpam_sba_no  and PurposeCode12 = '12') then 'S' WHEN exists (select 1 from dps8_pc12 where BOId = DPAM_SBA_NO and PurposeCode12 = '12' and (TypeOfTrans = '1' or TypeOfTrans ='2' or TypeOfTrans ='')) THEN 'M' ELSE 'D' END  
          ,0000--''--usr_fld5                             
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
           , client_list_modified  climmod   
    WHERE  CRN.CRN                 = CLIM_CRN_NO    
 and    dpam.dpam_sba_no       = crn.acct_no   
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    isnull(dphd.dphd_deleted_ind,1) = 1                     
    AND    clim.clim_deleted_ind   = 1                    
          and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1   
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('P Address')  
    
    UNION    
    
    /*SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'02' --''--Purpose_code                               
          ,dphd_sh_fname + ' ' +  isnull(dphd_sh_mname,'') + ' ' +  isnull(dphd_sh_lname,'')    
          ,isnull(dphd_sh_mname,'')     
          ,isnull(dphd_sh_lname,'')    
          ,''                    
          ,''                
          ,ISNULL(DPHD_SH_FTHNAME,'')      
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_ADR1'),''),7)--adr_zip             
         ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('SH',dpam.dpam_id,3,'N'),'')  
          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'SH_FAX1'),'')--fax   
          ,DPHD_SH_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                  
          ,0000--''--usr_fld3                                   
          ,0000--''--usr_fld4                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , @CRN                      CRN     
         , client_bank_accts         cliba                    
         , bank_mstr                 banm                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
    AND    cliba.cliba_banm_id     = banm.banm_id                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
    AND    cliba.cliba_deleted_ind = 1                    
    AND    banm.banm_deleted_ind   = 1                    
    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
    AND    ISNULL(dphd_sh_fname,'') <> ''    
    
    UNION    
    
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'03' --''--Purpose_code                               
          ,dphd_Th_fname + ' ' +  isnull(dphd_Th_mname,'') + ' ' +  isnull(dphd_Th_lname,'')    
          ,isnull(dphd_Th_mname,'')     
          ,isnull(dphd_Th_lname,'')    
          ,''                    
          ,''                
          ,ISNULL(DPHD_tH_FTHNAME,'')      
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_ADR1'),''),7)--adr_zip                                 
         ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('TH',dpam.dpam_id,3,'N'),'')  
          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'TH_FAX1'),'')--fax      
          ,DPHD_TH_PAN_NO    
          ,''    
          ,isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'TH_POA_MAIL'),'')--email        
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
          ,0000--''--usr_fld4                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , @CRN                      CRN    
         , client_bank_accts         cliba                    
         , bank_mstr                 banm                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
    AND    cliba.cliba_banm_id     = banm.banm_id                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
    AND    cliba.cliba_deleted_ind = 1                    
    AND    banm.banm_deleted_ind   = 1                    
    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
    AND    ISNULL(dphd_Th_fname,'') <> ''    
    
    UNION    
    
    /*SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'05' --''--Purpose_code                               
          ,DPPD_FNAME + ' ' +  ISNULL(DPPD_MNAME,'') + ' ' +  ISNULL(DPPD_LNAME,'')    
          ,isnull(DPPD_MNAME,'')     
          ,isnull(DPPD_LNAME,'')    
          ,''                    
          ,''                
          ,DPPD_FTHNAME    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'POA_ADR1'),''),7)--adr_zip                                 
          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')  <> '' then 'O'     
                END    
          ,case when isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')  <> '' then  isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'POA_OFF_PH1'),'')      
                END    
          ,''                    
          ,''    
          ,''    
          ,''    
          ,DPPD_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
          ,0000--''--usr_fld4                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , @CRN                    CRN     
         , client_bank_accts         cliba                    
         , dp_poa_dtls               dppd    
         , bank_mstr                 banm                    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
    AND    cliba.cliba_banm_id     = banm.banm_id                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    dppd.dppd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
    AND    cliba.cliba_deleted_ind = 1                    
    AND    banm.banm_deleted_ind   = 1                    
    AND    dpam_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
    AND    ISNULL(DPPD_FNAME,'')               <> ''    
    and    DPPD_HLD                = '1ST HOLDER'    
    
    UNION  */*/  
    
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
--          ,'13' --''--Purpose_code                               
--          ,isnull(DPPD_FNAME,'')  
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPPD_LNAME,'')    
--          ,case when dppd_gender in ('M','MALE') then 'MR'  when dppd_gender in ('F','FEMALE') then 'MS' else 'M/S' end                    
--          ,''                
--          ,DPPD_FTHNAME    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),1)--adr1                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),2)--adr2                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),3)--adr3                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),4)--adr_city                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),5)--adr_state                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),6)--adr_country                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'SH_POA_ADR'),''),7)--adr_zip                                 
--           ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,1,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,1,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,2,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,2,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('SH_POA',dpam.dpam_id,3,'N'),'')    
--          ,''    
--          ,DPPD_PAN_NO    
--          ,''    
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'SH_POA_MAIL'),''))--email      
--          ,''--usr_txt1                                   
--          ,''--usr_txt2                                   
--          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4                                   
--          ,0000--''--usr_fld5                             
--    FROM   dp_acct_mstr              dpam                    
--         , dp_holder_dtls            dphd                     
--         , client_mstr               clim                    
--         , @CRN                      CRN    
--         , client_bank_accts         cliba                    
--         , dp_poa_dtls               dppd    
--         , bank_mstr                 banm                    
--         , entity_type_mstr          enttm                    
--         , client_ctgry_mstr         clicm                    
--           left outer join                    
--           sub_ctgry_mstr            subcm                     
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
--    AND    CRN.CRN                 = CLIM_CRN_NO    
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
--    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
--    AND    cliba.cliba_banm_id     = banm.banm_id                     
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
--    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
--    AND    dpam.dpam_deleted_ind   = 1                    
--    AND    dphd.dphd_deleted_ind   = 1                     
--    AND    dppd.dppd_deleted_ind   = 1                     
--    AND    clim.clim_deleted_ind   = 1                    
--    AND    cliba.cliba_deleted_ind = 1                    
--    AND    banm.banm_deleted_ind   = 1                    
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
--    AND    ISNULL(DPPD_FNAME,'')               <> ''    
--    and    DPPD_HLD                = '2ND HOLDER'    
--    
--    UNION    
    
--    SELECT distinct '07'                    
--          ,clim_crn_no                    
--          ,dpam_sba_no                    
--          ,'14' --''--Purpose_code                               
--          ,isnull(DPPD_FNAME,'')  
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPPD_LNAME,'')    
--          ,case when dppd_gender in ('M','MALE') then 'MR'  when dppd_gender in ('F','FEMALE') then 'MS' else 'M/S' end                   
--          ,''                
--          ,DPPD_FTHNAME    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),1)--adr1                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),2)--adr2                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),3)--adr3                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),4)--adr_city                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),5)--adr_state                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),6)--adr_country                    
--          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'TH_POA_ADR'),''),7)--adr_zip                                 
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,1,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,1,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,2,'Y'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,2,'N'),'')  
--          ,isnull(citrus_usr.fn_fetch_ph('TH_POA',dpam.dpam_id,3,'N'),'')   
--          ,''    
--          ,DPPD_PAN_NO    
--          ,''    
--          ,lower(isnull(citrus_usr.fn_conc_value(clim.clim_crn_no,'TH_POA_MAIL'),''))--email      
--          ,''--usr_txt1                                   
--          ,''--usr_txt2                                   
--          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4                                   
--          ,0000--''--usr_fld5                             
--    FROM   dp_acct_mstr              dpam                    
--         , dp_holder_dtls            dphd                     
--         , client_mstr               clim                    
--         , @CRN                      CRN    
--         , client_bank_accts         cliba                    
--         , dp_poa_dtls               dppd    
--         , bank_mstr                 banm               
--         , entity_type_mstr          enttm                    
--         , client_ctgry_mstr         clicm                    
--           left outer join                    
--           sub_ctgry_mstr            subcm                     
--           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
--    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id        
--    AND    CRN.CRN                 = CLIM_CRN_NO    
--    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
--    AND    dpam.dpam_id            = cliba.cliba_clisba_id                    
--    AND    cliba.cliba_banm_id     = banm.banm_id                     
--    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
--    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
--    AND    dppd.dppd_dpam_id       = dpam.Dpam_id    
--    AND    dpam.dpam_deleted_ind   = 1                    
--    AND    dphd.dphd_deleted_ind   = 1                     
--    AND    dppd.dppd_deleted_ind   = 1                     
--    AND    clim.clim_deleted_ind   = 1                    
--    AND    cliba.cliba_deleted_ind = 1                    
--    AND    banm.banm_deleted_ind   = 1                    
--    AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
--    AND    ISNULL(DPPD_FNAME,'')               <> ''    
--    and    DPPD_HLD                = '3RD HOLDER'    
--    
--    
--    UNION    
--    
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'206' --''--Purpose_code                               
          ,isnull(DPHD_NOM_FNAME,'')  
          ,isnull(DPHD_NOM_MNAME,'')     
          ,case when isnull(DPHD_NOM_LNAME,'')='' then '.' else isnull(DPHD_NOM_LNAME,'.') end --isnull(DPHD_NOM_LNAME,'')    
    --,''  
    --,''  
    --,''  
          ,''--,case when DPHD_NOM_gender in ('M','MALE') then 'MR'  when DPHD_NOM_gender in ('F','FEMALE') then 'MS' else 'M/S' end                    
          ,''                
          ,isnull(DPHD_NOM_FTHNAME,'')    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOMINEE_ADR1'),''),7)--adr_zip                                 
           ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOMINEE',dpam.dpam_id,3,'N'),'')
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nom_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nom_dob,103),'/','')),'')  end 
          , isnull(citrus_usr.fn_acct_conc_value(dpam.dpam_id,'NOMINEE_FAX1'),'')--fax  
          ,isnull(DPHD_NOM_PAN_NO,'')    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4   
    --,'M'                                  
    --,'S'  
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '6') THEN 'S' ELSE 'M' END  
		--,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '6') THEN 'S' ELSE 'M' END) end
		--,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN not exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06') THEN 'S' ELSE 'M' END) end
		 --,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and TypeOfTrans = '3') THEN 'S' ELSE 'M' END) end
		  --,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and TypeOfTrans = '3') THEN 'S' when exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and (TypeOfTrans = '1' or TypeOfTrans ='2' or TypeOfTrans = '')) then 'M' else '' END) end	
		  ,Case when climmod.clic_mod_action = 'NOMINEE DEL' then 'D' else (CASE WHEN exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06' and TypeOfTrans = '3') THEN 'S' when not exists (select 1 from dps8_pc6 where BOId = DPAM_SBA_NO and PurposeCode6 = '06') then 'S' else 'M' END) end
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , @CRN                      CRN    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd       
 and    dpam.dpam_sba_no       = crn.acct_no                
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1   
    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1                    
   -- AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    --AND    ISNULL(DPHD_NOM_FNAME,'') <> ''  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('N ADDRESS','NOMINEE DEL','N NAMENDTLS','N CONTACTS')    
    
    UNION    
    
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'107' --''--Purpose_code                               
--          ,isnull(DPHD_GAU_FNAME,'')   
--          ,isnull(DPHD_GAU_MNAME,'')     
--          ,case when isnull(DPHD_GAU_LNAME,'')='' then '.' else isnull(DPHD_GAU_LNAME,'.') end --isnull(DPHD_GAU_LNAME,'')    
    ,''  
    ,''  
    ,''  
          ,''--,case when DPHD_GAU_gender in ('M','MALE') then 'MR'  when DPHD_GAU_gender in ('F','FEMALE') then 'MS' else 'M/S' end                       
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
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_gau_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_gau_dob,103),'/','')),'')  end 
          ,''    
          ,DPHD_GAU_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4    
    --,'M'                                 
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '7') THEN 'S' ELSE 'M' END  
    --,CASE WHEN not exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07') THEN 'S' ELSE 'M' END  
    --, CASE WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '3' ) THEN 'S'  WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '1' ) THEN 'M' ELSE 'D' END
    --, CASE WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '3' ) THEN 'S'  WHEN exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND (TypeOfTrans = '1'  or TypeOfTrans ='2' or TypeOfTrans = '') ) THEN 'M' ELSE 'D' END
	, CASE WHEN  exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND TypeOfTrans = '3' ) THEN 'S' WHEN not exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' ) THEN 'S'  WHEN exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07' AND (TypeOfTrans = '1' or TypeOfTrans = '2' or TypeOfTrans = '') ) THEN 'M' ELSE 'D' END
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim      
         , @CRN                      CRN    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
 and    dpam.dpam_sba_no       = crn.acct_no   
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1     
    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
    and    climmod.clic_mod_deleted_ind = 1                  
    --AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    AND    ISNULL(DPHD_GAU_FNAME,'') <> ''   
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('G Address','G NameNDtls','G Contacts')   
    
    
    UNION    
    
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'108' --''--Purpose_code                               
--          ,isnull(DPHD_NOMGAU_FNAME ,'')  
--          ,isnull(DPHD_NOMGAU_MNAME,'')     
--          ,case when isnull(DPHD_NOMGAU_LNAME,'')='' then '.' else isnull(DPHD_NOMGAU_LNAME,'.') end --isnull(DPHD_NOMGAU_LNAME,'')    
    ,''  
    ,''  
    ,''  
          ,''--,case when DPHD_NOMGAU_gender in ('M','MALE') then 'MR'  when DPHD_NOMGAU_gender in ('F','FEMALE') then 'MS' else 'M/S' end                                     
          ,''                
          ,DPHD_NOMGAU_FTHNAME    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),1)--adr1                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),2)--adr2                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),3)--adr3                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),4)--adr_city                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),5)--adr_state                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),6)--adr_country                    
          ,citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(DPAM.DPAM_ID,'NOM_GUARDIAN_ADDR'),''),7)--adr_zip                                 
           ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,1,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'Y'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,2,'N'),'')  
          ,isnull(citrus_usr.fn_fetch_ph('NOM_GUARD',dpam.dpam_id,3,'N'),'')
		  ,case when ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nomgau_dob,103),'/','')),'') ='0101900' then '00000000' else ISNULL(CONVERT(char(8),replace(convert(varchar,dphd_nomgau_dob,103),'/','')),'')  end 
          ,''    
          ,DPHD_NOMGAU_PAN_NO    
          ,''    
          ,''    
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4     
    --,'M'                                
    --,CASE WHEN not exists (select 1 from dpb9_mod where BOId = DPAM_SBA_NO and PurposeCode12 = '8') THEN 'S' ELSE 'M' END  
    --,CASE WHEN not exists (select 1 from dps8_pc7 where BOId = DPAM_SBA_NO and PurposeCode7 = '07') THEN 'S' ELSE 'M' END  
    --,CASE WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '1') THEN 'M' ELSE 'D' END 
    --,CASE WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '3') THEN 'S' WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and (TypeOfTrans = '1'  or TypeOfTrans ='2' or TypeOfTrans = '')) THEN 'M' ELSE 'D' END  
	,CASE WHEN exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08' and TypeOfTrans = '3') THEN 'S' WHEN not exists (select 1 from dps8_pc8 where BOId = DPAM_SBA_NO and PurposeCode8 = '08') THEN 'S' ELSE 'D' END  
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_holder_dtls            dphd                     
         , client_mstr               clim                    
         , @CRN                      CRN    
         , entity_type_mstr          enttm                    
         , client_ctgry_mstr         clicm                    
           left outer join                    
           sub_ctgry_mstr            subcm                     
           on  subcm.subcm_clicm_id    = clicm.clicm_id and   subcm.subcm_deleted_ind = 1                    
           , client_list_modified  climmod   
    WHERE  dpam.dpam_id            = dphd.dphd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
 and    dpam.dpam_sba_no       = crn.acct_no   
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
    AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                    
    AND    dpam.dpam_clicm_cd  = clicm.clicm_cd                    
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dphd.dphd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
   -- AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
    AND    ISNULL(DPHD_NOMGAU_FNAME,'') <> ''  
    and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '' end = clic_mod_pan_no)                
  --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
 and    climmod.clic_mod_deleted_ind = 1   
 and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('NG Address','NG NameNDtls','NG Contacts')  
  
union  
  
    SELECT distinct '07'                    
          ,clim_crn_no                    
          ,dpam_sba_no                    
          ,'18' --''--Purpose_code                               
--          ,isnull(DPPD_FNAME ,'')  
--          ,isnull(DPPD_MNAME,'')     
--          ,case when isnull(DPPD_LNAME,'')='' then '.' else isnull(DPPD_LNAME,'.') end --isnull(DPHD_NOMGAU_LNAME,'')    
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
          ,''    
          ,''   
		  ,''
          ,''--usr_txt1                                   
          ,''--usr_txt2                                   
          ,0000--''--usr_fld3                                   
--          ,0000--''--usr_fld4  
    ,'M'                                   
          ,0000--''--usr_fld5                             
    FROM   dp_acct_mstr              dpam                    
         , dp_poa_dtls            dppd                     
         , client_mstr               clim                    
         , @CRN                      CRN    
          , client_list_modified  climmod       
    WHERE  dpam.dpam_id            = dppd.dppd_dpam_id                        
    AND    CRN.CRN                 = CLIM_CRN_NO    
    AND    dpam.dpam_crn_no        = clim.clim_crn_no                     
  and    dpam.dpam_sba_no       = crn.acct_no   
    AND    dpam.dpam_deleted_ind   = 1                    
    AND    dpPd.dppd_deleted_ind   = 1                     
    AND    clim.clim_deleted_ind   = 1                    
      
          and   (dpam_sba_no =  clic_mod_dpam_sba_no or case when clic_mod_pan_no <> '' then citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') else '0' end = clic_mod_pan_no)                
                               
                           --AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
                                 AND   climmod.clic_mod_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
                         and    climmod.clic_mod_deleted_ind = 1  
   -- AND    clim_lst_upd_dt    BETWEEN CONVERT(DATETIME, @pa_from_dt + ' 00:00:00',103) AND CONVERT(DATETIME, @pa_to_dt+ ' 23:59:59',103)                            
     AND    ISNULL(DPPD_POA_TYPE,'') = 'AUTHORISED SIGNATORY'  
    AND    ISNULL(DPPD_FNAME,'') <> '' AND DPAM_CLICM_CD<>'25'  
    and isnull(climmod.clic_mod_batch_no,0) = 0  
 AND   climmod.clic_mod_action in ('Signature')  
   
  --    
  END    
  
  
      
    
  return    
    
    
--    
END

GO
