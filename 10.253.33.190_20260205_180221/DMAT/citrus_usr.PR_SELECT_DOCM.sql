-- Object: PROCEDURE citrus_usr.PR_SELECT_DOCM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SELECT_DOCM](@PA_DOCM_DOC_ID NUMERIC    
                               ,@PA_TAB         VARCHAR(20)    
                               ,@PA_LOGIN_NAME  VARCHAR(20)    
                               ,@ROWDELIMITER   VARCHAR(20)  ='*|~*'      
                               ,@COLDELIMITER   VARCHAR(20)  = '|*~|'      
                               ,@PA_REF_CUR     VARCHAR(8000) OUTPUT    
                               )    
AS    
/*******************************************************************************    
   SYSTEM         : CLASS    
   MODULE NAME    : PR_SELECT_DOCM    
   DESCRIPTION    : SCRIPT TO SELECT FROM THE DOCUMENTS MASTER    
   COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.    
   VERSION HISTORY:    
   VERS.  AUTHOR          DATE         REASON    
   -----  -------------   ----------   ------------------------------------------------    
   1.0    TUSHAR          24-JAN-2007  INITIAL VERSION.    
  **********************************************************************************/    
BEGIN    
  --    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  --    
   IF @PA_TAB ='RDOCM'    
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
                   , case docm.docm_mdty when 1 then 'M' else 'N'end   docm_mdty  
                   , docm.docm_id          docm_id  
                   , docm.docm_cd          docm_cd    
                   , docm.docm_desc        docm_desc  
                   , docm.docm_rmks        docm_rmks     
                   , excsm.excsm_exch_cd + '-' + excsm.excsm_seg_cd    excsm_cd   
                   ,docm.docm_deleted_ind         docm_deleted_ind    
     FROM            document_mstr         docm    
                   , exch_seg_mstr         excsm    
            , client_ctgry_mstr     clicm    
            , entity_type_mstr      enttm    
            , excsm_prod_mstr       excpm    
            , product_mstr          prom    
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
     AND    docm.docm_doc_id            = @pa_docm_doc_id    
     ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc    
    --     
    END     
    ELSE IF @PA_TAB='LDOCM'    
    BEGIN    
    --    
     SELECT DISTINCT excsm.excsm_exch_cd    
                    ,excsm.excsm_seg_cd    
                    ,prom_desc,prom_id    
     FROM            excsm_prod_mstr excpm     
                     left outer join exch_seg_mstr excsm     
     ON              excpm.excpm_excsm_id = excsm.excsm_id    
                     right outer join product_mstr prom     
     ON              excpm.excpm_prom_id = prom.prom_id   
     WHERE           excpm.excpm_deleted_ind=1  
     AND             excsm.excsm_deleted_ind=1  
     AND             prom_deleted_ind       =1  
     ORDER BY        excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc    
     --    
    END    
    ELSE IF @pa_tab = 'RDOCMMAK' --only show those records which the maker has created.    
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
               , CASE  docmm.docm_mdty WHEN  1 THEN  'M' ELSE 'N'  END docm_mdty  
               ,docmm.docm_deleted_ind         docm_deleted_ind     
          FROM   document_mstr_mak              docmm    
               , exch_seg_mstr                  excsm    
               , client_ctgry_mstr              clicm    
               , entity_type_mstr               enttm    
               , excsm_prod_mstr                excpm    
               , product_mstr                   prom    
          WHERE  docmm.docm_excpm_id          = excpm.excpm_id    
          AND    docmm.docm_clicm_id          = clicm.clicm_id    
          AND    docmm.docm_enttm_id          = enttm.enttm_id    
          AND    prom.prom_id                 = excpm.excpm_prom_id    
          AND    excpm.excpm_excsm_id         = excsm.excsm_id    
          AND    clicm.clicm_deleted_ind      = 1    
          AND    enttm.enttm_deleted_ind      = 1    
          AND    excpm.excpm_deleted_ind      = 1    
          AND    prom.prom_deleted_ind        = 1    
          AND    excsm.excsm_deleted_ind      = 1    
          AND    docmm.docm_deleted_ind       = 0    
          AND    docmm.docm_doc_id            = @pa_docm_doc_id    
          AND    docmm.docm_created_by        = @pa_login_name    
          ORDER BY excsm.excsm_exch_cd    
                 , excsm.excsm_seg_cd    
                 , prom.prom_desc    
                 , enttm.enttm_desc    
                 , clicm.clicm_desc    
      --    
      END    
      ELSE IF @pa_tab = 'RDOCMCHK' --only show those records which the checker has not created.    
      BEGIN    
      --    
        SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd    
              ,excsm.excsm_seg_cd             excsm_seg_cd    
              , prom.prom_id                   prom_id    
              , prom.prom_desc                 prom_desc    
              , enttm.enttm_id                 enttm_id    
              , enttm.enttm_desc               enttm_desc    
              , clicm.clicm_id                 clicm_id    
              , clicm.clicm_desc               clicm_desc  
              , docmm.docm_id                  docm_id  
              , docmm.docm_cd                  docm_cd    
              , docmm.docm_desc                docm_desc  
              , docmm.docm_rmks                docm_rmks  
              , excsm.excsm_exch_cd + '-' + excsm.excsm_seg_cd  excsm_cd  
              , CASE docmm.docm_mdty WHEN 1 THEN 'M'ELSE 'N'END docm_mdty    
              ,docmm.docm_deleted_ind         docm_deleted_ind         
        FROM   document_mstr_mak              docmm    
              , exch_seg_mstr                  excsm    
              , client_ctgry_mstr              clicm    
              , entity_type_mstr               enttm    
              , excsm_prod_mstr                excpm    
              , product_mstr                   prom    
        WHERE  docmm.docm_excpm_id          = excpm.excpm_id    
        AND    docmm.docm_clicm_id          = clicm.clicm_id    
        AND    docmm.docm_enttm_id          = enttm.enttm_id    
        AND    prom.prom_id                 = excpm.excpm_prom_id    
        AND    excpm.excpm_excsm_id         = excsm.excsm_id    
        AND    clicm.clicm_deleted_ind      = 1    
        AND    enttm.enttm_deleted_ind      = 1    
        AND    excpm.excpm_deleted_ind      = 1    
        AND    prom.prom_deleted_ind        = 1    
        AND    excsm.excsm_deleted_ind      = 1    
        AND    (docmm.docm_deleted_ind       = 0  OR docmm.docm_deleted_ind    = 4 OR docmm.docm_deleted_ind       = 6)  
         
        --AND    docmm.docm_doc_id            = @pa_docm_doc_id    
        AND    docmm.docm_lst_upd_by       <> @PA_LOGIN_NAME   
        ORDER  BY docm_cd  
                , excsm.excsm_exch_cd    
                , excsm.excsm_seg_cd    
                , prom.prom_desc    
                , enttm.enttm_desc    
                , clicm.clicm_desc    
                
            --    
      END    
                      
        
        
    
END

GO
