-- Object: PROCEDURE citrus_usr.PR_SELECT_CLIM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SELECT_CLIM](@PA_CRN_NO     NUMERIC  
                              ,@PA_ACCT_NO    VARCHAR(20)  
                              ,@PA_TAB        VARCHAR(20)  
                              ,@ROWDELIMITER  VARCHAR(20)  ='*|~*'  
                              ,@COLDELIMITER  VARCHAR(20)  = '|*~|'  
                              ,@PA_REF_CUR    VARCHAR(8000) OUTPUT  
                               )  
AS  
  /*******************************************************************************  
   SYSTEM         : CLASS  
   MODULE NAME    : PR_SELECT_CLIM  
   DESCRIPTION    : SCRIPT TO SELECT FROM THE CLIENT RELATED TABLES  
   COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
   VERSION HISTORY:  
   VERS.  AUTHOR          DATE         REASON  
   -----  -------------   ----------   ------------------------------------------------  
   1.0    HARI.R   09-NOV-2006  INITIAL VERSION.  
  **********************************************************************************/  
  --  
BEGIN  
--  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  --  
  IF @PA_TAB = 'CLIM'  
  BEGIN  
  --  
     SELECT CLIM.CLIM_NAME1                    CLIM_NAME1  
          , ISNULL(CLIM.CLIM_NAME2, '')        CLIM_NAME2  
          , ISNULL(CLIM.CLIM_NAME3, '')        CLIM_NAME3  
          , CLIM.CLIM_SHORT_NAME               CLIM_SHORT_NAME  
          , CLIM.CLIM_GENDER                   CLIM_GENDER  
          , CONVERT(VARCHAR,CLIM.CLIM_DOB,103) CLIM_DOB  
          , ENTTM.ENTTM_CD                     ENTTM_CD  
          , ENTTM.ENTTM_DESC                   ENTTM_DESC  
          , CLIM.CLIM_STAM_CD                  CLIM_STAM_CD  
          , CLICM.CLICM_CD                     CLICM_CD  
          , CLICM.CLICM_DESC                   CLICM_DESC   
     FROM   CLIENT_MSTR  CLIM        WITH (NOLOCK)  
          , ENTITY_TYPE_MSTR  ENTTM  WITH (NOLOCK)  
          , CLIENT_CTGRY_MSTR CLICM  
     WHERE  CLIM.CLIM_ENTTM_CD      = ENTTM_CD  
     AND    CLIM.CLIM_CLICM_CD      = CLICM.CLICM_CD  
     AND    CLIM.CLIM_CRN_NO        = @PA_CRN_NO  
     AND    CLIM.CLIM_DELETED_IND   = 1  
     AND    ENTTM.ENTTM_DELETED_IND = 1  
     AND    CLICM.CLICM_DELETED_IND =1  
     --cLIENT cAT dESC  
  --  
  END  
  
  IF @PA_TAB = 'ENTR'  
  BEGIN  
  --  
    SELECT TOP 7 ID_NUM = IDENTITY(INT, 1, 1)  
    INTO #ROWNUM  
    FROM SYSOBJECTS  
    --  
    SELECT ISNULL(A.ENTR_ID, 0)                   ENTR_ID  
         , ISNULL(ENTTM.ENTTM_CD, ' ')            ENTR_CD  
         , ISNULL(ENTTM.ENTTM_DESC, ' ')          ENTTM_DESC  
         , ISNULL(ENTM.ENTM_SHORT_NAME, ' ')      ENTM_SHORT_NAME  
         , ISNULL(ENTM.ENTM_PARENT_ID, 0)         PARENT_ID  
         , ISNULL(ENTTM.ENTTM_PARENT_CD, ' ')     ENTTM_PARENT_CD  
    FROM   ENTITY_TYPE_MSTR  ENTTM   WITH (NOLOCK)  
         ,(SELECT  (CASE WHEN R =  1 THEN ENTR.ENTR_HO  
                    ELSE CASE WHEN R=2 THEN ENTR.ENTR_RG  
                    ELSE CASE WHEN R=3 THEN ENTR.ENTR_AR  
                    ELSE CASE WHEN R=4 THEN ENTR.ENTR_BR  
                    ELSE CASE WHEN R=5 THEN ENTR.ENTR_SUB  
                    ELSE CASE WHEN R=6 THEN ENTR.ENTR_DL  
                    ELSE CASE WHEN R=7 THEN ENTR.ENTR_RM  
                    ELSE ENTR.ENTR_RM END END END END END END END )     ENTR_ID  
                   ,( CASE WHEN R =  1 THEN 'HO'  
                      ELSE CASE WHEN R=2 THEN 'RE'  
                      ELSE CASE WHEN R=3 THEN 'AR'  
                      ELSE CASE WHEN R=4 THEN 'BR'  
                      ELSE CASE WHEN R=5 THEN 'SB'  
                      ELSE CASE WHEN R=6 THEN 'DL'  
                      ELSE CASE WHEN R=7 THEN 'RM'  
                      END END END END END END END)  ENTR_CD,  
                         ENTR.ENTR_CRN_NO            CLIENT_ID  
             FROM  ENTITY_RELATIONSHIP   ENTR  WITH (NOLOCK)  
                   ,(SELECT ID_NUM R  FROM #ROWNUM WHERE ID_NUM <= 7) #AA  
                     WHERE  ENTR.ENTR_CRN_NO = @PA_CRN_NO) A  
                     RIGHT OUTER JOIN  
                     ENTITY_MSTR ENTM WITH (NOLOCK)  
             ON ENTM.ENTM_ID=A.ENTR_ID  
             WHERE   A.ENTR_CD                  = ENTTM.ENTTM_CD  
             AND    1 & ENTTM.ENTTM_CLI_YN        > 0  
             ORDER BY CASE WHEN ENTTM.ENTTM_CD = 'HO' THEN 1  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'RE' THEN  2  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'AR' THEN  3  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'BR' THEN  4  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'SB' THEN  5  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'DL' THEN  6  
             ELSE CASE WHEN  ENTTM.ENTTM_CD = 'RM' THEN  7  
             END END END END END END END  
      --  
    END  
  
    IF @PA_TAB = 'ADDR'  
    BEGIN  
      --  
      SELECT CONCM.CONCM_CD                   CONCM_CD  
           , CONCM.CONCM_DESC                 CONCM_DESC  
           , ISNULL(A.ADR_1, ' ')             ADR_1  
           , ISNULL(A.VALUE, ' ')             VALUE  
      FROM  (SELECT ENTAC.ENTAC_CONCM_ID      CONCM_ID  
                  , ADR.ADR_1                 ADR_1  
                  , ENTAC.ENTAC_CONCM_CD+@COLDELIMITER+ADR.ADR_1+@COLDELIMITER+ADR.ADR_2+@COLDELIMITER+ADR.ADR_3+@COLDELIMITER+ADR.ADR_CITY+@COLDELIMITER+ADR.ADR_STATE+@COLDELIMITER+ADR.ADR_COUNTRY+@COLDELIMITER+ADR.ADR_ZIP VALUE  
             FROM   ADDRESSES                 ADR    WITH (NOLOCK)  
                  , ENTITY_ADR_CONC           ENTAC  WITH (NOLOCK)  
             WHERE  ENTAC.ENTAC_ADR_CONC_ID = ADR.ADR_ID  
             AND    ENTAC.ENTAC_ENT_ID      = @PA_CRN_NO  
             AND    ADR.ADR_DELETED_IND     = 1  
             AND    ENTAC.ENTAC_DELETED_IND = 1  
            ) A  
             RIGHT OUTER JOIN  
             CONC_CODE_MSTR                   CONCM  WITH (NOLOCK)  
             ON CONCM.CONCM_ID=A.CONCM_ID  
      WHERE    CONCM.CONCM_DELETED_IND      = 1  
      AND    1 & CONCM.CONCM_CLI_YN         = 1  
      AND    2 & CONCM.CONCM_CLI_YN         = 0  
      ORDER  BY CONCM.CONCM_DESC  
      --  
    END  
    IF @PA_TAB = 'CONC'  
    BEGIN  
      --  
      SELECT CONCM.CONCM_CD                   CONCM_CD  
           , CONCM.CONCM_DESC                 CONCM_DESC  
           , ISNULL(A.CONC_VALUE, ' ')        VALUE  
      FROM  (SELECT ENTAC.ENTAC_CONCM_ID      CONCM_ID  
                  , CONC.CONC_VALUE           CONC_VALUE  
             FROM   CONTACT_CHANNELS          CONC  WITH (NOLOCK)  
                  , ENTITY_ADR_CONC           ENTAC WITH (NOLOCK)  
             WHERE  ENTAC.ENTAC_ADR_CONC_ID = CONC.CONC_ID  
      AND    ENTAC.ENTAC_ENT_ID      = @PA_CRN_NO  
             AND    CONC.CONC_DELETED_IND   = 1  
             AND    ENTAC.ENTAC_DELETED_IND = 1  
            ) A  
             RIGHT OUTER JOIN  
             CONC_CODE_MSTR                     CONCM  WITH (NOLOCK)  
             ON CONCM.CONCM_ID=A.CONCM_ID  
      WHERE  CONCM.CONCM_DELETED_IND        = 1  
      AND    1 & CONCM.CONCM_CLI_YN   = 1  
      AND    2 & CONCM.CONCM_CLI_YN    = 2  
      ORDER  BY CONCM.CONCM_DESC  
      --  
    END  
    /*IF @PA_TAB = 'ENTP'  
    BEGIN  
    --  
      IF @PA_ACCT_NO = 'ENT'  
      BEGIN  
        --  
        SELECT X.ENTPM_ID ENTPM_ID  
                 ,  X.ENTPM_CD ENTPM_CD  
                 ,  X.ENTPM_DESC ENTPM_DESC  
                 ,  X.ENTP_VALUE ENTP_VALUE  
                 ,  Y.ENTDM_CD ENTDM_CD  
                 ,  Y.ENTPD_VALUE value  
                 ,  y.entdm_desc entdm_desc  
        FROM (SELECT B.ENTP_ID                 ENTP_ID  
                     , A.ENTPM_ID              ENTPM_ID  
                     , A.ENTPM_CD              ENTPM_CD  
                     , A.ENTPM_DESC            ENTPM_DESC  
                     , B.ENTP_VALUE            ENTP_VALUE  
                  FROM ENTITY_PROPERTY_MSTR A  WITH (NOLOCK)  
                  LEFT OUTER JOIN  
                  ENTITY_PROPERTIES B    WITH (NOLOCK)  
                  ON  (A.ENTPM_ID=B.ENTP_ENTPM_ID)  
                  AND ENTP_ENT_ID = @PA_CRN_NO  
                  where 1 & A.ENTPM_CLI_YN = 0)  X  
              LEFT OUTER JOIN  
                 (SELECT A.ENTDM_ENTPM_ID           ENTDM_ENTPM_ID  
                            , B.ENTPD_ENTP_ID              ENTPD_ENTP_ID  
                            , A.ENTDM_CD                     ENTDM_CD  
                            , B.ENTPD_VALUE                 ENTPD_VALUE  
                            , a.entdm_desc  entdm_desc  
                  FROM    ENTPM_DTLS_MSTR A   WITH (NOLOCK)  
                          LEFT OUTER JOIN  
                          ENTITY_PROPERTY_DTLS B  WITH (NOLOCK)  
                  ON  (A.ENTDM_ID=B.ENTPD_ENTDM_ID)  
                  AND ENTPD_ENTP_ID IN  (SELECT ENTP_ID FROM ENTITY_PROPERTIES  WITH (NOLOCK) WHERE ENTP_ENT_ID=@PA_CRN_NO)) Y  
                  ON (X.ENTPM_ID = Y.ENTDM_ENTPM_ID)  
      END  
      ELSE  
      BEGIN  
      --  
        SELECT X.ENTPM_ID ENTPM_ID  
                 ,  X.ENTPM_CD ENTPM_CD  
                 ,  X.ENTPM_DESC ENTPM_DESC  
                 ,  X.ENTP_VALUE ENTP_VALUE  
                 ,  Y.ENTDM_CD ENTDM_CD  
                 ,  Y.ENTPD_VALUE value  
                 ,  y.entdm_desc entdm_desc  
        FROM (SELECT B.ENTP_ID                 ENTP_ID  
                     , A.ENTPM_ID              ENTPM_ID  
                     , A.ENTPM_CD              ENTPM_CD  
                     , A.ENTPM_DESC            ENTPM_DESC  
                     , B.ENTP_VALUE            ENTP_VALUE  
                  FROM ENTITY_PROPERTY_MSTR A  WITH (NOLOCK)  
                  LEFT OUTER JOIN  
                  ENTITY_PROPERTIES B    WITH (NOLOCK)  
                  ON  (A.ENTPM_ID=B.ENTP_ENTPM_ID)  
                  AND ENTP_ENT_ID = @PA_CRN_NO  
                  where  A.ENTPM_CLI_YN = 1)  X  
                  LEFT OUTER JOIN  
                 (SELECT A.ENTDM_ENTPM_ID           ENTDM_ENTPM_ID  
                            , B.ENTPD_ENTP_ID              ENTPD_ENTP_ID  
                            , A.ENTDM_CD                     ENTDM_CD  
                            , B.ENTPD_VALUE                 ENTPD_VALUE  
                            , a.entdm_desc  entdm_desc  
                  FROM    ENTPM_DTLS_MSTR A   WITH (NOLOCK)  
                          LEFT OUTER JOIN  
                          ENTITY_PROPERTY_DTLS B  WITH (NOLOCK)  
                  ON  (A.ENTDM_ID=B.ENTPD_ENTDM_ID)  
                  AND ENTPD_ENTP_ID IN  (SELECT ENTP_ID FROM ENTITY_PROPERTIES  WITH (NOLOCK) WHERE ENTP_ENT_ID=@PA_CRN_NO)) Y  
                  ON (X.ENTPM_ID = Y.ENTDM_ENTPM_ID)  
       --  
      END  
    --  
    END  
    IF @PA_TAB = 'CLID'  
    BEGIN  
      --  
      SELECT DISTINCT ISNULL(A.CLID_CRN_NO, 0)  CLID_CRN_NO  
           , B.EXCSM_EXCH_CD                    EXCSM_EXCH_CD  
           , B.EXCSM_SEG_CD                     EXCSM_SEG_CD  
           , ISNULL(B.DOCM_DOC_ID, 0)           DOCM_DOC_ID  
           , ISNULL(CONVERT(VARCHAR,A.CLID_VALID_YN), 0) CLID_VALID_YN  
           , ISNULL(A.CLID_REMARKS, ' ')        CLID_REMARKS  
           , B.DOCM_CD                          DOCM_CD  
           , B.DOCM_DESC                        DOCM_DESC  
           , ORDERBY = CASE WHEN EXCSM_EXCH_CD = 'BSE' THEN 1 ELSE CASE WHEN EXCSM_EXCH_CD = 'NSE' THEN  2 ELSE 3 END END  
      FROM  (SELECT DISTINCT CLID_CRN_NO  
                  , CLID.CLID_DOCM_DOC_ID  
                  , CLID_VALID_YN  
                  , CLID_REMARKS  
             FROM   CLIENT_DOCUMENTS CLID  WITH (NOLOCK)  
             WHERE  CLID_CRN_NO = @PA_CRN_NO  
            ) A RIGHT OUTER JOIN  
            (  
             SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
                    , excsm.excsm_seg_cd    excsm_seg_cd  
                    , prom.prom_id          prom_id  
                    , prom.prom_desc        prom_desc  
                    , enttm.enttm_id        enttm_id  
                    , enttm.enttm_desc      enttm_desc  
                    , clicm.clicm_id        clicm_id  
                    , clicm.clicm_desc      clicm_desc  
                    , docm.docm_doc_id      docm_doc_id  
                    , docm.docm_desc        docm_desc  
                    , case docm.docm_mdty when 1 then 'M' else 'N'end   docm_mdty  
      FROM            document_mstr         docm    WITH(NOLOCK)  
                    , exch_seg_mstr         excsm   WITH(NOLOCK)  
                    , client_ctgry_mstr     clicm   WITH(NOLOCK)  
                    , entity_type_mstr      enttm   WITH(NOLOCK)  
                    , excsm_prod_mstr       excpm   WITH(NOLOCK)  
                    , product_mstr          prom    WITH(NOLOCK)  
      WHERE  docm.docm_excpm_id           = excpm.excpm_id  
      AND    docm.docm_clicm_id           = clicm.clicm_id  
      AND    docm.docm_enttm_id           = enttm.enttm_id  
      AND    prom.prom_id                 = excpm.excpm_prom_id  
      AND    excpm.excpm_excsm_id         = excsm.excsm_id  
      AND    clicm.clicm_deleted_ind      = 1  
      AND    enttm.enttm_deleted_ind      = 1  
      AND    excpm.excpm_deleted_ind      = 1  
      AND    prom.prom_deleted_ind        = 1  
      AND    excsm.excsm_deleted_ind      = 1  
      AND    docm.docm_deleted_ind        = 1  
      ) B  
      ON  A.CLID_DOCM_DOC_ID               = B.DOCM_DOC_ID  
      ORDER  BY (CASE WHEN EXCSM_EXCH_CD='BSE' THEN 1 ELSE CASE WHEN EXCSM_EXCH_CD= 'NSE' THEN  2 ELSE 3 END END ), EXCSM_SEG_CD  
    --  
    END*/  
    IF @PA_TAB = 'CLIA'  
    BEGIN  
      --  
      SELECT DISTINCT A.CLIA_ACCT_NO          ACCT_NO  
           , COMPM.COMPM_ID                   COMPM_ID  
           , COMPM.COMPM_SHORT_NAME           COMPM_SHORT_NAME  
           , A.EXCSM_EXCH_CD                  EXCSM_EXCH_CD  
           , A.EXCSM_SEG_CD                   EXCSM_SEG_CD  
           , A.EXCSM_ID                       EXCSM_ID  
      FROM  (SELECT CLIA.CLIA_ACCT_NO         CLIA_ACCT_NO  
                  , EXCSM.EXCSM_COMPM_ID      COMPM_ID  
                  , EXCSM.EXCSM_EXCH_CD       EXCSM_EXCH_CD  
                  , EXCSM.EXCSM_SEG_CD        EXCSM_SEG_CD  
                  , EXCSM.EXCSM_ID            EXCSM_ID  
                  ,  citrus_usr.FN_GET_SINGLE_ACCESS (CLIA.CLIA_CRN_NO, CLIA.CLIA_ACCT_NO,EXCSM.EXCSM_DESC) ACCESS1  
             FROM   CLIENT_ACCOUNTS           CLIA   WITH (NOLOCK)  
                  , EXCH_SEG_MSTR             EXCSM  WITH (NOLOCK)  
             WHERE  CLIA.CLIA_CRN_NO        = @PA_CRN_NO  
             AND    CLIA.CLIA_DELETED_IND   = 1  
             AND    EXCSM.EXCSM_DELETED_IND = 1  
            ) A  
           , COMPANY_MSTR                    COMPM    WITH (NOLOCK)  
      WHERE  A.COMPM_ID                    = COMPM.COMPM_ID  
      AND    COMPM.COMPM_DELETED_IND       = 1  
      AND    ISNULL(CONVERT(NUMERIC, ACCESS1), 0)              <> 0  
      --  
    END  
    IF @PA_TAB = 'CLIBA'  
    BEGIN  
      --  
      SELECT clia.clia_acct_no                   acct_no  
           , clisba.clisba_no                    clisba_no  
           , cliba.cliba_ac_name                 cliba_ac_name  
           , cliba.cliba_banm_id                 cliba_banm_id  
           , banm.banm_name                      banm_name  
           , cliba.cliba_ac_type                 cliba_ac_type  
           , cliba.cliba_ac_no                   cliba_ac_no  
           , cliba.cliba_flg                     cliba_flg  
           , compm.compm_id                      compm_id  
           , compm.compm_short_name              compm_short_name  
           , excsm.excsm_exch_cd                 excsm_exch_cd  
           , excsm.excsm_seg_cd                  excsm_seg_cd  
           , excsm.excsm_id                      excsm_id  
      FROM   client_accounts                     clia     WITH (NOLOCK)  
           , client_bank_accts                   cliba    WITH (NOLOCK)  
           , client_sub_accts                    clisba   WITH (NOLOCK)  
           , bank_mstr                           banm     WITH (NOLOCK)  
           , exch_seg_mstr                       excsm    WITH (NOLOCK)  
           , company_mstr                        compm    WITH (NOLOCK)  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id  
      AND    clisba.clisba_crn_no              = clia.clia_crn_no  
      AND    clisba.clisba_acct_no             = clia.clia_acct_no  
      AND    cliba.cliba_clisba_id             = clisba.clisba_id  
      AND    banm.banm_id                      = cliba.cliba_banm_id  
      AND    clia.clia_deleted_ind             = 1  
      AND    isnull(clisba.clisba_deleted_ind, 1) = 1  
      AND    cliba.cliba_deleted_ind           = 1  
      AND    banm.banm_deleted_ind             = 1  
      AND    excsm.excsm_deleted_ind           = 1  
      AND    compm.compm_deleted_ind           = 1  
      AND     citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0  
      AND    clia.clia_crn_no                  = @PA_CRN_NO  
    --  
    END  
    IF @PA_TAB = 'CLIDPA'  
    BEGIN  
      --  
      SELECT clidpa.clidpa_dpm_id                clidpa_dpm_id  
           , dpm.dpm_name                        dpm_name  
           , dpm.dpm_dpid                        dpm_dpid  
           , clidpa.clidpa_dp_id                 clidpa_dp_id  
           , clidpa.clidpa_name                  clidpa_name  
           , clidpa.clidpa_flg & 1               poa_flg  
           , clidpa.clidpa_flg & 2               def_flg  
           , clidpa.clidpa_poa_type              clidpa_poa_type  
           , compm.compm_id                      compm_id  
           , compm.compm_short_name              compm_short_name  
           , excsm.excsm_exch_cd                 excsm_exch_cd  
           , excsm.excsm_seg_cd                  excsm_seg_cd  
           , clia.clia_acct_no                   acct_no  
           , clisba.clisba_no                    clisba_no  
           , excsm.excsm_id                      excsm_id  
           , excm.excm_cd                        dpm_type  
      FROM   client_accounts                     clia     WITH (NOLOCK)  
           , client_dp_accts                     clidpa   WITH (NOLOCK)  
           , client_sub_accts                    clisba   WITH (NOLOCK)  
           , dp_mstr                             dpm      WITH (NOLOCK)  
           , exchange_mstr                       excm     WITH (NOLOCK)  
           , exch_seg_mstr                       excsm    WITH (NOLOCK)  
           , company_mstr                        compm    WITH (NOLOCK)  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id  
      AND    clisba.clisba_crn_no              = clia.clia_crn_no  
      AND    clisba.clisba_acct_no             = clia.clia_acct_no  
      AND    clidpa.clidpa_clisba_id           = clisba.clisba_id  
      AND    dpm.dpm_id                        = clidpa.clidpa_dpm_id  
      AND    dpm.dpm_excsm_id                   = excsm.excsm_id  
      AND    clia.clia_deleted_ind             = 1  
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1  
      AND    clidpa.clidpa_deleted_ind         = 1  
      AND    dpm.dpm_deleted_ind               = 1  
      AND    excsm.excsm_deleted_ind           = 1  
      AND    compm.compm_deleted_ind           = 1  
      AND    excm.excm_deleted_ind               = 1  
      AND    citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0  
      AND    clia.clia_crn_no                  = @pa_crn_no;  
      --  
    END  
    IF @PA_TAB = 'ENTM'  
    BEGIN  
    --  
      IF @PA_ACCT_NO = 'HO'  
      BEGIN  
      --  
        /*SELECT isnull(x.entm_name1,'')  entm_name1  
             , isnull(x.entm_name2,'')  entm_name2  
             , isnull(x.entm_name3,'')  entm_name3  
             , isnull(x.entm_short_name,'')  entm_short_name  
             , isnull(x.enttm_desc,'')  enttm_desc  
             , isnull(x.parent_id,null)   parent_id  
             , isnull(a.parent_name1,'') parent_name1  
             , isnull(x.parent_type_cd,'') parent_type_cd  
        from  
            (  
             SELECT entm.entm_name1     entm_name1  
             , entm.entm_name2          entm_name2  
             , entm.entm_name3          entm_name3  
             , entm.entm_short_name     entm_short_name  
             , enttm.enttm_desc         enttm_desc  
             , entm.entm_parent_id      parent_id  
             , enttm.enttm_cd           parent_type_cd  
             FROM entity_mstr  entm       WITH (NOLOCK)  
                 ,entity_type_mstr enttm  WITH (NOLOCK)  
             WHERE enttm.enttm_cd        = entm.entm_enttm_cd  
             AND   entm.entm_id          = @PA_CRN_NO  
             AND   entm.entm_deleted_ind = 1  
            ) x  
              left outer join  
           (select entm_id, entm_name1, entm_short_name parent_name1  
            from entity_mstr  WITH (NOLOCK)) a  
        on a.entm_id = x.parent_id*/  
        SELECT ENTM.ENTM_NAME1          ENTM_NAME1  
             , ENTM.ENTM_NAME2          ENTM_NAME2  
             , ENTM.ENTM_NAME3          ENTM_NAME3  
             , ENTM.ENTM_SHORT_NAME     ENTM_SHORT_NAME  
             , ENTTM.ENTTM_DESC         ENTTM_DESC  
             , ENTM.ENTM_PARENT_ID      PARENT_ID  
             , ENTM.ENTM_NAME1          PARENT_NAME1  
             , ENTTM.ENTTM_CD           PARENT_TYPE_CD  
             , ENTTM.ENTTM_CD           ENTTM_CD             
             , CLICM.CLICM_CD           CLICM_CD  
             , CLICM.CLICM_DESC         CLICM_DESC  
        FROM  ENTITY_MSTR               ENTM   WITH (NOLOCK)  
             ,ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)  
             ,CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)  
        WHERE ENTTM.ENTTM_CD          = ENTM.ENTM_ENTTM_CD  
        AND   ENTM.ENTM_CLICM_CD      = CLICM.CLICM_CD  
        AND   ENTM.ENTM_ID            = @PA_CRN_NO  
        AND   ENTM.ENTM_DELETED_IND   = 1  
        AND   ENTTM.ENTTM_DELETED_IND = 1  
        AND   CLICM.CLICM_DELETED_IND = 1  
      --  
      END  
      ELSE  
      BEGIN  
      --  
          
        DECLARE @L_EXISTS SMALLINT  
          
        SELECT @L_EXISTS = ISNULL(ENTM_PARENT_ID,0)           
        FROM  ENTITY_MSTR               ENTM  
        WHERE ENTM.ENTM_ID            = @PA_CRN_NO  
        AND   ENTM.ENTM_DELETED_IND   = 1  
                
        IF @L_EXISTS<>0  
        BEGIN  
        --   
          SELECT A.ENTM_NAME1                     ENTM_NAME1  
               , A.ENTM_NAME2                     ENTM_NAME2  
               , A.ENTM_NAME3                     ENTM_NAME3  
               , A.ENTM_SHORT_NAME                ENTM_SHORT_NAME  
               , A.ENTTM_DESC                     ENTTM_DESC  
               , A.CLICM_CD                       CLICM_CD  
               , A.CLICM_DESC                     CLICM_DESC  
               , A.PARENT_ID                      PARENT_ID  
               , ENTM.ENTM_NAME1                  PARENT_NAME1  
               , ENTTM.ENTTM_CD                   PARENT_TYPE_CD  
               , A.ENTTM_CD                       ENTTM_CD       
          FROM  (SELECT ENTM.ENTM_NAME1           ENTM_NAME1  
                      , ENTM.ENTM_NAME2           ENTM_NAME2  
                      , ENTM.ENTM_NAME3           ENTM_NAME3  
                      , ENTM.ENTM_SHORT_NAME      ENTM_SHORT_NAME  
                      , ENTTM.ENTTM_DESC          ENTTM_DESC  
                      , ENTM.ENTM_PARENT_ID       PARENT_ID  
                      , CLICM.CLICM_CD            CLICM_CD  
                      , CLICM.CLICM_DESC          CLICM_DESC  
                      , ENTTM.ENTTM_CD            ENTTM_CD   
                 FROM   ENTITY_MSTR               ENTM  
                      , ENTITY_TYPE_MSTR          ENTTM  
                      , CLIENT_CTGRY_MSTR         CLICM  
                 WHERE  ENTTM.ENTTM_CD          = ENTM.ENTM_ENTTM_CD  
                 AND    ENTM.ENTM_CLICM_CD      = CLICM.CLICM_CD  
                 AND    ENTM.ENTM_ID            = @PA_CRN_NO  
                 AND    ENTM.ENTM_DELETED_IND   = 1  
                 AND    ENTTM.ENTTM_DELETED_IND = 1  
                 AND    CLICM.CLICM_DELETED_IND = 1  
                )                                 A  
               ,  ENTITY_MSTR                     ENTM  
               ,  ENTITY_TYPE_MSTR                ENTTM  
          WHERE   A.PARENT_ID                   = ENTM.ENTM_ID  
          AND     ENTTM.ENTTM_CD                = ENTM.ENTM_ENTTM_CD  
          AND     ENTTM.ENTTM_DELETED_IND       = 1  
       --  
       END  
       ELSE  
       BEGIN  
       --  
         SELECT ENTM.ENTM_NAME1               ENTM_NAME1               
              , ENTM.ENTM_NAME2               ENTM_NAME2               
              , ENTM.ENTM_NAME3               ENTM_NAME3               
              , ENTM.ENTM_SHORT_NAME          ENTM_SHORT_NAME          
              , ENTTM.ENTTM_DESC              ENTTM_DESC               
              , CLICM.CLICM_CD                CLICM_CD                 
              , CLICM.CLICM_DESC              CLICM_DESC               
              , ISNULL(ENTM.ENTM_PARENT_ID,0) PARENT_ID                
              , ENTM.ENTM_NAME1               PARENT_NAME1             
              , ''                            PARENT_TYPE_CD  
              , ENTTM.ENTTM_CD                ENTTM_CD    
         FROM   ENTITY_MSTR                   ENTM                     
              , ENTITY_TYPE_MSTR              ENTTM  
              , CLIENT_CTGRY_MSTR             CLICM  
         WHERE  ENTTM.ENTTM_CD          = ENTM.ENTM_ENTTM_CD  
         AND    ENTM.ENTM_CLICM_CD      = CLICM.CLICM_CD  
         AND    ENTM.ENTM_ID            = @PA_CRN_NO  
         AND    ENTM.ENTM_DELETED_IND   = 1  
         AND    ENTTM.ENTTM_DELETED_IND = 1  
         AND    CLICM.CLICM_DELETED_IND = 1  
       --  
       END  
      END  
      --  
    END-- END OF ENTM  
    --  
    IF @PA_TAB = 'PROM'  -- PRODUCT MAPPING  
    BEGIN  
    --  
      SELECT PROM.PROM_ID              PROM_ID  
           , PROM.PROM_CD              PROM_CD  
           , PROM.PROM_DESC            PROM_DESC  
           , EXCPM.EXCPM_EXCSM_ID      EXCPM_EXCSM_ID  
      FROM   EXCSM_PROD_MSTR           EXCPM   WITH (NOLOCK)  
           , PRODUCT_MSTR              PROM    WITH (NOLOCK)  
      WHERE  PROM.PROM_ID            = EXCPM.EXCPM_PROM_ID  
      AND    EXCPM.EXCPM_DELETED_IND = 1  
      AND    PROM.PROM_DELETED_IND   = 1  
    --  
    END  
  
  IF @PA_TAB = 'CLISBA'  
  BEGIN  
  --  
    SELECT COMPM.COMPM_ID                  COMPM_ID  
         , COMPM.COMPM_SHORT_NAME          COMPM_SHORT_NAME  
         , EXCSM.EXCSM_ID                  EXCSM_ID  
         , EXCSM.EXCSM_EXCH_CD             EXCSM_EXCH_CD  
         , EXCSM.EXCSM_SEG_CD              EXCSM_SEG_CD  
         , CLIA.CLIA_ACCT_NO               ACCT_NO  
         , EXCPM.EXCPM_PROM_ID             EXCPM_PROM_ID  
         , PROM.PROM_DESC                  PROM_DESC  
         , ISNULL(CLISBA.CLISBA_NO, 0)     CLISBA_NO  
         , ISNULL(CLISBA.CLISBA_NAME, 0)   CLISBA_NAME  
         , CONVERT(VARCHAR,COMPM.COMPM_ID)+'|*~|'+CONVERT(VARCHAR,EXCSM.EXCSM_ID)+'|*~|'+CLIA.CLIA_ACCT_NO+'|*~|'+ISNULL(CLISBA.CLISBA_NO, 0)+'|*~|'+ISNULL(CLISBA.CLISBA_NAME, 0)+'|*~|'+CONVERT(VARCHAR,EXCPM.EXCPM_PROM_ID)+'|*~|Q' VALUE  --*|~*  
    FROM   CLIENT_SUB_ACCTS            CLISBA   WITH (NOLOCK)  
         , CLIENT_ACCOUNTS             CLIA     WITH (NOLOCK)  
         , EXCSM_PROD_MSTR             EXCPM    WITH (NOLOCK)  
         , EXCH_SEG_MSTR               EXCSM    WITH (NOLOCK)  
         , PRODUCT_MSTR                PROM     WITH (NOLOCK)  
         , COMPANY_MSTR                COMPM    WITH (NOLOCK)  
    WHERE  CLISBA.CLISBA_CRN_NO      = CLIA.CLIA_CRN_NO  
    AND    CLISBA.CLISBA_ACCT_NO     = CLIA.CLIA_ACCT_NO  
    AND    CLISBA.CLISBA_EXCPM_ID    = EXCPM.EXCPM_ID --(+)  
    AND    EXCSM.EXCSM_ID            = EXCPM.EXCPM_EXCSM_ID  
    AND    COMPM.COMPM_ID            = EXCSM.EXCSM_COMPM_ID  
    AND    PROM.PROM_ID              = EXCPM.EXCPM_PROM_ID  
    AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( CLIA.CLIA_CRN_NO, CLIA.CLIA_ACCT_NO, EXCSM.EXCSM_DESC), 0) > 0  
    AND    CLIA.CLIA_DELETED_IND     = 1  
    AND    EXCSM.EXCSM_DELETED_IND   = 1  
    AND    CLISBA.CLISBA_DELETED_IND = 1  
    AND    CLIA.CLIA_CRN_NO          = @PA_CRN_NO  
 --  
 END  
 --  
 IF @PA_TAB = 'CLISBAENTR'  
 BEGIN  
 --  
    SELECT COMPM.COMPM_SHORT_NAME+' - '+EXCSM.EXCSM_EXCH_CD+' - '+EXCSM.EXCSM_SEG_CD+' - '+CLIA.CLIA_ACCT_NO+' - '+ISNULL(CLISBA.CLISBA_NO, 0)  SBA_VAL  
         , CONVERT(VARCHAR,COMPM.COMPM_ID)+'|*~|'+CONVERT(VARCHAR,EXCSM.EXCSM_ID)+'|*~|'+CLIA.CLIA_ACCT_NO+'|*~|'+ISNULL(CLISBA.CLISBA_NO, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,ENTR.ENTR_FROM_DT,103))+'|*~|'+'HO|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_HO)+'|*~|RE|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_RE)+'|*~|AR|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_AR)+'|*~|BR|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_BR)+'|*~|SB|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_SB)+'|*~|DL|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_DL)+'|*~|RM|*~|'+ citrus_usr.FN_SELECT_ENTM(ENTR.ENTR_RM)+'|*~|Q' REL_VALUE  
         , CONVERT(DATETIME,ENTR.ENTR_FROM_DT,103)   ENTR_FROM_DT  
    FROM   ENTITY_RELATIONSHIP         ENTR     WITH (NOLOCK)  
         , CLIENT_SUB_ACCTS            CLISBA   WITH (NOLOCK)  
         , CLIENT_ACCOUNTS             CLIA     WITH (NOLOCK)  
         , EXCH_SEG_MSTR               EXCSM    WITH (NOLOCK)  
         , COMPANY_MSTR                COMPM    WITH (NOLOCK)  
    WHERE  ENTR.ENTR_CRN_NO          = CLISBA.CLISBA_CRN_NO  
    AND    ENTR.ENTR_ACCT_NO         = CLISBA.CLISBA_ACCT_NO  
    AND    ENTR.ENTR_SBA             = CLISBA.CLISBA_NO  
    AND    CLISBA.CLISBA_CRN_NO      = CLIA.CLIA_CRN_NO  
    AND    CLISBA.CLISBA_ACCT_NO     = CLIA.CLIA_ACCT_NO  
    AND    COMPM.COMPM_ID            = EXCSM.EXCSM_COMPM_ID  
    AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( CLIA.CLIA_CRN_NO, CLIA.CLIA_ACCT_NO, EXCSM.EXCSM_DESC), 0) > 0  
    AND    CLIA.CLIA_DELETED_IND     = 1  
    AND    EXCSM.EXCSM_DELETED_IND   = 1  
    AND    CLISBA.CLISBA_DELETED_IND = 1  
    AND    CLIA.CLIA_CRN_NO          = @PA_CRN_NO  
    ORDER  BY CLISBA_NO , ENTR_FROM_DT DESC  
 --  
 END  
--  
END

GO
