-- Object: PROCEDURE citrus_usr.PR_SELECT_ENTPM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--PR_SELECT_ENTPM 0,'RENTPMCHK','SM','*|~*','|*~|',''  
  
CREATE PROCEDURE [citrus_usr].[PR_SELECT_ENTPM](@PA_ENTPM_PROP_ID NUMERIC    
                               ,@PA_TAB            VARCHAR(20)    
                               ,@PA_LOGIN_NAME     VARCHAR(20)    
                               ,@ROWDELIMITER      VARCHAR(20)  ='*|~*'      
                               ,@COLDELIMITER      VARCHAR(20)  = '|*~|'      
                               ,@PA_REF_CUR        VARCHAR(8000) OUTPUT    
                               )    
AS    
/*******************************************************************************    
   SYSTEM         : CLASS    
   MODULE NAME    : PR_SELECT_ENTPM    
   DESCRIPTION    : SCRIPT TO SELECT FROM THE ENTITY_PROPERTY_MSTR    
   COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.    
   VERSION HISTORY:    
   VERS.  AUTHOR          DATE         REASON    
   -----  -------------   ----------   ------------------------------------------------    
   1.0    TUSHAR          22-02-2007  INITIAL VERSION.    
  **********************************************************************************/    
BEGIN    
  --    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  --    
   IF @PA_TAB ='RENTPM'    
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
     , entpm.entpm_id                entpm_id    
     , entpm.entpm_cd                entpm_cd    
     , entpm.entpm_desc              entpm_desc    
     , entpm.entpm_rmks              entpm_rmks 
     , excsm.excsm_exch_cd  + '-' + excsm.excsm_seg_cd    excsm_cd    
     , case entpm.entpm_mdty when 1 then 'M' else 'N'end   entpm_mdty
     , entpm.entpm_deleted_ind       entpm_deleted_ind
     FROM            entity_property_mstr  entpm    
                   , exch_seg_mstr         excsm    
            , client_ctgry_mstr     clicm    
            , entity_type_mstr      enttm    
            , excsm_prod_mstr       excpm    
            , product_mstr          prom    
     WHERE  entpm.entpm_excpm_id         = excpm.excpm_id    
     AND    entpm.entpm_clicm_id         = clicm.clicm_id    
     AND    entpm.entpm_enttm_id         = enttm.enttm_id    
     AND    prom.prom_id                 = excpm.excpm_prom_id    
     AND    excpm.excpm_excsm_id         = excsm.excsm_id    
     AND    clicm.clicm_deleted_ind      = 1    
     AND    enttm.enttm_deleted_ind      = 1    
     AND    excpm.excpm_deleted_ind      = 1    
     AND    prom.prom_deleted_ind        = 1    
     AND    excsm.excsm_deleted_ind      = 1    
     AND    entpm.entpm_deleted_ind      = 1    
     AND    entpm.entpm_prop_id          = @pa_entpm_prop_id    
     ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc    
    --     
    END     
    ELSE IF @PA_TAB='LENTPM'    
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
     AND             excpm.excpm_deleted_ind=1
     AND             excsm.excsm_deleted_ind=1
     AND             prom.prom_deleted_ind  =1
     ORDER BY        excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc    
     --    
    END    
    ELSE IF @pa_tab = 'RENTPMMAK' --only show those records which the maker has created.    
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
               , CASE  entpmm.entpm_mdty WHEN  1 THEN  'M' ELSE 'N'  END entpm_mdty    
               , entpmm.entpm_deleted_ind       entpm_deleted_ind
          FROM   entity_property_mstr_mak       entpmm    
               , exch_seg_mstr                  excsm    
               , client_ctgry_mstr              clicm    
               , entity_type_mstr            enttm    
               , excsm_prod_mstr                excpm    
               , product_mstr                   prom    
          WHERE  entpmm.entpm_excpm_id          = excpm.excpm_id    
          AND    entpmm.entpm_clicm_id          = clicm.clicm_id    
          AND    entpmm.entpm_enttm_id          = enttm.enttm_id    
          AND    prom.prom_id                 = excpm.excpm_prom_id    
          AND    excpm.excpm_excsm_id         = excsm.excsm_id    
          AND    clicm.clicm_deleted_ind      = 1    
          AND    enttm.enttm_deleted_ind      = 1    
          AND    excpm.excpm_deleted_ind      = 1    
          AND    prom.prom_deleted_ind        = 1    
          AND    excsm.excsm_deleted_ind      = 1    
          AND    entpmm.entpm_deleted_ind     = 0    
          AND    entpmm.entpm_prop_id         = @pa_entpm_prop_id    
          AND    entpmm.entpm_created_by      = @pa_login_name    
          ORDER BY excsm.excsm_exch_cd    
                 , excsm.excsm_seg_cd    
                 , prom.prom_desc    
                 , enttm.enttm_desc    
                 , clicm.clicm_desc    
      --    
      END    
      ELSE IF @pa_tab = 'RENTPMCHK' --only show those records which the checker has not created.    
      BEGIN    
      --    
        SELECT DISTINCT excsm.excsm_exch_cd +'-'+excsm.excsm_seg_cd excsm_cd    
              , prom.prom_id                   prom_id    
              , prom.prom_desc                 prom_desc    
              , enttm.enttm_id                 enttm_id    
              , enttm.enttm_desc               enttm_desc    
              , clicm.clicm_id                 clicm_id    
              , clicm.clicm_desc               clicm_desc    
              , entpmm.entpm_id                entpm_id  
              , entpmm.entpm_cd                entpm_cd  
              , entpmm.entpm_desc              entpm_desc  
              , entpmm.entpm_rmks         entpm_rmks   
              , CASE entpmm.entpm_mdty WHEN 1 THEN 'M'ELSE 'N'END entpm_mdty    
              , entpmm.entpm_deleted_ind       entpm_deleted_ind
        FROM   entity_property_mstr_mak        entpmm    
              , exch_seg_mstr                  excsm    
              , client_ctgry_mstr              clicm    
              , entity_type_mstr               enttm    
              , excsm_prod_mstr                excpm    
              , product_mstr                   prom    
        WHERE  entpmm.entpm_excpm_id          = excpm.excpm_id    
        AND    entpmm.entpm_clicm_id          = clicm.clicm_id    
        AND    entpmm.entpm_enttm_id          = enttm.enttm_id    
        AND    prom.prom_id                   = excpm.excpm_prom_id    
        AND    excpm.excpm_excsm_id           = excsm.excsm_id    
        AND    clicm.clicm_deleted_ind        = 1    
        AND    enttm.enttm_deleted_ind        = 1    
        AND    excpm.excpm_deleted_ind        = 1    
        AND    prom.prom_deleted_ind          = 1    
        AND    excsm.excsm_deleted_ind        = 1    
        AND    (entpmm.entpm_deleted_ind       = 0  OR     entpmm.entpm_deleted_ind       = 4   OR     entpmm.entpm_deleted_ind       = 6)
        --AND    entpmm.entpm_prop_id           = @pa_entpm_prop_id    
        AND    entpmm.entpm_lst_upd_by       <> @pa_login_name    
        ORDER  BY excsm_cd  
                , prom.prom_desc    
                , enttm.enttm_desc    
                , clicm.clicm_desc    
            --    
      END    
                      
        
        
    
END

GO
