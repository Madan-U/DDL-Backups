-- Object: PROCEDURE citrus_usr.PR_IMPORT_MOD_DP
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SELECT * FROM DP_MSTR
--PR_IMPORT_MOD_DP '10005|*~|10099047|*~|*|~*','NSDL','30/05/2005','30/12/2110','M','12',2,'HO',''
CREATE PROCEDURE [citrus_usr].[PR_IMPORT_MOD_DP]
(
  @PA_CRN_NO      VARCHAR(8000)                  
, @PA_EXCH        VARCHAR(10)                  
, @PA_FROM_DT     VARCHAR(11)                  
, @PA_TO_DT       VARCHAR(11)                  
, @PA_TAB         CHAR(3)                  
, @PA_BATCH_NO    VARCHAR(25)  
, @PA_EXCSM_ID    NUMERIC   
, @PA_LOGINNAME   VARCHAR(25)  
, @PA_REF_CUR     VARCHAR(8000) OUTPUT                  
)                  
AS                  
BEGIN 
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
          , @c_crn_no            numeric                     
          , @c_dpam_id           numeric                                                                   
          , @c_acct_no           varchar(25)                                                                     
          , @c_sba_no            varchar(20)          
          , @l_crn_no            NUMERIC                  
          , @l_acct_no           VARCHAR(25)                    
          , @l_Value   VARCHAR(8000)                  
          , @l_client_type       VARCHAR(100)                  
          , @l_chk               NUMERIC                  
          , @l_ctgry_chk         NUMERIC                         
         , @L_DPM_ID           BIGINT        
    --   
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
        --                  
        END                  
      --                    
      END                  
      --   

            SELECT distinct isnull(convert(char(8),dpam_sba_no),SPACE(8))                  
             + isnull(convert(char(16),rtrim(ltrim(dpam_sba_name))),SPACE(16))                                                                                      --beneficiary short name                                                          
             + isnull(CONVERT(CHAR(2),citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),SPACE(2)))),'')   --occupation code
			 + isnull(convert(char(45),dphd.dphd_fh_fthname),SPACE(45)) --beneficiary FIRST FATHER holder name        
             + isnull(convert(char(45),dphd.dphd_sh_fthname),SPACE(45)) --beneficiary second FATHER holder name                   
             + isnull(convert(char(45),dphd.dphd_th_fthname),SPACE(45)) --beneficiary third FATHER holder name                  
             + convert(char(30),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),SPACE(30)))    --first holder PAN 
             + convert(char(30),ISNULL(dphd.dphd_sh_pan_no,SPACE(30)))    ----sec holder PAN                                                                         --second holder pan                  
             + convert(char(30),ISNULL(dphd.dphd_th_pan_no,SPACE(30)))    ----third holder PAN 
             + case when isnull(dphd.dphd_nom_fname,'')<>'' then 'N' when isnull(dphd.dphd_gau_fname,'')<>'' then 'G' else SPACE(1) end
             + case when isnull(dphd.dphd_nom_fname,'')<>'' then isnull(CONVERT(CHAR(45),dphd.dphd_nom_fname),SPACE(45)) when isnull(dphd.dphd_gau_fname,'')<>'' then isnull(CONVERT(CHAR(45),dphd.dphd_gau_fname),SPACE(45)) else SPACE(45) end
             + CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE SPACE(1) END                                               --nom-min indicator                  'REM'--nominee minor ind
             + CONVERT(CHAR(45),ISNULL(dphd_nomGAU_fname,''))
             + CASE when dphd_gau_fname <> '' then   isnull(convert(CHAR(8),convert(datetime, clim_dob,103)),'') ELSE '00000000' END 
             + CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN isnull(convert(CHAR(8),CONVERT(DATETIME,dphd_nom_dob)),'') ELSE '00000000' end  
             + convert(char(30),ISNULL(cliba.cliba_ac_no,SPACE(30)))                                                                              --bank account no                   
             + case when ISNULL(cliba.cliba_ac_type,'')= 'SAVINGS' then '10'  when ISNULL(cliba.cliba_ac_type,'')= 'CURRENT'  then '11' ELSE '13' end                                                                           --bank account no                   
             + convert(char(35),ISNULL(banm.banm_name ,SPACE(35)))    
             + space(100)                                                                             --bank name                   
             + convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),SPACE(50)))   --benrficiary rbi reference no --50                  
             + convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),'00000000'))                                              --benrficiary rbi approval date --8                  
             + convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),SPACE(24)))                                                 --beneficiary sebi registration no --24                  
             + Convert(char(20),citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),SPACE(20))))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
             + '000000'--branch code     
             + 'Y'                                                                                                      --local addr???                  
             + convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),SPACE(9)))  
             +case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
                   then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),1)),space(36))
                   else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),2)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),2)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),3)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),3)),space(36)) end  
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),4)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),4)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
													      then isnull(convert(char(6),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),7)),space(6))
													      else isnull(convert(char(6),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),7)),space(6)) end  
             +space(1)
             +isnull(convert(char(24),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'RES_PH1')),SPACE(24))
             +isnull(convert(char(24),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'FAX1')),SPACE(24)) 
             +isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),1)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),2)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),3)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),4)),space(36))
													+isnull(convert(char(7),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),7)),space(7))             
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),1)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),2)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),3)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),4)),space(36))
             +ISNULL(CONVERT(CHAR(7),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),7)),space(7))
             +case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
                   then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),1)),space(36))
                   else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1)),space(36)) end 
             +case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),2)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),2)),space(36)) end  
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),3)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),3)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
													      then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),4)),space(36))
													      else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),4)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
													      then isnull(convert(char(10),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),7)),space(10))
													      else isnull(convert(char(10),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),7)),space(10)) end
													      
													+SPACE(24)--'REM'--FORIEGN/CORRES PHONE NO
													+SPACE(24)--'REM'--FORIEGN/CORRES FAX
             +isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'NOM_GUARDIAN_ADDR'),1)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'NOM_GUARDIAN_ADDR'),2)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'NOM_GUARDIAN_ADDR'),3)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'NOM_GUARDIAN_ADDR'),4)),space(36))
													+isnull(convert(char(7),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'NOM_GUARDIAN_ADDR'),7)),space(7))
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),SPACE(9))) 
             +ISNULL(convert(CHAR(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE1')),SPACE(12))
             +CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1 )   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')  THEN 'N' ELSE 'N' END 
             
             +case when isnull(DPPD_FNAME,'') <> '' then 'Y' else 'N' end
             +CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END--PAN FLAG FOR FIRST HOLDER
            + case when dpam_enttm_cd = '02' then case when isnull(dphd.dphd_nom_fname,'')<>'' then 'N' else ' ' end else ' ' end 
               + SPACE(11)   
           
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL2'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID2',''),SPACE(9))) 
             +ISNULL(convert(char(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE2')),SPACE(12))
             +SPACE(1)--ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG1'),'')--SMS FOR FIRST HOLDER
             +SPACE(1)
             +case when isnull(DPHD_SH_PAN_NO,SPACE(1)) <> '' then 'Y' ELSE SPACE(1) END 
             +SPACE(12)
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL3'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID3',''),SPACE(9))) 
             +ISNULL(convert(CHAR(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE3')),SPACE(12))
             +SPACE(1)--ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG1'),'')--SMS FOR FIRST HOLDER
             +SPACE(1)
             +case when isnull(DPHD_TH_PAN_NO,SPACE(1)) <> '' then 'Y' ELSE SPACE(1) END 
             +SPACE(12)
             +convert(char(20),'')--USER REMARKS  
             Pridtls
             ,
             isnull(convert(CHAR(8),dpam_sba_no),SPACE(8))  
             +case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end 
             +convert(char(20),'') --user remarks
             StandingInstruction
             ,isnull(convert(CHAR(8),dpam_sba_no),SPACE(8))  
             +'11'
             +'#SIG#'
             +isnull(convert(char(135),dpam_sba_name),SPACE(135))          
             +isnull(convert(char(10),dpam_id),SPACE(10))--space(10) -- refrence nos
             +space(20) -- user rmks 
              AuthorisedDtls
             ,Isnull(accd_doc_path,'') docpath
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               LEFT OUTER JOIN  
               dp_poa_dtls            dppd                  on dppd.dppd_dpam_id            = dpam.dpam_id             
               LEFT OUTER JOIN  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id    
               left outer join
               account_documents         accd                  on accd_clisba_id          = dpam_id and accd_deleted_ind=1     
               left outer join
               account_document_mstr     accdm                 on  accd_accdocm_doc_id    = accdocm_doc_id and accd_deleted_ind=1 
           ,   @crn                      crn                  
           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
               left outer join   
               sub_ctgry_mstr   subcm   
               on clicm.clicm_id  = subcm.subcm_clicm_id    
               AND    subcm.subcm_deleted_ind = 1                  
        WHERE  crn.crn                 = clim.clim_crn_no                  
        AND    dpam.dpam_crn_no        = clim.clim_crn_no           
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
        AND    dpam.dpam_subcm_cd      = subcm.subcm_cd         
        AND    clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    dpam.dpam_deleted_ind   = 1                  
        AND    clim.clim_deleted_ind   = 1             
          and accdocm_cd='SIGN_BO'         
      
        --update dpam set dpam_batch_no =  @PA_BATCH_NO from @l_dp_pri_dtls, dp_acct_mstr dpam where dpam_sba_no =  send_ref_no1   
        
        --Select @l_counter = COUNT(send_ref_no1) from @l_dp_pri_dtls    
          
        SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
          
          
        IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1 AND BATCHN_TYPE='C')  
        BEGIN  
          
              
          INSERT INTO BATCHNO_NSDL_MSTR                                       
          (    
           BATCHN_DPM_ID,  
           BATCHN_NO,  
           BATCHN_RECORDS ,           
           BATCHN_TRANS_TYPE,
		   BATCHN_FILEGEN_DT,     
           BATCHN_TYPE,  
           BATCHN_STATUS,  
           BATCHN_CREATED_BY,  
           BATCHN_CREATED_DT ,  
           BATCHN_DELETED_IND  
          )  
          VALUES  
          (  
           @L_DPM_ID,  
           @PA_BATCH_NO,  
           0,  
           'ACCOUNT REGISTRATION',  
			CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00',
           'C',  
           'P',  
           @PA_LOGINNAME,  
           GETDATE(),  
           1  
           )  
  
  
  
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
          WHERE BITRM_PARENT_CD ='NSDL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
                 
        --  
        END  
    END      
    ELSE
    BEGIN 
            SELECT isnull(convert(char(8),dpam_sba_no),SPACE(8))                  
             + isnull(convert(char(16),rtrim(ltrim(dpam_sba_name))),SPACE(16))                                                                                      --beneficiary short name                                                          
             + isnull(CONVERT(CHAR(2),citrus_usr.fn_get_listing_NSDL('occupation',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'occupation',''),SPACE(2)))),'')   --occupation code
			 + isnull(convert(char(45),dphd.dphd_fh_fthname),SPACE(45)) --beneficiary FIRST FATHER holder name        
             + isnull(convert(char(45),dphd.dphd_sh_fthname),SPACE(45)) --beneficiary second FATHER holder name                   
             + isnull(convert(char(45),dphd.dphd_th_fthname),SPACE(45)) --beneficiary third FATHER holder name                  
             + convert(char(30),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),SPACE(30)))    --first holder PAN 
             + convert(char(30),ISNULL(dphd.dphd_sh_pan_no,SPACE(30)))    ----sec holder PAN                                                                         --second holder pan                  
             + convert(char(30),ISNULL(dphd.dphd_th_pan_no,SPACE(30)))    ----third holder PAN 
             + case when isnull(dphd.dphd_nom_fname,'')<>'' then 'N' when isnull(dphd.dphd_gau_fname,'')<>'' then 'G' else SPACE(1) end
             + case when isnull(dphd.dphd_nom_fname,'')<>'' then isnull(CONVERT(CHAR(45),dphd.dphd_nom_fname),SPACE(45)) when isnull(dphd.dphd_gau_fname,'')<>'' then isnull(CONVERT(CHAR(45),dphd.dphd_gau_fname),SPACE(45)) else SPACE(45) end
             + CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 )   THEN 'Y' ELSE SPACE(1) END                                               --nom-min indicator                  'REM'--nominee minor ind
             + CONVERT(CHAR(45),ISNULL(dphd_nomGAU_fname,''))
             + CASE when dphd_gau_fname <> '' then   isnull(convert(CHAR(8),convert(datetime, clim_dob,103)),'') ELSE '00000000' END 
             + CASE WHEN (dphd_nom_fname <> '' AND DATEDIFF(YEAR, CONVERT(DATETIME,DPHD_NOM_DOB,103), CONVERT(DATETIME,GETDATE(),103)) < 18 ) THEN isnull(convert(CHAR(8),CONVERT(DATETIME,dphd_nom_dob)),'') ELSE '00000000' end  
             + convert(char(30),ISNULL(cliba.cliba_ac_no,SPACE(30)))                                                                              --bank account no                   
             + case when ISNULL(cliba.cliba_ac_type,'')= 'SAVINGS' then '10'  when ISNULL(cliba.cliba_ac_type,'')= 'CURRENT'  then '11' ELSE '13' end                                                                           --bank account no                                                                                            --bank account no                   
             + convert(char(35),ISNULL(banm.banm_name ,SPACE(35)))    
             + space(100)                                                                             --bank name                   
             + convert(char(50),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RBI_REF_NO',''),SPACE(50)))   --benrficiary rbi reference no --50                  
             + convert(char(8),ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RBI_REF_NO','RBI_APP_DT',''),'00000000'))                                              --benrficiary rbi approval date --8                  
             + convert(char(24),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'SEBI_REGN_NO',''),SPACE(24)))                                                 --beneficiary sebi registration no --24                  
             + Convert(char(20),citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'TAX_DEDUCTION',''),SPACE(20))))  --benef_tax_ded_sta                                                                      --tax deduction status --20             
             + '000000'--branch code     
             + 'Y'                                                                                                      --local addr???                  
             + convert(char(9),ISNULL(citrus_usr.fn_acct_entp(dpam.dpam_id,'BENMICR'),SPACE(9)))  
             +case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),1)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),2)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),2)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),3)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),3)),space(36)) end  
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),4)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),4)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),1) = '' 
																			then isnull(convert(char(6),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'per_ADR1'),7)),space(7))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_PER_ADR1'),7)),space(36)) end  
             +space(1)
             +isnull(convert(char(24),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'RES_PH1')),SPACE(24))
             +isnull(convert(char(24),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'FAX1')),SPACE(24)) 
             +isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),1)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),2)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),3)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),4)),space(36))
													+isnull(convert(char(7),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(BANM_ID,'COR_ADR1'),7)),space(7))             
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),1)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),2)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),3)),space(36))
             +ISNULL(CONVERT(CHAR(36),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),4)),space(36))
             +ISNULL(CONVERT(CHAR(7),CITRUS_USR.FN_SPLITVAL(citrus_usr.[fn_acct_addr_value](dpam_id,'NOMINEE_ADR1'),7)),space(7))
             +case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),1)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1)),space(36)) end 
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),2)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),2)),space(36)) end  
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),3)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),3)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
																			then isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),4)),space(36))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),4)),space(36)) end
													+case when CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),1) = '' 
																			then isnull(convert(char(10),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'COR_ADR1'),7)),space(10))
																			else isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(dpam_id,'AC_COR_ADR1'),7)),space(36)) end

													+SPACE(24)--'REM'--FORIEGN/CORRES PHONE NO
													+SPACE(24)--'REM'--FORIEGN/CORRES FAX
             +isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'NOM_GUARDIAN_ADDR'),1)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'NOM_GUARDIAN_ADDR'),2)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'NOM_GUARDIAN_ADDR'),3)),space(36))
													+isnull(convert(char(36),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'NOM_GUARDIAN_ADDR'),4)),space(36))
													+isnull(convert(char(7),CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(CLIM.CLIM_CRN_NO,'NOM_GUARDIAN_ADDR'),7)),space(7))
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',''),SPACE(9))) 
             +ISNULL(convert(CHAR(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE1')),SPACE(12))
             +CASE WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= 1 )   THEN 'Y' 
               WHEN (convert(char(11),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')) <> '' AND  convert(char(1),ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG'),''))= '')  THEN 'N' ELSE 'N' END 
             +case when isnull(DPPD_FNAME,'') <> '' then 'Y' else 'N' end
             +CASE WHEN convert(char(1),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',''),''))  <> '' THEN 'Y' ELSE 'N' END--PAN FLAG FOR FIRST HOLDER
               + case when dpam_enttm_cd = '02' then case when isnull(dphd.dphd_nom_fname,'')<>'' then 'N' else ' ' end else ' ' end 
               + SPACE(11)   
           
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL2'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID2',''),SPACE(9))) 
             +ISNULL(convert(char(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE2')),SPACE(12))
             +SPACE(1)--ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG1'),'')--SMS FOR FIRST HOLDER
             +SPACE(1)
             +case when isnull(DPHD_SH_PAN_NO,SPACE(1)) <> '' then 'Y' ELSE SPACE(1) END 
             +SPACE(12)
             +convert(char(50),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL3'),SPACE(50)))
             + convert(char(9),ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID3',''),SPACE(9))) 
             +ISNULL(convert(CHAR(12),CITRUS_USR.FN_CONC_VALUE(CLIM.CLIM_CRN_NO,'MOBILE3')),SPACE(12))
             +SPACE(1)--ISNULL(citrus_usr.fn_ACCT_entp(DPAM_ID,'SMS_FLAG1'),'')--SMS FOR FIRST HOLDER
             +SPACE(1)
             +case when isnull(DPHD_TH_PAN_NO,SPACE(1)) <> '' then 'Y' ELSE SPACE(1) END 
             +SPACE(12)
             +convert(char(20),'')--USER REMARKS  
             Pridtls
             ,
             isnull(convert(CHAR(8),dpam_sba_no),SPACE(8))  
             +case when convert(char(1),ISNULL(citrus_usr.fn_ucc_accp(clim.clim_crn_no,'STAN_INS_IND',''),'')) in ('','0') then 'N' else 'Y'  end 
             +convert(char(20),'') --user remarks
             StandingInstruction
             ,isnull(convert(CHAR(8),dpam_sba_no),SPACE(8))  
             +'11'
             +'#SIG#'
             +isnull(convert(char(135),dpam_sba_name),SPACE(135))          
             +isnull(convert(char(10),dpam_id),SPACE(10))--space(10) -- refrence nos
             +space(20) -- user rmks 
              AuthorisedDtls
             ,isnull(accd_doc_path,'')   docpath
        FROM   dp_acct_mstr              dpam      
               left outer  join  
               dp_holder_dtls            dphd                  on dpam.dpam_id            = dphd.dphd_dpam_id             
               LEFT OUTER JOIN  
               dp_poa_dtls            dppd                  on dppd.dppd_dpam_id            = dpam.dpam_id             
               LEFT OUTER JOIN  
               client_bank_accts         cliba                 on dpam.dpam_id            = cliba.cliba_clisba_id   
               left outer join  
               bank_mstr                 banm                  on cliba.cliba_banm_id     = banm.banm_id     
               left outer join
               account_documents         accd                  on accd_clisba_id          = dpam_id and accd_deleted_ind=1     
               left outer join
               account_document_mstr     accdm                 on  accd_accdocm_doc_id    = accdocm_doc_id and accd_deleted_ind=1 

           ,   client_mstr               clim                   
           ,   entity_type_mstr          enttm                  
           ,   client_ctgry_mstr         clicm    
               left outer join   
               sub_ctgry_mstr   subcm   
               on clicm.clicm_id  = subcm.subcm_clicm_id    
               AND    subcm.subcm_deleted_ind = 1                  
        WHERE     dpam.dpam_crn_no        = clim.clim_crn_no           
        AND    dpam.dpam_enttm_cd      = enttm.enttm_cd                  
        AND    dpam.dpam_clicm_cd      = clicm.clicm_cd                  
        AND    dpam.dpam_subcm_cd      = subcm.subcm_cd         
        AND    clim_lst_upd_dt    BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                         
        AND    isnull(banm.banm_deleted_ind,1)   = 1                  
        AND    isnull(cliba.cliba_deleted_ind,1) = 1                  
        AND    isnull(dphd.dphd_deleted_ind,1)   = 1                   
        AND    dpam.dpam_deleted_ind   = 1                  
        AND    clim.clim_deleted_ind   = 1           
  and accdocm_cd='SIGN_BO'         

        SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   
          
          
        IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1 AND BATCHN_TYPE='C')  
        BEGIN  
          
              
          INSERT INTO BATCHNO_NSDL_MSTR                                       
          (    
           BATCHN_DPM_ID,  
           BATCHN_NO,  
           BATCHN_RECORDS ,           
           BATCHN_TRANS_TYPE,
		   BATCHN_FILEGEN_DT,     
           BATCHN_TYPE,  
           BATCHN_STATUS,  
           BATCHN_CREATED_BY,  
           BATCHN_CREATED_DT ,  
           BATCHN_DELETED_IND  
          )  
          VALUES  
          (  
           @L_DPM_ID,  
           @PA_BATCH_NO,  
           0,  
           'ACCOUNT REGISTRATION',  
			CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00',
           'C',  
           'P',  
           @PA_LOGINNAME,  
           GETDATE(),  
           1  
           )  
  
  
  
          UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
          WHERE BITRM_PARENT_CD ='NSDL_BTCH_CLT_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID and BITRM_BIT_LOCATION = @PA_EXCSM_ID  
                 
        --  
        END  

      
         
    END         
END

GO
