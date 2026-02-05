-- Object: PROCEDURE citrus_usr.PR_INS_SELECT_DOCM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_SELECT_DOCM](@PA_ENTTM_ID      NUMERIC
                                   ,@PA_CLICM_ID      NUMERIC   
                                   ,@PA_REF_CUR       VARCHAR(8000) OUTPUT  
                               )  
AS  
  /*******************************************************************************  
   SYSTEM         : CLASS  
   MODULE NAME    : PR_INS_SELECT_DOCM  
   DESCRIPTION    : SCRIPT TO SELECT DOCUMENT LIST FOR PARTICULAR CLIENT-CATEGORY,ENTTM ID
   COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
   VERSION HISTORY:  
   VERS.  AUTHOR          DATE         REASON  
   -----  -------------   ----------   ------------------------------------------------  
   1.0    TUSHAR          07-FEB-2007  INITIAL VERSION.  
  **********************************************************************************/  
  --  
  BEGIN  
    --  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    --  
   
           SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd
         , excsm.excsm_seg_cd                  excsm_seg_cd
         , prom.prom_id                        prom_id
         , prom.prom_desc                      prom_desc
         , enttm.enttm_id                      enttm_id
         , enttm.enttm_desc                    enttm_desc
         , clicm.clicm_id                      clicm_id
         , clicm.clicm_desc                    clicm_desc
         , (SELECT CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END) docm_mdty
         , docm_desc                           docdesc
         , docm.docm_doc_id                    doc_id
    FROM   document_mstr                       docm
         , exch_seg_mstr                       excsm
         , client_ctgry_mstr                   clicm
         , entity_type_mstr                    enttm
         , excsm_prod_mstr                     excpm
         , product_mstr                        prom
    WHERE  docm.docm_excpm_id                = excpm.excpm_id
    AND    docm.docm_clicm_id                = clicm.clicm_id
    AND    docm.docm_enttm_id                = enttm.enttm_id
    AND    prom.prom_id                      = excpm.excpm_prom_id
    AND    excpm.excpm_excsm_id              = excsm.excsm_id
    AND    clicm.clicm_deleted_ind           = 1
    AND    enttm.enttm_deleted_ind           = 1
    AND    excpm.excpm_deleted_ind           = 1
    AND    prom.prom_deleted_ind             = 1
    AND    excsm.excsm_deleted_ind           = 1
    AND    docm.docm_deleted_ind             = 1
    AND    docm.docm_clicm_id                = @pa_clicm_id
           AND    docm.docm_enttm_id                = @pa_enttm_id
  
    
  --  
  END

GO
