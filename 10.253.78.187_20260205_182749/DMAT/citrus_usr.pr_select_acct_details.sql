-- Object: PROCEDURE citrus_usr.pr_select_acct_details
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[pr_select_acct_details](@pa_id             VARCHAR(20)
                                       ,@pa_acct_type      VARCHAR(20) 
                                       ,@pa_tab            VARCHAR(20) 
                                       ,@pa_login_name     VARCHAR(25)
                                       ,@pa_clisba_id      NUMERIC
                                       ,@pa_acct_no        VARCHAR(20)
                                       ,@pa_excpm_id       NUMERIC
                                       ,@pa_clicm_id       NUMERIC
                                       ,@pa_enttm_id       NUMERIC
                                       ,@pa_chk_yn         NUMERIC
                                       ,@rowdelimiter      CHAR(4)
                                       ,@coldelimiter      CHAR(4)
                                       ,@pa_ref_cur        VARCHAR(8000) OUT
                                        )
                                
                                
AS
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : pr_select_acct_details
 DESCRIPTION    : This procedure will select data related to client_account
 COPYRIGHT(C)   : Marketplacetechnologies pvt ltd
 VERSION HISTORY:
 VERS.  AUTHOR             DATE        REASON
 -----  -------------      ----------  -------------------------------------------------
 1.0    TUSHAR             04-MAY-2007 INITIAL VERSION.
--------------------------------------------------------------------------------------*/
BEGIN
--

  DECLARE @values1            varchar(8000)
        , @values2            varchar(8000)
        , @c_access_cursor    cursor 
        , @desc               varchar(50)  
  --      
  SET @values1 = ''
  SET @values2 = ''
  SET @rowdelimiter ='*|~*'
  SET @coldelimiter ='|*~|'        
       
  IF @pa_chk_yn = 0 OR @pa_chk_yn = 2
  BEGIN
  --
    IF @pa_tab = 'ACCP'
    BEGIN
    --
      /*SELECT DISTINCT a.prom_id                      prom_id
           , a.accpm_prop_id                         accpm_prop_id
           , a.accpm_prop_desc                       accpm_prop_desc
           , ISNULL(a.accp_value, ' ')               accp_value
           , a.accpm_datatype                        accpm_datatype
           , a.accpm_mdty                            accpm_mdty
           , accdm.accdm_id                          accdm_id
           , accdm.accdm_desc                        accdm_desc
           , ISNULL(accpd.accpd_value, ' ')          accpd_value
           , LTRIM(RTRIM(accdm.accdm_datatype))      accdm_datatype
      FROM  (SELECT DISTINCT accpm.accpm_prop_desc   accpm_prop_desc
                   , accpm.accpm_prop_id             accpm_prop_id
                   , accpm.accpm_mdty                accpm_mdty
                   , accp.accp_value                 accp_value
                   , accpm.accpm_datatype            accpm_datatype
                   , prom.prom_id                    prom_id
              FROM   account_properties              accp
                     right outer join
                     account_property_mstr           accpm 
                     on accp.accp_accpm_prop_id       = accpm.accpm_prop_id 
                     AND    ISNULL(accp.accp_acct_no, 0)  = ISNULL(@pa_acct_no, 0)
                     AND    accp.accp_clisba_id           = @pa_clisba_id   
                   , excsm_prod_mstr                 excpm
                   , product_mstr                    prom
              WHERE  prom.prom_id                  = excpm.excpm_prom_id
              AND    accpm.accpm_excpm_id          = excpm.excpm_id
              AND    ISNULL(accp.accp_deleted_ind, 1) = 1
              AND    accpm.accpm_deleted_ind       = 1
              AND    excpm.excpm_deleted_ind       = 1
              AND    prom.prom_deleted_ind         = 1
              AND    excpm.excpm_id                = @pa_excpm_id           
              AND    accpm.accpm_clicm_id          = @pa_clicm_id           
              AND    accpm.accpm_enttm_id          = @pa_enttm_id           
              AND    accpm.accpm_acct_type         = @pa_acct_type 
              ) a left outer join accpm_dtls_mstr accdm ON a.accpm_prop_id = accdm.accdm_accpm_prop_id 
              left outer join account_property_dtls accpd ON accdm.accdm_id= accpd.accpd_accdm_id 
      WHERE  isnull(accpd.accpd_deleted_ind, 1)    = 1
      AND    accdm.accdm_deleted_ind               = 1*/
      SELECT DISTINCT a.prom_id                      prom_id
           , a.accpm_prop_id                         accpm_prop_id
           , a.accpm_prop_desc                       accpm_prop_desc
           , ISNULL(a.accp_value, ' ')               accp_value
           , a.accpm_datatype                        accpm_datatype
           , a.accpm_mdty                            accpm_mdty
           , b.accdm_mdty                            accdm_mdty
           , ISNULL(b.accdm_id,0)                    accdm_id
           , ISNULL(b.accdm_desc,'')                 accdm_desc
           , ISNULL(b.accpd_value, ' ')              accpd_value
           , ISNULL(LTRIM(RTRIM(b.accdm_datatype)),'') accdm_datatype
      FROM  (SELECT DISTINCT accpm.accpm_prop_desc   accpm_prop_desc
                   , accpm.accpm_prop_id             accpm_prop_id
                   , CASE accpm.accpm_mdty WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty
                   , accp.accp_value                 accp_value
                   , accpm.accpm_datatype            accpm_datatype
                   , prom.prom_id                    prom_id
              FROM   account_properties              accp
                     right outer join
                     account_property_mstr           accpm 
                     on accp.accp_accpm_prop_id       = accpm.accpm_prop_id 
                     --AND    ISNULL(accp.accp_acct_no, '')  = ISNULL(@pa_acct_no, '')
                     AND    accp.accp_clisba_id           = @pa_clisba_id
                     AND    ISNULL(accp.accp_deleted_ind, 1) = 1
                   , excsm_prod_mstr                 excpm
                   , product_mstr                    prom
              WHERE  prom.prom_id                  = excpm.excpm_prom_id
              AND    accpm.accpm_excpm_id          = excpm.excpm_id
              AND    accpm.accpm_deleted_ind       = 1
              AND    excpm.excpm_deleted_ind       = 1
              AND    prom.prom_deleted_ind         = 1
              AND    excpm.excpm_id                = @pa_excpm_id          
              AND    accpm.accpm_clicm_id          = @pa_clicm_id         
              AND    accpm.accpm_enttm_id          = @pa_enttm_id         
              AND    accpm.accpm_acct_type         = @pa_acct_type 
              ) a left outer join 
              (SELECT accdm_id
                     ,accdm_desc
                     ,accpd_value
                     ,accdm_datatype 
                     ,accdm_accpm_prop_id
                     ,CASE accdm.accdm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdm_mdty
              FROM    accpm_dtls_mstr accdm 
              left outer join account_property_dtls accpd 
              ON      accdm.accdm_id= accpd.accpd_accdm_id 
              AND     accpd_accp_id IN (SELECT accp_id FROM account_properties  WITH (NOLOCK) WHERE accp_clisba_id = @pa_clisba_id AND accp_deleted_ind = 1)
              AND     accpd.accpd_deleted_ind = 1
              WHERE   accdm.accdm_deleted_ind = 1 
              ) b
              ON      a.accpm_prop_id = b.accdm_accpm_prop_id 
    --
    END
    IF @pa_tab = 'ACCD'
    BEGIN
    --
       SELECT DISTINCT prom.prom_id                          prom_id  
            , ISNULL(prom.prom_desc,'')             prom_desc
            , ISNULL(accd.accd_doc_path,'')         accd_doc_path  
            , ISNULL(accd.accd_remarks,'')          accd_remarks    
            , accdocm.accdocm_doc_id                accdocm_doc_id  
            , ISNULL(accdocm.accdocm_desc,'')       accdocm_desc  
            , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
            , ISNULL(accd.accd_valid_yn,0)          accd_valid_yn
       FROM   account_document_mstr accdocm  WITH(NOLOCK)  
              LEFT OUTER JOIN
              account_documents     accd     WITH(NOLOCK)   
              ON   accdocm.accdocm_doc_id               = accd.accd_accdocm_doc_id 
              AND  accd.accd_clisba_id                  = ISNULL(@pa_clisba_id,0)
              AND    accd.accd_acct_type                = ISNULL(@pa_acct_type,'')
            , exch_seg_mstr         excsm    WITH(NOLOCK)  
            , excsm_prod_mstr       excpm    WITH(NOLOCK)  
            , product_mstr          prom     WITH(NOLOCK)  
       WHERE  accdocm.accdocm_excpm_id             = excpm.excpm_id  
       AND    prom.prom_id                         = excpm.excpm_prom_id  
       AND    excpm.excpm_excsm_id                 = excsm.excsm_id 
       AND    accdocm.accdocm_clicm_id             = @pa_clicm_id
       AND    accdocm.accdocm_enttm_id             = @pa_enttm_id
       AND    excpm.excpm_id                       = @pa_excpm_id 
       AND    excpm.excpm_deleted_ind              = 1  
       AND    ISNULL(accd_deleted_ind, 1)          = 1
       AND    prom.prom_deleted_ind                = 1  
       AND    excsm.excsm_deleted_ind              = 1  
       AND    accdocm.accdocm_deleted_ind          = 1  
       
       ORDER  BY accdocm_desc
    --
    END
    IF @pa_tab = 'ACCT_ADDR'
    BEGIN
    --
      /*SELECT  concm.concm_cd                   concm_cd
            , concm.concm_desc                 concm_desc
            , ISNULL(a.adr_1,'')               adr_1    
            --, ISNULL(a.value, ' ')             value
            , concm.concm_cd+'|*~|'+a.adr_1+'|*~|'+ISNULL(a.adr_2,'')+'|*~|'+ISNULL(a.adr_3,'')+'|*~|'+ISNULL(a.adr_city,'')+'|*~|'+ISNULL(a.adr_state,'')+'|*~|'+ISNULL(a.adr_country,'')+'|*~|'+ISNULL(a.adr_zip,'')+'|*~|'+'*|~*' value
       FROM  (SELECT accac.accac_concm_id      concm_id
                   , adr.adr_1                 adr_1
                   , adr.adr_2                 adr_2
                   , adr.adr_3                 adr_3
                   , adr.adr_city              adr_city
                   , adr.adr_state             adr_state
                   , adr.adr_country           adr_country
                   , adr.adr_zip               adr_zip
      --             , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+adr.adr_2+'|*~|'+adr.adr_3+'|*~|'+adr.adr_city+'|*~|'+adr.adr_state+'|*~|'+adr.adr_country+'|*~|'+adr.adr_zip value
              FROM   addresses                 adr    WITH (NOLOCK)
                   , account_adr_conc          accac  WITH (NOLOCK)
              WHERE  accac.accac_adr_conc_id = adr.adr_id
              AND    accac.accac_clisba_id   = @pa_clisba_id
              AND    accac.accac_acct_no     = @pa_acct_no
              AND    adr.adr_deleted_ind     = 1
              AND    accac.accac_deleted_ind = 1
             ) a
              RIGHT OUTER JOIN
              conc_code_mstr                   concm  WITH (NOLOCK)
              ON concm.concm_id              = a.concm_id
       WHERE  concm.concm_deleted_ind        = 1
       AND    1 & concm.concm_cli_yn         = 1
       AND    2 & concm.concm_cli_yn         = 0
       ORDER  BY concm.concm_desc*/
       --
       SET    @c_access_cursor =  CURSOR fast_forward FOR
       SELECT  concm.concm_cd+'|*~|'+a.adr_1+'|*~|'+ISNULL(a.adr_2,'')+'|*~|'+ISNULL(a.adr_3,'')+'|*~|'+ISNULL(a.adr_city,'')+'|*~|'+ISNULL(a.adr_state,'')+'|*~|'+ISNULL(a.adr_country,'')+'|*~|'+ISNULL(a.adr_zip,'')+'|*~|'+concm.concm_desc+'|*~|'+'*|~*' value
       FROM  (SELECT accac.accac_concm_id      concm_id
                   , adr.adr_1                 adr_1
                   , adr.adr_2                 adr_2
                   , adr.adr_3                 adr_3
                   , adr.adr_city              adr_city
                   , adr.adr_state             adr_state
                   , adr.adr_country           adr_country
                   , adr.adr_zip               adr_zip
      --             , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+adr.adr_2+'|*~|'+adr.adr_3+'|*~|'+adr.adr_city+'|*~|'+adr.adr_state+'|*~|'+adr.adr_country+'|*~|'+adr.adr_zip value
              FROM   addresses                 adr    WITH (NOLOCK)
                   , account_adr_conc          accac  WITH (NOLOCK)
              WHERE  accac.accac_adr_conc_id = adr.adr_id
              AND    accac.accac_clisba_id   = @pa_clisba_id
              AND    accac.accac_acct_no     = @pa_acct_no
              AND    adr.adr_deleted_ind     = 1
              AND    accac.accac_deleted_ind = 1
             ) a
              RIGHT OUTER JOIN
              conc_code_mstr                   concm  WITH (NOLOCK)
              ON concm.concm_id              = a.concm_id
       WHERE  concm.concm_deleted_ind        = 1
       AND    1 & concm.concm_cli_yn         = 1
       AND    2 & concm.concm_cli_yn         = 0
       ORDER  BY concm.concm_desc
       --
       OPEN @c_access_cursor
       FETCH NEXT FROM @c_access_cursor INTO @values1
       --
       WHILE @@fetch_status = 0
       BEGIN
        --
        SET @values2 = ISNULL(@values1,'') +@values2
        FETCH NEXT FROM @c_access_cursor INTO @values1
        --
       END
       --
       CLOSE @c_access_cursor
       deallocate @c_access_cursor
       --
       SELECT @values2 value
       
    --
    END
    IF @pa_tab = 'ACCT_CONC'
    BEGIN
    --
      /*SELECT concm.concm_cd                   concm_cd
           , concm.concm_desc                 concm_desc
           , isnull(a.conc_value, ' ')        value
      FROM  (SELECT accac.accac_concm_id      concm_id
                  , conc.conc_value           conc_value
             FROM   contact_channels          conc  WITH (NOLOCK)
                  , account_adr_conc          accac WITH (NOLOCK)
             WHERE  accac.accac_adr_conc_id = conc.conc_id
             AND    accac.accac_clisba_id   = @pa_clisba_id 
             AND    accac.accac_acct_no     = @pa_acct_no
             AND    conc.conc_deleted_ind   = 1
             AND    accac.accac_deleted_ind = 1
            ) a
             RIGHT OUTER JOIN
             conc_code_mstr                     concm  WITH (NOLOCK)
             ON concm.concm_id=a.concm_id
      WHERE  concm.concm_deleted_ind        = 1
      AND    1 & concm.concm_cli_yn         = 1
      AND    2 & concm.concm_cli_yn         = 2
      ORDER  BY concm.concm_desc*/
      --
      SET    @c_access_cursor =  CURSOR fast_forward FOR
      SELECT ISNULL(concm.concm_cd+@coldelimiter+a.conc_value+@coldelimiter+concm.concm_desc+@coldelimiter+@rowdelimiter,'') value
      FROM  (SELECT accac.accac_concm_id      concm_id
                  , conc.conc_value           conc_value
             FROM   contact_channels          conc  WITH (NOLOCK)
                  , account_adr_conc          accac WITH (NOLOCK)
             WHERE  accac.accac_adr_conc_id = conc.conc_id
             AND    accac.accac_clisba_id   = @pa_clisba_id 
             AND    accac.accac_acct_no     = @pa_acct_no
             AND    conc.conc_deleted_ind   = 1
             AND    accac.accac_deleted_ind = 1
            ) a
             RIGHT OUTER JOIN
             conc_code_mstr                     concm  WITH (NOLOCK)
             ON concm.concm_id=a.concm_id
      WHERE  concm.concm_deleted_ind        = 1
      AND    1 & concm.concm_cli_yn         = 1
      AND    2 & concm.concm_cli_yn         = 2
      ORDER  BY concm.concm_desc
      --
      OPEN @c_access_cursor
      FETCH NEXT FROM @c_access_cursor INTO @values1
      --
      WHILE @@fetch_status = 0
      BEGIN
       --
       SET @values2 = ISNULL(@values1,'') +@values2
       FETCH NEXT FROM @c_access_cursor INTO @values1
       --
      END
      --
      CLOSE @c_access_cursor
      deallocate @c_access_cursor
      --
       SELECT @values2 value
      
    --
    END
  --
  END
  IF @pa_chk_yn = 1
    BEGIN
    --
      IF @pa_tab = 'ACCP'
      BEGIN
      --
        SELECT DISTINCT a.prom_id                      prom_id
             , a.accpm_prop_id                         accpm_prop_id
             , a.accpm_prop_desc                       accpm_prop_desc
             , ISNULL(a.accp_value, ' ')               accp_value
             , a.accpm_datatype                        accpm_datatype
             , a.accpm_mdty                            accpm_mdty
             , b.accdm_mdty                            accdm_mdty
             , ISNULL(b.accdm_id,0)                    accdm_id
             , ISNULL(b.accdm_desc,'')                 accdm_desc
             , ISNULL(b.accpd_value, ' ')              accpd_value
             , ISNULL(LTRIM(RTRIM(b.accdm_datatype)),'') accdm_datatype
        FROM  (SELECT DISTINCT accpm.accpm_prop_desc   accpm_prop_desc
                    , accpm.accpm_prop_id              accpm_prop_id
                    , CASE accpm.accpm_mdty WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty
                    , accp.accp_value                  accp_value
                    , accpm.accpm_datatype             accpm_datatype
                    , prom.prom_id                     prom_id
               FROM   accp_mak                         accp
                      right outer join
                      account_property_mstr            accpm 
                      on accp.accp_accpm_prop_id              = accpm.accpm_prop_id 
                      --AND    ISNULL(accp.accp_acct_no, '')    = ISNULL(@pa_acct_no, '')
                      AND    accp.accp_clisba_id              = @pa_clisba_id
                      AND    ISNULL(accp.accp_deleted_ind, 0) IN (0,4,8)
                    , excsm_prod_mstr                  excpm
                    , product_mstr                     prom
               WHERE  prom.prom_id                   = excpm.excpm_prom_id
               AND    accpm.accpm_excpm_id           = excpm.excpm_id
               AND    accpm.accpm_deleted_ind        = 1
               AND    excpm.excpm_deleted_ind        = 1
               AND    prom.prom_deleted_ind          = 1
               AND    excpm.excpm_id                 = @pa_excpm_id          
               AND    accpm.accpm_clicm_id           = @pa_clicm_id         
               AND    accpm.accpm_enttm_id           = @pa_enttm_id         
               AND    accpm.accpm_acct_type          = @pa_acct_type 
               ) a left outer join 
               (SELECT accdm_id
                      ,accdm_desc
                      ,accpd_value
                      ,accdm_datatype 
                      ,accdm_accpm_prop_id
                      ,CASE accdm.accdm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdm_mdty
               FROM    accpm_dtls_mstr accdm 
               left outer join accpd_mak accpd 
               ON      accdm.accdm_id= accpd.accpd_accdm_id 
               AND     accpd_accp_id IN (SELECT accp_id FROM accp_mak  WITH (NOLOCK) WHERE accp_clisba_id = @pa_clisba_id AND accp_deleted_ind in (0,8))
               AND     accpd.accpd_deleted_ind IN (0,4,8)
               WHERE   accdm.accdm_deleted_ind = 1 
               ) b
        ON      a.accpm_prop_id = b.accdm_accpm_prop_id 
               
        UNION       
               
        SELECT DISTINCT a.prom_id                      prom_id
             , a.accpm_prop_id                         accpm_prop_id
             , a.accpm_prop_desc                       accpm_prop_desc
             , ISNULL(a.accp_value, ' ')               accp_value
             , a.accpm_datatype                        accpm_datatype
             , a.accpm_mdty                            accpm_mdty
             , b.accdm_mdty                            accdm_mdty
             , ISNULL(b.accdm_id,0)                    accdm_id
             , ISNULL(b.accdm_desc,'')                 accdm_desc
             , ISNULL(b.accpd_value, ' ')              accpd_value
             , ISNULL(LTRIM(RTRIM(b.accdm_datatype)),'') accdm_datatype
        FROM  (SELECT DISTINCT accpm.accpm_prop_desc   accpm_prop_desc
                    , accpm.accpm_prop_id             accpm_prop_id
                    , CASE accpm.accpm_mdty WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty
                    , accp.accp_value                 accp_value
                    , accpm.accpm_datatype            accpm_datatype
                    , prom.prom_id                    prom_id
               FROM   account_properties              accp
                      right outer join
                      account_property_mstr           accpm 
                      on accp.accp_accpm_prop_id       = accpm.accpm_prop_id 
                      --AND    ISNULL(accp.accp_acct_no, '')  = ISNULL(@pa_acct_no, '')
                      AND    accp.accp_clisba_id           = @pa_clisba_id
                      AND    ISNULL(accp.accp_deleted_ind, 1) = 1
                    , excsm_prod_mstr                 excpm
                    , product_mstr                    prom
               WHERE  prom.prom_id                  = excpm.excpm_prom_id
               AND    accpm.accpm_excpm_id          = excpm.excpm_id
               AND    accpm.accpm_deleted_ind       = 1
               AND    excpm.excpm_deleted_ind       = 1
               AND    prom.prom_deleted_ind         = 1
               AND    excpm.excpm_id                = @pa_excpm_id          
               AND    accpm.accpm_clicm_id          = @pa_clicm_id         
               AND    accpm.accpm_enttm_id          = @pa_enttm_id         
               AND    accpm.accpm_acct_type         = @pa_acct_type 
               AND    accp.accp_accpm_prop_id       NOT IN(SELECT accp_accpm_prop_id FROM accp_mak WHERE  accp_deleted_ind IN (0,8) AND accp_clisba_id =@pa_clisba_id)
               ) a left outer join 
               (SELECT accdm_id
                      ,accdm_desc
                      ,accpd_value
                      ,accdm_datatype 
                      ,accdm_accpm_prop_id 
                      , CASE accdm.accdm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdm_mdty
               FROM    accpm_dtls_mstr accdm 
               left outer join account_property_dtls accpd 
               ON      accdm.accdm_id= accpd.accpd_accdm_id 
               AND     accpd_accp_id IN (SELECT accp_id FROM account_properties  WITH (NOLOCK) WHERE accp_clisba_id = @pa_clisba_id AND accp_deleted_ind = 1)
               AND     accpd.accpd_deleted_ind = 1
               WHERE   accdm.accdm_deleted_ind = 1 
               ) b
               ON      a.accpm_prop_id = b.accdm_accpm_prop_id 
      --
      END
      IF @pa_tab = 'ACCD'
      BEGIN
      --
        SELECT DISTINCT prom.prom_id                 prom_id  
             , ISNULL(prom.prom_desc,'')             prom_desc
             , ISNULL(accd.accd_doc_path,'')         accd_doc_path  
             , ISNULL(accd.accd_remarks,'')          accd_remarks    
             , accdocm.accdocm_doc_id                accdocm_doc_id  
             , ISNULL(accdocm.accdocm_desc,'')       accdocm_desc  
             , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
             , ISNULL(accd.accd_valid_yn,0)          accd_valid_yn
        FROM   account_document_mstr accdocm         WITH(NOLOCK)  
               LEFT OUTER JOIN
               accd_mak              accd            WITH(NOLOCK)   
               ON   accdocm.accdocm_doc_id         = accd.accd_accdocm_doc_id 
               AND  accd.accd_clisba_id            = ISNULL(@pa_clisba_id,0)
               AND  accd.accd_acct_type            = ISNULL(@pa_acct_type,'')
               AND    ISNULL(accd_deleted_ind, 0)    IN (0,4,8)
             , exch_seg_mstr         excsm           WITH(NOLOCK)  
             , excsm_prod_mstr       excpm           WITH(NOLOCK)  
             , product_mstr          prom            WITH(NOLOCK)  
        WHERE  accdocm.accdocm_excpm_id            = excpm.excpm_id  
        AND    prom.prom_id                        = excpm.excpm_prom_id  
        AND    excpm.excpm_excsm_id                = excsm.excsm_id 
        AND    accdocm.accdocm_clicm_id            = @pa_clicm_id
        AND    accdocm.accdocm_enttm_id            = @pa_enttm_id
        AND    excpm.excpm_id                      = @pa_excpm_id 
        AND    excpm.excpm_deleted_ind             = 1  
        AND    prom.prom_deleted_ind               = 1  
        AND    excsm.excsm_deleted_ind             = 1  
        AND    accdocm.accdocm_deleted_ind         = 1  
        
        UNION
        
        SELECT DISTINCT prom.prom_id                 prom_id  
             , ISNULL(prom.prom_desc,'')             prom_desc
             , ISNULL(accd.accd_doc_path,'')         accd_doc_path  
             , ISNULL(accd.accd_remarks,'')          accd_remarks    
             , accdocm.accdocm_doc_id                accdocm_doc_id  
             , ISNULL(accdocm.accdocm_desc,'')       accdocm_desc  
             , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
             , ISNULL(accd.accd_valid_yn,0)          accd_valid_yn
        FROM   account_document_mstr accdocm  WITH(NOLOCK)  
               LEFT OUTER JOIN
               account_documents     accd     WITH(NOLOCK)   
               ON   accdocm.accdocm_doc_id               = accd.accd_accdocm_doc_id 
             
             , exch_seg_mstr         excsm    WITH(NOLOCK)  
             , excsm_prod_mstr       excpm    WITH(NOLOCK)  
             , product_mstr          prom     WITH(NOLOCK)  
        WHERE  accdocm.accdocm_excpm_id             = excpm.excpm_id  
        AND    prom.prom_id                         = excpm.excpm_prom_id  
        AND    excpm.excpm_excsm_id                 = excsm.excsm_id 
        AND    accdocm.accdocm_clicm_id             = @pa_clicm_id
        AND    accdocm.accdocm_enttm_id             = @pa_enttm_id
        AND    excpm.excpm_id                       = @pa_excpm_id 
        AND    excpm.excpm_deleted_ind              = 1  
        AND    prom.prom_deleted_ind                = 1  
        AND    excsm.excsm_deleted_ind              = 1  
        AND    accdocm.accdocm_deleted_ind          = 1  
        AND  accd.accd_clisba_id                  = ISNULL(@pa_clisba_id,0)
        AND    accd.accd_acct_type                = ISNULL(@pa_acct_type,'')
        AND    ISNULL(accd_deleted_ind, 1)        = 1
        ORDER  BY accdocm_desc
      --
      END
      IF @pa_tab = 'ACCT_ADDR'
      BEGIN
      --
        SET    @c_access_cursor =  CURSOR fast_forward FOR
        SELECT addam.adr_concm_cd+@coldelimiter+isnull(addam.adr_1,' ')+@coldelimiter+isnull(addam.adr_2,' ')+@coldelimiter+isnull(addam.adr_3,' ')+@coldelimiter+isnull(addam.adr_city,' ')+@coldelimiter+isnull(addam.adr_state,' ')+@coldelimiter+isnull(addam.adr_country,' ')+@coldelimiter+isnull(addam.adr_zip,' ')+@coldelimiter+concm.concm_desc+@coldelimiter+@rowdelimiter value
             --, concm.concm_cd               concm_cd
             , concm.concm_desc             concm_desc
             --, ISNULL(addam.adr_1, ' ')     adr_1
        FROM   addr_acct_mak                addam
               RIGHT OUTER JOIN
               conc_code_mstr               concm ON concm.concm_id=addam.adr_concm_id  AND addam.adr_deleted_ind IN (0, 8) AND  addam.adr_clisba_id = @pa_clisba_id
        WHERE  concm.concm_deleted_ind      = 1
        AND    1 & concm.concm_cli_yn       = 1
        AND    2 & concm.concm_cli_yn       = 0
        UNION 
        SELECT  concm.concm_cd+@coldelimiter+isnull(a.adr_1,' ')+@coldelimiter+isnull(a.adr_2,' ')+@coldelimiter+isnull(a.adr_3,' ')+@coldelimiter+isnull(a.adr_city,' ')+@coldelimiter+isnull(a.adr_state,' ')+@coldelimiter+isnull(a.adr_country,' ')+@coldelimiter+isnull(a.adr_zip,' ')+@coldelimiter++concm.concm_desc+@coldelimiter+@rowdelimiter value 
              --, concm.concm_cd                   concm_cd
              , concm.concm_desc                 concm_desc
              --, ISNULL(a.adr_1,'')               adr_1    
        FROM  (SELECT accac.accac_concm_id      concm_id
                    , adr.adr_1                 adr_1
                    , adr.adr_2                 adr_2
                    , adr.adr_3                 adr_3
                    , adr.adr_city              adr_city
                    , adr.adr_state             adr_state
                    , adr.adr_country           adr_country
                    , adr.adr_zip               adr_zip
       --           , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+adr.adr_2+'|*~|'+adr.adr_3+'|*~|'+adr.adr_city+'|*~|'+adr.adr_state+'|*~|'+adr.adr_country+'|*~|'+adr.adr_zip value
               FROM   addresses                 adr    WITH (NOLOCK)
                    , account_adr_conc          accac  WITH (NOLOCK)
               WHERE  accac.accac_adr_conc_id = adr.adr_id
               AND    accac.accac_clisba_id   = @pa_clisba_id
               AND    accac.accac_acct_no     = @pa_acct_no
               AND    adr.adr_deleted_ind     = 1
               AND    accac.accac_deleted_ind = 1
              ) a
               RIGHT OUTER JOIN
               conc_code_mstr                   concm  WITH (NOLOCK)
               ON concm.concm_id              = a.concm_id
        WHERE  concm.concm_deleted_ind        = 1
        AND    1 & concm.concm_cli_yn         = 1
        AND    2 & concm.concm_cli_yn         = 0
        AND    concm.concm_id NOT IN ( SELECT addam.adr_concm_id    adr_concm_id
                                       FROM   addr_acct_mak         addam
                                       WHERE  addam.adr_clisba_id   = @pa_clisba_id
                                       AND    addam.adr_deleted_ind IN (0, 4, 8)
                                     )
        ORDER  BY concm.concm_desc
        --
        OPEN @c_access_cursor
        --
        FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
        --
        WHILE @@fetch_status = 0
        BEGIN
         --
         SET @values2 = isnull(@values1,'')+@values2
         --
         FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
         --
        END
        --
        close @c_access_cursor
        deallocate @c_access_cursor
        --
        SELECT @values2 value
      --
      END
      IF @pa_tab = 'ACCT_CONC'
      BEGIN
      --
        SET    @c_access_cursor =  CURSOR fast_forward FOR
        SELECT --isnull(concam.conc_value, ' ')  value
               concm.concm_cd+@coldelimiter+isnull(concam.conc_value,' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
             --, concm.concm_cd                  concm_cd
             , concm.concm_desc                concm_desc
        FROM   conc_acct_mak                   concam
               RIGHT OUTER JOIN
               conc_code_mstr                  concm  WITH (NOLOCK)
               ON concm.concm_id = concam.conc_concm_id AND concam.conc_clisba_id = @pa_clisba_id AND concam.conc_deleted_ind IN (0, 8)
        WHERE  concm.concm_deleted_ind        = 1
        AND    1 & concm.concm_cli_yn         = 1
        UNION
        SELECT --isnull(a.conc_value, ' ')        value
               concm.concm_cd+@coldelimiter+isnull(a.conc_value,' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
             --, concm.concm_cd                   concm_cd
             , concm.concm_desc                 concm_desc
        FROM  (SELECT accac.accac_concm_id      concm_id
                    , conc.conc_value           conc_value
               FROM   contact_channels          conc  WITH (NOLOCK)
                    , account_adr_conc          accac WITH (NOLOCK)
               WHERE  accac.accac_adr_conc_id = conc.conc_id
               AND    accac.accac_clisba_id   = @pa_clisba_id 
               AND    accac.accac_acct_no     = @pa_acct_no
               AND    conc.conc_deleted_ind   = 1
               AND    accac.accac_deleted_ind = 1
              ) a
               RIGHT OUTER JOIN
               conc_code_mstr                     concm  WITH (NOLOCK)
               ON concm.concm_id=a.concm_id
        WHERE  concm.concm_deleted_ind        = 1
        AND    1 & concm.concm_cli_yn         = 1
        AND    2 & concm.concm_cli_yn         = 2
        AND    concm.concm_id NOT IN (SELECT concam.conc_concm_id     conc_concm_id
                                       FROM   conc_acct_mak           concam
                                       WHERE  concam.conc_clisba_id   = @pa_clisba_id
                                       AND    concam.conc_deleted_ind IN (0, 4, 8)
                                      ) 
        ORDER  BY concm.concm_desc
        OPEN @c_access_cursor
        --
        FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
        --
        WHILE @@fetch_status = 0
        BEGIN
         --
         SET @values2 = isnull(@values1,'')+@values2
         --
         FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
         --
        END
        --
        close @c_access_cursor
        deallocate @c_access_cursor
        --
        SELECT @values2 value
      --
      END
    --
  END
--
END

GO
