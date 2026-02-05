-- Object: PROCEDURE citrus_usr.pr_select_mstr_acct
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[pr_select_mstr_acct](@pa_id             VARCHAR(20)
                                     ,@pa_action         VARCHAR(20)
                                     ,@pa_login_name     VARCHAR(20)
                                     ,@pa_cd             VARCHAR(25)
                                     ,@pa_desc           VARCHAR(250)
                                     ,@pa_rmks           VARCHAR(250)
                                     ,@pa_values         VARCHAR(8000)
                                     ,@rowdelimiter      CHAR(4)
                                     ,@coldelimiter      CHAR(4)
                                     ,@pa_ref_cur        VARCHAR(8000) OUT
                                     )
                                
                                
AS
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : pr_select_acct
 DESCRIPTION    : This procedure will select data related to client_account
 COPYRIGHT(C)   : Marketplacetechnologies pvt ltd
 VERSION HISTORY:
 VERS.  AUTHOR             DATE        REASON
 -----  -------------      ----------  -------------------------------------------------
 1.0    TUSHAR             04-MAY-2007 INITIAL VERSION.
--------------------------------------------------------------------------------------*/
BEGIN
--
  IF @pa_action = 'ACCDOCM_SEARCH'
  BEGIN
  --    
    SELECT DISTINCT accdocm.accdocm_cd        accdocm_cd
          ,accdocm.accdocm_desc               accdocm_desc  
          ,accdocm.accdocm_doc_id             accdocm_doc_id  
          ,ISNULL(accdocm.accdocm_rmks,'')    accdocm_rmks
          ,accdocm.accdocm_acct_type          accdocm_acct_type
    FROM   account_document_mstr              accdocm    with(nolock)
    WHERE  accdocm.accdocm_doc_id             LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @pa_cd END
    AND    accdocm.accdocm_deleted_ind = 1

  --
  END
  ELSE IF @PA_ACTION = 'ACCDOCM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT accdocmm.accdocm_cd   accdocm_cd
         , accdocmm.accdocm_desc          accdocm_desc  
         , accdocmm.accdocm_doc_id        accdocm_doc_id    
         , accdocmm.accdocm_rmks          accdocm_rmks
         , accdocmm.accdocm_acct_type     accdocm_acct_type
    FROM   accdocm_mak                    accdocmm    with(nolock)
    WHERE  accdocmm.accdocm_deleted_ind IN (0, 4, 6)
    AND    accdocmm.accdocm_doc_id      LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    accdocmm.accdocm_created_by  = @PA_LOGIN_NAME
  --
  END
    ELSE IF @PA_ACTION = 'ACCDOCM_SEARCHC'
    BEGIN
    --
      SELECT DISTINCT accdocmm.accdocm_cd  accdocm_cd
            ,accdocmm.accdocm_desc         accdocm_desc  
            ,accdocmm.accdocm_doc_id       accdocm_doc_id
            ,accdocmM.accdocm_acct_type    accdocm_acct_type
      FROM   accdocm_mak                   accdocmm    with(nolock)
      WHERE  accdocmm.accdocm_deleted_ind IN (0, 4, 6)
      AND    accdocmm.accdocm_created_by  <> @PA_LOGIN_NAME
    --
    END
    ELSE IF @PA_ACTION ='RACCDOCM'  
    BEGIN  
    --  
      SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
           , excsm.excsm_seg_cd    excsm_seg_cd  
           , prom.prom_id          prom_id  
           , prom.prom_desc        prom_desc  
           , enttm.enttm_id        enttm_id  
           , enttm.enttm_desc      enttm_desc  
           , clicm.clicm_id        clicm_id  
           , clicm.clicm_desc      clicm_desc  
           , case accdocm.accdocm_mdty when 1 then 'M' else 'N'end   accdocm_mdty
           --
           , accdocm.accdocm_id            accdocm_id
           , accdocm.accdocm_cd            accdocm_cd  
           , accdocm.accdocm_desc          accdocm_desc
           , accdocm.accdocm_rmks          accdocm_rmks
           --
      FROM   account_document_mstr accdocm    with(nolock)
           , exch_seg_mstr         excsm    with(nolock)
           , client_ctgry_mstr     clicm   with(nolock)
           , entity_type_mstr      enttm   with(nolock)
           , excsm_prod_mstr       excpm   with(nolock)
           , product_mstr          prom   with(nolock)
      WHERE  accdocm.accdocm_excpm_id           = excpm.excpm_id  
      AND    accdocm.accdocm_clicm_id           = clicm.clicm_id  
      AND    accdocm.accdocm_enttm_id           = enttm.enttm_id  
      AND    prom.prom_id                 = excpm.excpm_prom_id  
      AND    excpm.excpm_excsm_id         = excsm.excsm_id  
      AND    clicm.clicm_deleted_ind      = 1  
      AND    enttm.enttm_deleted_ind      = 1  
      AND    excpm.excpm_deleted_ind      = 1  
      AND    prom.prom_deleted_ind        = 1  
      AND    excsm.excsm_deleted_ind      = 1  
      AND    accdocm.accdocm_deleted_ind  = 1  
      AND    accdocm.accdocm_doc_id       = convert(NUMERIC,@PA_CD)  
      ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc  
    --   
    END   
    ELSE IF @PA_ACTION='LACCDOCM'  
    BEGIN  
    --  
      SELECT DISTINCT excsm.excsm_exch_cd  
            ,excsm.excsm_seg_cd  
            ,prom_desc,prom_id  
      FROM   excsm_prod_mstr excpm         with(nolock)
             left outer join exch_seg_mstr excsm     with(nolock)
      ON     excpm.excpm_excsm_id        = excsm.excsm_id  
             right outer join product_mstr prom    with(nolock)
      ON     excpm.excpm_prom_id         = prom.prom_id 
      WHERE  excpm.excpm_deleted_ind     = 1
      AND    excsm.excsm_deleted_ind     = 1
      AND    prom_deleted_ind            = 1
      ORDER BY excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc  
    --  
    END  
    ELSE IF @PA_ACTION = 'RACCDOCMMAK' --only show those records which the maker has created.  
    BEGIN  
    --  
      SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
           , excsm.excsm_seg_cd             excsm_seg_cd  
           , prom.prom_id                   prom_id  
           , prom.prom_desc                 prom_desc  
           , enttm.enttm_id                 enttm_id  
           , enttm.enttm_desc               enttm_desc  
           , clicm.clicm_id                 clicm_id  
           , clicm.clicm_desc               clicm_desc  
           , CASE  accdocmm.accdocm_mdty WHEN  1 THEN  'M' ELSE 'N'  END accdocm_mdty
              
      FROM   accdocm_mak                    accdocmm with(nolock)
           , exch_seg_mstr                  excsm    with(nolock)
           , client_ctgry_mstr              clicm   with(nolock)
           , entity_type_mstr               enttm   with(nolock)
           , excsm_prod_mstr                excpm   with(nolock)
           , product_mstr                   prom   with(nolock)
      WHERE  accdocmm.accdocm_excpm_id    = excpm.excpm_id  
      AND    accdocmm.accdocm_clicm_id    = clicm.clicm_id  
      AND    accdocmm.accdocm_enttm_id    = enttm.enttm_id  
      AND    prom.prom_id                 = excpm.excpm_prom_id  
      AND    excpm.excpm_excsm_id         = excsm.excsm_id  
      AND    clicm.clicm_deleted_ind      = 1  
      AND    enttm.enttm_deleted_ind      = 1  
      AND    excpm.excpm_deleted_ind      = 1  
      AND    prom.prom_deleted_ind        = 1  
      AND    excsm.excsm_deleted_ind      = 1  
      AND    accdocmm.accdocm_deleted_ind = 0  
      AND    accdocmm.accdocm_doc_id      = CONVERT(NUMERIC,@PA_CD)  
      AND    accdocmm.accdocm_created_by  = @PA_LOGIN_NAME  
      ORDER BY excsm.excsm_exch_cd  
             , excsm.excsm_seg_cd  
             , prom.prom_desc  
             , enttm.enttm_desc  
             , clicm.clicm_desc  
    --  
    END  
    ELSE IF @PA_ACTION = 'RACCDOCMCHK' --only show those records which the checker has not created.  
    BEGIN  
    --  
      SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
           , excsm.excsm_seg_cd             excsm_seg_cd  
           , prom.prom_id                   prom_id  
           , prom.prom_desc                 prom_desc  
           , enttm.enttm_id                 enttm_id  
           , enttm.enttm_desc               enttm_desc  
           , clicm.clicm_id                 clicm_id  
           , clicm.clicm_desc               clicm_desc
           , accdocmm.accdocm_id            accdocm_id
           , accdocmm.accdocm_cd            accdocm_cd  
           , accdocmm.accdocm_desc          accdocm_desc
           , accdocmm.accdocm_rmks          accdocm_rmks
           , accdocmm.accdocm_acct_type     accdocm_acct_type
           , excsm.excsm_exch_cd + '-' + excsm.excsm_seg_cd  excsm_cd
           , CASE accdocmm.accdocm_mdty WHEN 1 THEN 'M'ELSE 'N'END accdocm_mdty  
           , accdocmm.accdocm_deleted_ind   accdocm_deleted_ind       
      FROM   accdocm_mak                    accdocmm   with(nolock)
           , exch_seg_mstr                  excsm  with(nolock) 
           , client_ctgry_mstr              clicm  with(nolock) 
           , entity_type_mstr               enttm  with(nolock) 
           , excsm_prod_mstr                excpm  with(nolock) 
           , product_mstr                   prom   with(nolock)
      WHERE  accdocmm.accdocm_excpm_id            = excpm.excpm_id  
      AND    accdocmm.accdocm_clicm_id            = clicm.clicm_id  
      AND    accdocmm.accdocm_enttm_id            = enttm.enttm_id  
      AND    prom.prom_id                 = excpm.excpm_prom_id  
      AND    excpm.excpm_excsm_id         = excsm.excsm_id  
      AND    clicm.clicm_deleted_ind      = 1  
      AND    enttm.enttm_deleted_ind      = 1  
      AND    excpm.excpm_deleted_ind      = 1  
      AND    prom.prom_deleted_ind        = 1  
      AND    excsm.excsm_deleted_ind      = 1  
      AND    accdocmm.accdocm_deleted_ind IN (0,4,6)
      --AND    docmm.docm_doc_id            = CONVERT(NUMERIC,@PA_CD)  
      AND    accdocmm.accdocm_lst_upd_by       <> @PA_LOGIN_NAME 
      ORDER  BY excsm.excsm_exch_cd  
              , excsm.excsm_seg_cd  
              , prom.prom_desc  
              , enttm.enttm_desc  
              , clicm.clicm_desc  
              , accdocmm.accdocm_cd
    --  
  END  
  ELSE IF @PA_ACTION = 'ACCPM_SEARCH'
    BEGIN
    --
      SELECT DISTINCT accpm.accpm_prop_cd   accpm_prop_cd
            --,accpm.accpm_id                 accpm_id
            ,accpm.accpm_prop_id            accpm_prop_id
            ,accpm.accpm_prop_desc          accpm_prop_desc
            ,accpm.accpm_acct_type          accpm_acct_type
      FROM   account_property_mstr          accpm  with(nolock)
      WHERE  accpm.accpm_deleted_ind = 1
    --
    END
    ELSE IF @PA_ACTION = 'ACCPM_SEARCHM'
    BEGIN
    --
      SELECT DISTINCT accpmm.accpm_prop_cd   accpm_prop_cd
            --,accpmm.accpm_id                 accpm_id
            ,accpmm.accpm_prop_id            accpm_prop_id
            ,accpmm.accpm_prop_desc          accpm_prop_desc
            ,accpmm.accpm_acct_type          accpm_acct_type
      FROM   accpm_mak                       accpmm   with(nolock)
      WHERE  accpmm.accpm_deleted_ind IN (0, 4, 6)
      AND    accpmm.accpm_created_by   = @PA_LOGIN_NAME
    --
    END
    ELSE IF @PA_ACTION = 'ACCPM_SEARCHC'
    BEGIN
    --
      SELECT DISTINCT accpmm.accpm_prop_cd   accpm_prop_cd
            ,accpmm.accpm_id                 accpm_id
            ,accpmm.accpm_prop_id            accpm_prop_id
            ,accpmm.accpm_prop_desc          accpm_prop_desc
            ,accpmm.accpm_acct_type          accpm_acct_type
      FROM   accpm_mak                       accpmm   with(nolock)
      WHERE  accpmm.accpm_deleted_ind IN (0, 4, 6)
      AND    accpmm.accpm_created_by   <> @PA_LOGIN_NAME
    --
    END
    IF @PA_ACTION ='RACCPM'    
    BEGIN    
    --    
      SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd    
           , excsm.excsm_seg_cd    excsm_seg_cd    
           , prom.prom_id          prom_id    
           , prom.prom_desc        prom_desc    
           , enttm.enttm_id        enttm_id    
           , enttm.enttm_desc      enttm_desc    
           , clicm.clicm_id        clicm_id    
           , clicm.clicm_desc      clicm_desc    
           , accpm.accpm_id        accpm_id    
           , accpm.accpm_prop_cd   accpm_prop_cd    
           , accpm.accpm_prop_desc accpm_prop_desc    
           , accpm.accpm_prop_rmks accpm_prop_rmks 
           , accpm.accpm_acct_type accpm_acct_type
           , excsm.excsm_exch_cd  + '-' + excsm.excsm_seg_cd    excsm_cd    
           , case accpm.accpm_mdty when 1 then 'M' else 'N'end   accpm_mdty
           , accpm.accpm_deleted_ind  accpm_deleted_ind
           , accpm.accpm_datatype     accpm_datatype    
       FROM  account_property_mstr accpm   with(nolock)  
           , exch_seg_mstr         excsm   with(nolock)   
           , client_ctgry_mstr     clicm   with(nolock)  
           , entity_type_mstr      enttm   with(nolock)  
           , excsm_prod_mstr       excpm   with(nolock)  
           , product_mstr          prom    with(nolock) 
       WHERE accpm.accpm_excpm_id         = excpm.excpm_id    
       AND   accpm.accpm_clicm_id         = clicm.clicm_id    
       AND   accpm.accpm_enttm_id         = enttm.enttm_id    
       AND   prom.prom_id                 = excpm.excpm_prom_id    
       AND   excpm.excpm_excsm_id         = excsm.excsm_id    
       AND   clicm.clicm_deleted_ind      = 1    
       AND   enttm.enttm_deleted_ind      = 1    
       AND   excpm.excpm_deleted_ind      = 1    
       AND   prom.prom_deleted_ind        = 1    
       AND   excsm.excsm_deleted_ind      = 1    
       AND   accpm.accpm_deleted_ind      = 1    
       AND   accpm.accpm_prop_id          = CONVERT(NUMERIC,@PA_CD)    
       ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc    
     --     
     END     
     ELSE IF @PA_ACTION='LACCPM'    
     BEGIN    
     --    
       SELECT DISTINCT excsm.excsm_exch_cd    
             ,excsm.excsm_seg_cd    
             ,prom_desc,prom_id    
       FROM   excsm_prod_mstr excpm           with(nolock)
              left outer join exch_seg_mstr   excsm      with(nolock)
       ON     excpm.excpm_excsm_id          = excsm.excsm_id    
              right outer join product_mstr   prom      with(nolock)
       ON     excpm.excpm_prom_id           = prom.prom_id    
       AND    excpm.excpm_deleted_ind       = 1
       AND    excsm.excsm_deleted_ind       = 1
       AND    prom.prom_deleted_ind         = 1
       ORDER BY excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc    
     --    
     END    
     ELSE IF @PA_ACTION = 'RACCPMMAK' --only show those records which the maker has created.    
     BEGIN    
     --    
       SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd    
            , excsm.excsm_seg_cd             excsm_seg_cd    
            , prom.prom_id                   prom_id    
            , prom.prom_desc                 prom_desc    
            , enttm.enttm_id                 enttm_id    
            , enttm.enttm_desc               enttm_desc    
            , clicm.clicm_id                 clicm_id    
            , clicm.clicm_desc               clicm_desc    
            , CASE  accpmm.accpm_mdty WHEN  1 THEN  'M' ELSE 'N'  END accpm_mdty    
            , accpmm.accpm_deleted_ind       accpm_deleted_ind
        FROM  accpm_mak                      accpmm     with(nolock) 
            , exch_seg_mstr                  excsm     with(nolock)
            , client_ctgry_mstr              clicm     with(nolock)
            , entity_type_mstr               enttm     with(nolock)
            , excsm_prod_mstr                excpm     with(nolock)
            , product_mstr                   prom     with(nolock)
        WHERE accpmm.accpm_excpm_id          = excpm.excpm_id    
        AND   accpmm.accpm_clicm_id          = clicm.clicm_id    
        AND   accpmm.accpm_enttm_id          = enttm.enttm_id    
        AND   prom.prom_id                   = excpm.excpm_prom_id    
        AND   excpm.excpm_excsm_id           = excsm.excsm_id    
        AND   clicm.clicm_deleted_ind        = 1    
        AND   enttm.enttm_deleted_ind        = 1    
        AND   excpm.excpm_deleted_ind        = 1    
        AND   prom.prom_deleted_ind          = 1    
        AND   excsm.excsm_deleted_ind        = 1    
        AND   accpmm.accpm_deleted_ind       = 0    
        AND   accpmm.accpm_prop_id           = CONVERT(NUMERIC,@PA_CD)    
        AND   accpmm.accpm_created_by        = @PA_LOGIN_NAME    
        ORDER BY  excsm.excsm_exch_cd    
                , excsm.excsm_seg_cd    
                , prom.prom_desc    
                , enttm.enttm_desc    
                , clicm.clicm_desc    
     --    
     END    
     ELSE IF @PA_ACTION = 'RACCPMCHK' --only show those records which the checker has not created.    
     BEGIN    
     --    
       SELECT DISTINCT excsm.excsm_exch_cd +'-'+excsm.excsm_seg_cd excsm_cd    
            , prom.prom_id                   prom_id    
            , prom.prom_desc                 prom_desc    
            , enttm.enttm_id                 enttm_id    
            , enttm.enttm_desc               enttm_desc    
            , clicm.clicm_id                 clicm_id    
            , clicm.clicm_desc               clicm_desc    
            , accpmm.accpm_id                accpm_id  
            , accpmm.accpm_prop_cd           accpm_prop_cd  
            , accpmm.accpm_prop_desc         accpm_prop_desc  
            , accpmm.accpm_prop_rmks         accpm_prop_rmks   
            , accpmm.accpm_acct_type         accpm_acct_type
            , CASE accpmm.accpm_mdty WHEN 1 THEN 'M'ELSE 'N'END accpm_mdty    
            , accpmm.accpm_deleted_ind       accpm_deleted_ind
            , accpmm.accpm_datatype          accpm_datatype  
       FROM   accpm_mak                      accpmm     with(nolock)
            , exch_seg_mstr                  excsm     with(nolock)
            , client_ctgry_mstr              clicm     with(nolock)
            , entity_type_mstr               enttm     with(nolock)
            , excsm_prod_mstr                excpm     with(nolock)
            , product_mstr                   prom     with(nolock)
       WHERE  accpmm.accpm_excpm_id          = excpm.excpm_id    
       AND    accpmm.accpm_clicm_id          = clicm.clicm_id    
       AND    accpmm.accpm_enttm_id          = enttm.enttm_id    
       AND    prom.prom_id                   = excpm.excpm_prom_id    
       AND    excpm.excpm_excsm_id           = excsm.excsm_id    
       AND    clicm.clicm_deleted_ind        = 1    
       AND    enttm.enttm_deleted_ind        = 1    
       AND    excpm.excpm_deleted_ind        = 1    
       AND    prom.prom_deleted_ind          = 1    
       AND    excsm.excsm_deleted_ind        = 1    
       AND    accpmm.accpm_deleted_ind       IN(0,4,6)
       AND    accpmm.accpm_lst_upd_by        <> @pa_login_name    
       ORDER  BY excsm_cd  
               , prom.prom_desc    
               , enttm.enttm_desc    
               , clicm.clicm_desc    
    --    
    END 
    ELSE IF @PA_ACTION = 'ACCPDM_SEARCH'
    BEGIN
    --
      SELECT DISTINCT accdm.accdm_cd   accdm_cd
            ,accdm.accdm_desc          accdm_desc
      FROM   accpm_dtls_mstr           accdm  with(nolock)
      WHERE  accdm.accdm_deleted_ind = 1
    --
    END
    ELSE IF @PA_ACTION = 'ACCPDM_SEARCHM'
    BEGIN
    --
      SELECT DISTINCT accdmm.accdm_cd    accdm_cd
            ,accdmm.accdm_desc           accdm_desc
      FROM   accdm_mak                   accdmm   with(nolock)
      WHERE  accdmm.accdm_deleted_ind IN (0, 4, 6)
      AND    accdmm.accdm_created_by   = @PA_LOGIN_NAME
    --
    END
    ELSE IF @PA_ACTION = 'ACCPDM_SEARCHC'
    BEGIN
    --
      SELECT DISTINCT accdmm.accdm_cd    accdm_cd
            ,accdmm.accdm_desc           accdm_desc
      FROM   accdm_mak                   accdmm   with(nolock)
      WHERE  accdmm.accdm_deleted_ind IN (0, 4, 6)
      AND    accdmm.accdm_created_by  <> @PA_LOGIN_NAME
    --
    END
    ELSE IF @PA_ACTION = 'ACCPDM_SEL'
    BEGIN
    --
      SELECT DISTINCT accdm.accdm_id        accdm_id
           , accpm.accpm_prop_id            accdm_accpm_id
           , accdm.accdm_cd                 accdm_cd
           , accdm.accdm_desc               accdm_desc
           , accpm.accpm_prop_cd            accpm_cd
           , accdm.accdm_rmks               accdm_rmks
           , accdm_datatype                 accdm_datatype
           , accpm.accpm_datatype           accpm_datatype        
           , ''                             errmsg
           , accdm.accdm_mdty               accdm_mdty 
      FROM   accpm_dtls_mstr                accdm   with(nolock)
           , account_property_mstr          accpm   with(nolock)
      WHERE  accdm.accdm_accpm_prop_id    = accpm.accpm_prop_id
      AND    accdm.accdm_deleted_ind      = 1
      AND    accdm.accdm_cd               LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
      AND    accdm.accdm_desc             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
    --
    END
    ELSE IF @PA_ACTION = 'ACCPDM_SELM'
    BEGIN
    --
      SELECT DISTINCT accdmm.accdm_id        accdm_id
             , accpm.accpm_prop_id           accdm_accpm_id
             , accdmm.accdm_cd               accdm_cd
             , accdmm.accdm_desc             accdm_desc
             , accpm.accpm_prop_cd           accpm_cd
             , accdmm.accdm_rmks             accdm_rmks
             , accdmm.accdm_datatype         accdm_datatype
             , accpm.accpm_datatype          accpm_datatype    
             , ''                            errmsg
             , accdmm.accdm_mdty             accdm_mdty
      FROM   accdm_mak                       accdmm  with(nolock)
           , account_property_mstr            accpm   with(nolock)
      WHERE  accdmm.accdm_accpm_prop_id    = accpm.accpm_prop_id
      AND    accdmm.accdm_deleted_ind      IN (0, 4, 6)
      AND    accdmm.accdm_cd               LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
      AND    accdmm.accdm_desc             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
      AND    accdmm.accdm_created_by       = @PA_LOGIN_NAME
    --
    END
    ELSE IF @PA_ACTION = 'ACCPDM_SELC'
    BEGIN
    --
      SELECT DISTINCT accdmm.accdm_id        accdm_id
           , accpm.accpm_prop_id             accdm_accpm_id
           , accdmm.accdm_cd                 accdm_cd
           , accdmm.accdm_desc               accdm_desc
           , accpm.accpm_prop_cd             accpm_cd
           , accdmm.accdm_rmks               accdm_rmks
           , accdmm.accdm_datatype           accdm_datatype   
           , accpm.accpm_datatype            accpm_datatype  
           , ''                              errmsg
           , accdmm.accdm_mdty               accdm_mdty
      FROM   accdm_mak                       accdmm   with(nolock)
           , account_property_mstr           accpm    with(nolock)
      WHERE  accdmm.accdm_accpm_prop_id    = accpm.accpm_prop_id
      AND    accdmm.accdm_deleted_ind      IN (0, 4, 6)
      AND    accdmm.accdm_cd               LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
      AND    accdmm.accdm_desc             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
      AND    accdmm.accdm_lst_upd_by       <> @PA_LOGIN_NAME
    --
  END  
--
END

GO
