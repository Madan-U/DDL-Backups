-- Object: PROCEDURE citrus_usr.pr_select_clisba_app
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--20	pr_select_clisba_app					for get select list of app records at sub_accts_level

CREATE PROCEDURE [citrus_usr].[pr_select_clisba_app](@PA_ID  NUMERIC     
                                     ,@PA_MSG VARCHAR(1000) OUTPUT    
                                     )    
AS    
BEGIN    
--    
  DECLARE @l_temp_tab TABLE(prom_id NUMERIC)    
      
  INSERT INTO @l_temp_tab     
  SELECT DISTINCT prom_id     
  FROM   entity_properties_mak    
        ,entity_property_mstr     
        ,product_mstr    
        ,excsm_prod_mstr    
  WHERE  entp_entpm_prop_id = entpm_prop_id     
  AND    entp_ent_id  = @PA_ID    
  AND    prom_id  = excpm_prom_id    
  AND    entp_deleted_ind    IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT prom_id     
  FROM   client_documents_mak    
        ,document_mstr    
        ,product_mstr    
        ,excsm_prod_mstr    
  WHERE  clid_docm_doc_id = docm_doc_id    
  AND    clid_crn_no  = @PA_ID    
  AND    prom_id     = excpm_prom_id    
  AND    clid_deleted_ind    IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT  prom_id     
  FROM   accp_mak    
        ,account_property_mstr    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts    
        ,client_mstr    
  WHERE  accp_accpm_prop_id = accpm_prop_id    
  AND    clisba_id          = accp_clisba_id    
  AND    accpm_excpm_id     = excpm_id    
  AND    excpm_prom_id      = prom_id    
  AND    clisba_crn_no      = clim_crn_no    
  AND    clim_crn_no        = @PA_ID    
  AND    accp_deleted_ind    IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT  prom_id     
  FROM   accp_mak    
        ,account_property_mstr    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts_mak    
        ,client_mstr    
  WHERE  accp_accpm_prop_id = accpm_prop_id    
  AND    clisba_id          = accp_clisba_id    
  AND    accpm_excpm_id     = excpm_id    
  AND    excpm_prom_id      = prom_id    
  AND    clisba_crn_no      = clim_crn_no    
  AND    clim_crn_no        = @PA_ID    
  AND    accp_deleted_ind    IN (0,4,8)    
  AND    clisba_deleted_ind  IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT  prom_id     
  FROM   accd_mak    
        ,account_document_mstr    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts    
        ,client_mstr    
  WHERE accd_accdocm_doc_id = accdocm_doc_id    
  AND   clisba_id           = accd_clisba_id    
  AND   accdocm_excpm_id    = excpm_id    
  AND   excpm_prom_id       = prom_id    
  AND   clisba_crn_no       = clim_crn_no    
  AND   clim_crn_no         = @PA_ID    
  AND   accd_deleted_ind    IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT  prom_id     
  FROM   accd_mak    
        ,account_document_mstr    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts_mak    
        ,client_mstr    
  WHERE accd_accdocm_doc_id = accdocm_doc_id    
  AND   clisba_id           = accd_clisba_id    
  AND   accdocm_excpm_id    = excpm_id    
  AND   excpm_prom_id       = prom_id    
  AND   clisba_crn_no       = clim_crn_no    
  AND   clim_crn_no         = @PA_ID    
  AND   accd_deleted_ind    IN (0,4,8)    
  AND   clisba_deleted_ind  IN (0,4,8)    
      
  UNION     
      
  SELECT DISTINCT  prom_id    
  FROM   entity_relationship_mak    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts    
  WHERE  clisba_no           = entr_sba    
  AND    clisba_excpm_id     = excpm_id    
  AND    excpm_prom_id       = prom_id     
  AND    entr_crn_no         = @PA_ID    
  AND    entr_deleted_ind    IN (0,4,8)    
      
  UNION    
      
  SELECT DISTINCT  prom_id    
  FROM   entity_relationship_mak    
        ,product_mstr    
        ,excsm_prod_mstr    
        ,client_sub_accts_mak    
  WHERE  clisba_no           = entr_sba    
  AND    clisba_excpm_id     = excpm_id    
  AND    excpm_prom_id       = prom_id     
  AND    entr_crn_no         = @PA_ID    
  AND    entr_deleted_ind    IN (0,4,8)    
  AND    clisba_deleted_ind  IN (0,4,8)    
      
  UNION    
      
  SELECT prom.prom_id              prom_id    
  FROM  client_accounts                      clia    WITH (NOLOCK)    
     ,  client_sub_accts_mak                 clisbam  WITH (NOLOCK)    
     ,  excsm_prod_mstr                      excpm    WITH (NOLOCK)    
     ,  exch_seg_mstr          excsm    WITH (NOLOCK)    
     ,  product_mstr                         prom     WITH (NOLOCK)    
     ,  company_mstr                         compm    WITH (NOLOCK)    
     ,  status_mstr                          stam     WITH (NOLOCK)    
     ,  brokerage_mstr                       brom     WITH (NOLOCK)    
     ,  client_dp_accts_mak                  clidpam  WITH (NOLOCK)              
  WHERE  clisbam.clisba_crn_no             = clia.clia_crn_no    
  AND    clisbam.clisba_acct_no            = clia.clia_acct_no    
  AND    clisbam.clisba_excpm_id           = excpm.excpm_id     
  AND    excsm.excsm_id                    = excpm.excpm_excsm_id    
  AND    compm.compm_id                    = excsm.excsm_compm_id    
  AND    prom.prom_id                      = excpm.excpm_prom_id    
  AND    clisbam.clisba_access2            = stam.stam_id    
  AND    clisbam.clisba_brom               = brom.brom_id    
  AND    clisbam.clisba_id                 = clidpam.clidpa_clisba_id    
  AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
  AND    clisbam.clisba_deleted_ind        IN(0,4,8)    
  AND    clidpam.clidpa_deleted_ind        IN(0,4,8)    
  AND    clia.clia_deleted_ind             = 1     
  AND    excpm.excpm_deleted_ind           = 1    
  AND    excsm.excsm_deleted_ind           = 1    
  AND    prom.prom_deleted_ind             = 1    
  AND    compm.compm_deleted_ind           = 1    
  AND    clia.clia_crn_no                  = @PA_ID    
      
  UNION    
      
  SELECT prom.prom_id                        prom_id                     
  FROM   client_accounts                     clia    WITH (NOLOCK)    
     ,   client_sub_accts_mak                clisbam  WITH (NOLOCK)    
     ,   excsm_prod_mstr                     excpm    WITH (NOLOCK)    
     ,   exch_seg_mstr                       excsm    WITH (NOLOCK)    
     ,   product_mstr                        prom     WITH (NOLOCK)    
     ,   company_mstr                        compm    WITH (NOLOCK)    
     ,   status_mstr                         stam     WITH (NOLOCK)    
     ,   brokerage_mstr                      brom     WITH (NOLOCK)    
     ,   client_BANK_accts_mak               clibam  WITH (NOLOCK)              
  WHERE  clisbam.clisba_crn_no             = clia.clia_crn_no    
  AND    clisbam.clisba_acct_no            = clia.clia_acct_no    
  AND    clisbam.clisba_excpm_id           = excpm.excpm_id     
  AND    excsm.excsm_id                    = excpm.excpm_excsm_id    
  AND    compm.compm_id                    = excsm.excsm_compm_id    
  AND    prom.prom_id                      = excpm.excpm_prom_id    
  AND    clisbam.clisba_access2            = stam.stam_id    
  AND    clisbam.clisba_brom               = brom.brom_id    
  AND    clisbam.clisba_id                 = clibam.cliba_clisba_id    
  AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
  AND    clisbam.clisba_deleted_ind        IN(0,4,8)    
  AND    clibam.cliba_deleted_ind          IN(0,4,8)    
  AND    clia.clia_deleted_ind             = 1     
  AND    excpm.excpm_deleted_ind           = 1    
  AND    excsm.excsm_deleted_ind           = 1    
  AND    prom.prom_deleted_ind             = 1    
  AND    compm.compm_deleted_ind           = 1    
  AND    clia.clia_crn_no                  = @PA_ID    
      
  UNION     
      
  SELECT prom.prom_id                prom_id    
  FROM   client_accounts             clia    WITH (NOLOCK)    
       , excsm_prod_mstr             excpm   WITH (NOLOCK)    
       , exch_seg_mstr               excsm   WITH (NOLOCK)    
       , product_mstr                prom    WITH (NOLOCK)    
       , company_mstr                compm   WITH (NOLOCK)    
       , status_mstr                 stam    WITH (NOLOCK)    
       , client_sub_accts            clisba  WITH (NOLOCK)    
       ,  client_brokerage           clib    WITH (NOLOCK)     
       ,  brokerage_mstr             brom    WITH (NOLOCK)     
       , client_dp_accts_mak         clidpam  WITH (NOLOCK)              
    
  WHERE  clisba.clisba_crn_no      = clia.clia_crn_no    
  AND    clisba.clisba_acct_no     = clia.clia_acct_no    
  AND    clisba.clisba_excpm_id    = excpm.excpm_id     
  AND    excsm.excsm_id            = excpm.excpm_excsm_id    
  AND    compm.compm_id            = excsm.excsm_compm_id    
  AND    prom.prom_id              = excpm.excpm_prom_id    
  AND    clisba.clisba_access2     = stam.stam_id    
  and    clisba_id                 = clib_clisba_id    
  and    clib.clib_brom_id         = brom.brom_id    
  AND    clisba.clisba_id          = clidpam.clidpa_clisba_id    
  AND    clidpam.clidpa_deleted_ind        IN(0,4,8)    
  AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
  AND    clia.clia_deleted_ind     = 1    
  AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1    
  AND    clisba.clisba_deleted_ind = 1    
  AND    excpm.excpm_deleted_ind   = 1    
  AND    prom.prom_deleted_ind     = 1    
  AND    compm.compm_deleted_ind   = 1    
  AND    clia.clia_crn_no          = @PA_ID    
      
  UNION    
      
  SELECT prom.prom_id                prom_id    
  FROM   client_accounts             clia    WITH (NOLOCK)    
       , excsm_prod_mstr             excpm   WITH (NOLOCK)    
       , exch_seg_mstr               excsm   WITH (NOLOCK)    
       , product_mstr                prom    WITH (NOLOCK)    
       , company_mstr                compm   WITH (NOLOCK)    
       , status_mstr                 stam    WITH (NOLOCK)    
       , client_sub_accts            clisba  WITH (NOLOCK)    
       ,  client_brokerage           clib    WITH (NOLOCK)     
       ,  brokerage_mstr             brom    WITH (NOLOCK)     
       , client_bank_accts_mak       clibam  WITH (NOLOCK)              
  WHERE  clisba.clisba_crn_no      = clia.clia_crn_no    
  AND    clisba.clisba_acct_no     = clia.clia_acct_no    
  AND    clisba.clisba_excpm_id    = excpm.excpm_id     
  AND    excsm.excsm_id            = excpm.excpm_excsm_id    
  AND    compm.compm_id            = excsm.excsm_compm_id    
  AND    prom.prom_id              = excpm.excpm_prom_id    
  AND    clisba.clisba_access2     = stam.stam_id    
  AND    clisba_id                 = clib_clisba_id    
  AND    clib.clib_brom_id         = brom.brom_id    
  AND    clisba.clisba_id          = clibam.cliba_clisba_id    
  AND    clibam.cliba_deleted_ind        IN(0,4,8)    
  AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
  AND    clia.clia_deleted_ind     = 1    
  AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1    
  AND    clisba.clisba_deleted_ind = 1    
  AND    excpm.excpm_deleted_ind   = 1    
  AND    prom.prom_deleted_ind     = 1    
  AND    compm.compm_deleted_ind   = 1    
  AND    clia.clia_crn_no          = @PA_ID    
    
    
      
      
  SELECT prom_id    
         ,compm_id    
         ,compm_short_name    
         ,excsm_id    
         ,excsm_exch_cd    
         ,excsm_seg_cd    
         ,acct_no    
         ,excpm_prom_id    
         ,prom_desc    
         ,stam_desc    
         ,brom_desc    
         ,clisba_id      
         ,clisba_no    
         ,clisba_name    
         ,value    
  FROM   (SELECT prom.prom_id                        prom_id    
               , compm.compm_id                      compm_id    
               , compm.compm_short_name              compm_short_name    
               , excsm.excsm_id                      excsm_id    
               , excsm.excsm_exch_cd                 excsm_exch_cd    
               , excsm.excsm_seg_cd                  excsm_seg_cd    
               , clia.clia_acct_no                   acct_no    
               , excpm.excpm_prom_id                 excpm_prom_id    
               , prom.prom_desc                      prom_desc    
               , stam.stam_desc                      stam_desc    
               , brom.brom_desc                      brom_desc    
               , clisbam.clisba_id                   clisba_id      
               , isnull(clisbam.clisba_no, 0)        clisba_no    
               , isnull(clisbam.clisba_name, 0)      clisba_name    
               , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value  --*|~*    
          FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)    
               , client_accounts_mak                 clia     WITH (NOLOCK)    
               , excsm_prod_mstr                     excpm    WITH (NOLOCK)    
               , exch_seg_mstr                       excsm    WITH (NOLOCK)    
               , product_mstr                        prom     WITH (NOLOCK)    
               , company_mstr                        compm    WITH (NOLOCK)    
               , status_mstr                         stam     WITH (NOLOCK)    
               , brokerage_mstr                      brom     WITH (NOLOCK)    
          WHERE  clisbam.clisba_crn_no              = clia.clia_crn_no    
          AND    clisbam.clisba_acct_no             = clia.clia_acct_no    
          AND    clisbam.clisba_excpm_id            = excpm.excpm_id     
          AND    excsm.excsm_id                     = excpm.excpm_excsm_id    
          AND    compm.compm_id                     = excsm.excsm_compm_id    
          AND    prom.prom_id                       = excpm.excpm_prom_id    
          AND    clisbam.clisba_access2             = stam.stam_id    
          AND    clisbam.clisba_brom                = brom.brom_id    
          AND    clisbam.clisba_deleted_ind         IN(0,8)    
          AND    clia.clia_deleted_ind              IN(0,8)  
          AND    excpm.excpm_deleted_ind            = 1    
          AND    excsm.excsm_deleted_ind            = 1    
          AND    prom.prom_deleted_ind              = 1    
          AND    compm.compm_deleted_ind            = 1    
          AND    clia.clia_crn_no                   = @PA_ID   
  
          UNION  
  
          SELECT prom.prom_id                        prom_id    
               , compm.compm_id                      compm_id    
               , compm.compm_short_name              compm_short_name    
               , excsm.excsm_id                      excsm_id    
               , excsm.excsm_exch_cd                 excsm_exch_cd    
               , excsm.excsm_seg_cd                  excsm_seg_cd    
               , clia.clia_acct_no                   acct_no    
               , excpm.excpm_prom_id                 excpm_prom_id    
               , prom.prom_desc                      prom_desc    
               , stam.stam_desc                      stam_desc    
               , brom.brom_desc                      brom_desc    
               , clisbam.clisba_id                   clisba_id      
               , isnull(clisbam.clisba_no, 0)        clisba_no    
               , isnull(clisbam.clisba_name, 0)      clisba_name    
               , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value  --*|~*    
          FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)    
               , client_accounts                     clia     WITH (NOLOCK)    
               , excsm_prod_mstr                     excpm   WITH (NOLOCK)    
               , exch_seg_mstr                       excsm    WITH (NOLOCK)    
               , product_mstr                        prom     WITH (NOLOCK)    
               , company_mstr                        compm    WITH (NOLOCK)    
               , status_mstr                         stam     WITH (NOLOCK)    
               , brokerage_mstr                      brom     WITH (NOLOCK)    
          WHERE  clisbam.clisba_crn_no              = clia.clia_crn_no    
          AND    clisbam.clisba_acct_no             = clia.clia_acct_no    
          AND    clisbam.clisba_excpm_id            = excpm.excpm_id     
          AND    excsm.excsm_id                     = excpm.excpm_excsm_id    
          AND    compm.compm_id                     = excsm.excsm_compm_id    
          AND    prom.prom_id                       = excpm.excpm_prom_id    
          AND    clisbam.clisba_access2             = stam.stam_id    
          AND    clisbam.clisba_brom             = brom.brom_id    
          AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
          AND    clisbam.clisba_deleted_ind         IN(0,8)    
          AND    clia.clia_deleted_ind              = 1    
          AND    excpm.excpm_deleted_ind            = 1    
          AND    excsm.excsm_deleted_ind            = 1    
          AND    prom.prom_deleted_ind              = 1    
          AND    compm.compm_deleted_ind            = 1    
          AND    clia.clia_crn_no                   = @PA_ID    
          
          
          UNION    
    
          SELECT PROM.PROM_ID                 PROM_ID    
               , compm.compm_id               compm_id    
               , compm.compm_short_name       compm_short_name    
               , excsm.excsm_id               excsm_id    
               , excsm.excsm_exch_cd          excsm_exch_cd    
               , excsm.excsm_seg_cd           excsm_seg_cd    
               , clia.clia_acct_no            acct_no    
               , excpm.excpm_prom_id          excpm_prom_id    
               , prom.prom_desc               prom_desc    
               , stam.stam_desc               stam_desc    
               , brom.brom_desc               brom_desc    
               , clisba.clisba_id             clisba_id      
               , ISNULL(clisba.clisba_no, 0)  clisba_no    
               , ISNULL(clisba.clisba_name, 0)clisba_name    
               , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+ CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+ISNULL(clisba.clisba_name, 0)+'|*~|'+ CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value        
          FROM   client_accounts             clia    WITH (NOLOCK)    
               , excsm_prod_mstr             excpm   WITH (NOLOCK)    
               , exch_seg_mstr               excsm   WITH (NOLOCK)    
               , product_mstr                prom    WITH (NOLOCK)    
               , company_mstr                compm   WITH (NOLOCK)    
               , status_mstr                 stam    WITH (NOLOCK)    
               , client_sub_accts            clisba  WITH (NOLOCK)    
                 left outer join                  
                 client_brokerage            clib    WITH (NOLOCK) on clisba_id          = clib_clisba_id    
                 left outer join                  
                 brokerage_mstr              brom    WITH (NOLOCK) on clib.clib_brom_id  = brom.brom_id    
          WHERE  clisba.clisba_crn_no      = clia.clia_crn_no    
          AND    clisba.clisba_acct_no     = clia.clia_acct_no    
          AND    clisba.clisba_excpm_id    = excpm.excpm_id     
          AND    excsm.excsm_id            = excpm.excpm_excsm_id    
          AND    compm.compm_id            = excsm.excsm_compm_id    
          AND    prom.prom_id              = excpm.excpm_prom_id    
          AND    clisba.clisba_access2     = stam.stam_id    
    
          AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0    
          AND    clia.clia_deleted_ind     = 1    
          AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1    
          AND    clisba.clisba_deleted_ind = 1    
          AND    excpm.excpm_deleted_ind   = 1    
          AND    prom.prom_deleted_ind     = 1    
          AND    compm.compm_deleted_ind   = 1    
          AND    clia.clia_crn_no          = @PA_ID    
          AND    clisba.clisba_crn_no NOT IN ( SELECT clisbam.clisba_id             clisba_id    
                                               FROM   client_sub_accts_mak          clisbam    
                                               WHERE  clisbam.clisba_deleted_ind IN (0, 4, 8)    
                                               AND    clisbam.clisba_crn_no       = @PA_ID    
                                             )    
          ) x    
   WHERE  x.prom_id in (SELECT prom_id FROM @l_temp_tab)           
       
--    
END

GO
