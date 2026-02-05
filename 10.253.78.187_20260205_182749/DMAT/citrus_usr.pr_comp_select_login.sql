-- Object: PROCEDURE citrus_usr.pr_comp_select_login
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_comp_select_login 'newrol',''
Create proc [citrus_usr].[pr_comp_select_login](@pa_login_name varchar(250),@pa_ref_cur varchar(8000) out)
as
select distinct comp_name , excsm_id , isnull(id,0) id from (SELECT compm.compm_short_name + '-' + dpm_dpid  +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd  comp_name                      
           , excsm.excsm_id                                     
           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                      
      FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                      
           , company_mstr                 compm  WITH (NOLOCK)
           , dp_mstr     WITH (NOLOCK)                
      WHERE  excsm.excsm_compm_id         = compm.compm_id                      
      AND    excsm.excsm_deleted_ind      = 1                      
      AND    compm.compm_deleted_ind      = 1       
      and    excsm.excsm_id = dpm_excsm_id and default_dp=dpm_excsm_id and dpm_Deleted_ind=1 
) a left outer join (SELECT excsm_id  id 
							FROM   actions act  , roles_actions rola  , screens scr , roles rol  , exch_seg_mstr excsm  , company_mstr  compm  , entity_roles ,dp_mstr 
							WHERE  act.act_id = rola.rola_act_id  
							AND    scr.scr_id            = act.act_scr_id  
							AND    rol.rol_id            = rola.rola_rol_id  
							AND    compm.compm_id        = excsm.excsm_compm_id  
							and  dpm_excsm_id = excsm_id 
							AND    rola.rola_rol_id      = entro_rol_id
							and    entro_logn_name       = @pa_login_name
							AND    citrus_usr.fn_get_comp_access( rola_rol_id      , 0, 0, rola_access1, 0, excsm.excsm_desc) > 0 

 ) b 
      on a.excsm_id = b.id

GO
