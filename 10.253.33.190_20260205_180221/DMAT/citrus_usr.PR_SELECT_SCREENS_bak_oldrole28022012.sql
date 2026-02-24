-- Object: PROCEDURE citrus_usr.PR_SELECT_SCREENS_bak_oldrole28022012
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[PR_SELECT_SCREENS_bak_oldrole28022012](@pa_tab        VARCHAR(50)  
                                  ,@pa_scr_id     NUMERIC  
                                  ,@pa_rol_id     NUMERIC  
                                  ,@rowdelimiter  VARCHAR(4) = '*|~*'  
                                  ,@coldelimiter  VARCHAR(4) = '|*~|'  
                                  ,@pa_ref_cur    VARCHAR(8000) OUTPUT  
                                  )  
 AS  
  /*******************************************************************************  
   SYSTEM         : CLASS  
   MODULE NAME    : PR_SELECT_SCREENS  
   DESCRIPTION    : THIS PROCEDURE RETURN THE RELEVANT DATA FOR THE SCREENS WHICH SETS UP THE ROLES  
   COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
   VERSION HISTORY:  
   VERS.  AUTHOR             DATE         REASON  
   -----  -------------      ----------   ------------------------------------------------  
   1.0    SUKHVINDER/TUSHAR  11-JAN-2007  INITIAL VERSION.  
  **********************************************************************************/  
 --  
 BEGIN  
 --  
    IF @pa_tab = 'INS_SCR'  
    BEGIN  
    --  
      SELECT scr_id   scr_id  
           , scr_desc scr_desc
           , scr_dp  
      FROM   screens WITH (NOLOCK)  
      WHERE  scr_deleted_ind = 1  
      AND    SCR_URL<>'blank.aspx'  
      ORDER  BY scr_desc  
    --  
    END  
    ELSE IF @PA_TAB = 'INS_COMP'  
    BEGIN  
    --  
      SELECT scrc.scrc_comp_id      scrc_comp_id  
           , scr.scr_id             scr_id  
           , scr.scr_desc           scr_desc  
           , scrc.scrc_comp_desc    scrc_comp_desc  
      FROM   screens                scr  WITH (NOLOCK)  
           , screen_component       scrc WITH (NOLOCK)  
      WHERE  scr.scr_id           = scrc.scrc_scr_id  
      AND    scr.scr_id           = @pa_scr_id  
      ORDER  BY scrc.scrc_comp_desc  
    --  
    END  
    ELSE IF @PA_TAB = 'EDT_ROL_SCR'  
    BEGIN  
    --  
      /*SELECT scr.scr_id              scr_id  
           , scr.scr_desc            scr_desc  
           , act.act_cd              act_cd  
           , excsm.excsm_id          excsm_id  
           , compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd  compm_short_name  
           , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,excsm.excsm_id)   compexchange_id  
      FROM   actions                 act    WITH (NOLOCK)  
           , roles_actions           rola   WITH (NOLOCK)  
           , screens                 scr    WITH (NOLOCK)  
           , exch_seg_mstr           excsm  WITH (NOLOCK)  
           , company_mstr            compm  WITH (NOLOCK)  
      WHERE  act.act_id            = rola.rola_act_id  
      AND    scr.scr_id            = act.act_scr_id  
      AND    compm.compm_id        = excsm.excsm_compm_id  
      AND    rola.rola_rol_id      = @pa_rol_id  
      AND    citrus_usr.fn_get_comp_access(@pa_rol_id, 0, 0, rola_access1, 0, excsm.excsm_desc) > 0  
      ORDER  BY scr.scr_desc*/  
      SELECT excsm_id excsm_id,CONVERT(VARCHAR,excsm.excsm_id) +@coldelimiter + CONVERT(VARCHAR,scr.scr_id) +@coldelimiter + act.act_cd ScrValues  
      FROM   actions            act  
           , roles_actions           rola  
           , screens                 scr  
           , roles                   rol  
           , exch_seg_mstr           excsm  
           , company_mstr            compm  
      WHERE(act.act_id = rola.rola_act_id)  
      AND    scr.scr_id            = act.act_scr_id  
      AND    rol.rol_id            = rola.rola_rol_id  
      AND    compm.compm_id        = excsm.excsm_compm_id  
      AND    rola.rola_rol_id      = @pa_rol_id  
      AND    citrus_usr.fn_get_comp_access( @pa_rol_id, 0, 0, rola_access1, 0, excsm.excsm_desc) > 0  
      --ORDER  BY scr.scr_desc  
        
  
    --  
    END  
    ELSE IF @PA_TAB = 'EDT_ROL_COMP'  
    BEGIN  
    --  
      /*SELECT scr.scr_id                scr_id  
           , scr.scr_desc              scr_desc  
           , rolc.rolc_comp_id         rolc_comp_id  
           , scrc.scrc_comp_desc       scrc_comp_desc  
           , rolc.rolc_disable         rolc_disable  
           , excsm.excsm_id            excsm_id  
           , compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd     compm_short_name  
      FROM   roles_components          rolc   WITH (NOLOCK)  
           , screen_component          scrc   WITH (NOLOCK)  
           , screens                   scr    WITH (NOLOCK)  
           , exch_seg_mstr             excsm  WITH (NOLOCK)  
           , company_mstr              compm  WITH (NOLOCK)  
      WHERE  rolc.rolc_scr_id        = scrc.scrc_scr_id  
      AND    rolc.rolc_comp_id       = scrc.scrc_comp_id  
      AND    scr.scr_id              = scrc.scrc_scr_id  
      AND    compm.compm_id          = excsm.excsm_compm_id  
      AND    scrc.scrc_deleted_ind   = 1  
      AND    excsm.excsm_deleted_ind = 1  
      AND    rolc.rolc_rol_id        = @pa_rol_id  
      --AND    SCR.SCR_ID              = @PA_SCR_ID  
      AND    citrus_usr.fn_get_comp_access( @pa_rol_id, 0, 0, rolc.rolc_mdtry, 0, excsm.excsm_desc) > 0  
      ORDER  by scrc.scrc_comp_desc*/  
      SELECT CONVERT(VARCHAR,excsm.excsm_id)+@coldelimiter+ CONVERT(VARCHAR,scr.scr_id) +@coldelimiter+ CONVERT(VARCHAR,rolc.rolc_comp_id) +@coldelimiter+ CASE rolc.rolc_disable WHEN 1 THEN 'READ ONLY' ELSE  'MANDATORY' END  ComponentValues  
      FROM   roles_components          rolc  
           , screen_component          scrc  
           , screens                   scr  
           , exch_seg_mstr             excsm  
           , company_mstr              compm  
      WHERE(rolc.rolc_scr_id = scrc.scrc_scr_id)  
      AND    rolc.rolc_comp_id       = scrc.scrc_comp_id  
      AND    scr.scr_id              = scrc.scrc_scr_id  
      AND    compm.compm_id          = excsm.excsm_compm_id  
      AND    scrc.scrc_deleted_ind   = 1  
      AND    excsm.excsm_deleted_ind = 1  
      AND    rolc.rolc_rol_id        = @pa_rol_id  
      AND    citrus_usr.fn_get_comp_access( @pa_rol_id, 0, 0, rolc.rolc_mdtry, 0, excsm.excsm_desc) > 0  
      --ORDER  BY scrc.scrc_comp_desc  
  
    --  
    END  
    ELSE IF @pa_tab = 'EDT_SCR'  
    BEGIN  
    --  
      SELECT scr.scr_id            scr_id  
           , scr.scr_desc          scr_desc  
      FROM   screens               scr  WITH (NOLOCK)  
      WHERE  scr.scr_id  NOT IN (SELECT DISTINCT act.act_scr_id  
                                 FROM   actions             act   WITH (NOLOCK)  
                                      , roles_actions       rola  WITH (NOLOCK)  
                                 WHERE  act.act_id        = rola.rola_act_id  
                                 AND    rola.rola_rol_id  = @pa_rol_id  
                                 )  
      AND    scr.scr_deleted_ind = 1  
      ORDER  BY scr.scr_desc  
    --  
    END  
    ELSE IF @pa_tab = 'SCR'  
    BEGIN  
    --  
      DECLARE @c_cursor   CURSOR  
      DECLARE @l_act_cd   VARCHAR(25)  
             ,@l_actions  VARCHAR(25)  
             ,@l_scr_menu_read   NUMERIC   
             ,@l_scr_menu_write  NUMERIC   
             ,@l_scr_menu_print  NUMERIC   
             ,@l_scr_menu_export NUMERIC   
               
      SET    @l_scr_menu_read = 0  
      SET    @l_scr_menu_write = 0  
      SET    @l_scr_menu_print = 0   
      SET    @l_scr_menu_export = 0  
        
      SET     @c_cursor  = CURSOR fast_forward FOR SELECT act_cd FROM actions where act_scr_id = @pa_scr_id and act_deleted_ind = 1  
        
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_act_cd  
         
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
        IF @l_act_cd  = 'READ'  
        BEGIN  
        --  
          SET @l_scr_menu_read  = 1  
        --  
        END  
          
        ELSE IF @l_act_cd  = 'WRITE'  
        BEGIN  
        --  
          SET @l_scr_menu_write  = 1  
        --  
        END  
          
        ELSE IF @l_act_cd  = 'PRINT'  
        BEGIN  
        --  
          SET @l_scr_menu_print  = 1  
        --  
        END  
       
        ELSE IF @l_act_cd  = 'EXPORT'  
        BEGIN  
        --  
          SET @l_scr_menu_export  = 1  
        --  
        END  
          
          
          
        
        FETCH next FROM @c_cursor INTO @l_act_cd  
      --  
      END  --#cursor  
      --  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
        
        
      SELECT scr.scr_id                    scr_id  
            ,scr.scr_cd                    scr_cd  
            ,scr.scr_name                  scr_name  
            ,scr.scr_desc                  scr_desc  
            ,scr.scr_parent_id             scr_menu_ba  
            ,scr.scr_parent_id             scr_parent_id  
            ,scr.scr_url                   scr_url  
            ,case when scr.scr_dp = 1 then 'N'
             when scr.scr_dp = 2 then 'C'
             else 'B' end  scr_dp  
            ,scr.scr_checker_yn            scr_menu_type  
            ,scr.scr_ord_by                scr_ord_by  
            ,@l_scr_menu_read              scr_menu_read   
            ,@l_scr_menu_write             scr_menu_write  
            ,@l_scr_menu_export            scr_menu_export  
            ,@l_scr_menu_print             scr_menu_print  
            ,''                            errmsg   
      FROM   screens scr  
      
      WHERE scr_id  = @pa_scr_id        
    --  
    END  
    ELSE IF @PA_TAB = 'ROL_MAP'  
    BEGIN  
    --  
      SELECT rol.rol_id    rol_id  
           , CASE WHEN ISNULL(x.scr_id,0) = 0 THEN 0 ELSE 1 END  rol_chk  
           , rol.rol_desc  rol_desc   
      FROM   roles rol   
             left outer join   
             (SELECT DISTINCT scr_id  
                     ,rol_id   
              FROM    screens  
                     ,actions  
                     ,roles_actions  
                     ,roles   
              WHERE   scr_id = @pa_scr_id  
              AND     scr_id = act_scr_id  
              AND     rola_act_id = act_id   
              AND     rol_id = rola_rol_id)x   
              on x.rol_id   = rol.rol_id  
      WHERE rol_deleted_ind = 1          
    --  
    END  
--  
END

GO
