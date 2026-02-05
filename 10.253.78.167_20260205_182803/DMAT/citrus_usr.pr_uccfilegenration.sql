-- Object: PROCEDURE citrus_usr.pr_uccfilegenration
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--SELECT * FROM EXCH_SEG_MSTR
--pr_uccfilegenration '','NSE','','N','30/05/2009','30/05/2009',''
CREATE PROCEDURE [citrus_usr].[pr_uccfilegenration](@pa_crn_no     varchar(8000)
													,@pa_exch       varchar(10)
													,@pa_exch_seg   varchar(20)
													,@pa_n_m        char(1)
													,@pa_from_dt    varchar(11)
													,@pa_to_dt      varchar(11)
													,@pa_ref_cur    varchar(8000) OUTPUT
													)
AS
BEGIN
--
  DECLARE @@rm_id                  varchar(8000)
        , @@cur_id                 varchar(8000)
        , @@foundat                int
        , @@delimeterlength        int
        , @@delimeter              char(1)
        , @l_crn_no                numeric
        , @l_acct_no               varchar(25)
        , @l_cash_desc             VARCHAR(50)
        , @l_deri_desc             VARCHAR(50)

  --
  IF ISNULL(@pa_crn_no, '') <> ''
  BEGIN--n_n
  --
    SET @@rm_id  =  @pa_crn_no
    --
    DECLARE @crn TABLE (crn         numeric
                       ,acct_no     varchar(25)
                       ,clim_stam_cd     varchar(25)
                       ,fm_dt       datetime
                       ,to_dt       datetime
                       ,clim_clicm_cd varchar(25)
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
        SET @l_acct_no = CONVERT(VARCHAR(25),citrus_usr.fn_splitval(@@cur_id,2))
        --
        INSERT INTO @crn
        SELECT clim_crn_no,@l_acct_no, clim_stam_cd,clim_lst_upd_dt, clim_lst_upd_dt ,clim_clicm_cd
        FROM   client_mstr WITH (NOLOCK)
        WHERE  clim_crn_no = CONVERT(numeric, @l_crn_no)

      --
      END
    --
    END
    --

    IF  @pa_exch = 'NSE'
    BEGIN--nse
    --
      IF @pa_n_m = 'N'
      BEGIN--new
      --
        SELECT x.segment
               --+'|'+CONVERT(VARCHAR(10), CONVERT(NUMERIC, clim.clim_crn_no)) --client_code
               +'|'+LTRIM(RTRIM(CONVERT(CHAR(10), x.clia_acct_no))) --client_code
               +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
               +'|'+ltrim(rtrim(CONVERT(CHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),CRN.CRN),''))))
               +'|'+ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(CRN.CRN,'PAN_GIR_NO',@pa_exch)))) --pan no
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'EMAIL1'),''))))--CONVERT(VARCHAR(25), citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch)) --pan ward
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),1))))--adr1
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),2))))--adr2
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),3))))--adr3
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),4))))--adr_city
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),5))))--adr_state
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),6))))--adr_country
               +'|'+ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),7))))--adr_zip
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'ISD_CODE'),''))))
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'STD_CODE'),''))))
               +'|'+case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then CASE WHEN convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),''))))
                         ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),'')))) END
                    ELSE CASE WHEN  convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),''))))
                         ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),'')))) END
                    END
               +'|'+ltrim(rtrim(convert(VARCHAR(10),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'MOBILE1'),''))       ))
               +'|'+CASE WHEN case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END = '01-Jan-1900' THEN '' ELSE case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END END
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'REGR_NO',@pa_exch))
               +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_AUTHORITY',@pa_exch))
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_AT',@pa_exch))
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+--convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),1))
               +'|'+--convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),2))
               +'|'+--convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
                     --                    WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
               +'|'+--convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),4))
               +'|'+--convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),1))
               +'|'+--convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),2))
               +'|'+--convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),3))
			   +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch))
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PASSPORT_NO',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				+'|'+CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(CRN.CRN,'CONTACT_PERSON',@pa_exch))
                +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch))
                +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'CONTACT_PERSON','CONTACT_PAN',@pa_exch))
				+'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''))-1) else '' end
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'CONTACT_PHONE'),'')
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'CONTACT_EMAIL'),'')
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
				+'|'
               +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(CRN.CRN,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
               +'|'+'E'   ucc_details
        FROM
            (SELECT clia.clia_crn_no            clia_crn_no
                  , clia.clia_acct_no           clia_acct_no
                  , excsm.excsm_exch_cd         excsm_exch_cd
                  , excsm.excsm_seg_cd          excsm_seg_cd
                  , excsm.excsm_compm_id        compm_id
                  , CASE WHEN excsm.excsm_seg_cd  = 'CASH' THEN 'C' WHEN excsm.excsm_seg_cd = 'DERIVATIVES' THEN  'F' ELSE '' END segment
                  --, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
             FROM   client_accounts             clia      WITH (NOLOCK)
                  , exch_seg_mstr               excsm     WITH (NOLOCK)
             , client_mstr clim
,ucctony_271109 temp
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                and   clim.clim_crn_no = clia.clia_crn_no
                and   clia.clia_acct_no = temp.f1
                --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND    clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND    clia.clia_deleted_ind     = 1
              AND    excsm.excsm_deleted_ind   = 1
            ) x
            , @crn                              crn
            , CLIENT_MSTR                       A
        WHERE CLIM_CRN_NO                     = CRN
        AND   x.clia_crn_no                   = crn.crn
        AND   x.clia_acct_no                  = crn.acct_no
        AND   crn.fm_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        --AND   crn.to_dt                       = crn.fm_dt
        --AND   x.access1                      <> 0
        ORDER BY X.clia_acct_no,X.SEGMENT
      --
      END--new
      ELSE
      BEGIN--mod
      --
        SELECT x.segment
               --+'|'+CONVERT(VARCHAR(10), CONVERT(NUMERIC, clim.clim_crn_no)) --client_code
               +'|'+CONVERT(VARCHAR(10), x.clia_acct_no) --client_code
               +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')))) --client name --+'|'+CONVERT(VARCHAR(9), citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',@pa_exch)) --mapin
               +'|'+ltrim(rtrim(CONVERT(VARCHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),CRN.CRN),''))))
               +'|'+ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(CRN.CRN,'PAN_GIR_NO',@pa_exch)))) --pan no
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'EMAIL1'),''))))--CONVERT(VARCHAR(25), citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch)) --pan ward
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),1))))--adr1
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),2))))--adr2
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),3))))--adr3
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),4))))--adr_city
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),5))))--adr_state
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),6))))--adr_country
               +'|'+ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'COR_ADR1'),''),7))))--adr_zip
               +'|'
               +'|'
               +'|'+case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then CASE WHEN convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),'')))) END
                    ELSE CASE WHEN  convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'OFF_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'RES_PH1'),'')))) END
                    END
               +'|'+ltrim(rtrim(convert(VARCHAR(10),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'MOBILE1'),''))       ))
               +'|'+CASE WHEN case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END = '01-Jan-1900' THEN '' ELSE case when A.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END END
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'REGR_NO',@pa_exch))
               +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_AUTHORITY',@pa_exch))
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_AT',@pa_exch))
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(CRN.CRN,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'--+convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),1))
               +'|'--+convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),2))
               +'|'--+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
                     --                    WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
               +'|'--+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'BANK',@PA_EXCH),''),4))
               +'|'--+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),1))
               +'|'--+convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),2))
               +'|'--+convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(CRN.CRN,'DP',@PA_EXCH),''),3))
				+'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch))
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PASSPORT_NO',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(CRN.CRN,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				+'|'+CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(CRN.CRN,'CONTACT_PERSON',@pa_exch))
                 +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch))
                +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(CRN.CRN,'CONTACT_PERSON','CONTACT_PAN',@pa_exch))
				+'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''))-1) else '' end
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'CONTACT_PHONE'),'')
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(CRN.CRN,'CONTACT_EMAIL'),'')
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
				+'|'
               +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(CRN.CRN,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
               +'|'+'E'   ucc_details
        FROM
              (SELECT clia.clia_crn_no            clia_crn_no
                    , clia.clia_acct_no           clia_acct_no
                    , excsm.excsm_exch_cd         excsm_exch_cd
                    , excsm.excsm_seg_cd          excsm_seg_cd
                    , excsm.excsm_compm_id        compm_id
                    , CASE WHEN excsm.excsm_seg_cd  = 'CASH' THEN 'C' WHEN excsm.excsm_seg_cd = 'DERIVATIVES' THEN  'F' ELSE '' END segment
                    --, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
               FROM   client_accounts             clia      WITH (NOLOCK)
                    , exch_seg_mstr               excsm     WITH (NOLOCK)
                , client_mstr clim
,ucctony_271109 temp
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                and   clim.clim_crn_no = clia.clia_crn_no
                and   clia.clia_acct_no = temp.f1
                --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
               AND clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
               AND    clia.clia_deleted_ind     = 1
               AND    excsm.excsm_deleted_ind   = 1
              ) x
              , @crn                              crn
              , CLIENT_MSTR  A
        WHERE CLIM_CRN_NO = CRN.CRN
        AND   x.clia_crn_no                     = crn.crn
        AND   x.clia_acct_no                    = crn.acct_no
        AND   crn.to_dt                           BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        --AND   crn.to_dt                         <> crn.fm_dt
        --AND   x.access1                    <> 0
        ORDER BY X.clia_acct_no,X.SEGMENT
      --
      END--mod
    --
    END--nse
    --
    --
    --
    ELSE IF @pa_exch = 'NSX'
				    BEGIN--bse
				    --
				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --
				       select x.segment
				       +'|'+LTRIM(RTRIM(CONVERT(CHAR(10), x.clia_acct_no))) --client_code
				                   +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch)))),'') --pan no
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'EMAIL1'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),1)))),'')  --adr1
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),2)))),'')  --adr2
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),3)))),'')  --adr3
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),4)))),'')--adr_city
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),5)))),'')--adr_state
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),6)))),'')--adr_country
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),7)))),'')--adr_zip
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'ISD_CODE'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'STD_CODE'),'')))),'')
				                   +'|'+case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then CASE WHEN convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),'')))) END
				                        ELSE CASE WHEN  convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),'')))) END
				                        END
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'MOBILE1'),'')))),'')
				                   +'|'+CASE WHEN case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END = '01-Jan-1900' THEN '' ELSE case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END END
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch)),'')
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE isnull(REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-'),'') END
                                   +'|'+isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
								   --+'|'+isnull(citrus_usr.fn_ucc_dp('SLBNSE',crn.crn,crn.acct_no),'')
                                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),1)))),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),2)))),'')
				                   --+'|'+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
				                   --                          WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
				                   --+'|'+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),4))
				                   --,convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),1))
				                   --,convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),2))
				                   --,convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),3))
				    		   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)),'')
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				    		   +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON','CONTACT_PAN',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON1','CONTACT_DESIGNATION1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON1','CONTACT_PAN1',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE1'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL1'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON2','CONTACT_DESIGNATION2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON2','CONTACT_PAN2',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE2'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL2'),'')
				               +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(crn.crn,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
				               +'|'+'E'
				           ucc_details

				            FROM
				                (SELECT clia.clia_crn_no            clia_crn_no
				                      , clia.clia_acct_no           clia_acct_no
				                      , excsm.excsm_exch_cd         excsm_exch_cd
				                      , excsm.excsm_seg_cd          excsm_seg_cd
				                      , excsm.excsm_compm_id        compm_id
				                      , CASE WHEN excsm.excsm_seg_cd  = 'FUTURES' THEN 'X'  ELSE '' END segment
				                      , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				                 FROM   client_accounts             clia      WITH (NOLOCK)
				                      , exch_seg_mstr               excsm     WITH (NOLOCK)
				                 , client_mstr clim
								WHERE  excsm.excsm_exch_cd       = @pa_exch
								--AND    excsm.excsm_seg_cd        = @pa_exch_seg
								and   clim.clim_crn_no = clia.clia_crn_no
								 --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                                 AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				                 and     excsm.excsm_exch_cd       = 'NSX'
				                 and     excsm.excsm_seg_cd        = 'FUTURES'
				                  AND    clia.clia_deleted_ind     = 1
				                  AND    excsm.excsm_deleted_ind   = 1
				                ) x
				                , @crn                              crn
				                , CLIENT_MSTR                       CLIM
				                --,CLIENT_ACCOUNTS                    CLIA
				            WHERE CLIM.CLIM_CRN_NO                = CRN.CRN      --CLIA.CLIA_CRN_NO
				            AND   x.clia_crn_no                   = crn.crn      --CLIM_CRN_NO
				            --AND   x.clia_acct_no                  = crn.acct_no  --CLIA.CLIA_ACCT_NO
				            AND   crn.fm_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND   crn.to_dt                       = crn.fm_dt
				           -- AND   x.access1                      <> 0
				            ORDER BY X.clia_acct_no,X.SEGMENT
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				      --
				        select x.segment
				       +'|'+LTRIM(RTRIM(CONVERT(CHAR(10), x.clia_acct_no))) --client_code
				                   +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch)))),'') --pan no
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'EMAIL1'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),1)))),'')  --adr1
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),2)))),'')  --adr2
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),3)))),'')  --adr3
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),4)))),'')--adr_city
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),5)))),'')--adr_state
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),6)))),'')--adr_country
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(crn.crn,'COR_ADR1'),''),7)))),'')--adr_zip
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'ISD_CODE'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'STD_CODE'),'')))),'')
				                   +'|'+case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then CASE WHEN convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),'')))) END
				                        ELSE CASE WHEN  convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'OFF_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'RES_PH1'),'')))) END
				                        END
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'MOBILE1'),'')))),'')
				                   +'|'+CASE WHEN case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END = '01-Jan-1900' THEN '' ELSE case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END END
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch)),'')
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE isnull(REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-'),'') END
                                   +'|'+isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
                                   --+'|'+isnull(citrus_usr.fn_ucc_dp('SLBNSE',crn.crn,crn.acct_no),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),1)))),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),2)))),'')
				                   --+'|'+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
				                   --                          WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
				                   --+'|'+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'BANK',@PA_EXCH),''),4))
				                   --,convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),1))
				                   --,convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),2))
				                   --,convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(crn.crn,'DP',@PA_EXCH),''),3))
				    		   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)),'')
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(crn.crn,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				    		   +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON','CONTACT_PAN',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON1','CONTACT_DESIGNATION1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON1','CONTACT_PAN1',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR1'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR1'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE1'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL1'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(crn.crn,'CONTACT_PERSON2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON2','CONTACT_DESIGNATION2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(crn.crn,'CONTACT_PERSON2','CONTACT_PAN2',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(crn.crn,'CONTACT_ADDR2'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(CRN.CRN,'CONTACT_ADDR2'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_PHONE2'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(crn.crn,'CONTACT_EMAIL2'),'')

				                   +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(crn.crn,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
				                   +'|'+'E'
				ucc_details

				            FROM
				                (SELECT clia.clia_crn_no            clia_crn_no
				                      , clia.clia_acct_no           clia_acct_no
				                      , excsm.excsm_exch_cd         excsm_exch_cd
				                      , excsm.excsm_seg_cd          excsm_seg_cd
				                      , excsm.excsm_compm_id        compm_id
				                      , CASE WHEN excsm.excsm_seg_cd  = 'FUTURES' THEN 'X'  ELSE '' END segment
				                      , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				                 FROM   client_accounts             clia      WITH (NOLOCK)
				                      , exch_seg_mstr               excsm     WITH (NOLOCK)
				                 , client_mstr clim
								WHERE  excsm.excsm_exch_cd       = @pa_exch
								--AND    excsm.excsm_seg_cd        = @pa_exch_seg
								and   clim.clim_crn_no = clia.clia_crn_no
								--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                                 AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				                 and     excsm.excsm_exch_cd       = 'NSX'
				                 and     excsm.excsm_seg_cd        = 'FUTURES'
				                  AND    clia.clia_deleted_ind     = 1
				                  AND    excsm.excsm_deleted_ind   = 1
				                ) x
				                , @crn                              crn
				                , CLIENT_MSTR                       CLIM
				                --,CLIENT_ACCOUNTS                    CLIA
				            WHERE CLIM.CLIM_CRN_NO                = crn.CRN     --CLIA.CLIA_CRN_NO
				            AND   x.clia_crn_no                   = crn.crn     --CLIM_CRN_NO
				            --AND   x.clia_acct_no                  = crn.acct_no --CLIA.CLIA_ACCT_NO
				            AND   crn.to_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND   crn.to_dt                       = crn.fm_dt
				            --AND   x.access1                      <> 0
				            ORDER BY X.clia_acct_no,X.SEGMENT
				      --
				      END--mod
				    --
				    END--nsx

    --
    --
    --
    ELSE IF @pa_exch = 'BSE'
				    BEGIN--bse
				    --
				      SELECT @l_cash_desc = excsm_desc from exch_seg_mstr where excsm_exch_cd= 'BSE' and excsm_seg_cd = 'CASH'
				      SELECT @l_deri_desc = excsm_desc from exch_seg_mstr where excsm_exch_cd= 'BSE' and excsm_seg_cd = 'DERIVATIVES'

				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --

				        SELECT distinct 'N'--@pa_n_m
				               +'|'+--Webx Sub_bat usercode
				               +'|'+--CASE WHEN x.excsm_seg_cd = 'CASH' THEN 'Y' ELSE 'N' END
				               --+'|'+CASE WHEN x.excsm_seg_cd = 'DERIVATIVES' THEN 'Y' ELSE 'N' END
				               + CASE when (x.access1 <> 0 and x.access2 <> 0) THEN 'Y|Y' WHEN x.access1 <> 0 and x.access2 = 0 then 'Y|Y' ELSE 'N|Y' END
				               +'|'   --Reserved1
				               +'|'+ CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE '' END   --Reserved1
				               +'|'   --Reserved1
				               +'|'+convert(varchar(10),crn.acct_no)--right(crn.acct_no, len(crn.acct_no)-2)--convert(varchar(10),crn.acct_no)  --clientcode
				               +'|'+ case when crn.clim_clicm_cd in ('HNI','NRI') then 'CL' else citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn) end
				               +'|'+LTRIM(RTRIM(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn)))
				               +'|'+citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn)
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'MAPIN_ID',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch)
				               +                                                                         --'|'
				               --+'|'+REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','')
							   +'|'+case when crn.clim_clicm_cd in ('IND','NRI') then ''  else CASE WHEN ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch),'')='' THEN isnull(citrus_usr.fn_ucc_dob(crn.crn, 'NCDEX'),'') ELSE ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch),'') END end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)
				               ---+'|'
				               +'|'+case WHEN CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) ='01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) END
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+Case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103) end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|||'--isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')
				               +'|'+isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'')
				               +'|'--remarks
				               +'|'--Introducers Name
				               +'|'--Sub-Broker Name
				               +'|'--Introducers Name
				               +'|'+isnull(citrus_usr.fn_ucc_dob(crn.crn, @pa_exch),'')
				               +'|'+isnull(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch),'')--client Agreement date
				               +'|N'--client with other members
				               +'|'+ 'Y'  ucc_details
				               --+'|'  ucc_details
				         FROM
				            (SELECT distinct clia.clia_crn_no            clia_crn_no
				                  , clia.clia_acct_no           clia_acct_no
				                  , excsm.excsm_exch_cd         excsm_exch_cd
				                  --, excsm.excsm_seg_cd          excsm_seg_cd
				                  , excsm.excsm_compm_id        compm_id
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_cash_desc),0) access1
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_deri_desc),0) access2
                                  , ISNULL(SLB.SLB_CLIENT_CD,'') SLB_CODE
				             FROM   client_accounts             clia      WITH (NOLOCK)
                                    LEFT OUTER JOIN SLB_MSTR SLB WITH (NOLOCK) ON CLIA.CLIA_ACCT_NO=SLB.SLB_CLIENT_CD AND SLB_DELETED_IND=1
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
				             , client_mstr clim
							WHERE  excsm.excsm_exch_cd       = @pa_exch
							--AND    excsm.excsm_seg_cd        = @pa_exch_seg
							and   clim.clim_crn_no = clia.clia_crn_no
							--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                             AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				             --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				             AND    clia.clia_deleted_ind     = 1
				             AND    excsm.excsm_deleted_ind   = 1
				            ) x
				            , @crn                              crn
				        WHERE x.clia_crn_no                   = crn.crn
				        AND   x.clia_acct_no                  = crn.acct_no
				        AND   crn.fm_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                       = crn.fm_dt
				        AND   (x.access1 <> 0 or x.access2 <> 0)
                        AND Not Exists(Select bseur_ucc_code from Bse_ucc_response where bseur_ucc_code=x.clia_acct_no)
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				      --
				        SELECT distinct 'N'
				               +'|'+--Webx Sub_bat usercode
				               +'|'+--CASE WHEN x.excsm_seg_cd = 'CASH' THEN 'Y' ELSE 'N' END
				               --+'|'+CASE WHEN x.excsm_seg_cd = 'DERIVATIVES' THEN 'Y' ELSE 'N' END
				               + CASE when (x.access1 <> 0 and x.access2 <> 0) THEN 'Y|Y' WHEN x.access1 <> 0 and x.access2 = 0 then 'Y|Y' ELSE 'N|Y' END
				               +'|'
				               +'|'+CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE '' END   --Reserved1
				               +'|'
				               +'|'+ convert(varchar(10),crn.acct_no)  --clientcode right(crn.acct_no, len(crn.acct_no)-2)--
				               +'|'+case when crn.clim_clicm_cd in ('HNI','NRI') then 'CL' else citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn) end
				               +'|'+LTRIM(RTRIM(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn)))
				               +'|'+replace(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn), ',',' ')
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'MAPIN_ID',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch)
				               --+'|'+REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','')
							   +'|'+case when crn.clim_clicm_cd in ('IND','NRI') then '' else CASE WHEN ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch),'')='' THEN isnull(citrus_usr.fn_ucc_dob(crn.crn, 'NCDEX'),'') ELSE ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',@pa_exch),'') END end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+case WHEN CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) ='01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) END
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+Case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103) end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|'+citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch)
				               --+'|'
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|||'--isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')
				               +'|'+isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'')
				               +'|'--remarks
				               +'|'--Introducers Name
				               +'|'--Sub-Broker Name
				               +'|'--Introducers Name
				               +'|'+isnull(citrus_usr.fn_ucc_dob(crn.crn, @pa_exch),'')
				               +'|'+isnull(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch),'')--client Agreement date --client Agreement no
				               +'|N'+--client with other members
				               +'|'+ 'Y'  ucc_details
				               --+'|'  ucc_details
				        FROM
				           (SELECT distinct clia.clia_crn_no             clia_crn_no
				                  , clia.clia_acct_no           clia_acct_no
				                  , excsm.excsm_exch_cd         excsm_exch_cd
				                  , excsm.excsm_seg_cd          excsm_seg_cd
				                  , excsm.excsm_compm_id        compm_id
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_cash_desc),0) access1
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_deri_desc),0) access2
				                  , ISNULL(SLB.SLB_CLIENT_CD,'') SLB_CODE
				            FROM   client_accounts             clia      WITH (NOLOCK)
                    LEFT OUTER JOIN SLB_MSTR SLB WITH (NOLOCK) ON CLIA.CLIA_ACCT_NO=SLB.SLB_CLIENT_CD  AND SLB_DELETED_IND=1
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
				             , client_mstr clim
								WHERE  excsm.excsm_exch_cd       = @pa_exch
								--AND    excsm.excsm_seg_cd        = @pa_exch_seg
								and   clim.clim_crn_no = clia.clia_crn_no
								--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                               AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				             --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				             AND    clia.clia_deleted_ind     = 1
				             AND    excsm.excsm_deleted_ind   = 1
				           )  x
				           ,  @crn                              crn
				        WHERE x.clia_crn_no                  = crn.crn
				        AND   x.clia_acct_no                 = crn.acct_no
				        AND   crn.to_dt                        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                     <> crn.fm_dt
				        AND   (x.access1                     <> 0 or x.access2                     <> 0      )
                        AND   Exists(Select bseur_ucc_code from Bse_ucc_response where bseur_ucc_code=x.clia_acct_no)
				      --
				      END--mod
				    --
    END--bse
    --
    ELSE IF @pa_exch = 'MCX'
				    BEGIN--MCX
				    --
				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --
				        SELECT --CONVERT(varchar(10),clim.clim_crn_no)  --clientcode
				                 CONVERT(varchar(10),crn.acct_no)  --clientcode
				               +','+isnull(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn),'')--1st, Middle, Last Name
				               +','+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'') --Categery
				               +','+isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
				               +','+isnull(replace(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGR_NO',@pa_exch),'/',''),'')--client Agreement No
				               +','+isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,@pa_Exch),'/',''),'') --DOB
                               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'')
				               +','+ --isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
				               +','--UIN
				               +','+isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
				               +','+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --NSDL & CDSL
				            --+'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no) --nsdl
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
				               +','--Introducer Name
				               +','--Introducer Client Id
				               +','--Intriducer Relationship with Client
				               +','--Dealing With Other Member
                   +','+isnull(citrus_usr.fn_to_get_shortname_UCCMCX(crn.crn,clia_acct_no,'FM'),'')--Relationship Code
				               +','+'E'  ucc_details
				        FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
				            , client_mstr clim
							WHERE  excsm.excsm_exch_cd       = @pa_exch
							--AND    excsm.excsm_seg_cd        = @pa_exch_seg
							and   clim.clim_crn_no = clia.clia_crn_no
							--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                              AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg

				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           )  x
				            , @crn                             crn
				        WHERE x.clia_crn_no                  = crn.crn
				        AND   x.clia_acct_no                 = crn.acct_no
				        AND   crn.fm_dt                        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                      = crn.fm_dt
				        AND   x.access1                     <> 0
				        AND not Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_COMMODITIES where mcxur_Ucc_code=x.clia_acct_no)
				      --select * from exch_seg_mstr
				      END--new
				      ELSE
				      BEGIN--mod
				      --
				        SELECT --CONVERT(varchar(10),clim.clim_crn_no)  --clientcode
				                 CONVERT(varchar(10),crn.acct_no)  --clientcode
				               +','+isnull(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn),'')--1st, Middle, Last Name
				               +','+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'') --Categery
				               +','+isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
				               +','+isnull(replace(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGR_NO',@pa_exch),'/',''),'')--client Agreement No
				               +','+isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,@pa_Exch),'/',''),'') --DOB
                               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'')
				               +','+--isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
				               +','--UIN
				               +','+isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
				               +','+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --NSDL & CDSL
				            --+'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no) --nsdl
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106),'/','')
				               +','+isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
				               +','--Introducer Name
				               +','--Introducer Client Id
				               +','--Intriducer Relationship with Client
				               +','--Dealing With Other Member
                               +','+isnull(citrus_usr.fn_to_get_shortname_UCCMCX(crn.crn,clia_acct_no,'FM'),'')--Relationship Code
				               +','+'E'  ucc_details
				         FROM
				            (SELECT clia.clia_crn_no            clia_crn_no
				                  , clia.clia_acct_no           clia_acct_no
				                  , excsm.excsm_exch_cd         excsm_exch_cd
				                  , excsm.excsm_seg_cd          excsm_seg_cd
				                  , excsm.excsm_compm_id        compm_id
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				             FROM   client_accounts             clia      WITH (NOLOCK)
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
				              , client_mstr clim
								WHERE  excsm.excsm_exch_cd       = @pa_exch
								--AND    excsm.excsm_seg_cd        = @pa_exch_seg
								and   clim.clim_crn_no = clia.clia_crn_no
								--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				             AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg

				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				            ) x
				            , @crn                              crn
				        WHERE x.clia_crn_no                   = crn.crn
				        AND   x.clia_acct_no                  = crn.acct_no
				        AND   crn.to_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                      <> crn.fm_dt
				        AND   x.access1                      <> 0
				        AND Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_COMMODITIES where mcxur_Ucc_code=x.clia_acct_no)
				      --
				      END--mod
				    --
    END--MCX
    --
    --
    --ADDED FOR MCX CURRENCY ON 171208 BY VIVEK
    --
    --
    else if @pa_exch = 'MCD'
       begin
    if @pa_n_m = 'N'
    begin
    select convert (varchar(10),crn.acct_no)   --clientcode
    + ',' + isnull(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn),'') --1st, Middle, Last Name
    + ',' + isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'') --Categery
    + ',' + isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
    + ',' + isnull(replace(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch),'/',''),'')--client Agreement No
    + ',' + isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,@pa_Exch),'/',''),'') --DOB
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'')
    + ',' --+ isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
    + ','
    + ',' + isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
    + ',' + isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --NSDL & CDSL
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
    + ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
    + ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch),'')
    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
    + ',' --Introducer Name
    + ',' --Introducer Client Id
    + ',' --Intriducer Relationship with Client
    + ',' --Dealing With Other Member
    + ','+'E'  ucc_details
     FROM
   (SELECT clia.clia_crn_no            clia_crn_no
	 , clia.clia_acct_no           clia_acct_no
	 , excsm.excsm_exch_cd         excsm_exch_cd
	 , excsm.excsm_seg_cd          excsm_seg_cd
	 , excsm.excsm_compm_id        compm_id
	 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
    FROM   client_accounts             clia      WITH (NOLOCK)
	 , exch_seg_mstr               excsm     WITH (NOLOCK)
    , client_mstr clim
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                and   clim.clim_crn_no = clia.clia_crn_no
               -- AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
    --AND    excsm.excsm_seg_cd        = @pa_exch_seg
    AND    clia.clia_deleted_ind     = 1
    AND    excsm.excsm_deleted_ind   = 1
   )  x
    , @crn                             crn
		WHERE x.clia_crn_no                  = crn.crn
		AND   x.clia_acct_no                 = crn.acct_no
		AND   crn.fm_dt                        BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
		--AND   crn.to_dt                      = crn.fm_dt
		AND   x.access1                     <> 0
		AND Not Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_currency where mcxur_Ucc_code=x.clia_acct_no)
		--
		END--new
		ELSE
		BEGIN--mod
		select convert (varchar(10),crn.acct_no)   --clientcode
			+ ',' + isnull(citrus_usr.fn_ucc_client_name(@pa_exch,crn.crn),'') --1st, Middle, Last Name
			+ ',' + isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'') --Categery
			+ ',' + isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, crn.crn),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',@pa_exch),'/',''),'')--client Agreement No
			+ ',' + isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,@pa_Exch),'/',''),'') --DOB
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'')
			+ ',' --+ isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
			+ ','
			+ ',' + isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'') --name, addr, acct no, acct type
			+ ',' + isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --NSDL & CDSL
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
			+ ',' --Introducer Name
			+ ',' --Introducer Client Id
			+ ',' --Intriducer Relationship with Client
			+ ',' --Dealing With Other Member
			+ ','+'E'  ucc_details
			FROM
				(SELECT clia.clia_crn_no            clia_crn_no
				, clia.clia_acct_no           clia_acct_no
				, excsm.excsm_exch_cd         excsm_exch_cd
				, excsm.excsm_seg_cd          excsm_seg_cd
				, excsm.excsm_compm_id        compm_id
				, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				FROM   client_accounts             clia      WITH (NOLOCK)
				, exch_seg_mstr               excsm     WITH (NOLOCK)
				 , client_mstr clim
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                and   clim.clim_crn_no = clia.clia_crn_no
                --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
				AND    clia.clia_deleted_ind     = 1
			AND    excsm.excsm_deleted_ind   = 1
			) x
			, @crn                              crn
				WHERE x.clia_crn_no                   = crn.crn
				AND   x.clia_acct_no                  = crn.acct_no
				AND   crn.to_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				--AND   crn.to_dt                      <> crn.fm_dt
				AND   x.access1                      <> 0
				AND Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_currency where mcxur_Ucc_code=x.clia_acct_no)
		   --
		END--mod
		--
		END--MCD
     --
    --
            IF @pa_exch = 'NCDEX'
				    BEGIN--NCDEX
				    --

				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --

				        SELECT '20'                              --Record Type
				              +'|'+isnull(citrus_usr.fn_ucc_client_name(@pa_exch, crn.crn),'') --client 1st name
				              +'|'+CONVERT(varchar(10), crn.acct_no)  --client code
				              +'|'+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'')--category
				              +'|'+isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT','NCDEX'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY','NCDEX'),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_client_name(@pa_exch, crn.crn),'')--client 1st name
                              +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				              --+'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
                              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_dob(crn.crn,@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_dob(crn.crn,@pa_exch),103),106) end,' ','-'),'')
				              +'|'+--age
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'FTH_NAME',@pa_exch),'') --pan no      --fathername
				              +'|' --spouse_name
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_OFF', crn.crn),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_RES', crn.crn),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_OFF', crn.crn),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_RES', crn.crn),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'') --pan no
				              +'|'+ --ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'') --pan ward
				              +'|'+ 'N'--declaration as per fmc --case when citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch) <> '' then 'Y' else 'N' end
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')--bank name, address, acct no, acct type
				              +'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --nsdl
				              --+'|'+isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'') --cdsl
				              --+'|'+'N'
				              + '|' + 'I'
                              + '|'   --column 54  --+'|'+ CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE 'N' END
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_O', crn.crn),'') -- OFFICE STATE
                              + '|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_R', crn.crn),'') -- RES STATE
                              + '|'+isnull(citrus_usr.fn_ucc_client_ctgry('NCDEXCTGRYDESC',crn.crn),'')--category-- CLIENT SUB CTGRY
                              + '|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PARTNERS',@pa_exch),'')-- NOS OF PARTNER
                              + '|' -- DELETE FLAG
				              +'|'+'E'   ucc_details
				FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
				             , client_mstr clim
							WHERE  excsm.excsm_exch_cd       = @pa_exch
							--AND    excsm.excsm_seg_cd        = @pa_exch_seg
							and   clim.clim_crn_no = clia.clia_crn_no
							--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                              AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           )  x
				            , @crn                            crn
                            , client_mstr                     clim  --vivek
				        WHERE x.clia_crn_no                  = crn.crn
				        AND   x.clia_acct_no                 = crn.acct_no
                        and   clim.clim_crn_no               = crn.crn
				        AND   crn.fm_dt                       BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                      = crn.fm_dt
				        --AND   x.access1                     <> 0
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				      --

				        SELECT '20'                              --Record Type
				              +'|'+isnull(citrus_usr.fn_ucc_client_name(@pa_exch, crn.crn),'') --client 1st name
				              +'|'+CONVERT(varchar(10), crn.acct_no)  --client code
				              +'|'+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,crn.crn),'')--category
				              +'|'+isnull(citrus_usr.fn_ucc_entp(crn.crn,'REGR_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AT','NCDEX'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'REGR_NO','REGR_AUTHORITY','NCDEX'),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_client_name(@pa_exch, crn.crn),'')--client 1st name
                              +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				              --+'|'+ISNULL(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,@pa_exch),' ','-'),'') --dob
                              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_dob(crn.crn,@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_dob(crn.crn,@pa_exch),103),106) end,' ','-'),'')
				              +'|'+--age
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'FTH_NAME',@pa_exch),'') --pan no      --fathername
				              +'|' --spouse_name
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_OFF', crn.crn),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_RES', crn.crn),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_OFF', crn.crn),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_RES', crn.crn),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch),'') --pan no
				              +'|'+ --ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',@pa_exch),'') --pan ward
				              +'|'+ 'N'--declaration as per fmc --case when citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',@pa_exch) <> '' then 'Y' else 'N' end
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')--bank name, address, acct no, acct type
				              +'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,crn.crn,crn.acct_no),'') --nsdl
				              --+'|'+isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'') --cdsl
				              --+'|'+'N'
				              + '|' + 'I'
                              + '|'   --column 54  --+'|'+ CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE 'N' END
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_O', crn.crn),'') -- OFFICE STATE
                              + '|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_R', crn.crn),'') -- RES STATE
                              + '|'+isnull(citrus_usr.fn_ucc_client_ctgry('NCDEXCTGRYDESC',crn.crn),'') -- CLIENT SUB CTGRY
                              + '|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PARTNERS',@pa_exch),'') --NOS OF PARTNER
                              + '|' -- DELETE FLAG
				              +'|'+'E'   ucc_details
				         FROM
				            (SELECT clia.clia_crn_no            clia_crn_no
				                  , clia.clia_acct_no           clia_acct_no
				                  , excsm.excsm_exch_cd         excsm_exch_cd
				                  , excsm.excsm_seg_cd          excsm_seg_cd
				                  , excsm.excsm_compm_id        compm_id
				                  , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				             FROM   client_accounts             clia      WITH (NOLOCK)
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
				              , client_mstr clim
							WHERE  excsm.excsm_exch_cd       = @pa_exch
							--AND    excsm.excsm_seg_cd        = @pa_exch_seg
							and   clim.clim_crn_no = clia.clia_crn_no
							--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                             AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				            ) x
				            , @crn                              crn
                            , client_mstr                       clim
				        WHERE x.clia_crn_no                   = crn.crn
				        AND   x.clia_acct_no                  = crn.acct_no
				        AND   crn.to_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   crn.to_dt                      <> crn.fm_dt
				        AND   x.access1                      <> 0
                        and   clim.clim_crn_no               = crn.crn
				      --
				      END--mod
				    --
    END--NCDEX
    --
    IF RTRIM(LTRIM(LEFT(@pa_exch,3)))   = 'SLB'
		  BEGIN -- SLB
			 IF RTRIM(LTRIM(RIGHT(@pa_exch,3))) = 'NSE'
			 BEGIN--SLB
			 --
		      IF @pa_n_m = 'N'
				  BEGIN -- NEW

						SELECT 'S'                              --Record Type
						+'|'+isnull(CONVERT(varchar(10), crn.acct_no),'')  --client code
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'MAPIN_ID',RIGHT(@pa_exch,3)),'')--MapIn Id
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',RIGHT(@pa_exch,3)),'') --pan no
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',RIGHT(@pa_exch,3)),'') --pan ward
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',RIGHT(@pa_exch,3)) ,'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ -- REG NOS OF CLIENT
						+'|'+ -- REG AUTHORITY
						+'|'+ -- PLACE OF REG
						+'|'+ -- DATE OF REG
						+'|'+ isnull(citrus_usr.fn_ucc_client_name(RTRIM(LTRIM(LEFT(@pa_exch,3))), crn.crn),'')-- CLIENT NAME
						+'|'+ Isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),crn.crn),'') -- CTGRY
						+'|'+ Isnull(Replace(citrus_usr.fn_ucc_addr_pin_conc('SLB',crn.crn),',',' '),'') ---ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(RIGHT(@pa_exch,3)))+'_COR', crn.crn),'')  -- CLIENT ADDRESS
						+'|'+ case when Isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,RIGHT(@pa_exch,3)),' ','-'),'')='' then Isnull(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',RIGHT(@pa_exch,3)),'') else Isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,RIGHT(@pa_exch,3)),' ','-'),'') end
						+'|'+ Isnull(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',RIGHT(@pa_exch,3)),'') -- CLIENT AGREEMENT DATE
						+'|'+ Isnull(CITRUS_USR.FN_FIND_RELATIONS(crn.crn,'INT'),'')-- INTRODUCER NAME
						+'|'+ -- INTRODUCER RELATION
						+'|'+ -- INTRODUCER CLIENT ID
						+'|'+ Isnull(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')--bank name, address, acct no, acct type
						--+'|'+ Case when isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP ID
						--+'|'+ Case when isnull(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP NAME
						--+'|'+ --BENEFICIAL CATEGORY
                        +'|'+Isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'')
						+'|'+ --ANT OTHER A/C
						+'|'+ --SETTL MODE
						+'|'+'N'
						+'|'+isnull(CONVERT(varchar(10), crn.acct_no),'')
						+'|'+'E'
						ucc_details

						FROM
						(SELECT clia.clia_crn_no            clia_crn_no
						, clia.clia_acct_no           clia_acct_no
						, excsm.excsm_exch_cd         excsm_exch_cd
						, excsm.excsm_seg_cd          excsm_seg_cd
						, excsm.excsm_compm_id        compm_id
						, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
						FROM   client_accounts             clia      WITH (NOLOCK)
						, exch_seg_mstr               excsm     WITH (NOLOCK)
						 , client_mstr clim
						WHERE  excsm.excsm_exch_cd       = @pa_exch
						--AND    excsm.excsm_seg_cd        = @pa_exch_seg
						and   clim.clim_crn_no = clia.clia_crn_no
						--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                        AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
						--AND    excsm.excsm_seg_cd        = @pa_exch_seg
						AND    clia.clia_deleted_ind     = 1
						AND    excsm.excsm_deleted_ind   = 1
						)  x
						, @crn                             crn
						WHERE x.clia_crn_no                  = crn.crn
						AND   x.clia_acct_no                 = crn.acct_no
						AND   crn.fm_dt                       BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
						--AND   crn.to_dt                      = crn.fm_dt
						AND   x.access1                     <> 0
				  END   -- NEW
		      ELSE
				  BEGIN -- MODIFIED

						SELECT 'S'                              --Record Type
						+'|'+Isnull(CONVERT(varchar(10), crn.acct_no),'')  --client code
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'MAPIN_ID',RIGHT(@pa_exch,3)),'')--MapIn Id
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PAN_GIR_NO',RIGHT(@pa_exch,3)),'') --pan no
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PAN_GIR_NO','WARD_NO',RIGHT(@pa_exch,3)),'') --pan ward
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'PASSPORT_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'PASSPORT_NO','PASSPORT_ISSUED_ON',RIGHT(@pa_exch,3)) ,'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'LICENCE_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'LICENCE_NO','LICENCE_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'VOTERSID_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'VOTERSID_NO','VOTERSID_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',RIGHT(@pa_exch,3)),'')
						+'|'+ISNULL(citrus_usr.fn_ucc_entpd(crn.crn,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',RIGHT(@pa_exch,3)),'')
						+'|'+ -- REG NOS OF CLIENT
						+'|'+ -- REG AUTHORITY
						+'|'+ -- PLACE OF REG
						+'|'+ -- DATE OF REG
						+'|'+ isnull(citrus_usr.fn_ucc_client_name(RTRIM(LTRIM(LEFT(@pa_exch,3))), crn.crn),'')-- CLIENT NAME -- CLIENT NAME
						+'|'+ isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),crn.crn),'') -- CTGRY
						+'|'+ ISNULL(Replace(citrus_usr.fn_ucc_addr_pin_conc('SLB',crn.crn),',',' '),'') ---ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(RIGHT(@pa_exch,3)))+'_COR', crn.crn),'')  -- CLIENT ADDRESS
						+'|'+ CASE WHEN Isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,RIGHT(@pa_exch,3)),' ','-'),'')='' THEN Isnull(citrus_usr.fn_ucc_entp(crn.crn,'INC_DOB',RIGHT(@pa_exch,3)),'') ELSE Isnull(REPLACE(citrus_usr.fn_ucc_dob(crn.crn,RIGHT(@pa_exch,3)),' ','-'),'') END
						+'|'+ ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'CLIENT_AGREMENT_ON',RIGHT(@pa_exch,3)),'') -- CLIENT AGREEMENT DATE
						+'|'+ ISNULL(CITRUS_USR.FN_FIND_RELATIONS(crn.crn,'INT'),'')-- INTRODUCER NAME
						+'|'+ -- INTRODUCER RELATION
						+'|'+ -- INTRODUCER CLIENT ID
						+'|'+ ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,crn.crn,crn.acct_no),'')--bank name, address, acct no, acct type
--						+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP ID
--						+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(crn.crn,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP NAME
--						+'|'+ --BENEFICIAL CATEGORY
                        +'|'+ Isnull(citrus_usr.fn_ucc_dp(@pa_exch,crn.crn,crn.acct_no),'')
						+'|'+ --ANT OTHER A/C
						+'|'+ -- SETTL MODE
						+'|'+'N'
						+'|'+ISNULL(CONVERT(varchar(10), crn.acct_no),'')
						+'|'+'E'
						ucc_details

						FROM
						(SELECT clia.clia_crn_no            clia_crn_no
						, clia.clia_acct_no           clia_acct_no
						, excsm.excsm_exch_cd         excsm_exch_cd
						, excsm.excsm_seg_cd          excsm_seg_cd
						, excsm.excsm_compm_id        compm_id
						, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
						FROM   client_accounts             clia      WITH (NOLOCK)
						, exch_seg_mstr               excsm     WITH (NOLOCK)
						 , client_mstr clim
						WHERE  excsm.excsm_exch_cd       = @pa_exch
						--AND    excsm.excsm_seg_cd        = @pa_exch_seg
						and   clim.clim_crn_no = clia.clia_crn_no
						--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                        AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
						--AND    excsm.excsm_seg_cd        = @pa_exch_seg
						AND    clia.clia_deleted_ind     = 1
						AND    excsm.excsm_deleted_ind   = 1
						) x
						, @crn                              crn
						WHERE x.clia_crn_no                   = crn.crn
						AND   x.clia_acct_no                  = crn.acct_no
						AND   crn.to_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
						--AND   crn.to_dt                      <> crn.fm_dt
						AND   x.access1                      <> 0
				  END   -- MODIFIED
       END         --SLB
  END


  END--n_n
  ELSE       --FOR SELECTED CLIENTS
  BEGIN--n
  --
    IF  @pa_exch = 'NSE'
    BEGIN--nse
    --
      IF @pa_n_m ='N'
      BEGIN--new
      --
        SELECT x.segment
               --+'|'+CONVERT(VARCHAR(10), CONVERT(NUMERIC, clim.clim_crn_no)) --client_code
               +'|'+CONVERT(VARCHAR(10), x.clia_acct_no) --client_code
               +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
               +'|'+ltrim(rtrim(CONVERT(VARCHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),clim.clim_crn_no),''))))
               +'|'+ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)))) --pan no
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))))--CONVERT(VARCHAR(25), citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch)) --pan ward
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1))))--adr1
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2))))--adr2
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3))))--adr3
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4))))--adr_city
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5))))--adr_state
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6))))--adr_country
               +'|'+ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7))))--adr_zip
               +'|'
               +'|'
               +'|'+case when clim_clicm_cd  in ('IND','NRI','SOL')
                    then CASE WHEN convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')))) END
                    ELSE CASE WHEN  convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')))) END
                    END
               +'|'+ltrim(rtrim(convert(VARCHAR(10),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))       ))
               +'|'+CASE WHEN case when clim.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END = '01-Jan-1900' THEN '' ELSE case when clim.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END END
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch))
               +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch))
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch))
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+--convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),1))
               +'|'+--convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),2))
               +'|'+--convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
                      --                   WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
               +'|'+--convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),4))
               +'|'+--convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),1))
               +'|'+--convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),2))
               +'|'+--convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),3))
				+'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch))
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				+'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				+'|'+CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON',@pa_exch))
                 +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch))
                +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_PAN',@pa_exch))
				+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-1) else '' end
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE'),'')
				+'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL'),'')
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
                +'|'
				+'|'
				+'|'
				+'|'
				+'|'
				+'|'
               +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
               +'|'+'E'   ucc_details
        FROM
             (SELECT clia.clia_crn_no            clia_crn_no
                   , clia.clia_acct_no           clia_acct_no
                   , excsm.excsm_exch_cd       excsm_exch_cd
               , excsm.excsm_seg_cd          excsm_seg_cd
                   , excsm.excsm_compm_id        compm_id
                   , CASE WHEN excsm.excsm_seg_cd  = 'CASH' THEN 'C' WHEN excsm.excsm_seg_cd  = 'DERIVATIVES' THEN  'F' ELSE '' END segment
                   --, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
              FROM   client_accounts             clia      WITH (NOLOCK)
                   , exch_seg_mstr               excsm     WITH (NOLOCK)
                   , client_mstr clim
,ucctony_271109 temp
              WHERE    excsm.excsm_exch_cd       = @pa_exch
              and   clim.clim_crn_no = clia.clia_crn_no
              and   clia.clia_acct_no = temp.f1
              --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND    clia.clia_deleted_ind     = 1
              AND    excsm.excsm_deleted_ind   = 1
             ) x
             , client_mstr                       clim
             , client_accounts                   clia
        WHERE x.clia_crn_no                    = clim.clim_crn_no
        AND   clim.clim_crn_no                 = clia.clia_crn_no
        AND   x.clia_acct_no                   = clia.clia_acct_no
        --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        --AND   clim.clim_lst_upd_dt             = clim.clim_created_dt
        AND   clim.clim_deleted_ind            = 1
        --AND   x.access1                       <> 0
        AND   Not exists(Select nseur_ucc_code from Nse_ucc_response where nseur_ucc_code=x.clia_acct_no)
        ORDER BY X.clia_acct_no,X.SEGMENT
      --
      END--new
      ELSE
      BEGIN--mod
      --
        SELECT  x.segment--segment
               --+'|'+CONVERT(VARCHAR(10), CONVERT(NUMERIC, clim.clim_crn_no)) --client_code
               +'|'+CONVERT(VARCHAR(10),  x.clia_acct_no) --client_code
               +'|'+ltrim(rtrim(CONVERT(VARCHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')))) --client name
               +'|'+ltrim(rtrim(CONVERT(VARCHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),clim.clim_crn_no),''))))
               +'|'+ltrim(rtrim(CONVERT(VARCHAR(10), citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)))) --pan no
               +'|'+ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),''))))--CONVERT(VARCHAR(25), citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch)) --pan ward
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1))))--adr1
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2))))--adr2
               +'|'+ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3))))--adr3
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4))))--adr_city
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5))))--adr_state
               +'|'+ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6))))--adr_country
               +'|'+ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7))))--adr_zip
               +'|'
               +'|'
               +'|'+case when clim_clicm_cd  in ('IND','NRI','SOL')
                    then CASE WHEN convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')))) END
                    ELSE CASE WHEN  convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')) <> ''
                         THEN ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),''))))
                         ELSE ltrim(rtrim(convert(VARCHAR(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')))) END
                    END
               +'|'+ltrim(rtrim(convert(VARCHAR(10),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),''))       ))
               +'|'+CASE WHEN case when clim.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END = '01-Jan-1900' THEN '' ELSE case when clim.clim_clicm_cd  in ('IND','NRI','SOL')
                    then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                    ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
                         THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
                         ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
                         END
                    END END
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch))
               +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch))
               +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch))
               +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') END
               +'|'--+convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),1))
               +'|'--+convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),2))
               +'|'--+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
                     --                    WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
               +'|'--+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),4))
               +'|'--+convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),1))
               +'|'--+convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),2))
               +'|'--+convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),3))
			   +'|'+CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch))
				 +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)) ELSE '' END
				 +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				 +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				 +'|'+CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON',@pa_exch))
     +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch))
     +'|'+CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_PAN',@pa_exch))
				 +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-1) else '' end
				 +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE'),'')
				 +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL'),'')
				 +'|'
     +'|'
				 +'|'
				 +'|'
				 +'|'
				+'|'
    +'|'
				+'|'
				+'|'
				+'|'
				+'|'
				+'|'
               +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
               +'|'+'E'   ucc_details
        FROM
             (SELECT clia.clia_crn_no            clia_crn_no
                   , clia.clia_acct_no           clia_acct_no
                   , excsm.excsm_exch_cd         excsm_exch_cd
                   , excsm.excsm_seg_cd          excsm_seg_cd
                   , excsm.excsm_compm_id        compm_id
                   , CASE WHEN excsm.excsm_seg_cd  = 'CASH' THEN 'C' WHEN excsm.excsm_seg_cd  = 'DERIVATIVES' THEN  'F' ELSE '' END segment
                  -- , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
              FROM   client_accounts             clia      WITH (NOLOCK)
                   , exch_seg_mstr               excsm     WITH (NOLOCK)
                   , client_mstr                 clim      WITH (NOLOCK)
,ucctony_271109 temp
              WHERE    excsm.excsm_exch_cd       = @pa_exch
              and   clim.clim_crn_no = clia.clia_crn_no
              and   clia.clia_acct_no =  temp.f1
              --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
              AND    clia.clia_deleted_ind     = 1
              AND    excsm.excsm_deleted_ind   = 1
             ) x
             , client_mstr      clim
             , client_accounts                   clia
        WHERE x.clia_crn_no                    = clim.clim_crn_no
        AND   clim.clim_crn_no                 = clia.clia_crn_no
        AND   x.clia_acct_no                   = clia.clia_acct_no
        --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
		      AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
        --AND   clim.clim_lst_upd_dt            <> clim.clim_created_dt
        AND   clim.clim_deleted_ind            = 1
        --AND   x.access1                       <> 0
        AND   Exists(Select nseur_ucc_code from Nse_ucc_response where nseur_ucc_code=x.clia_acct_no)
        ORDER BY X.clia_acct_no,X.SEGMENT
      --
      END--mod
    --
    END--nse
    --
    --
    --
    ELSE IF @pa_exch = 'NSX'
				    BEGIN--bse
				    --
				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --
				       select x.segment
				                   +'|'+LTRIM(RTRIM(CONVERT(CHAR(10), x.clia_acct_no))) --client_code
				                   +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)))),'') --pan no
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1)))),'')--adr1
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2)))),'')--adr2
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3)))),'')--adr3
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4)))),'')  --adr_city
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5)))),'')--adr_state
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6)))),'') --adr_country
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7)))),'')--adr_zip
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'ISD_CODE'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'STD_CODE'),'')))),'')
				                   +'|'+case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then CASE WHEN convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')))) END
				                        ELSE CASE WHEN  convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')))) END
				                        END
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')))),'')
				                   +'|'+CASE WHEN case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END = '01-Jan-1900' THEN '' ELSE case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END END

				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch)),'')
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE isnull(REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-'),'') END
                                   +'|'+isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
                                   --+'|'+isnull(citrus_usr.fn_ucc_dp('SLBNSE',clim.clim_crn_no,clia.clia_acct_no),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),1)))),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),2)))),'')
				                   --+'|'+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
				                                             --WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
				                   --+'|'+isnull(convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),4)),'')
				                   --,convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),1))
				                   --,convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),2))
				                   --,convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),3))
				    		   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)),'')
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				    		   +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_PAN',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON1','CONTACT_DESIGNATION1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON1','CONTACT_PAN1',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE1'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL1'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON2','CONTACT_DESIGNATION2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON2','CONTACT_PAN2',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE2'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL2'),'')

				                   +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
				                   +'|'+'E'
				ucc_details

				            FROM
				                (SELECT clia.clia_crn_no            clia_crn_no
				                      , clia.clia_acct_no           clia_acct_no
				                      , excsm.excsm_exch_cd         excsm_exch_cd
				                      , excsm.excsm_seg_cd          excsm_seg_cd
				                      , excsm.excsm_compm_id        compm_id
				                      , CASE WHEN excsm.excsm_seg_cd  = 'FUTURES' THEN 'X'  ELSE '' END segment
				                      , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				                 FROM   client_accounts             clia      WITH (NOLOCK)
				                      , exch_seg_mstr               excsm     WITH (NOLOCK)
                                      , client_mstr                 clim
				                 WHERE excsm.excsm_exch_cd       = @pa_exch
                                 and   clim.clim_crn_no = clia.clia_crn_no
                                 --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                                 AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             	                 --and     excsm.excsm_exch_cd       = 'NSX'
				                 and     excsm.excsm_seg_cd        = 'FUTURES'
				                  AND    clia.clia_deleted_ind     = 1
				                  AND    excsm.excsm_deleted_ind   = 1
				                ) x
				                --, @crn                              crn
				                , CLIENT_MSTR                       CLIM
				                ,CLIENT_ACCOUNTS                    CLIA
				            WHERE CLIM.CLIM_CRN_NO                     = CLIA.CLIA_CRN_NO--CRN
				            AND   x.clia_crn_no                   = CLIM_CRN_NO --crn.crn
				            AND   x.clia_acct_no                  = CLIA.CLIA_ACCT_NO --crn.acct_no
				            --AND   clim.clim_created_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                              AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND   crn.to_dt                       = crn.fm_dt
				            AND   x.access1                      <> 0
				            ORDER BY X.clia_acct_no,X.SEGMENT
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				      --
				        select x.segment
				                   +'|'+LTRIM(RTRIM(CONVERT(CHAR(10), x.clia_acct_no))) --client_code
				                   +'|'+ltrim(rtrim(CONVERT(CHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')) ))
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(2), isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(CONVERT(CHAR(10), citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)))),'') --pan no
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'EMAIL1'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),1)))),'')--adr1
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),2)))),'')--adr2
				                   +'|'+isnull(ltrim(rtrim(convert(char(255),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),3)))),'')--adr3
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),4)))),'')  --adr_city
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),5)))),'')--adr_state
				                   +'|'+isnull(ltrim(rtrim(convert(char(50),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),6)))),'') --adr_country
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'COR_ADR1'),''),7)))),'')--adr_zip
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'ISD_CODE'),'')))),'')
				                   +'|'+isnull(ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'STD_CODE'),'')))),'')
				                   +'|'+case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then CASE WHEN convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')))) END
				                        ELSE CASE WHEN  convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),'')) <> ''
				                             THEN ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'OFF_PH1'),''))))
				                             ELSE ltrim(rtrim(convert(char(60),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'RES_PH1'),'')))) END
				                        END
				                   +'|'+isnull(ltrim(rtrim(convert(char(10),ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'MOBILE1'),'')))),'')
				                   +'|'+CASE WHEN case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END = '01-Jan-1900' THEN '' ELSE case when CLIM.clim_clicm_cd  in ('IND','NRI','SOL')
				                        then REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                        ELSE CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) <> ''
				                             THEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch)) ,103),106),' ','-')
				                             ELSE  REPLACE(CONVERT(VARCHAR(11),CLIM_DOB,106),' ','-')
				                             END
				                        END END
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') ='01-Jan-1900' THEN '' ELSE REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch)) ,103),106),' ','-') END
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch)),'')
				                   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch)),'')
				                   +'|'+CASE WHEN REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-') = '01-Jan-1900' THEN '' ELSE isnull(REPLACE(CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch)) ,103),106),' ','-'),'') END
                                   +'|'+isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
                                   --+'|'+isnull(citrus_usr.fn_ucc_dp('SLBNSE',clim.clim_crn_no,clia.clia_acct_no),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(60),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),1)))),'')
				                   --+'|'+isnull(ltrim(rtrim(convert(VARCHAR(250),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),2)))),'')
				                   --+'|'+convert(VARCHAR(2),CASE WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) IN ('SAVINGS','SAVING') THEN '10'
				                   --                          WHEN citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),3) = 'CURRENT' THEN '11' ELSE	'99' END )
				                   --+'|'+isnull(convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'BANK',@PA_EXCH),''),4)),'')
				                   --,convert(VARCHAR(25),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),1))
				                   --,convert(VARCHAR(4),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),2))
				                   --,convert(VARCHAR(16),citrus_usr.fn_splitval(ISNULL(citrus_usr.GET_DEFAULT_BANKDP(clim.clim_crn_no,'DP',@PA_EXCH),''),3))
				    		   +'|'+isnull(CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)),'')
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)) ELSE '' END
				    		   +'|'+CASE WHEN CONVERT(VARCHAR(25),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PROOF_TYPE',@pa_exch)) = 1 AND CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PROOF_TYPE','PROOF_PASSPORT',@pa_exch))  = 1 THEN CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch)) ELSE '' END
				    		   +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_DESIGNATION',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON','CONTACT_PAN',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON1','CONTACT_DESIGNATION1',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON1','CONTACT_PAN1',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR1'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE1'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL1'),'')
				               +'|'+isnull(CONVERT(VARCHAR(100),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CONTACT_PERSON2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON2','CONTACT_DESIGNATION2',@pa_exch)),'')
				               +'|'+isnull(CONVERT(VARCHAR(60),citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'CONTACT_PERSON2','CONTACT_PAN2',@pa_exch)),'')
				    		   --+'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''),'|*~|',', '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''))-2) else '' end
                               +'|'+case when ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),'') <> '' then substring(REPLACE(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''),'|*~|',' '),1,len(ISNULL(citrus_usr.fn_addr_value(clim.clim_crn_no,'CONTACT_ADDR2'),''))-1) else '' end
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_PHONE2'),'')
				    		   +'|'+ISNULL(citrus_usr.fn_dp_import_conc(clim.clim_crn_no,'CONTACT_EMAIL2'),'')

				                   +'|'+ CASE WHEN CONVERT(CHAR(1),citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INP_VERIFICATION',@pa_exch)) <> '' THEN 'Y' ELSE 'N' END
				                   +'|'+'E'
				ucc_details

				            FROM
				                (SELECT clia.clia_crn_no            clia_crn_no
				                      , clia.clia_acct_no           clia_acct_no
				                      , excsm.excsm_exch_cd         excsm_exch_cd
				                      , excsm.excsm_seg_cd          excsm_seg_cd
				                      , excsm.excsm_compm_id        compm_id
				                      , CASE WHEN excsm.excsm_seg_cd  = 'FUTURES' THEN 'X'  ELSE '' END segment
				                      , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				                 FROM   client_accounts             clia      WITH (NOLOCK)
				                      , exch_seg_mstr               excsm     WITH (NOLOCK)
				                  , client_mstr clim
								WHERE  excsm.excsm_exch_cd       = @pa_exch
								--AND    excsm.excsm_seg_cd        = @pa_exch_seg
								and   clim.clim_crn_no = clia.clia_crn_no
								--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                                 AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				                 and     excsm.excsm_exch_cd       = 'NSX'
				                 and     excsm.excsm_seg_cd        = 'FUTURES'
				                  AND    clia.clia_deleted_ind     = 1
				                  AND    excsm.excsm_deleted_ind   = 1
				                ) x
				                --, @crn                              crn
				                , CLIENT_MSTR                       CLIM
				                ,CLIENT_ACCOUNTS                    CLIA
				            WHERE CLIM.CLIM_CRN_NO                     = CLIA.CLIA_CRN_NO--CRN
				            AND   x.clia_crn_no                   = CLIM_CRN_NO --crn.crn
				            AND   x.clia_acct_no                  = CLIA.CLIA_ACCT_NO --crn.acct_no
				            AND   clim.clim_lst_upd_dt                         BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            --AND   crn.to_dt                       = crn.fm_dt
				            AND   x.access1                      <> 0
				            ORDER BY X.clia_acct_no,X.SEGMENT
				      --
				      END--mod
				    --
    END--nsx
    --
    --
    --
    ELSE IF @pa_exch = 'BSE'
				    BEGIN--bse
				    --
				      SELECT @l_cash_desc = excsm_desc from exch_seg_mstr where excsm_exch_cd= 'BSE' and excsm_seg_cd = 'CASH'
				      SELECT @l_deri_desc = excsm_desc from  exch_seg_mstr where excsm_exch_cd= 'BSE' and excsm_seg_cd = 'DERIVATIVES'

				      IF @pa_n_m ='N'
				      BEGIN--new
				      --
				        SELECT distinct 'N'
				               +'|'+--Webx Sub_bat usercode
				               +'|'+--CASE WHEN x.excsm_seg_cd = 'CASH' THEN 'Y' ELSE 'N' END
				               --+'|'+CASE WHEN x.excsm_seg_cd = 'DERIVATIVES' THEN 'Y' ELSE 'N' END
				               + CASE when (x.access1 <> 0 and x.access2 <> 0) THEN 'Y|Y' WHEN x.access1 <> 0 and x.access2 = 0 then 'Y|Y' ELSE 'N|Y' END
				               +'|'+
				               +'|'+ CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE '' END
				               +'|'+
				               --+'|'+convert(varchar(10),clim.clim_crn_no)  --clientcode
				               +'|'+convert(varchar(10),x.clia_acct_no)  --clientcode
				               +'|'+ case when clim.clim_clicm_cd in ('HNI','NRI') then  'CL'  else citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no) END
				               +'|'+LTRIM(RTRIM(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no) ))
				               +'|'+citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),103),' ','')
				               +'|'+ case when clim.clim_clicm_cd in ('IND','NRI') then  ''  else CASE WHEN ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch),'')='' THEN isnull(citrus_usr.fn_ucc_dob(clim.clim_crn_no, 'NCDEX'),'') ELSE ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch),'') END end
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)
				               +'|'+case WHEN CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) ='01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) END
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),' ','')
				               --+'|'+convert(varchar(11),case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) end,103)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch)
				               +'|'+Case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103) end
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103),' ','')
				               --+'|'+convert(varchar(11),case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103) end,103)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch)
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103) end
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+convert(varchar(11),case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) end,103)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|'--Commenting here for jmm +citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no, clia.clia_acct_no)
				               +'|'+
				               +'|'+
				               +'|'+
				               +'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no, clia.clia_acct_no)
				               +'|'--remarks
				               +'|'--Introducers Name
				               +'|'--Sub-Broker Name
				               +'|' +isnull(citrus_usr.fn_ucc_dob(clim.clim_crn_no, @pa_exch),'')
				               +'|' --+ citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch) --DOB
				               +'|' + 'N'--client Agreement no
				               +'|' + 'Y'--client with other members


				               ucc_details


				         FROM
				             (SELECT distinct clia.clia_crn_no            clia_crn_no
				                   , clia.clia_acct_no           clia_acct_no
				                   , excsm.excsm_exch_cd         excsm_exch_cd
				                   , excsm.excsm_seg_cd          excsm_seg_cd
				                   , excsm.excsm_compm_id        compm_id
				                   , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_cash_desc),0) access1
				                   , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_deri_desc),0) access2
                   , SLB.SLB_CLIENT_CD SLB_CODE
				             FROM   client_accounts             clia      WITH (NOLOCK)
                    LEFT OUTER JOIN SLB_MSTR SLB ON CLIA.CLIA_ACCT_NO=SLB.SLB_CLIENT_CD AND SLB_DELETED_IND=1
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
                                  , client_mstr clim
				             WHERE  excsm.excsm_exch_cd       = @pa_exch
                             and   clim.clim_crn_no = clia.clia_crn_no
                             --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                             AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             	             --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				             AND    clia.clia_deleted_ind     = 1
				             AND    excsm.excsm_deleted_ind   = 1
				             ) x
				             , client_mstr                       clim
				             , client_accounts                   clia
				         WHERE x.clia_crn_no                   = clim.clim_crn_no
				         AND   clim.clim_crn_no                = clia.clia_crn_no
				         AND   x.clia_acct_no                  = clia.clia_acct_no
				         --AND   clim.clim_created_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                         AND   clim.clim_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				         --AND   clim.clim_lst_upd_dt            = clim.clim_created_dt
				         AND   clim.clim_deleted_ind           = 1
				         AND   (x.access1                      <> 0      or x.access2                      <> 0      )
				         AND   Not exists(Select bseur_ucc_code from Bse_ucc_response where bseur_ucc_code=x.clia_acct_no)
				       --
				       END--new
				       ELSE
				       BEGIN--mod
				       --
				         SELECT distinct 'M'
				               +'|'+--Webx Sub_bat usercode
				               +'|'+--CASE WHEN x.excsm_seg_cd = 'CASH' THEN 'Y' ELSE 'N' END
				               --+'|'+CASE WHEN x.excsm_seg_cd = 'DERIVATIVES' THEN 'Y' ELSE 'N' END
				               + CASE when (x.access1 <> 0 and x.access2 <> 0) THEN 'Y|Y' WHEN x.access1 <> 0 and x.access2 = 0 then 'Y|Y' ELSE 'N|Y' END
				               +'|'
				               +'|'+ CASE WHEN X.SLB_CODE <> '' THEN 'Y' ELSE '' END
				               +'|'
				               --+'|'+convert(varchar(10),clim.clim_crn_no)  --clientcode
				               +'|'+convert(varchar(10),x.clia_acct_no)  --clientcode
				               +'|'+case when clim.clim_clicm_cd in ('HNI','NRI') then  'CL'  else citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no) end
				               +'|'+LTRIM(RTRIM(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no) ))
				               +'|'+citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),103),' ','-')
				               --+'|'+ case when citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no)='I' then  REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','')   else citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch) end
				               +'|'+ case when clim.clim_clicm_cd  in ('IND','NRI') then  ''  else CASE WHEN ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch),'')='' THEN isnull(citrus_usr.fn_ucc_dob(clim.clim_crn_no, 'NCDEX'),'') ELSE ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',@pa_exch),'') END end
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+case WHEN CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) ='01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103) ,103) END
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+Case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),103) end
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|'+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch)+'|'+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch)
				               --+'|'+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),' ','')
				               +'|'+case when convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103)='01/01/1900' then '' else convert(varchar(11),CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103) ,103) end
				               +'|'--Commenting here for jmm +citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no, clia.clia_acct_no)
				               +'|'+
				               +'|'+
				               +'|'+
				               +'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no,clia.clia_acct_no)
				               +'|'--remarks
				               +'|'--Introducers Name
				               +'|'--Sub-Broker Name
				               +'|' +isnull(citrus_usr.fn_ucc_dob(clim.clim_crn_no, @pa_exch),'')
				               +'|'--+ citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch)--DOB
				               +'|'+ 'N'--client Agreement no
				               +'|'+ 'Y'--client with other members

				               ucc_details
				         FROM
				             (SELECT distinct clia.clia_crn_no            clia_crn_no
				                   , clia.clia_acct_no           clia_acct_no
				                   , excsm.excsm_exch_cd         excsm_exch_cd
				                   , excsm.excsm_seg_cd          excsm_seg_cd
				                   , excsm.excsm_compm_id        compm_id
				                   , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_cash_desc),0) access1
				                   , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,@l_deri_desc),0) access2
				   , SLB.SLB_CLIENT_CD SLB_CODE
				             FROM   client_accounts             clia      WITH (NOLOCK)
                    LEFT OUTER JOIN SLB_MSTR SLB ON CLIA.CLIA_ACCT_NO=SLB.SLB_CLIENT_CD AND SLB_DELETED_IND=1
				                  , exch_seg_mstr               excsm     WITH (NOLOCK)
                                  , client_mstr clim
				             WHERE  excsm.excsm_exch_cd       = @pa_exch
                             and   clim.clim_crn_no = clia.clia_crn_no
                             --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                             AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

				             --AND    excsm.excsm_seg_cd        = @pa_exch_seg
				             AND    clia.clia_deleted_ind     = 1
				             AND    excsm.excsm_deleted_ind   = 1
				             ) x
				             , client_mstr                       clim
				             , client_accounts                   clia
				         WHERE x.clia_crn_no                   = clim.clim_crn_no
				         AND   clim.clim_crn_no                = clia.clia_crn_no
				         AND   x.clia_acct_no                  = clia.clia_acct_no
				         AND   clim.clim_lst_upd_dt              BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				         --AND   clim.clim_lst_upd_dt           <> clim.clim_created_dt
				         AND   clim.clim_deleted_ind           = 1
				         AND   (x.access1                      <> 0      or x.access2                      <> 0      )
				         AND   Exists(Select bseur_ucc_code from Bse_ucc_response where bseur_ucc_code=x.clia_acct_no)
				       --
				       END--mod
				    --
    END--bse
    --
    ELSE IF @pa_exch = 'MCX'
				    BEGIN--MCX
				    --
				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --
				        /*SELECT CONVERT(varchar(10), clim.clim_crn_no)--client_code
				              +','+citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no)
				              +','+citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no)
				              +','+citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no)
				              +','--client Agreement No
				              +','+REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch),'/','')
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch)
				              +','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch)
				              +','--UIN
				              +','+citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no)
				              +','+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no)  --cdsl
				              +','+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no)  --nsdl
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch)+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn


				_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),'/','')+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),103),'/','')
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENSE_NO',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_ISSUED_AT',@pa_exch)+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no


				,'LICENSE_NO','LICENSE_ISSUED_ON',@pa_exch),103),103),'/','')+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_EXPIRED_ON',@pa_exch),103),103),'/','')
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch)+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn


				_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),'/','')
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch)+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn


				_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),'/','')
				              +','+citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch)+','+citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch)+','+REPLACE(CONVERT


				(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106),'/','')
				              +',' --Introducer Name
				              +','--Introducer Client Id
				              +','--Intriducer Relationship with Client
				              +','--Dealing With
				              +','--Other Member
				              +','+'E'   ucc_details
				      */
				        SELECT --CONVERT(varchar(10),clim.clim_crn_no)  --clientcode
				                 CONVERT(varchar(10),x.clia_acct_no)  --clientcode
				               +','+isnull(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no),'')--1st, Middle, Last Name
				               +','+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'') --Categery
				               +','+isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
				               --+','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGR_NO',@pa_exch),'')--client Agreement No
                               +','+isnull(replace(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGR_NO',@pa_exch),'/',''),'')--client Agreement No
				               +','+isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_Exch),'/',''),'') --DOB
                               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'')
				               +','+--isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
				               +','--UIN
				               +','+isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
				               +','+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --NSDL & CDSL
				            --+'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no) --nsdl
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),103),'/','')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_EXPIRED_ON',@pa_exch),103),103),'/','')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
				               +','--Introducer Name
				               +','--Introducer Client Id
				               +','--Intriducer Relationship with Client
				               +','--Dealing With Other Member
                               +','+isnull(citrus_usr.fn_to_get_shortname_UCCMCX(clim.clim_crn_no,clia.clia_acct_no,'FM'),'')--Relationship Code
				               +','+'E'  ucc_details
				        FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
                                 , client_mstr clim
				            WHERE excsm.excsm_exch_cd       = @pa_exch
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg
                            and   clim.clim_crn_no = clia.clia_crn_no
                             --    AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             	                     AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           )   x
				             , client_mstr                     clim
				             , client_accounts                 clia
				         WHERE x.clia_crn_no                 = clim.clim_crn_no
				         AND   clim.clim_crn_no              = clia.clia_crn_no
				         AND   x.clia_acct_no                = clia.clia_acct_no
				         --AND   clim.clim_created_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                         AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				         --AND   clim.clim_lst_upd_dt          = clim.clim_created_dt
				         AND   clim.clim_deleted_ind  = 1
				         AND   x.access1                    <> 0
				         AND not Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_COMMODITIES where mcxur_Ucc_code=x.clia_acct_no)
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				      --
				        SELECT --CONVERT(varchar(10),clim.clim_crn_no)  --clientcode
				                 CONVERT(varchar(10),x.clia_acct_no)  --clientcode
				               +','+isnull(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no),'')--1st, Middle, Last Name
				               +','+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'') --Categery
				               +','+isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
				               --+','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGR_NO',@pa_exch),'')--client Agreement No
                               +','+isnull(replace(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGR_NO',@pa_exch),'/',''),'')--client Agreement No
				               +','+isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_Exch),'/',''),'') --DOB
                               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'')
				               +','+--isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
				               +','--UIN
				               +','+isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
				               +','+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --NSDL & CDSL
				            --+'|'+citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no) --nsdl
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),103),'/','')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENSE_NO','LICENSE_EXPIRED_ON',@pa_exch),103),103),'/','')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),103),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
				               +','+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
				               +','+isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch),'')
				               --+','+REPLACE(CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106),'/','')
				               --+','+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
                               +','+isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
				               +','--Introducer Name
				               +','--Introducer Client Id
				               +','--Intriducer Relationship with Client
				               +','--Dealing With Other Member
                               +','+isnull(citrus_usr.fn_to_get_shortname_UCCMCX(clim.clim_crn_no,clia.clia_acct_no,'FM'),'')--Relationship Code
				               +','+'E'  ucc_details
				        FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
                                 , client_mstr clim
				            WHERE excsm.excsm_exch_cd       = @pa_exch
				            --AND    excsm.excsm_seg_cd        = @pa_exch_seg
							         and   clim.clim_crn_no = clia.clia_crn_no
							--AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             	            AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           )   x
				             , client_mstr                     clim
				             , client_accounts                 clia
				         WHERE x.clia_crn_no                 = clim.clim_crn_no
				         AND   clim.clim_crn_no              = clia.clia_crn_no
				         AND   x.clia_acct_no                = clia.clia_acct_no
				         AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				         --AND   clim.clim_lst_upd_dt          = clim.clim_created_dt
				         AND   clim.clim_deleted_ind  = 1
				         AND   x.access1                    <> 0
				         AND Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_COMMODITIES where mcxur_Ucc_code=x.clia_acct_no)
				      --
				      END--mod
				    --SELECT * FROM EXCH_SEG_MSTR
    END--MCX
    --
    --
    else if @pa_exch = 'MCD'
              begin
       if @pa_n_m = 'N'
         begin
			select convert (varchar(10),x.clia_acct_no)   --clientcode
			+ ',' + isnull(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no),'') --1st, Middle, Last Name
			+ ',' + isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'') --Categery
			+ ',' + isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch),'/',''),'')--client Agreement No
			+ ',' + isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_Exch),'/',''),'') --DOB
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'')
			+ ',' --+ isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
			+ ','
			+ ',' + isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
			+ ',' + isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --NSDL & CDSL
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
			+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch),'')
			+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
			+ ',' --Introducer Name
			+ ',' --Introducer Client Id
			+ ',' --Intriducer Relationship with Client
			+ ',' --Dealing With Other Member
			+ ','+'E'  ucc_details
			  FROM
				   (SELECT clia.clia_crn_no            clia_crn_no
						 , clia.clia_acct_no           clia_acct_no
						 , excsm.excsm_exch_cd         excsm_exch_cd
						 , excsm.excsm_seg_cd          excsm_seg_cd
						 , excsm.excsm_compm_id        compm_id
						 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
					FROM   client_accounts             clia      WITH (NOLOCK)
						 , exch_seg_mstr               excsm     WITH (NOLOCK)
                         , client_mstr                 clim
					WHERE excsm.excsm_exch_cd       = @pa_exch
					--AND    excsm.excsm_seg_cd        = @pa_exch_seg
	                and   clim.clim_crn_no = clia.clia_crn_no
                   -- AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                    AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

					AND    clia.clia_deleted_ind     = 1
					AND    excsm.excsm_deleted_ind   = 1
				   )   x
		             , client_mstr                     clim
		             , client_accounts                 clia
		         WHERE x.clia_crn_no                 = clim.clim_crn_no
		         AND   clim.clim_crn_no              = clia.clia_crn_no
		         AND   x.clia_acct_no                = clia.clia_acct_no
		         --AND   clim.clim_created_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                  AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
		         --AND   clim.clim_lst_upd_dt          = clim.clim_created_dt
		         AND   clim.clim_deleted_ind  = 1
		         AND   x.access1                    <> 0
		         AND Not Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_currency where mcxur_Ucc_code=x.clia_acct_no)
		      --
		      END--new
		ELSE
		  BEGIN--mod
		  select convert (varchar(10),x.clia_acct_no)   --clientcode
				+ ',' + isnull(citrus_usr.fn_ucc_client_name(@pa_exch,clim.clim_crn_no),'') --1st, Middle, Last Name
				+ ',' + isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'') --Categery
				+ ',' + isnull(citrus_usr.fn_ucc_addr_pin_conc(@pa_exch, clim.clim_crn_no),'')--adr1,adr2,adr3,city,state,country,pincode,telephone
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',@pa_exch),'/',''),'')--client Agreement No
				+ ',' + isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_Exch),'/',''),'') --DOB
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'')
				+ ',' --+ isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'')
				+ ','
				+ ',' + isnull(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --name, addr, acct no, acct type
				+ ',' + isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,clia.clia_acct_no),'') --NSDL & CDSL
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),'/',''),'')
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),'/',''),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
			    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),'/',''),'')
			    + ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_EXPIRES_ON',@pa_exch),'/',''),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),'/',''),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),'/',''),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY',@pa_exch),'')
				+ ',' + isnull(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT',@pa_exch),'')
				+ ',' + isnull(replace(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),'/',''),'')
				+ ',' --Introducer Name
				+ ',' --Introducer Client Id
				+ ',' --Intriducer Relationship with Client
				+ ',' --Dealing With Other Member
				+ ','+'E'  ucc_details
			      FROM
				   (SELECT clia.clia_crn_no            clia_crn_no
						 , clia.clia_acct_no           clia_acct_no
						 , excsm.excsm_exch_cd         excsm_exch_cd
						 , excsm.excsm_seg_cd          excsm_seg_cd
						 , excsm.excsm_compm_id        compm_id
						 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
					FROM   client_accounts             clia      WITH (NOLOCK)
						 , exch_seg_mstr               excsm     WITH (NOLOCK)
                         , client_mstr                 clim
					WHERE excsm.excsm_exch_cd       = @pa_exch
					--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                    and   clim.clim_crn_no = clia.clia_crn_no
                    --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                    AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
             	    AND    clia.clia_deleted_ind     = 1
					AND    excsm.excsm_deleted_ind   = 1
				   )   x
		             , client_mstr                     clim
		             , client_accounts                 clia
				   WHERE x.clia_crn_no                 = clim.clim_crn_no
					 AND   clim.clim_crn_no              = clia.clia_crn_no
					 AND   x.clia_acct_no                = clia.clia_acct_no
					 AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
					 --AND   clim.clim_lst_upd_dt          = clim.clim_created_dt
					 AND   clim.clim_deleted_ind  = 1
					 AND   x.access1                    <> 0
					 AND Exists(Select mcxur_Ucc_code from mcx_Ucc_Response_currency where mcxur_Ucc_code=x.clia_acct_no)
				  --
				      END--mod
			         --
                     END--MCX
                   --
                --
    ELSE IF @pa_exch = 'NCDEX'
				    BEGIN--NCDEX
				    --
				      IF @pa_n_m = 'N'
				      BEGIN--new
				      --

				        SELECT '20'                              --Record Type
				              +'|'+isnull(citrus_usr.fn_ucc_client_name(@pa_exch, clim.clim_crn_no),'') --client 1st name
				              +'|'+CONVERT(varchar(10), x.clia_acct_no)  --client code
				              +'|'+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'')--category
				              +'|'+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT','NCDEX'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY','NCDEX'),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_client_name(@pa_exch, clim.clim_crn_no),'')--client 1st name
                              +'|'+ltrim(rtrim(CONVERT(VARCHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')))) --client name
				              --+'|'+ISNULL(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch),' ','-'),'') --dob
                              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch),103),106) end,' ','-'),'')
				              +'|'+--age
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'FTH_NAME',@pa_exch),'') --pan no      --fathername
				              +'|' --spouse_name
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_OFF', clim.clim_crn_no),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_RES', clim.clim_crn_no),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_OFF', clim.clim_crn_no),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_RES', clim.clim_crn_no),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'') --pan no
				              +'|'+--ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'') --pan ward
				              +'|'+ 'N'--declaration as per fmc --case when citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch) <> '' then 'Y' else 'N' end
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')--bank name, address, acct no, acct type
				              +'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'') --nsdl
				              --+'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'') --cdsl
				              --+'|'+'N'
				              + '|' + 'I'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|' + ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_O', clim.clim_crn_no),'') -- OFFICE STATE
                              + '|' + ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_R', clim.clim_crn_no),'') -- RES STATE
                              + '|' +isnull(citrus_usr.fn_ucc_client_ctgry('NCDEXCTGRYDESC',clim.clim_crn_no),'')-- CLIENT SUB CTGRY
                              + '|' +ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PARTNERS',@pa_exch),'')--NOS OF PARTNER
                              + '|' -- DELETE FLAG
				              +'|'+'E'   ucc_details
				        FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
                                 , client_mstr clim
				            WHERE  excsm.excsm_exch_cd       = @pa_exch
				           and   clim.clim_crn_no = clia.clia_crn_no
                                -- AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
						    AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           )   x
				             , client_mstr                     clim
				             , client_accounts                 clia
				         WHERE x.clia_crn_no                 = clim.clim_crn_no
				         AND   clim.clim_crn_no              = clia.clia_crn_no
				         AND   x.clia_acct_no                = clia.clia_acct_no
				         --AND   clim.clim_created_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                         AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				         --AND   clim.clim_lst_upd_dt          = clim.clim_created_dt
				         AND   clim.clim_deleted_ind         = 1
				         AND   x.access1                    <> 0
				      --
				      END--new
				      ELSE
				      BEGIN--mod
				       --
				        SELECT '20'                              --Record Type
				              +'|'+isnull(citrus_usr.fn_ucc_client_name(@pa_exch, clim.clim_crn_no),'') --client 1st name
				              +'|'+CONVERT(varchar(10), x.clia_acct_no)  --client code
				              +'|'+isnull(citrus_usr.fn_ucc_client_ctgry(@pa_exch,clim.clim_crn_no),'')--category
				              +'|'+isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'REGR_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AT','NCDEX'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'REGR_NO','REGR_AUTHORITY','NCDEX'),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_client_name(@pa_exch, clim.clim_crn_no),'')--client 1st name
                              +'|'+ltrim(rtrim(CONVERT(VARCHAR(150), isnull(clim_name3,'')+ case when isnull(clim_name3,'') = '' then '' else ' ' end + isnull(clim_name1,'') + ' ' + isnull(clim_name2,'')))) --client name
				              --+'|'+ISNULL(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch),' ','-'),'') --dob
                              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_dob(clim.clim_crn_no,@pa_exch),103),106) end,' ','-'),'')
				              +'|'+--age
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'FTH_NAME',@pa_exch),'') --pan no      --fathername
				              +'|' --spouse_name
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_OFF', clim.clim_crn_no),'')
				              --+'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(@pa_exch))+'_RES', clim.clim_crn_no),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_OFF', clim.clim_crn_no),'')
                              +'|'+ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_RES', clim.clim_crn_no),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch),'') --pan no
				              +'|'+--ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',@pa_exch),'') --pan ward
				              +'|'+ 'N'--declaration as per fmc --+case when citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',@pa_exch) <> '' then 'Y' else 'N' end
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_EXPIRES_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',@pa_exch),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',@pa_exch),'')
				              +'|'+isnull(REPLACE(case when citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch) = '' then convert(varchar,'') else CONVERT(Varchar,CONVERT(DateTime,citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',@pa_exch),103),106) end,' ','-'),'')
				              +'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')--bank name, address, acct no, acct type
				              +'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'') --nsdl
				              --+'|'+isnull(citrus_usr.fn_ucc_dp_mcx_ncdex(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'') --cdsl
				              --+'|'+'N'
				              + '|' + 'I'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|'
                              + '|' + ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_O', clim.clim_crn_no),'') -- OFFICE STATE
                              + '|' + ISNULL(citrus_usr.fn_ucc_addr_pin_conc('NCDEX_R', clim.clim_crn_no),'') -- RES STATE
                              + '|' +isnull(citrus_usr.fn_ucc_client_ctgry('NCDEXCTGRYDESC',clim.clim_crn_no),'')-- CLIENT SUB CTGRY
                              + '|' +ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PARTNERS',@pa_exch),'')--NOS OF PARTNER
                              + '|' -- DELETE FLAG
				              +'|'+'E'   ucc_details
				        FROM
				           (SELECT clia.clia_crn_no            clia_crn_no
				                 , clia.clia_acct_no           clia_acct_no
				                 , excsm.excsm_exch_cd         excsm_exch_cd
				                 , excsm.excsm_seg_cd          excsm_seg_cd
				                 , excsm.excsm_compm_id        compm_id
				                 , ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				            FROM   client_accounts             clia      WITH (NOLOCK)
				                 , exch_seg_mstr               excsm     WITH (NOLOCK)
                                 , client_mstr clim
				            WHERE  excsm.excsm_exch_cd       = @pa_exch
				            and   clim.clim_crn_no = clia.clia_crn_no
                                -- AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                            AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

				            AND    clia.clia_deleted_ind     = 1
				            AND    excsm.excsm_deleted_ind   = 1
				           ) x
				            , client_mstr                      clim
				            , client_accounts                  clia
				        WHERE x.clia_crn_no                  = clim.clim_crn_no
				        AND   clim.clim_crn_no               = clia.clia_crn_no
				        AND   x.clia_acct_no                 = clia.clia_acct_no
				        AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				        --AND   clim.clim_lst_upd_dt          <> clim.clim_created_dt
				        AND   clim.clim_deleted_ind          = 1
				        AND   x.access1                     <> 0
				      --
				      END--mod
				    --
    END    --NCDEX
    --
  -------------SLB START

		    ELSE IF RTRIM(LTRIM(LEFT(@pa_exch,3))) = 'SLB'
		    BEGIN--SLB
		    --
			IF RTRIM(LTRIM(RIGHT(@pa_exch,3))) = 'NSE'
			BEGIN--SLB
			--
		      IF @pa_n_m = 'N'
		      BEGIN--new
		      --

				SELECT 'S'                              --Record Type
				+'|'+ISNULL(CONVERT(varchar(10), x.clia_acct_no),'')  --client code
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',RIGHT(@pa_exch,3)),'')--MapIn Id
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',RIGHT(@pa_exch,3)),'') --pan no
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',RIGHT(@pa_exch,3)),'') --pan ward
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',RIGHT(@pa_exch,3)) ,'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ -- REG NOS OF CLIENT
				+'|'+ -- REG AUTHORITY
				+'|'+ -- PLACE OF REG
				+'|'+ -- DATE OF REG
				+'|'+ISNULL(citrus_usr.fn_ucc_client_name(RTRIM(LTRIM(LEFT(@pa_exch,3))), clim.clim_crn_no),'')--client 1st name
				+'|'+isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),clim.clim_crn_no),'') --+'|'+ -- CTGRY
				+'|'+ ISNULL(Replace(citrus_usr.fn_ucc_addr_pin_conc('SLB',clim.clim_crn_no),',',' '),'') --ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(RIGHT(@pa_exch,3)))+'_COR', clim.clim_crn_no),'') --CLIENT ADDRESS

				+'|'+CASE WHEN Isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,RIGHT(@pa_exch,3)),' ','-'),'')='' THEN Isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',RIGHT(@pa_exch,3)),'') ELSE Isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,RIGHT(@pa_exch,3)),' ','-'),'') END
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',RIGHT(@pa_exch,3)),'') -- CLIENT AGREEMENT DATE
				+'|'+ ISNULL(CITRUS_USR.FN_FIND_RELATIONS(clim.clim_crn_no,'INT'),'')-- INTRODUCER NAME
				+'|'+ -- INTRODUCER RELATION
				+'|'+ -- INTRODUCER CLIENT ID
				+'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')--bank name, address, acct no, acct type
--				+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP ID
--				+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP NAME
--				+'|'+ --BENEFICIAL CATEGORY
                +'|'+Isnull(citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')
				+'|'+ --ANT OTHER A/C
				+'|'+ -- SETTL MODE
				+'|'+'N'
				+'|'+ISNULL(CONVERT(varchar(10), x.clia_acct_no),'')
				+'|'+'E'
				ucc_details

				FROM
				(SELECT clia.clia_crn_no            clia_crn_no
				, clia.clia_acct_no           clia_acct_no
				, excsm.excsm_exch_cd         excsm_exch_cd
				, excsm.excsm_seg_cd          excsm_seg_cd
				, excsm.excsm_compm_id        compm_id
				, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				FROM   client_accounts             clia      WITH (NOLOCK)
				, exch_seg_mstr               excsm     WITH (NOLOCK)
                , client_mstr clim
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				and   clim.clim_crn_no = clia.clia_crn_no
                --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

				AND    clia.clia_deleted_ind     = 1
				AND    excsm.excsm_deleted_ind   = 1
				)   x
				, client_mstr                     clim
				, client_accounts                 clia
				WHERE x.clia_crn_no                 = clim.clim_crn_no
				AND   clim.clim_crn_no              = clia.clia_crn_no
				AND   x.clia_acct_no                = clia.clia_acct_no
				--AND   clim.clim_created_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                 AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				--AND   clim.clim_lst_upd_dt        = clim.clim_created_dt
				AND   clim.clim_deleted_ind         = 1
				AND   x.access1                    <> 0
		      --
		      END--new
		      ELSE
		      BEGIN--mod
		      --

				SELECT 'S'                              --Record Type
				+'|'+ISNULL(CONVERT(varchar(10), x.clia_acct_no),'')  --client code
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'MAPIN_ID',RIGHT(@pa_exch,3)),'')--MapIn Id
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PAN_GIR_NO',RIGHT(@pa_exch,3)),'') --pan no
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PAN_GIR_NO','WARD_NO',RIGHT(@pa_exch,3)),'') --pan ward
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'PASSPORT_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'PASSPORT_NO','PASSPORT_ISSUED_ON',RIGHT(@pa_exch,3)) ,'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'LICENCE_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'LICENCE_NO','LICENCE_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'VOTERSID_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'VOTERSID_NO','VOTERSID_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_AT',RIGHT(@pa_exch,3)),'')
				+'|'+ISNULL(citrus_usr.fn_ucc_entpd(clim.clim_crn_no,'RAT_CARD_NO','RAT_CARD_ISSUED_ON',RIGHT(@pa_exch,3)),'')
				+'|'+ -- REG NOS OF CLIENT
				+'|'+ -- REG AUTHORITY
				+'|'+ -- PLACE OF REG
				+'|'+ -- DATE OF REG
				+'|'+ISNULL(citrus_usr.fn_ucc_client_name(RTRIM(LTRIM(LEFT(@pa_exch,3))), clim.clim_crn_no),'')--client 1st name
				+'|'+ isnull(citrus_usr.fn_ucc_client_ctgry(RIGHT(@pa_exch,3),clim.clim_crn_no),'') -- CTGRY
				+'|'+ ISNULL(Replace(citrus_usr.fn_ucc_addr_pin_conc('SLB',clim.clim_crn_no),',',' '),'') --ISNULL(citrus_usr.fn_ucc_addr_pin_conc(ltrim(rtrim(RIGHT(@pa_exch,3)))+'_COR', clim.clim_crn_no),'') --CLIENT ADDRESS

				+'|'+CASE WHEN Isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,RIGHT(@pa_exch,3)),' ','-'),'')='' THEN Isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'INC_DOB',RIGHT(@pa_exch,3)),'') ELSE Isnull(REPLACE(citrus_usr.fn_ucc_dob(clim.clim_crn_no,RIGHT(@pa_exch,3)),' ','-'),'') END
				+'|'+ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'CLIENT_AGREMENT_ON',RIGHT(@pa_exch,3)),'') -- CLIENT AGREEMENT DATE
				+'|'+ ISNULL(CITRUS_USR.FN_FIND_RELATIONS(clim.clim_crn_no,'INT'),'')-- INTRODUCER NAME
				+'|'+ -- INTRODUCER RELATION
				+'|'+ -- INTRODUCER CLIENT ID
				+'|'+ISNULL(citrus_usr.fn_ucc_bank(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')--bank name, address, acct no, acct type
--				+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP ID
--				+'|'+ Case when ISNULL(citrus_usr.fn_ucc_entp(clim.clim_crn_no,'RAT_CARD_NO',RIGHT(@pa_exch,3)),'')='' then '' else '' end --DP NAME
--				+'|'+ --BENEFICIAL CATEGORY
                +'|'+Isnull(citrus_usr.fn_ucc_dp(@pa_exch,clim.clim_crn_no,x.clia_acct_no),'')
				+'|'+ --ANT OTHER A/C
				+'|'+ -- SETTL MODE
				+'|'+'N'
				+'|'+ISNULL(CONVERT(varchar(10), x.clia_acct_no),'')
				+'|'+'E'
				ucc_details

				FROM
				(SELECT clia.clia_crn_no            clia_crn_no
				, clia.clia_acct_no           clia_acct_no
				, excsm.excsm_exch_cd         excsm_exch_cd
				, excsm.excsm_seg_cd          excsm_seg_cd
				, excsm.excsm_compm_id        compm_id
				, ISNULL(citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc),0) access1
				FROM   client_accounts             clia      WITH (NOLOCK)
				, exch_seg_mstr               excsm     WITH (NOLOCK)
                , client_mstr clim
				WHERE  excsm.excsm_exch_cd       = @pa_exch
				--AND    excsm.excsm_seg_cd        = @pa_exch_seg
                and   clim.clim_crn_no = clia.clia_crn_no
                --AND   clim.clim_created_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
                AND   clim.clim_lst_upd_dt               BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'

				AND    clia.clia_deleted_ind     = 1
				AND    excsm.excsm_deleted_ind   = 1
				) x
				, client_mstr                      clim
				, client_accounts                  clia
				WHERE x.clia_crn_no                  = clim.clim_crn_no
				AND   clim.clim_crn_no               = clia.clia_crn_no
				AND   x.clia_acct_no                 = clia.clia_acct_no
				AND   clim.clim_lst_upd_dt             BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
				--AND   clim.clim_lst_upd_dt          <> clim.clim_created_dt
				AND   clim.clim_deleted_ind          = 1
				AND   x.access1                     <> 0
		      --
		      END--mod
		    --
		    END--SLB
       END -- SLB NSE COND END
-------------SLB END


  END--n
--
END
--exec pr_uccfilegenration 45, 'CASH',''

GO
