-- Object: PROCEDURE citrus_usr.pr_dpm_adr_conc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from dp_acct_mstr order by 1 desc  
--begin tran    
--select * from dp_Acct_mstr where dpam_crn_no in (86264,86209)
--pr_dpm_adr_conc '','11/09/2008','15/09/2008','NSDL','DEPOSITORY','n','3',''      
--rollback     
CREATE PROCEDURE [citrus_usr].[pr_dpm_adr_conc]( @pa_crn_no        varchar(8000)        
                               , @pa_from_dt       varchar(11)              
                               , @pa_to_dt         varchar(11)              
                               , @pa_exch_cd       varchar(10)              
                               , @pa_exch_seg_cd   varchar(15)              
                               , @pa_tab           char(1)    
                               , @PA_BATCH_NO      BIGINT           
                               , @pa_ref_cur       varchar(8000)  output              
                               )              
AS                                              
--              
BEGIN              
--              
  DECLARE @clim_crn TABLE (crn  NUMERIC)              
  --         
  DECLARE @L_EXCSM_ID NUMERIC     

 SELECT @L_EXCSM_ID = EXCSM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_EXCH_CD = @pa_exch_cd AND EXCSM_SEG_CD = @pa_exch_seg_cd
  DECLARE @addr_conc TABLE(adr_code varchar(25)  
                          ,crn       NUMERIC              
                          ,ctgry     VARCHAR(50)              
                          ,adr1      VARCHAR(50)              
                          ,adr2      VARCHAR(50)                  
                          ,adr3      VARCHAR(50)                  
                          ,city      VARCHAR(50)                  
                          ,state     VARCHAR(50)                  
                          ,country   VARCHAR(50)                  
                          ,zip       VARCHAR(50)                  
                          ,Off_tel   VARCHAR(25)              
                          ,off_fax   VARCHAR(25)           
                          ,adr_type  varchar(2)   
         ,enttm_cd         varchar(20)  
         ,clicm_cd         varchar(20)  
         ,subcm_cd         varchar(20)                        
,sba_no varchar(20)  
,NRN_NO VARCHAR(20)  
                         )              
  --                                      
  DECLARE @conc TABLE (crn      NUMERIC              
                      ,code     VARCHAR(20)
                                    
                      ,value    VARCHAR(50)                  
                      ,sba_no varchar(20) 
                      )              
  --                                  
  DECLARE @@rm_id                  varchar(8000)          
        , @@cur_id                 varchar(8000)          
        , @@foundat                int          
        , @@delimeterlength        int         
        , @@delimeter              char(1)        
        , @l_crn_no                numeric        
        , @l_acct_no               varchar(25)
        , @l_nrn_yn                char(1)
        
        SET @l_nrn_yn  = 'N'          
                
          
  IF ISNULL(@pa_crn_no, '') <> ''        
  BEGIN--n_n        
  --        
    SET @@rm_id  =  @pa_crn_no        
    --        
    DECLARE @crn TABLE (crn              numeric        
                       ,clim_stam_cd     varchar(25)        
                       ,created_dt       datetime        
                       ,lst_upd_dt       datetime        
                       )        
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
        SELECT clim_crn_no,clim_stam_cd, clim_created_dt, clim_lst_upd_dt   
        FROM   client_mstr WITH (NOLOCK),DP_ACCT_MSTR  WITH (NOLOCK)        
        WHERE  DPAM_CRN_NO = CLIM_cRN_NO AND clim_crn_no = CONVERT(numeric, @l_crn_no)        
        AND    clim_deleted_ind  = 1   
        AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
        AND    ISNULL(dpam_batch_no,0) = @PA_BATCH_NO       
        
      --        
      END        
    --          
    END        
  --        
        
          
    INSERT INTO @clim_crn               
    SELECT crn               
    FROM   @crn clim              
    WHERE  clim.lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+ ' 00:00:00'               
    AND    CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'              
            
          
  --        
  END        
  ELSE        
  BEGIN        
  --        
    INSERT INTO @clim_crn               
    SELECT clim_crn_no               
    FROM  client_mstr clim     WITH (NOLOCK) ,DP_ACCT_MSTR  WITH (NOLOCK)        
    WHERE  DPAM_CRN_NO = CLIM_cRN_NO AND clim.clim_LST_UPD_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+ ' 00:00:00'               
    AND    CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'              
    AND    clim_deleted_ind  = 1               
    AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
    AND    ISNULL(dpam_batch_no,0) = @PA_BATCH_NO  
  --        
  END        
   
  --where  clim.clim_created_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'               
  --              
  INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
, dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , dp_acct_mstr               dpam    WITH (NOLOCK)  
       , @clim_crn                  
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id      = crn 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1  
AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  and    entac_ent_id            = dpam_crn_no    
  and    dpam.dpam_batch_no = @PA_BATCH_NO   
  and    entac.entac_concm_cd in ('AC_PER_ADR1')  



INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
, dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , dp_acct_mstr               dpam    WITH (NOLOCK)  
       , @clim_crn                  
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id      = crn 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1  
AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  and    entac_ent_id            = dpam_crn_no    
  and    dpam.dpam_batch_no = @PA_BATCH_NO   
  and    entac.entac_concm_cd in ('AC_FH_ADR1','AC_COR_ADR1') 
  AND    convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) <> 1


 
  
  
  INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
       , dpam_clicm_cd  
       , dpam_subcm_cd  
       , dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , dp_acct_mstr               dpam    WITH (NOLOCK)  
       , @clim_crn                  
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id      = crn 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1  
  and    entac_ent_id            = dpam_crn_no    
  and    dpam.dpam_batch_no = @PA_BATCH_NO   
  and    entac.entac_concm_cd in ('per_adr1')  
  and   not exists(select adr_code from @addr_conc where sba_no = dpam_sba_no and adr_code = 'AC_PER_ADR1') 
  
  INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
, dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , dp_acct_mstr               dpam    WITH (NOLOCK)  
       , @clim_crn                  
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id      = crn 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1  
  and    entac_ent_id            = dpam_crn_no    
  and    dpam.dpam_batch_no = @PA_BATCH_NO   
  and    entac.entac_concm_cd in ('FH_ADR1') 
  and   not exists(select adr_code from @addr_conc where sba_no = dpam_sba_no and adr_code = 'AC_FH_ADR1') 
  AND    convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) <> 1
  
  
  INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
, dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , dp_acct_mstr               dpam    WITH (NOLOCK)  
       , @clim_crn                  
  WHERE  entac.entac_adr_conc_id = adr.adr_id              
  AND    entac.entac_ent_id      = crn 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1  
  and    entac_ent_id            = dpam_crn_no    
  and    dpam.dpam_batch_no = @PA_BATCH_NO   
  and    entac.entac_concm_cd in ('COR_ADR1') 
  and   not exists(select adr_code from @addr_conc where sba_no = dpam_sba_no and adr_code = 'AC_COR_ADR1') 
  AND    convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(dpam.dpam_id,'ADR_PREF_FLG',''),'')) <> 1
  
  
  
 INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  ,NRN_NO  
  )              
  SELECT distinct concm_cd,dpam_crn_no              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
,dpam_sba_no  
,ISNULL(NOM_NRN_NO,'')  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , account_adr_conc           accac  WITH (NOLOCK)  
       , dp_acct_mstr               dpam WITH (NOLOCK)  
       , conc_code_mstr       
       , DP_HOLDER_DTLS  
       , @clim_crn                  
  WHERE  accac.accac_adr_conc_id = adr.adr_id              
  AND    dpam_crn_no     = crn 
  AND    DPAM_ID   = DPHD_DPAM_ID  
  AND    adr.adr_deleted_ind     = 1              
  AND    accac.accac_deleted_ind = 1  
  AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  and    ACCAC_CLISBA_ID            = dpam_id  
  and    dpam.dpam_batch_no = @PA_BATCH_NO
  and    accac.accac_concm_id      = concm_id  
  and    concm_cd ='NOMINEE_ADR1'
  AND    ISNULL(DPHD_NOM_FNAME,'') <> '' 
  
  
   INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  ,NRN_NO  
  )              
  SELECT distinct concm_cd,dpam_crn_no              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
,dpam_sba_no  
,ISNULL(NOM_NRN_NO,'')  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , account_adr_conc           accac  WITH (NOLOCK)  
       , dp_acct_mstr               dpam WITH (NOLOCK)  
       , conc_code_mstr       
       , DP_HOLDER_DTLS  
       , @clim_crn                  
  WHERE  accac.accac_adr_conc_id = adr.adr_id              
  AND    dpam_crn_no     = crn 
  AND    DPAM_ID   = DPHD_DPAM_ID  
  AND    adr.adr_deleted_ind     = 1              
  AND    accac.accac_deleted_ind = 1  
  AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  and    ACCAC_CLISBA_ID            = dpam_id  
  and    dpam.dpam_batch_no = @PA_BATCH_NO
  and    accac.accac_concm_id      = concm_id  
  and    concm_cd ='GUARD_ADR' 
  AND    ISNULL(DPHD_GAU_FNAME,'') <> ''


INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
  ,enttm_cd  
  ,clicm_cd  
  ,subcm_cd  
  ,sba_no  
  ,NRN_NO  
  )              
  SELECT distinct concm_cd,dpam_crn_no              
       , adr.adr_1              
       , adr.adr_2               
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'C'  
       , dpam_enttm_cd  
, dpam_clicm_cd  
, dpam_subcm_cd  
,dpam_sba_no  
,ISNULL(NOM_NRN_NO,'')  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , account_adr_conc           accac  WITH (NOLOCK)  
       , dp_acct_mstr               dpam  WITH (NOLOCK)  
       , conc_code_mstr       
       , DP_HOLDER_DTLS  
       ,@clim_crn
  WHERE  accac.accac_adr_conc_id = adr.adr_id              
  AND    dpam_crn_no     = crn 
  AND    DPAM_ID   = DPHD_DPAM_ID  
  AND    adr.adr_deleted_ind     = 1              
  AND    accac.accac_deleted_ind = 1  
AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  and    ACCAC_CLISBA_ID            = dpam_id  
  and    dpam.dpam_batch_no = @pa_batch_no
  and    accac.accac_concm_id      = concm_id  
  and    concm_cd = 'NOM_GUARDIAN_ADDR' 
  AND    ISNULL(dphd_nomgau_fname,'') <> '' 
 
  
          
  
  INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
, enttm_cd  
, clicm_cd  
, subcm_cd  
,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2              
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'B'  
       ,dpam_enttm_cd  
       ,dpam_clicm_cd  
       ,dpam_subcm_cd  
,dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)               
       , dp_acct_mstr      dpam WITH (NOLOCK)               
       , client_bank_accts  
       ,@clim_crn 
  WHERE  entac.entac_adr_conc_id = adr.adr_id        
  and    entac_ent_id            = cliba_banm_id  
  AND    cliba_clisba_id         = dpam_id   
  and    dpam_crn_no = crn               
  and    dpam.dpam_batch_no = @pa_batch_no
  AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1      
  and    entac.entac_concm_cd = 'COR_ADR1'     

INSERT INTO @addr_conc              
  (adr_code  
  ,crn              
  ,adr1              
  ,adr2              
  ,adr3              
  ,city              
  ,state              
  ,country              
  ,zip              
  ,adr_type  
, enttm_cd  
, clicm_cd  
, subcm_cd  
,sba_no  
  )              
  SELECT distinct entac.entac_concm_cd,entac.entac_ent_id              
       , adr.adr_1              
       , adr.adr_2              
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip              
       , 'B'  
       ,dpam_enttm_cd  
       ,dpam_clicm_cd  
       ,dpam_subcm_cd  
,dpam_sba_no  
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)               
       , dp_acct_mstr      dpam WITH (NOLOCK)               
       , client_bank_accts  
       ,@clim_crn 
  WHERE  entac.entac_adr_conc_id = adr.adr_id        
  and    entac_ent_id            = cliba_banm_id  
  AND    cliba_clisba_id         = dpam_id   
  and    dpam_crn_no = crn               
  and    dpam.dpam_batch_no = @pa_batch_no
  AND    DPAM_EXCSM_ID = @L_EXCSM_ID 
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1      
  and    entac.entac_concm_cd = 'PER_ADR1' 
  and    not exists (select crn , adr_code from @addr_conc where adr_type = 'B' and crn = entac_ent_id AND adr_code = 'COR_ADR1')

                
INSERT INTO @conc              
	  SELECT dpam.dpam_crn_no              
		   , concm.concm_cd              
		   , convert(varchar(50), conc.conc_value)  
           , dpam_sba_no                      
	  FROM  contact_channels          conc    WITH (NOLOCK)              
		  , account_adr_conc          accac   WITH (NOLOCK)  
		  , dp_acct_mstr              dpam    WITH (NOLOCK)       
		  , conc_code_mstr            concm   WITH (NOLOCK)         
	  WHERE accac.accac_adr_conc_id  = conc.conc_id              
	  and   accac.accac_concm_id     = concm.concm_id
	  AND   dpam.dpam_crn_no      IN (SELECT crn FROM @clim_crn)              
	  and   accac_clisba_id    =   dpam_id 
	  AND   concm.concm_cd     in('ACCRES_PH1','ACCOFF_PH1','NOMINEE_PH1','NOM_GUARD_OFF','GUARD_RES')            
	  AND   conc.conc_deleted_ind    = 1              
	  AND   accac.accac_deleted_ind  = 1         
        
        
         INSERT INTO @conc              
  SELECT dpam.dpam_crn_no             
		   , concm.concm_cd             
		   , convert(varchar(50), conc.conc_value)  
           , dpam_sba_no                      
	  FROM  contact_channels          conc    WITH (NOLOCK)              
		  , account_adr_conc          accac   WITH (NOLOCK)  
		  , dp_acct_mstr              dpam    WITH (NOLOCK)       
		  , conc_code_mstr            concm   WITH (NOLOCK)         
	  WHERE accac.accac_adr_conc_id  = conc.conc_id              
	  and   accac.accac_concm_id     = concm.concm_id
	  AND   dpam.dpam_crn_no      IN (SELECT crn FROM @clim_crn)              
	  and   accac_clisba_id    =   dpam_id 
	  AND   concm.concm_cd     in( 'ACCFAX1','NOMINEE_FAX1')              
	  AND   conc.conc_deleted_ind    = 1              
	  AND   accac.accac_deleted_ind  = 1     
	  
	  INSERT INTO @conc              
  SELECT entac.entac_ent_id              
       , entac.entac_concm_cd              
       , convert(varchar(50), conc.conc_value)   
       , dpam_sba_no            
  FROM  contact_channels          conc    WITH (NOLOCK)              
      , entity_adr_conc           entac   WITH (NOLOCK)               
      , dp_acct_mstr              dpam    WITH (NOLOCK)                 
  WHERE entac.entac_adr_conc_id  = conc.conc_id              
  AND   entac.entac_ent_id      IN (SELECT crn FROM @clim_crn)   
  and   entac.entac_ent_id      = dpam_crn_no                
  AND   entac.entac_concm_cd     = 'OFF_PH1'              
  AND   conc.conc_deleted_ind    = 1              
  AND   entac.entac_deleted_ind  = 1   
  and not exists (select sba_no , code from @conc where sba_no  = dpam.dpam_sba_no and code = entac_concm_cd  and    entac_concm_cd in('ACCOFF_PH1') )           
     
     
      INSERT INTO @conc              
  SELECT entac.entac_ent_id              
       , entac.entac_concm_cd              
       , convert(varchar(50), conc.conc_value)   
       , dpam_sba_no            
  FROM  contact_channels          conc    WITH (NOLOCK)              
      , entity_adr_conc           entac   WITH (NOLOCK)               
      , dp_acct_mstr              dpam    WITH (NOLOCK)                 
  WHERE entac.entac_adr_conc_id  = conc.conc_id              
  AND   entac.entac_ent_id      IN (SELECT crn FROM @clim_crn)   
  and   entac.entac_ent_id      = dpam_crn_no                
  AND   entac.entac_concm_cd     = 'RES_PH1'              
  AND   conc.conc_deleted_ind    = 1              
  AND   entac.entac_deleted_ind  = 1   
  and not exists (select sba_no , code from @conc where sba_no  = dpam.dpam_sba_no and code = entac_concm_cd  and    entac_concm_cd in('ACCRES_PH1') )           
     
     
      INSERT INTO @conc              
  SELECT entac.entac_ent_id              
       , entac.entac_concm_cd              
       , convert(varchar(50), conc.conc_value)    
       , dpam_sba_no          
  FROM   contact_channels           conc    WITH (NOLOCK)              
       , entity_adr_conc            entac   WITH (NOLOCK) 
       , dp_acct_mstr              dpam    WITH (NOLOCK)               
  WHERE  entac.entac_adr_conc_id = conc.conc_id              
  AND    entac.entac_ent_id     IN (SELECT crn FROM @clim_crn)    
  and    entac.entac_ent_id      = dpam_crn_no           
  AND    entac.entac_concm_cd    = 'FAX1'              
  AND    conc.conc_deleted_ind   = 1              
  AND    entac.entac_deleted_ind = 1    
and not exists (select sba_no , code from @conc where sba_no  = dpam.dpam_sba_no and code = entac_concm_cd  and    entac_concm_cd in( 'ACCFAX1')   )             
        

         
  --              

           
  --               
  UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code IN ( 'RES_PH1'  ,'OFF_PH1')
  and    adr_code =   'per_adr1'    
  and   cc.value <> ''
  

 UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code IN ( 'RES_PH1'  ,'OFF_PH1')
  and    adr_code =   'cor_adr1'    
  and   cc.value <> ''
  
  
   UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code IN ( 'ACCRES_PH1' ,'ACCOFF_PH1')
  and    adr_code = 'AC_PER_ADR1'       
  and   cc.value <> '' 

 UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code IN ( 'ACCRES_PH1' ,'ACCOFF_PH1')
  and    adr_code = 'AC_COR_ADR1'       
  and   cc.value <> '' 
  
  UPDATE @addr_conc               
  SET    off_fax = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'NOMINEE_FAX1'  
  and   adr_code = 'NOMINEE_ADR1'            
  and   cc.value <> ''          
         
    
    
       
 UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'NOMINEE_PH1'
  and   adr_code = 'NOMINEE_ADR1'      
  and   cc.value <> '' 

UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'NOM_GUARD_OFF'  
and   adr_code = 'NOM_GUARDIAN_ADDR'       
  and   cc.value <> '' 

UPDATE @addr_conc               
  SET    Off_tel = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'GUARD_RES'
and   adr_code = 'GUARD_ADR'                 
  and   cc.value <> '' 
  
  
  UPDATE @addr_conc               
  SET    off_fax = cc.value               
  FROM   @conc cc              
     ,   @addr_conc ad              
  WHERE  cc.crn  = ad.crn    
  and    ad.sba_no = cc.sba_no          
  AND    cc.code = 'FAX1'  
  and    adr_code = 'PER_ADR1'    
  and   cc.value <> ''  

 UPDATE @addr_conc               
  SET    off_fax = cc.value               
  FROM   @conc cc              
     ,   @addr_conc ad              
  WHERE  cc.crn  = ad.crn    
  and    ad.sba_no = cc.sba_no          
  AND    cc.code = 'FAX1'  
  and    adr_code = 'cor_ADR1'    
  and   cc.value <> ''                   
  --         
        
  UPDATE @addr_conc               
  SET    off_fax = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'ACCFAX1'   
  and    adr_code = 'AC_PER_ADR1'     
  and   cc.value <> '' 

 UPDATE @addr_conc               
  SET    off_fax = cc.value              
  FROM   @conc cc              
      ,  @addr_conc ad              
  WHERE  cc.crn  = ad.crn              
  and    ad.sba_no = cc.sba_no
  AND    cc.code = 'ACCFAX1'   
  and    adr_code = 'AC_COR_ADR1'     
  and   cc.value <> '' 

            
     
      
        
  --        
 --select * from @addr_conc      
        
 /* SELECT CASE WHEN ISNULL(ctgry,'') in ('FI', 'FII','Body Corporate','Mutual fund')        THEN '01'              
              WHEN ISNULL(ctgry,'') in ('Trust and Bank')           THEN '02'              
              WHEN ISNULL(ctgry,'') = 'NOMINEE'        THEN '03'             
              WHEN ISNULL(ctgry,'') = 'GUARDIAN'       THEN '03'              
              WHEN ISNULL(ctgry,'') = 'NRI & Foreign National'        THEN '04'              
              WHEN ISNULL(ctgry,'') = 'CORRESPONDENCE' THEN '04'              
              WHEN ISNULL(ctgry,'') = 'MINOR GUARDIAN' THEN '06'              
              else '00' END              
  +isnull(convert(char(36),adr1),'')+isnull(convert(char(36),adr2),'')+isnull(convert(char(36),adr3),'')+isnull(convert(char(36),city),'')+isnull(convert(char(10),zip),'')+isnull(convert(char(24),Off_tel),'')+isnull(convert(char(24),off_fax),'') details 
  
    
    
  
      
           
       select * from conc_code_mstr  
           
  FROM  @addr_conc              
  WHERE ctgry <> ''        */  
  
   IF EXISTS(SELECT bitrm_id FROM BITMAP_REF_MSTR brm WHERE BITRM_PARENT_CD = 'NRN_RQ' AND BITRM_VALUES = 'Y') 
   SET @l_nrn_yn = 'Y'
  
      select details , sba_no from (  
      select DISTINCT case when (adr_code in ('AC_PER_ADR1','per_adr1') and adr_type = 'C') then 1  
              when (adr_code in ('COR_ADR1','per_adr1') and adr_type = 'B') then 2  
              when (adr_code in ('AC_FH_ADR1','FH_ADR1','COR_ADR1','AC_COR_ADR1') and adr_type = 'C' )  then 4   
              when (adr_code in ('NOMINEE_ADR1','GUARD_ADR') and adr_type = 'C')  then 3  
			  when (adr_code in ('NOM_GUARDIAN_ADDR') and adr_type = 'C')  then 6  
         end ord,  
         case when (adr_code in ('per_adr1','AC_PER_ADR1') and adr_type = 'C') then '01'  
              when (adr_code in ('COR_ADR1','per_adr1') and adr_type = 'B') then '02'  
              when (adr_code in ('AC_FH_ADR1','FH_ADR1','COR_ADR1','AC_COR_ADR1') and adr_type = 'C')  then '04'   
              when (adr_code in ('NOMINEE_ADR1','GUARD_ADR') and adr_type = 'C')  then '03' 
			when (adr_code in ('NOM_GUARDIAN_ADDR') and adr_type = 'C')  then '06'  
         end  
         + CASE WHEN adr_code = 'NOMINEE_ADR1' AND @l_nrn_yn = 'Y' THEN convert(char(36),'NRN' + ISNULL(NRN_NO,'') ) ELSE convert(char(36),isnull(adr1,'')) END 
          +CASE WHEN adr_code = 'NOMINEE_ADR1' AND @l_nrn_yn = 'Y' THEN convert(char(36),isnull(adr1,'')) ELSE convert(char(36),isnull(adr2,'')) END 
          +CASE WHEN adr_code = 'NOMINEE_ADR1' AND @l_nrn_yn = 'Y' THEN convert(char(36),isnull(adr2,'')) ELSE convert(char(36),isnull(adr3,'')) end
          +convert(char(36),isnull(city,''))
          +convert(char(10),isnull(zip,''))
          +convert(char(24),isnull(Off_tel,''))
          +convert(char(24),isnull(off_fax,'')) 
           details   
      , sba_no   
       FROM  @addr_conc              
       WHERE adr1 <> ''   
       ) a  
 order by sba_no , ord 
 
   
--              
END

GO
