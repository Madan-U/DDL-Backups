-- Object: PROCEDURE citrus_usr.pr_select_dp_client_details
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_select_dp_client_details](@pa_id          NUMERIC  = 0        
                                           ,@pa_clicm_id    NUMERIC  = 0        
                                           ,@pa_enttm_id    NUMERIC  = 0        
                                           ,@pa_crn_no      NUMERIC  = 0        
                                           ,@pa_acct_no     VARCHAR(20)        
                                           ,@pa_tab         VARCHAR(20)        
                                           ,@pa_value       VARCHAR(8000)        
                                           ,@pa_chk_yn      NUMERIC  
                                           ,@pa_roles       VARCHAR(8000)
                                           ,@pa_scr_id      NUMERIC
                                           ,@rowdelimiter   VARCHAR(4)  = '*|~*'        
                                           ,@coldelimiter   VARCHAR(4)  = '|*~|'        
                                           ,@pa_ref_cur     VARCHAR(8000) OUTPUT        
                                           )        
AS        
BEGIN        
--
  DECLARE @l_product  varchar(20)
  --
  SET @l_product = '01'
  --
  IF @pa_chk_yn = 0 OR @pa_chk_yn = 2        
  BEGIN--chk_0_2          
  --     
     
    IF @PA_TAB = 'CLIDPAM'        
    BEGIN        
    --        
print 'shilpa'
       SELECT DISTINCT compm.compm_id         compm_id            
            , compm.compm_short_name          compm_short_name            
            , excsm.excsm_id                  excsm_id            
            , excsm.excsm_exch_cd             excsm_exch_cd            
            , excsm.excsm_seg_cd              excsm_seg_cd            
            , dpam.dpam_acct_no               acct_no            
            , dpam.dpam_id                    dpam_id           
            , dpam.dpam_sba_no                dpam_sba_no         
            --, isnull(brokm.brom_desc ,'')     brom_desc          
            , sm.stam_desc                    stam_desc        
            , sm.stam_cd                      stam_cd          
            , dpam.dpam_enttm_cd              enttm_cd        
            , cm.clicm_desc                clicm_desc
            , enttm.enttm_desc                enttm_desc
												, dpam.dpam_subcm_cd              subcm_cd                
            , subcm.subcm_desc                subcm_desc
            , dpm.dpm_dpid                    dpid        
            , ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name        
            , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,excsm.excsm_id)+'|*~|'+convert(varchar,dpm.dpm_dpid)+'|*~|'+ dpam.dpam_sba_no+'|*~|'+convert(varchar,isnull(dpam.dpam_sba_name, 0))+'|*~|'+ISNULL(convert(varchar(50), dpam.dpam_acct_no),'')+'|*~|'+isnull(dpam.dpam_stam_cd,'')+'|*~|'+convert(varchar,dpam.dpam_enttm_cd)+'|*~|'+dpam.dpam_clicm_cd+'|*~|'+dpam.dpam_subcm_cd+'|*~|'+'|*~|Q' value  --*|~*            
            , enttm.enttm_id                  enttm_id          
            , cm.clicm_id                     clicm_id  
            --, brokm.brom_id                   brom_id        
       FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
            , company_mstr                    compm    WITH (NOLOCK)        
            , entity_type_mstr                enttm    WITH (NOLOCK)             
            , status_mstr                     sm       WITH (NOLOCK)        
            , client_ctgry_mstr               cm       WITH (NOLOCK)        
            , dp_mstr                         dpm      WITH (NOLOCK)        
            , dp_acct_mstr                    dpam     WITH (NOLOCK)        
            , sub_ctgry_mstr                subcm       WITH (NOLOCK)     
              --LEFT OUTER JOIN           
            --, client_dp_brkg                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
              --LEFT OUTER JOIN          
            --, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
            , product_mstr                    prom          
            , excsm_prod_mstr                 excpm
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
       WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
       AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
       AND    excsm_list.excsm_id             = excsm.excsm_id    
       --AND    brokm.brom_excpm_id             = excpm.excpm_id      
       and    dpam.dpam_subcm_cd              = subcm.subcm_cd 
       and    cm.clicm_id                     = subcm.subcm_clicm_id
       AND    prom.prom_cd                    = @l_product     
       AND    prom.prom_id                    = excpm.excpm_prom_id      
       AND    dpam.dpam_enttm_cd              = enttm.enttm_cd        
       AND    compm.compm_id                  = excsm.excsm_compm_id        
       --AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
       --AND    combrkg.clidb_brom_id           = brokm.brom_id        
       AND    dpam.dpam_clicm_cd              = cm.clicm_cd        
       AND    dpam.dpam_dpm_id                = dpm.dpm_id         
       AND    dpam.dpam_stam_cd               = sm.stam_cd        
       --AND    Brokm.Brom_deleted_ind          = 1         
       AND    dpam.dpam_deleted_ind           = 1            
       AND    excsm.excsm_deleted_ind         = 1        
       AND    cm.clicm_deleted_ind            = 1            
       AND    compm.compm_deleted_ind         = 1        
       AND    dpm.dpm_deleted_ind             = 1        
       AND    sm.stam_deleted_ind             = 1        
       AND    enttm.enttm_deleted_ind         = 1      
       AND    PROM.PROM_DELETED_IND           = 1      
       AND    EXCPM.EXCPM_DELETED_IND         = 1          
       AND    dpam.dpam_crn_no                = @PA_CRN_NO        
    --        
    END   
    IF @PA_TAB = 'CLIENT_BRKG'        
				BEGIN        
				--        
							SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
							 				, isnull(brokm.brom_desc ,'')     brom_desc          
												, convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,isnull(combrkg.clidb_eff_from_dt,'01/01/1900'),103)+'|*~|'+isnull(brokm.brom_id,0)+'|*~|Q'   value       
												, isnull(CONVERT(VARCHAR,combrkg.clidb_eff_from_dt,103),'')    clidb_eff_from_dt 
                                                , brokm.brom_id                   brom_id        
                                                , isnull(CONVERT(VARCHAR,combrkg.clidb_eff_to_dt,103),'')    clidb_eff_to_dt 
							FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
												, company_mstr                    compm    WITH (NOLOCK)        
												, dp_mstr                         dpm      WITH (NOLOCK)        
												, dp_acct_mstr                    dpam     WITH (NOLOCK)        
														--LEFT OUTER JOIN           
												, client_dp_brkg                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
														--LEFT OUTER JOIN          
												, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
												, product_mstr                    prom          
												, excsm_prod_mstr                 excpm
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
							AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
							AND    excsm_list.excsm_id             = excsm.excsm_id    
							--AND    brokm.brom_excpm_id             = excpm.excpm_id      
							AND    prom.prom_cd                    = @l_product     
							AND    prom.prom_id                    = excpm.excpm_prom_id      
    						AND    compm.compm_id                  = excsm.excsm_compm_id        
							AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
							AND    combrkg.clidb_brom_id           = brokm.brom_id        
							AND    dpam.dpam_dpm_id                = dpm.dpm_id         
							AND    Brokm.Brom_deleted_ind          = 1         
							AND    dpam.dpam_deleted_ind           = 1            
							AND    excsm.excsm_deleted_ind         = 1        
							AND    compm.compm_deleted_ind         = 1        
							AND    dpm.dpm_deleted_ind             = 1        
							AND    PROM.PROM_DELETED_IND           = 1      
							AND    EXCPM.EXCPM_DELETED_IND         = 1          
							AND    clidb_deleted_ind               = 1
							AND    dpam.dpam_crn_no                = @PA_CRN_NO        
							ORDER BY clidb_eff_from_dt DESC
				--        
    END   
    --        
    IF @PA_TAB = 'CLIDPHD'        
    BEGIN        
    --        
       SELECT dphd_dpam_id          
            , dphd_dpam_sba_no          
            , isnull(dphd_sh_fname,'')            dphd_sh_fname        
            , isnull(dphd_sh_mname,'')            dphd_sh_mname        
            , isnull(dphd_sh_lname,'')            dphd_sh_lname        
            , isnull(dphd_sh_fthname,'')          dphd_sh_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_sh_dob,''),103) = '01/01/1900' THEN  '' ELSE convert(varchar,isnull(dphd_sh_dob,''),103) END    dphd_sh_dob          
            , isnull(dphd_sh_pan_no,'')           dphd_sh_pan_no        
            , isnull(dphd_sh_gender,'')           dphd_sh_gender        
            , isnull(dphd_th_fname,'')            dphd_th_fname        
            , isnull(dphd_th_mname,'')            dphd_th_mname        
            , isnull(dphd_th_lname,'')            dphd_th_lname        
            , isnull(dphd_th_fthname,'')          dphd_th_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_th_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_th_dob,''),103) END   dphd_th_dob          
            , isnull(dphd_th_pan_no,'')           dphd_th_pan_no        
            , isnull(dphd_th_gender,'')           dphd_th_gender        
            , isnull(dphd_nomgau_fname,'')           dphd_nomgau_fname        
            , isnull(dphd_nomgau_mname,'')           dphd_nomgau_mname        
            , isnull(dphd_nomgau_lname,'')           dphd_nomgau_lname        
            , isnull(dphd_nomgau_fthname,'')         dphd_nomgau_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103)    END    dphd_nomgau_dob          
            , isnull(dphd_nomgau_pan_no,'')          dphd_nomgau_pan_no        
            , isnull(dphd_nomgau_gender,'')          dphd_nomgau_gender       
            , isnull(dphd_nom_fname,'')           dphd_nom_fname        
            , isnull(dphd_nom_mname,'')           dphd_nom_mname        
            , isnull(dphd_nom_lname,'')           dphd_nom_lname        
            , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103)   = '01/01/1900' THEN  '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103)    END dphd_nom_dob          
            , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
            , isnull(dphd_nom_gender,'')          dphd_nom_gender        
				, ISNULL(NOM_NRN_NO,'')               dphd_nom_NRN_NO
            , isnull(dphd_gau_fname,'')           dphd_gau_fname        
            , isnull(dphd_gau_mname,'')           dphd_gau_mname        
            , isnull(dphd_gau_lname,'')           dphd_gau_lname        
            , isnull(dphd_gau_fthname,'')         dphd_gau_fthname        
            , CASE WHEN  convert(varchar,isnull(dphd_gau_dob,''),103)   = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_gau_dob,''),103)    END dphd_gau_dob          
            , isnull(dphd_gau_pan_no,'')          dphd_gau_pan_no        
            , isnull(dphd_gau_gender,'')          dphd_gau_gender        
            , isnull(dphd_fh_fthname,'')          dphd_fh_fthname        
            , isnull(dpam_subcm_cd,'')            dpam_subcm_cd
			, isnull(DPAM_CLICM_CD,'')            DPAM_CLICM_CD
			, isnull(DPAM_ENTTM_CD,'')            DPAM_ENTTM_CD

       FROM   dp_holder_dtls    dphd  WITH (NOLOCK)           
            , dp_acct_mstr      dam   WITH (NOLOCK)            
              /*        
              left outer join         
              entity_properties entp  on (dam.dpam_crn_no = entp.entp_ent_id )        
              left outer join        
     (SELECT DISTINCT entpm.entpm_prop_id prop_id          
               FROM   dp_acct_mstr              dpam          
                    , client_ctgry_mstr         clicm          
                    , entity_property_mstr      entpm        
                    , entity_type_mstr          enttm            
               WHERE  clicm.clicm_cd          = dpam_clicm_cd          
               AND    dpam.dpam_crn_no        = @pa_crn_no            
               AND    entpm.entpm_clicm_id    = clicm.clicm_id        
               AND    enttm.enttm_cd          = dpam.dpam_enttm_cd           
               AND    entpm.entpm_enttm_id    = enttm.enttm_id          
               AND    entpm.entpm_cd          = 'FTH_NAME'          
       AND    entpm_deleted_ind       = 1           
               AND    dpam.dpam_deleted_ind   = 1          
               AND    clicm.clicm_deleted_ind = 1        
               AND    enttm.enttm_deleted_ind = 1          
               )x  on (x.prop_id              = entp.entp_entpm_prop_id)        
               */        
        WHERE  dam.dpam_crn_no                = @pa_crn_no        
        AND    dam.dpam_sba_no                = convert(varchar, @pa_value)         
        AND    dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
        AND    dphd.dphd_deleted_ind          = 1          
        AND    dam.dpam_deleted_ind           = 1    


       if not exists(select dphd_dpam_sba_no from dp_holder_dtls where dphd_dpam_sba_no = convert(varchar, @pa_value))      
       begin
       --
       
       SELECT 0          
            , ''          
            , '' dphd_sh_fname        
            , '' dphd_sh_mname        
            , '' dphd_sh_lname        
            , '' dphd_sh_fthname        
            , '' dphd_sh_dob          
            , '' dphd_sh_pan_no        
            , '' dphd_sh_gender        
            , '' dphd_th_fname        
            , '' dphd_th_mname        
            , '' dphd_th_lname        
            , '' dphd_th_fthname        
            , '' dphd_th_dob          
            , '' dphd_th_pan_no        
            , '' dphd_th_gender        
            , '' dphd_nomgau_fname        
            , '' dphd_nomgau_mname        
            , '' dphd_nomgau_lname        
            , '' dphd_nomgau_fthname        
            , '' dphd_nomgau_dob          
            , '' dphd_nomgau_pan_no        
            , '' dphd_nomgau_gender       
            , '' dphd_nom_fname        
            , '' dphd_nom_mname        
            , '' dphd_nom_lname        
            , '' dphd_nom_fthname        
            , '' dphd_nom_dob          
            , '' dphd_nom_pan_no        
            , '' dphd_nom_gender        
            , '' dphd_gau_fname        
            , '' dphd_gau_mname        
            , '' dphd_gau_lname        
            , '' dphd_gau_fthname        
            , '' dphd_gau_dob          
            , '' dphd_gau_pan_no        
            , '' dphd_gau_gender        
            , '' dphd_fh_fthname        
            , '' dpam_subcm_cd
       FROM   dp_acct_mstr      dam   WITH (NOLOCK)            
       WHERE  dam.dpam_crn_no                = @pa_crn_no        
       AND    dam.dpam_sba_no                = convert(varchar, @pa_value)         
       AND    dam.dpam_deleted_ind           = 1  
       --
       end
    --        
    END 
    
    IF @PA_TAB = 'CLIDPHD_MOD'        
    BEGIN        
    --        
       SELECT dphd_dpam_id          
            , dphd_dpam_sba_no          
--            , isnull(dphd_sh_fname,'')            dphd_sh_fname        
--            , isnull(dphd_sh_mname,'')            dphd_sh_mname        
--            , isnull(dphd_sh_lname,'')            dphd_sh_lname        
--            , isnull(dphd_sh_fthname,'')          dphd_sh_fthname        
--            , CASE WHEN convert(varchar,isnull(dphd_sh_dob,''),103) = '01/01/1900' THEN  '' ELSE convert(varchar,isnull(dphd_sh_dob,''),103) END    dphd_sh_dob          
--            , isnull(dphd_sh_pan_no,'')           dphd_sh_pan_no        
--            , isnull(dphd_sh_gender,'')           dphd_sh_gender        
--            , isnull(dphd_th_fname,'')            dphd_th_fname        
--            , isnull(dphd_th_mname,'')            dphd_th_mname        
--            , isnull(dphd_th_lname,'')            dphd_th_lname        
--            , isnull(dphd_th_fthname,'')          dphd_th_fthname        
--            , CASE WHEN convert(varchar,isnull(dphd_th_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_th_dob,''),103) END   dphd_th_dob          
--            , isnull(dphd_th_pan_no,'')           dphd_th_pan_no        
--            , isnull(dphd_th_gender,'')           dphd_th_gender        
--            , isnull(dphd_nomgau_fname,'')           dphd_nomgau_fname        
--            , isnull(dphd_nomgau_mname,'')           dphd_nomgau_mname        
--            , isnull(dphd_nomgau_lname,'')           dphd_nomgau_lname        
--            , isnull(dphd_nomgau_fthname,'')         dphd_nomgau_fthname        
--            , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103)    END    dphd_nomgau_dob          
--            , isnull(dphd_nomgau_pan_no,'')          dphd_nomgau_pan_no        
--            , isnull(dphd_nomgau_gender,'')          dphd_nomgau_gender       
            , isnull(dphd_nom_fname,'')           dphd_nom_fname        
            , isnull(dphd_nom_mname,'')           dphd_nom_mname        
            , isnull(dphd_nom_lname,'')           dphd_nom_lname        
            , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103)   = '01/01/1900' THEN  '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103)    END dphd_nom_dob          
            , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
            , isnull(dphd_nom_gender,'')          dphd_nom_gender        
				, ISNULL(NOM_NRN_NO,'')               dphd_nom_NRN_NO
--            , isnull(dphd_gau_fname,'')           dphd_gau_fname        
--            , isnull(dphd_gau_mname,'')           dphd_gau_mname        
--            , isnull(dphd_gau_lname,'')           dphd_gau_lname        
--            , isnull(dphd_gau_fthname,'')         dphd_gau_fthname        
--            , CASE WHEN  convert(varchar,isnull(dphd_gau_dob,''),103)   = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_gau_dob,''),103)    END dphd_gau_dob          
--            , isnull(dphd_gau_pan_no,'')          dphd_gau_pan_no        
--            , isnull(dphd_gau_gender,'')          dphd_gau_gender        
--            , isnull(dphd_fh_fthname,'')          dphd_fh_fthname        
--            , isnull(dpam_subcm_cd,'')            dpam_subcm_cd
--			, isnull(DPAM_CLICM_CD,'')            DPAM_CLICM_CD
--			, isnull(DPAM_ENTTM_CD,'')            DPAM_ENTTM_CD

       FROM   dp_holder_dtls    dphd  WITH (NOLOCK)           
            , dp_acct_mstr      dam   WITH (NOLOCK)            
              /*        
              left outer join         
              entity_properties entp  on (dam.dpam_crn_no = entp.entp_ent_id )        
              left outer join        
     (SELECT DISTINCT entpm.entpm_prop_id prop_id          
               FROM   dp_acct_mstr              dpam          
                    , client_ctgry_mstr         clicm          
                    , entity_property_mstr      entpm        
                    , entity_type_mstr          enttm            
               WHERE  clicm.clicm_cd          = dpam_clicm_cd          
               AND    dpam.dpam_crn_no        = @pa_crn_no            
               AND    entpm.entpm_clicm_id    = clicm.clicm_id        
               AND    enttm.enttm_cd          = dpam.dpam_enttm_cd           
               AND    entpm.entpm_enttm_id    = enttm.enttm_id          
               AND    entpm.entpm_cd          = 'FTH_NAME'          
       AND    entpm_deleted_ind       = 1           
               AND    dpam.dpam_deleted_ind   = 1          
               AND    clicm.clicm_deleted_ind = 1        
               AND    enttm.enttm_deleted_ind = 1          
               )x  on (x.prop_id              = entp.entp_entpm_prop_id)        
               */        
        WHERE  dam.dpam_crn_no                = @pa_crn_no        
        AND    dam.dpam_sba_no                = convert(varchar, @pa_value)         
        AND    dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
        AND    dphd.dphd_deleted_ind          = 1          
        AND    dam.dpam_deleted_ind           = 1  
		and    dam.dpam_sba_no                = @pa_value
	end        
    IF @PA_TAB = 'CLIDPPD'        
				BEGIN        
				--       
				print '111' 
							SELECT dppd_dpam_id          
												, isnull(dppd_fname,'')           fname        
												, isnull(dppd_mname,'')           mname        
												, isnull(dppd_lname,'')           lname        
												, isnull(dppd_fthname,'')         fthname        
												, case when convert(varchar,isnull(dppd_dob,''),103)  = '01/01/1900' then '' else convert(varchar,isnull(dppd_dob,''),103) end dob          
												, isnull(dppd_pan_no,'')          pan        
												, isnull(dppd_gender,'')          gender        
												, isnull(dppd_hld,'')             holdertype
												, isnull(dppd_poa_type,'')        poatype
												, dpam_excsm_id                   excsm_id
												, dpm.dpm_dpid                    dpid  
												, compm_id                        compm_id
												, CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
												, compm.compm_short_name             compm_short_name        
												, excsm.excsm_exch_cd                excsm_exch_cd        
            , excsm.excsm_seg_cd                 excsm_seg_cd
            , dppd_poa_id 
												, case when convert(varchar(11),dppd_setup,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_setup,103) end dppd_setup
												, dppd_gpabpa_flg 
												, case when convert(varchar(11),dppd_eff_fr_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_fr_dt,103) end dppd_eff_fr_dt
            , case when convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_TO_dt,103) end dppd_eff_TO_dt
            , dppd.dppd_id                       dppd_id 
            ,dppd_master_id
             ,'' dppd_relapptxt
            ,''dppd_uid
            ,'' dppd_polconntxt
            ,'' dppd_relapp
            ,'' dppd_polconn
							FROM   dp_poa_dtls       dppd  WITH (NOLOCK)           
												, dp_acct_mstr      dpam   WITH (NOLOCK)
												, dp_mstr           dpm   WITH (NOLOCK)
												, company_mstr      compm WITH (NOLOCK)
												, exch_seg_mstr     excsm WITH (NOLOCK)
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_crn_no                = @pa_crn_no  
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    excsm.excsm_id                  = dpam.dpam_excsm_id
							AND    excsm_list.excsm_id                 = excsm.excsm_id 
							AND    excsm.excsm_compm_id            = compm.compm_id
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    dpam.dpam_id                    = dppd.dppd_dpam_id
							AND    dppd.dppd_deleted_ind           = 1          
							AND    dpam.dpam_deleted_ind           = 1          
				--        
    END   
    
    IF @PA_TAB = 'CLIDPPD_MOD'        
				BEGIN        

				--        
							SELECT distinct dppd_dpam_id          
												, isnull(dppd_fname,'')           fname        
												, isnull(dppd_mname,'')           mname        
												, isnull(dppd_lname,'')           lname        
												, isnull(dppd_fthname,'')         fthname        
												, case when convert(varchar,isnull(dppd_dob,''),103)  = '01/01/1900' then '' else convert(varchar,isnull(dppd_dob,''),103) end dob          
												, isnull(dppd_pan_no,'')          pan        
												, isnull(dppd_gender,'')          gender        
												, isnull(dppd_hld,'')             holdertype
												, isnull(dppd_poa_type,'')        poatype
												, dpam_excsm_id                   excsm_id
												, dpm.dpm_dpid                    dpid  
												, compm_id                        compm_id
												, CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
												, compm.compm_short_name             compm_short_name        
												, excsm.excsm_exch_cd                excsm_exch_cd        
            , excsm.excsm_seg_cd                 excsm_seg_cd
            , dppd_poa_id 
												, case when convert(varchar(11),dppd_setup,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_setup,103) end dppd_setup
												, dppd_gpabpa_flg 
												, case when convert(varchar(11),dppd_eff_fr_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_fr_dt,103) end dppd_eff_fr_dt
            , case when convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_TO_dt,103) end dppd_eff_TO_dt
            , dppd.dppd_id                       dppd_id 
             ,dppd_master_id
							FROM   dp_poa_dtls       dppd  WITH (NOLOCK)           
												, dp_acct_mstr      dpam   WITH (NOLOCK)
												, dp_mstr           dpm   WITH (NOLOCK)
												, company_mstr      compm WITH (NOLOCK)
												, exch_seg_mstr     excsm WITH (NOLOCK)
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_crn_no                = @pa_crn_no  
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    excsm.excsm_id                  = dpam.dpam_excsm_id
							AND    excsm_list.excsm_id             = excsm.excsm_id 
							AND    excsm.excsm_compm_id            = compm.compm_id
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    dpam.dpam_id                    = dppd.dppd_dpam_id
							AND    dppd.dppd_deleted_ind           = 1          
							AND    dpam.dpam_deleted_ind           = 1     
							AND    dpam.dpam_sba_no  			   = @pa_acct_no  
							---and    convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900'
							and   ( convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' or convert(varchar(11),dppd_eff_TO_dt,103)  ='31/12/2100' or convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/2049' )
				--        
    END  
    --        
    IF @PA_TAB = 'CLIDPBA'        
    BEGIN        
    --        
    
      SELECT cliba.cliba_ac_name                cliba_ac_name        
           , cliba.cliba_banm_id                cliba_banm_id        
           , CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
           , dpm.dpm_dpid                       dpid                         
--           , banm.banm_name + '~' +isnull(BANM_BRANCH,'	') + '~' + convert(varchar(20),isnull(BANM_MICR,0)) + '~'
--             + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) + '~' bank_name
			, banm.banm_name + '-' + convert(varchar(20),isnull(BANM_MICR,0)) + '-' + ISNULL(banm_rtgs_cd,'') BANK_NAME
			,isnull(BANM_BRANCH,'	')  BANM_BRANCH
			, convert(varchar(20),isnull(BANM_MICR,0)) BANM_MICR
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) banm_add1
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) banm_add2
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) banm_add3
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) banm_city
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) banm_state
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) banm_nation
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) banm_pincode
           --, banm.banm_branch         
           , cliba.cliba_ac_type                cliba_ac_type        
           , cliba.cliba_ac_no                  cliba_ac_no        
           , cliba.cliba_flg & 1                def_flg        
           , cliba.cliba_flg & 2                poa_flg        
           , compm.compm_id                     compm_id        
           , compm.compm_short_name             compm_short_name        
           , excsm.excsm_exch_cd                excsm_exch_cd        
           , excsm.excsm_seg_cd                 excsm_seg_cd        
           , excsm.excsm_id                     excsm_id  
           ,compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat         
        ,convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no) rel_value              
      FROM   dp_acct_mstr                       dpam     WITH (NOLOCK)        
           , client_bank_accts                  cliba    WITH (NOLOCK)        
           , bank_mstr                          banm     WITH (NOLOCK)        
           , exch_seg_mstr                      excsm    WITH (NOLOCK)        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
           , company_mstr                       compm    WITH (NOLOCK)        
           , dp_mstr                            dpm      WITH (NOLOCK)        
      WHERE  dpam.dpam_crn_no                 = @pa_crn_no        
      AND    compm.compm_id                   = excsm.excsm_compm_id        
      AND    excsm.excsm_id                   = dpam.dpam_excsm_id         
      AND    cliba.cliba_clisba_id            = dpam.dpam_id        
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    dpm.dpm_id                       = dpam.dpam_dpm_id          
      AND    banm.banm_id                     = cliba.cliba_banm_id        
      AND    cliba.cliba_deleted_ind          = 1        
      AND    banm.banm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind          = 1        
      AND    dpm.dpm_deleted_ind              = 1        
      AND    dpam.dpam_deleted_ind            = 1        
    --        
    END        
    --        
    IF @PA_TAB = 'CLIDPENTR'        
    BEGIN        
    --        
    --compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd        
      --CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
      --SELECT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+convert(varchar, dpam.dpam_sba_no)    Comp_Exch_Seg_Demat        
      SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dm.dpm_dpid),2) = 'IN' THEN dm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
           , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,entr.entr_from_dt,103)+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'        
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'        
                         +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value         
           , CONVERT(varchar,entr.entr_from_dt,103)   entr_from_dt    
           , isnull( CONVERT(varchar,entr.entr_to_dt,103) ,'2900-01-01 00:00:00.000')  entr_to_dt 
      FROM   entity_relationship                  entr     WITH (NOLOCK)        
          ,  exch_seg_mstr                        excsm    WITH (NOLOCK)        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
          ,  company_mstr                         compm    WITH (NOLOCK)        
          ,  dp_acct_mstr                         dpam     WITH (NOLOCK)        
          ,  dp_mstr                              dm       WITH (NOLOCK)         
          ,  product_mstr                         prom     WITH (NOLOCK)               
          ,  excsm_prod_mstr                      excpm    WITH (NOLOCK)    
      WHERE  entr.entr_crn_no                   = @pa_crn_no           
      AND    dpam.dpam_crn_no                   = entr.entr_crn_no        
      AND    dpam.dpam_sba_no                   = entr.entr_sba            
      AND    dpam.dpam_dpm_id                   = dm.dpm_id          
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    dpam.dpam_excsm_id                 = excsm.excsm_id           
      AND    compm.compm_id                     = excsm.excsm_compm_id        
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id
						AND    prom.prom_id                       = excpm.excpm_prom_id
      and    prom.prom_cd                       = @l_product
      AND    entr.entr_deleted_ind              = 1         
      AND    excsm.excsm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind            = 1        
      AND    dm.dpm_deleted_ind                 = 1        
      AND    dpam.dpam_deleted_ind = 1         
      order  by entr_from_dt desc        
     --           
     END        
     --        
     IF @pa_tab = 'CLIDPAM_PROP'        
     BEGIN     
     print 'yogesh'   
     --        
        /*SELECT DISTINCT excsm.excsm_exch_cd  excsm_exch_cd        
             , excsm.excsm_seg_cd            excsm_seg_cd         
             , entpm.entpm_prop_id           entpm_prop_id        
             , entpm.entpm_cd                entpm_cd        
             , entp.entp_value               entp_value        
             , entpm.entpm_desc              entpm_desc        
             , entdm.entdm_id                entdm_id          
             , entdm.entdm_cd                entdm_cd        
             , entpd.entpd_value             entpd_value        
             , entdm.entdm_desc              entdm_desc        
             , entdm.entdm_datatype          entdm_datatype        
             , entpm.entpm_mdty              entpm_mdty        
             , entdm.entdm_mdty              entdm_mdty        
             , entpm.entpm_datatype          entpm_datatype        
             , case excsm.excsm_exch_cd WHEN 'CDSL'THEN convert(varchar,1) WHEN 'NSDL'THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1          
        FROM   dp_acct_mstr                  dpam  WITH (NOLOCK)        
        
             , exch_seg_mstr                 excsm WITH (NOLOCK)        
             , client_ctgry_mstr             clicm WITH (NOLOCK)        
             , entity_type_mstr              enttm WITH (NOLOCK)        
             , entity_property_mstr          entpm WITH (NOLOCK)        
               LEFT OUTER JOIN        
               entpm_dtls_mstr               entdm WITH (NOLOCK) on (entpm.entpm_prop_id = entdm.entdm_entpm_prop_id)         
               LEFT OUTER JOIN        
               entity_properties             entp  WITH (NOLOCK) on (entp.entp_entpm_prop_id = entpm.entpm_prop_id ) and (entp.entp_ent_id = @pa_crn_no)         
               LEFT OUTER JOIN         
               entity_property_dtls          entpd WITH (NOLOCK) on (entpd.entpd_entp_id = entp.entp_id) and (entpd.entpd_entdm_id = entdm.entdm_id)        
        WHERE  dpam.dpam_excsm_id         =  excsm.excsm_id        
        AND    dpam.dpam_clicm_cd         =  clicm.clicm_cd        
        AND    dpam.dpam_enttm_cd         =  enttm.enttm_cd        
        AND    entpm.entpm_clicm_id       =  clicm.clicm_id        
        AND    entpm.entpm_enttm_id       =  enttm.enttm_id        
        AND    dpam.dpam_crn_no           =  @pa_crn_no        
        AND    dpam.dpam_deleted_ind      =  1        
        AND    excsm.excsm_deleted_ind    =  1         
        AND    clicm.clicm_deleted_ind    =  1        
     AND    entpm.entpm_deleted_ind    =  1        
        ORDER BY ord1--, entpm.entpm_cd, entdm.entdm_cd        */
        
        SELECT DISTINCT excsm.excsm_exch_cd  excsm_exch_cd        
													, excsm.excsm_seg_cd            excsm_seg_cd         
													, entpm.entpm_prop_id           entpm_prop_id        
													, entpm.entpm_cd                entpm_cd        
													, entp.entp_value               entp_value        
													, entpm.entpm_desc              entpm_desc        
													, isnull(entdm.entdm_id,0)                entdm_id          
													, entdm.entdm_cd                entdm_cd        
													, entpd.entpd_value             entpd_value        
													, entdm.entdm_desc              entdm_desc        
													, entdm.entdm_datatype          entdm_datatype        
													, case when entpm.entpm_mdty = 1 then 'M' else 'N' end              entpm_mdty        
													, case when entdm.entdm_mdty = 1 then 'M' else 'N' end              entdm_mdty        
													, entpm.entpm_datatype          entpm_datatype        
													, case excsm.excsm_exch_cd WHEN 'CDSL'THEN convert(varchar,1) WHEN 'NSDL'THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1          
								FROM   dp_acct_mstr                  dpam  WITH (NOLOCK)        
															left outer join 
															exch_seg_mstr                 excsm WITH (NOLOCK)   on dpam.dpam_excsm_id = excsm.excsm_id     
													, excsm_prod_mstr               excpm WITH (NOLOCK)
													, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
													, client_ctgry_mstr             clicm WITH (NOLOCK)        
													, entity_type_mstr              enttm WITH (NOLOCK)        
													, entity_property_mstr          entpm WITH (NOLOCK)        
															LEFT OUTER JOIN        
															entpm_dtls_mstr               entdm WITH (NOLOCK) on (entpm.entpm_prop_id = entdm.entdm_entpm_prop_id)         
															LEFT OUTER JOIN        
															entity_properties             entp  WITH (NOLOCK) on (entp.entp_entpm_prop_id = entpm.entpm_prop_id ) and (entp.entp_ent_id = @pa_crn_no)         
															LEFT OUTER JOIN         
															entity_property_dtls          entpd WITH (NOLOCK) on (entpd.entpd_entp_id = entp.entp_id) and (entpd.entpd_entdm_id = entdm.entdm_id)        
								WHERE  dpam.dpam_excsm_id         =  excsm.excsm_id        
								AND    dpam.dpam_clicm_cd         =  clicm.clicm_cd        
								AND    excsm_list.excsm_id                 = excsm.excsm_id 
								AND    dpam.dpam_enttm_cd         =  enttm.enttm_cd        
								AND    entpm.entpm_clicm_id       =  clicm.clicm_id        
								AND    entpm.entpm_enttm_id       =  enttm.enttm_id   
								AND    entpm.entpm_excpm_id       =  excpm.excpm_id   
								AND    excpm.excpm_excsm_id       =  excsm.excsm_id
								AND    dpam.dpam_crn_no           =  @pa_crn_no       
								AND    dpam.dpam_deleted_ind      =  1        
								AND    excsm.excsm_deleted_ind    =  1         
								AND    clicm.clicm_deleted_ind    =  1        
        AND    entpm.entpm_deleted_ind    =  1  
      --                      
      END  
      
      IF @pa_tab = 'CLIDPAM_PROP_MOD'        
     BEGIN        
     --        
        SELECT DISTINCT excsm.excsm_exch_cd  excsm_exch_cd        
				, excsm.excsm_seg_cd            excsm_seg_cd         
				, entpm.entpm_prop_id           entpm_prop_id        
				, entpm.entpm_cd                entpm_cd        
				, entp.entp_value               entp_value        
				, entpm.entpm_desc              entpm_desc        
				, isnull(entdm.entdm_id,0)                entdm_id          
				, entdm.entdm_cd                entdm_cd        
				, entpd.entpd_value             entpd_value        
				, entdm.entdm_desc              entdm_desc        
				, entdm.entdm_datatype          entdm_datatype        
				, case when entpm.entpm_mdty = 1 then 'M' else 'N' end              entpm_mdty        
				, case when entdm.entdm_mdty = 1 then 'M' else 'N' end              entdm_mdty        
				, entpm.entpm_datatype          entpm_datatype        
				, case excsm.excsm_exch_cd WHEN 'CDSL'THEN convert(varchar,1) WHEN 'NSDL'THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1          
				FROM   dp_acct_mstr                  dpam  WITH (NOLOCK)        
						left outer join 
						exch_seg_mstr                 excsm WITH (NOLOCK)   on dpam.dpam_excsm_id = excsm.excsm_id     
				, excsm_prod_mstr               excpm WITH (NOLOCK)
				, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
				, client_ctgry_mstr             clicm WITH (NOLOCK)        
				, entity_type_mstr              enttm WITH (NOLOCK)        
				, entity_property_mstr          entpm WITH (NOLOCK)        
						LEFT OUTER JOIN        
						entpm_dtls_mstr               entdm WITH (NOLOCK) on (entpm.entpm_prop_id = entdm.entdm_entpm_prop_id)         
						LEFT OUTER JOIN        
						entity_properties             entp  WITH (NOLOCK) on (entp.entp_entpm_prop_id = entpm.entpm_prop_id ) and (entp.entp_ent_id = @pa_crn_no)         
						LEFT OUTER JOIN         
						entity_property_dtls          entpd WITH (NOLOCK) on (entpd.entpd_entp_id = entp.entp_id) and (entpd.entpd_entdm_id = entdm.entdm_id)        
		WHERE  dpam.dpam_excsm_id         =  excsm.excsm_id        
		AND    dpam.dpam_clicm_cd         =  clicm.clicm_cd        
		AND    excsm_list.excsm_id                 = excsm.excsm_id 
		AND    dpam.dpam_enttm_cd         =  enttm.enttm_cd        
		AND    entpm.entpm_clicm_id       =  clicm.clicm_id        
		AND    entpm.entpm_enttm_id       =  enttm.enttm_id   
		AND    entpm.entpm_excpm_id       =  excpm.excpm_id   
		AND    excpm.excpm_excsm_id       =  excsm.excsm_id
		AND    dpam.dpam_crn_no           =  @pa_crn_no       
		AND    dpam.dpam_deleted_ind      =  1        
		AND    excsm.excsm_deleted_ind    =  1         
		AND    clicm.clicm_deleted_ind    =  1        
        AND    entpm.entpm_deleted_ind    =  1  
		AND	   entpm.entpm_cd = @PA_VALUE  
		--and    dpam.dpam_sba_no = @pa_acct_no
      --                      
      END        
      --        
      IF @pa_tab  = 'CLIDPAM_DOC'        
      BEGIN        
      --        
        SELECT DISTINCT y.excsm_exch_cd                excsm_exch_cd        
                      , y.excsm_seg_cd                 excsm_seg_cd        
                       , isnull(x.clid_doc_path,'')   clid_doc_path          
                    , isnull(x.clid_remarks ,'')   clid_remarks          
                    , isnull(x.docm_doc_id ,0)   docm_doc_id          
                    , isnull(x.docm_desc,'')       docm_desc          
                    , y.clicm_id        clicm_id          
                    , isnull(x.docm_mdty ,'')      docm_mdty          
                    , isnull(x.clid_valid_yn,0)   clid_valid_yn           
                    , y.dpam_enttm_cd   dpam_enttm_cd          
                    , y.exch              exch  
        FROM         
        (SELECT DISTINCT ISNULL(clid.clid_doc_path,'') clid_doc_path          
              , ISNULL(clid.clid_remarks,'')           clid_remarks            
              , docm.docm_doc_id                       docm_doc_id          
              , ISNULL(docm.docm_desc,'')              docm_desc        
              , docm.docm_enttm_id                     docm_enttm_id          
              , docm.docm_clicm_id                     docm_clicm_id          
              , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty          
              , ISNULL(clid.clid_valid_yn,0)           clid_valid_yn        
        FROM    document_mstr                          docm        
                left outer join        
                client_documents                       clid on (clid.clid_docm_doc_id = docm.docm_doc_id and clid.clid_crn_no = @pa_crn_no)        
        WHERE   isnull(clid.clid_deleted_ind,1)      = 1        
        AND     docm.docm_deleted_ind                = 1        
        )x        
        RIGHT OUTER JOIN        
        (SELECT DISTINCT clicm.clicm_id                clicm_id        
              , excsm.excsm_exch_cd                    excsm_exch_cd        
              , excsm.excsm_seg_cd                     excsm_seg_cd           
              , enttm.enttm_id                         enttm_id        
              , dpam.dpam_enttm_cd                     dpam_enttm_cd         
              , CASE excsm.excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  exch        
         from   dp_acct_mstr                           dpam        
              , exch_seg_mstr                          excsm  WITH (NOLOCK)        
              , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
              , client_ctgry_mstr                      clicm  WITH (NOLOCK)        
              , entity_type_mstr                       enttm  WITH (NOLOCK)             
         where  dpam.dpam_crn_no                     = @pa_crn_no        
         AND    dpam.dpam_clicm_cd                   = clicm.clicm_cd        
         AND    excsm_list.excsm_id                 = excsm.excsm_id 
         AND    enttm.enttm_cd                       = dpam.dpam_enttm_cd        
         AND    dpam.dpam_excsm_id                   = excsm.excsm_id        
         AND    dpam.dpam_deleted_ind                = 1        
         AND    excsm.excsm_deleted_ind              = 1        
    AND    enttm.enttm_deleted_ind              = 1        
         AND    clicm.clicm_deleted_ind              = 1        
        )y        
        ON (x.docm_enttm_id = y.enttm_id) and (x.docm_clicm_id = y.clicm_id)        
        ORDER BY exch        
      --        
      END        
      IF @pa_tab  = 'CLIM_DP'        
      BEGIN        
      --    
        print 'mayur'    
        SELECT clim.clim_name1                         clim_name1          
             , ISNULL(clim.clim_name2, '')             clim_name2          
             , ISNULL(clim.clim_name3, '')             clim_name3          
             , clim.clim_short_name                    clim_short_name          
             , clim.clim_gender           clim_gender          
             , case when CONVERT(VARCHAR,isnull(clim.clim_dob,''),103) = '01/01/1900' then '' else  CONVERT(VARCHAR,isnull(clim.clim_dob,''),103) end     clim_dob          
             , clim.clim_stam_cd                       clim_stam_cd          
             , isnull(clim.clim_rmks,'')               clim_rmks          
             , isnull(clim.clim_sbum_id,0)             clim_sbum_id          
             , isnull(sbum.sbum_desc,'')               sbum_desc          
        FROM   client_mstr                             clim   WITH (NOLOCK)          
                  , sbu_mstr                           sbum   WITH (NOLOCK)        
        WHERE  clim.clim_sbum_id                     = sbum.sbum_id          
        AND    clim.clim_crn_no                      = @pa_crn_no          
        AND    clim.clim_deleted_ind                 = 1          
      --        
      END        
      --        
      IF @pa_tab = 'DPID_SEL'        
      BEGIN        
      --        
        /*SELECT dpm.dpm_id             dpm_id        
             , dpm.dpm_dpid           dpm_dpid        
             , dpm.dpm_name           dpm_name        
        FROM   dp_mstr                dpm   WITH (NOLOCK) 
             , exch_seg_mstr          excsm
        WHERE  dpm_excsm_id         = excsm.excsm_id
        AND    excsm.excsm_id       = @pa_id
        AND    dpm_deleted_ind      = 1        */
        SELECT dpm.dpm_id             dpm_id        
													, dpm.dpm_dpid           dpm_dpid        
													, dpm.dpm_name           dpm_name        
								FROM   dp_mstr                dpm   WITH (NOLOCK) 
								WHERE  default_dp           = @pa_id
        AND    dpm_deleted_ind      = 1    
      --        
      END        
      --        
      IF @pa_tab = 'DPA_APP_SELECT'        
      BEGIN        
      --        
      print '11'
        SELECT DISTINCT compm.compm_id           compm_id        
            , compm.compm_short_name             compm_short_name        
            , excsm.excsm_id                     excsm_id        
            , excsm.excsm_exch_cd                excsm_exch_cd        
            , excsm.excsm_seg_cd                 excsm_seg_cd        
            , dpamm.dpam_id                      dpam_id        
            , dpamm.dpam_acct_no                 dpam_acct_no        
            , dpm.dpm_dpid                       dpm_dpid         
            , ISNULL(dpamm.dpam_sba_name, 0)     dpam_sba_name        
            , CASE clil.clim_ins_upd_del WHEN 'I' THEN 'ADD'        
               WHEN 'E' THEN 'EDIT'        
                                         WHEN 'D' THEN 'DELETE'                   
                                         END     Status          
        FROM  dp_acct_mstr_mak                   dpamm    WITH (NOLOCK)        
            , dp_mstr                            dpm      WITH (NOLOCK)        
            , exch_seg_mstr                      excsm    WITH (NOLOCK)        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , company_mstr                       compm    WITH (NOLOCK)        
            , client_list                        clil     WITH (NOLOCK)        
        WHERE  excsm.excsm_id                  = dpamm.dpam_excsm_id        
        AND    dpamm.dpam_dpm_id               = dpm.dpm_id        
        AND    compm.compm_id                  = excsm.excsm_compm_id        
        AND    dpamm.dpam_id               = clil.clisba_no        
        AND    dpamm.dpam_crn_no               = clil.clim_crn_no        
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND    dpamm.dpam_deleted_ind          IN(0,4,8)        
        AND    excsm.excsm_deleted_ind         = 1        
        AND    compm.compm_deleted_ind         = 1        
        AND    dpamm.dpam_crn_no               = @pa_crn_no        
        AND    clil.clim_status                = 0        
        AND    clil.clim_deleted_ind           = 1         
        AND    dpm.dpm_deleted_ind             = 1        
        UNION        
        SELECT DISTINCT compm.compm_id     compm_id        
             , compm.compm_short_name      compm_short_name        
             , excsm.excsm_id              excsm_id        
             , excsm.excsm_exch_cd         excsm_exch_cd        
             , excsm.excsm_seg_cd          excsm_seg_cd        
             , dpam.dpam_id                dpam_id        
             , dpam.dpam_acct_no           dpam_acct_no        
             , dpm.dpm_dpid                dpm_dpid         
             , ISNULL(dpam.dpam_sba_name, '') dpam_sba_name                       
             , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'        
                                           WHEN 'E' THEN 'EDIT'        
                      WHEN 'D' THEN 'DELETE'                   
                                           END  Status        
        FROM  dp_Acct_mstr                 dpam  WITH (NOLOCK)          
            , dp_mstr                      dpm      WITH (NOLOCK)        
            , exch_seg_mstr                excsm   WITH (NOLOCK)        
            
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , company_mstr                 compm   WITH (NOLOCK)        
            , client_list                  clil    WITH (NOLOCK)        
        WHERE excsm.excsm_id            =  dpam.dpam_excsm_id        
        AND   dpam.dpam_dpm_id          =  dpm.dpm_id        
        AND   compm.compm_id            =  excsm.excsm_compm_id        
        AND   dpam.dpam_id          =  clil.clisba_no        
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND   dpam.dpam_crn_no          =  clil.clim_crn_no        
        AND   ISNULL(excsm.excsm_deleted_ind, 0) = 1        
        AND   dpam.dpam_deleted_ind     = 1        
        AND   compm.compm_deleted_ind   = 1        
        AND   dpam.dpam_crn_no          = @pa_crn_no        
        AND   dpam.dpam_id         NOT IN  (SELECT dpam_id          
                                            FROM   dp_acct_mstr_mak         
                                            WHERE  dpam_deleted_ind IN (0, 4, 8)        
                                            AND    dpam_crn_no       = @pa_crn_no        
                                           )        
        AND    clil.clim_status         = 0        
        AND    clil.clim_deleted_ind    = 1        
        AND    dpm.dpm_deleted_ind      = 1        
     --        
     END         
  --           
  END--chk_0_2        

  
  -----------------------------------------------------------------------------------------------        
  ELSE        
  BEGIN--chk_1        
  --      
IF @pa_tab = 'DEMATINFODISP'
  BEGIN
  ---
	SELECT DISTINCT  
				 compm.compm_short_name             compm_short_name        
	             
				, excsm.excsm_exch_cd                excsm_exch_cd        
				, excsm.excsm_seg_cd                 excsm_seg_cd        
				  , dpamm.dpam_SBA_no                 dpam_SBA_no   
				, dpamm.dpam_acct_no                 dpam_acct_no        
				, dpm.dpm_dpid                       dpm_dpid         
				, ISNULL(dpamm.dpam_sba_name, 0)     dpam_sba_name       
	            
			FROM  dp_acct_mstr_mak                   dpamm    WITH (NOLOCK)        
				, dp_mstr                            dpm      WITH (NOLOCK)        
				, exch_seg_mstr                      excsm    WITH (NOLOCK)        
				, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
				, company_mstr                       compm    WITH (NOLOCK)  
			WHERE  excsm.excsm_id                  = dpamm.dpam_excsm_id        
			AND    dpamm.dpam_dpm_id               = dpm.dpm_id        
			AND    compm.compm_id                  = excsm.excsm_compm_id   
			AND    excsm_list.excsm_id                 = excsm.excsm_id 
			AND    dpamm.dpam_deleted_ind          IN(0)        
			AND    excsm.excsm_deleted_ind         = 1        
			AND    compm.compm_deleted_ind         = 1        
			AND    dpamm.dpam_crn_no               = @pa_crn_no                        
			AND    dpm.dpm_deleted_ind             = 1    
	UNION
	SELECT DISTINCT  compm.compm_short_name             compm_short_name        
	              
				, excsm.excsm_exch_cd                excsm_exch_cd        
				, excsm.excsm_seg_cd                 excsm_seg_cd        
				, dpamm.dpam_SBA_no                 dpam_SBA_no       
				, dpamm.dpam_acct_no                 dpam_acct_no        
				, dpm.dpm_dpid                       dpm_dpid         
				, ISNULL(dpamm.dpam_sba_name, 0)     dpam_sba_name       
	            
			FROM  dp_acct_mstr                   dpamm    WITH (NOLOCK)        
				, dp_mstr                            dpm      WITH (NOLOCK)        
				, exch_seg_mstr                      excsm    WITH (NOLOCK)        
				, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
				, company_mstr                       compm    WITH (NOLOCK)  
			WHERE  excsm.excsm_id                  = dpamm.dpam_excsm_id        
			AND    dpamm.dpam_dpm_id               = dpm.dpm_id        
			AND    compm.compm_id                  = excsm.excsm_compm_id   
			AND    excsm_list.excsm_id                 = excsm.excsm_id 
			AND    dpamm.dpam_deleted_ind          IN(1)        
			AND    excsm.excsm_deleted_ind         = 1        
			AND    compm.compm_deleted_ind         = 1        
			AND    dpamm.dpam_crn_no               = @pa_crn_no                        
			AND    dpm.dpm_deleted_ind             = 1
  ---
  END
  
    IF @pa_tab  = 'CLIM_DP'        
    BEGIN--clim_dp        
    --        
      SELECT climm.clim_name1                    clim_name1          
           , isnull(climm.clim_name2, '')        clim_name2          
           , isnull(climm.clim_name3, '')        clim_name3          
           , climm.clim_short_name               clim_short_name          
           , climm.clim_gender                   clim_gender          
           , case when convert(varchar,isnull(climm.clim_dob,''),103) = '01/01/1900' then '' else convert(varchar,isnull(climm.clim_dob,''),103) end clim_dob          
           , climm.clim_stam_cd                  clim_stam_cd          
           , isnull(climm.clim_rmks,'')          clim_rmks          
           , isnull(climm.clim_sbum_id,0)        clim_sbum_id          
           , isnull(sbum.sbum_desc,'')           sbum_desc          
      FROM   client_mstr_mak                     climm  WITH (NOLOCK)          
           , sbu_mstr                            sbum   WITH (NOLOCK)        
      WHERE  climm.clim_sbum_id                = sbum.sbum_id          
      AND    climm.clim_crn_no                 = @pa_crn_no          
      AND    isnull(climm.clim_deleted_ind,0) IN (0,8)          
      UNION        
      SELECT clim.clim_name1                    clim_name1          
           , ISNULL(clim.clim_name2, '')        clim_name2          
           , ISNULL(clim.clim_name3, '')        clim_name3          
           , clim.clim_short_name         clim_short_name          
           , clim.clim_gender                   clim_gender          
           , case when convert(varchar,isnull(clim.clim_dob,''),103) = '01/01/1900' then '' else convert(varchar,isnull(clim.clim_dob,''),103)  end clim_dob          
           , clim.clim_stam_cd                  clim_stam_cd          
           , isnull(clim.clim_rmks,'')          clim_rmks          
           , isnull(clim.clim_sbum_id,0)        clim_sbum_id          
           , isnull(sbum.sbum_desc,'')          sbum_desc          
      FROM   client_mstr                        clim  WITH (NOLOCK)          
           , sbu_mstr                           sbum  WITH (NOLOCK)        
      WHERE  clim.clim_sbum_id                = sbum.sbum_id          
      AND    clim.clim_crn_no                 = @pa_crn_no          
      AND    clim.clim_crn_no            NOT IN (SELECT climm.clim_crn_no         
                                                 FROM   client_mstr_mak           climm  WITH (NOLOCK)        
                                                 WHERE  climm.clim_crn_no       = @pa_crn_no         
                                                 AND    climm.clim_deleted_ind IN (0,8)          
                                                )        
      AND    clim.clim_deleted_ind            = 1          
    --        
    END--clim_dp        
    --   
     
    IF @PA_TAB = 'CLIDPAM'        
    BEGIN--clidpam        
    --        
      SELECT DISTINCT compm.compm_id         compm_id            
						           , compm.compm_short_name          compm_short_name            
						           , excsm.excsm_id                  excsm_id            
						           , excsm.excsm_exch_cd             excsm_exch_cd            
						           , excsm.excsm_seg_cd              excsm_seg_cd            
						           , dpam.dpam_acct_no               acct_no            
						           , dpam.dpam_id                    dpam_id           
						           , isnull(dpam.dpam_sba_no, 0)     dpam_sba_no            
						           --, isnull(brokm.brom_desc ,'')     brom_desc          
						           , sm.stam_desc    stam_desc        
						           , sm.stam_cd                      stam_cd          
						           , dpam.dpam_enttm_cd              enttm_cd        
						           , cm.clicm_desc                   clicm_desc        
						           , enttm.enttm_desc                enttm_desc                        
																	, dpam.dpam_subcm_cd              subcm_cd                
                 , subcm.subcm_desc                subcm_desc
						           , dpm.dpm_dpid                    dpid        
						           , ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name        
						           , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,excsm.excsm_id)+'|*~|'+convert(varchar,dpm.dpm_dpid)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+ISNULL(convert(varchar(50), dpam.dpam_sba_name),'')+'|*~|'+convert(varchar,isnull(dpam.dpam_acct_no, 0))+'|*~|'+isnull(dpam.dpam_stam_cd,'')+'|*~|'+convert(varchar,dpam.dpam_enttm_cd)+'|*~|'+dpam.dpam_clicm_cd+'|*~|'+dpam.dpam_subcm_cd+'|*~||*~|Q' value  --*|~*            
						           , enttm.enttm_id                  enttm_id        
						           , cm.clicm_id                     clicm_id        
						           --, brokm.brom_id                   brom_id        
						      FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
						           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
						           , company_mstr                    compm    WITH (NOLOCK)            
						           , entity_type_mstr                enttm    WITH (NOLOCK)        
						           , status_mstr                     sm       WITH (NOLOCK)        
						           , client_ctgry_mstr               cm       WITH (NOLOCK)        
						           , sub_ctgry_mstr                 subcm       WITH (NOLOCK)             
						           , dp_mstr                         dpm      WITH (NOLOCK)        
						           , dp_acct_mstr_mak                dpam     WITH (NOLOCK)        
						           , product_mstr                    PROM          
						           , excsm_prod_mstr                 excpm 
						           
						      WHERE  dpam.dpam_excsm_id            = excsm.excsm_id      
						      AND    excsm.excsm_id                = excpm.excpm_excsm_id          
						      AND    prom.prom_cd                  = @l_product
						      AND    prom.prom_id                  = excpm.excpm_prom_id          
						      and    cm.clicm_id                     = subcm.subcm_clicm_id
            and    dpam.dpam_subcm_cd              = subcm.subcm_cd 
						      AND    compm.compm_id                = excsm.excsm_compm_id        
						      AND    excsm_list.excsm_id                 = excsm.excsm_id 
						      AND    dpam.dpam_enttm_cd            = enttm.enttm_cd        
						      AND    dpam.dpam_clicm_cd            = cm.clicm_cd        
						      AND    dpam.dpam_dpm_id              = dpm.dpm_id         
						      AND    dpam.dpam_stam_cd             = sm.stam_cd        
						      AND    dpam.dpam_crn_no              = @pa_crn_no        
						      AND    isnull(dpam.dpam_deleted_ind,0) IN (0,8)            
						      AND    excsm.excsm_deleted_ind       = 1        
						      AND    cm.clicm_deleted_ind          = 1            
						      AND    compm.compm_deleted_ind       = 1        
						      AND    dpm.dpm_deleted_ind           = 1        
						      AND    sm.stam_deleted_ind           = 1      
						      UNION        
						      SELECT DISTINCT compm.compm_id         compm_id            
						           , compm.compm_short_name          compm_short_name            
						           , excsm.excsm_id                  excsm_id            
						           , excsm.excsm_exch_cd             excsm_exch_cd            
						           , excsm.excsm_seg_cd              excsm_seg_cd            
						           , dpam.dpam_acct_no               acct_no            
						           , dpam.dpam_id                    dpam_id        
						
						           , dpam.dpam_sba_no                dpam_sba_no        
						           , sm.stam_desc                    stam_desc        
						           , sm.stam_cd                      stam_cd          
						           , dpam.dpam_enttm_cd              enttm_cd        
						           , cm.clicm_desc                   clicm_desc 
						           , enttm.enttm_desc                enttm_desc                        
																	, dpam.dpam_subcm_cd              subcm_cd                
                 , subcm.subcm_desc                subcm_desc        
						           , dpm.dpm_dpid                    dpid        
						           , ISNULL(dpam.dpam_sba_name,'')   dpam_sba_name        
						           , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,excsm.excsm_id)+'|*~|'+convert(varchar,dpm.dpm_dpid)+'|*~|'+dpam.dpam_sba_no+'|*~|'+ISNULL(convert(varchar(50), dpam.dpam_sba_name),'')+'|*~|'+convert(varchar,isnull(dpam.dpam_acct_no, 0))+'|*~|'+isnull(dpam.dpam_stam_cd,'')+'|*~|'+convert(varchar,dpam.dpam_enttm_cd)+'|*~|'+dpam.dpam_clicm_cd+'|*~|'+dpam.dpam_subcm_cd+'|*~||*~|Q' value  --*|~*            
						           , enttm.enttm_id                  enttm_id        
						           , cm.clicm_id                     clicm_id        
						        
						      FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
						           , company_mstr                    compm    WITH (NOLOCK)            
						           , status_mstr                     sm       WITH (NOLOCK)        
						           , client_ctgry_mstr               cm       WITH (NOLOCK)        
						           , entity_type_mstr                enttm    WITH (NOLOCK)        
						           , sub_ctgry_mstr                 subcm       WITH (NOLOCK)            
						           , dp_mstr                         dpm      WITH (NOLOCK)        
						           , dp_acct_mstr                    dpam     WITH (NOLOCK)        
						           , product_mstr                    prom          
						           , excsm_prod_mstr                 excpm       
						           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
						      WHERE  dpam.dpam_excsm_id            = excsm.excsm_id      
						      AND    excsm.excsm_id                = excpm.excpm_excsm_id          
						      AND    excsm_list.excsm_id                 = excsm.excsm_id 
						      AND    prom.prom_cd                  = @l_product
						      AND    sm.stam_deleted_ind           = 1      
						      AND    prom.prom_id                  = excpm.excpm_prom_id     
						      and    dpam.dpam_subcm_cd            = subcm.subcm_cd 
						      and    cm.clicm_id                     = subcm.subcm_clicm_id
						      AND    compm.compm_id                = excsm.excsm_compm_id        
						      AND    dpam.dpam_clicm_cd            = cm.clicm_cd        
						      AND    dpam.dpam_enttm_cd            = enttm.enttm_cd        
						      AND    dpam.dpam_dpm_id              = dpm.dpm_id         
						      AND    dpam.dpam_stam_cd             = sm.stam_cd        
						      AND    dpam_crn_no                   = @pa_crn_no         
						      AND    dpam.dpam_acct_no         NOT IN (SELECT dpam_acct_no 
						                                              FROM   dp_acct_mstr_mak   WITH (NOLOCK)         
						                                              WHERE  dpam_deleted_ind IN (0,8)        
						                                              AND    dpam_crn_no       = @pa_crn_no         
						                                             )        
						      AND    dpam.dpam_deleted_ind         = 1            
						      AND    excsm.excsm_deleted_ind       = 1        
						      AND    cm.clicm_deleted_ind          = 1            
						      AND    compm.compm_deleted_ind       = 1        
						      AND    dpm.dpm_deleted_ind           = 1        
						      AND    sm.stam_deleted_ind           = 1
						
						

      
    --         
    END--clidpam        
    -- 
    IF @PA_TAB = 'CLIENT_BRKG'        
				BEGIN        
				--        
							SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
												, isnull(brokm.brom_desc ,'')     brom_desc          
												, convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,isnull(combrkg.clidb_eff_from_dt,'01/01/1900'),103)+'|*~|'+isnull(brokm.brom_id,0)+'|*~|Q'   value       
												, isnull(CONVERT(VARCHAR,combrkg.clidb_eff_from_dt,103),'')    clidb_eff_from_dt 
												, brokm.brom_id                   brom_id        
                                                , isnull(CONVERT(VARCHAR,combrkg.clidb_eff_to_dt,103),'')    clidb_eff_to_dt 
							FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
												, company_mstr                    compm    WITH (NOLOCK)        
												, dp_mstr                         dpm      WITH (NOLOCK)        
												, dp_acct_mstr                    dpam     WITH (NOLOCK)        
														--LEFT OUTER JOIN           
												, client_dp_brkg                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
														--LEFT OUTER JOIN          
												, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
												, product_mstr                    prom          
												, excsm_prod_mstr                 excpm
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
							AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
							AND    excsm_list.excsm_id             = excsm.excsm_id    
							AND    brokm.brom_excpm_id             = excpm.excpm_id      
							AND    prom.prom_cd                    = @l_product     
							AND    prom.prom_id                    = excpm.excpm_prom_id      
							AND    compm.compm_id                  = excsm.excsm_compm_id        
							AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
							AND    combrkg.clidb_brom_id           = brokm.brom_id        
							AND    dpam.dpam_dpm_id                = dpm.dpm_id         
							AND    Brokm.Brom_deleted_ind          = 1         
							AND    dpam.dpam_deleted_ind           = 1            
							AND    excsm.excsm_deleted_ind         = 1        
							AND    compm.compm_deleted_ind         = 1        
							AND    dpm.dpm_deleted_ind             = 1        
							AND    PROM.PROM_DELETED_IND           = 1      
							AND    EXCPM.EXCPM_DELETED_IND         = 1          
							AND    clidb_deleted_ind               = 1
							AND    dpam.dpam_crn_no                = @PA_CRN_NO
                            and    not exists(select b.clidb_brom_id from clib_mak b where combrkg.clidb_dpam_id = b.clidb_dpam_id  and combrkg.clidb_eff_from_dt = b.clidb_eff_from_dt and b.clidb_deleted_ind in (0,4,8))   
							union
							SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
												, isnull(brokm.brom_desc ,'')     brom_desc          
												, convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,isnull(combrkg.clidb_eff_from_dt,'01/01/1900'),103)+'|*~|'+isnull(brokm.brom_id,0)+'|*~|Q'   value       
												, isnull(CONVERT(VARCHAR,combrkg.clidb_eff_from_dt,103),'')    clidb_eff_from_dt 
												, brokm.brom_id                   brom_id        
                                                , isnull(CONVERT(VARCHAR,combrkg.clidb_eff_to_dt,103),'')    clidb_eff_to_dt 
							FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
												, company_mstr                    compm    WITH (NOLOCK)        
												, dp_mstr                         dpm      WITH (NOLOCK)        
												, dp_acct_mstr_mak                    dpam     WITH (NOLOCK)        
														--LEFT OUTER JOIN           
												, client_dp_brkg                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
														--LEFT OUTER JOIN          
												, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
												, product_mstr                    prom          
												, excsm_prod_mstr                 excpm
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
							AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
							AND    excsm_list.excsm_id             = excsm.excsm_id    
							AND    brokm.brom_excpm_id             = excpm.excpm_id      
							AND    prom.prom_cd                    = @l_product     
							AND    prom.prom_id                    = excpm.excpm_prom_id      
							AND    compm.compm_id                  = excsm.excsm_compm_id        
							AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
							AND    combrkg.clidb_brom_id           = brokm.brom_id        
							AND    dpam.dpam_dpm_id                = dpm.dpm_id         
							AND    Brokm.Brom_deleted_ind          = 1         
							AND    dpam.dpam_deleted_ind           in (0,8)        
							AND    excsm.excsm_deleted_ind         = 1        
							AND    compm.compm_deleted_ind         = 1        
							AND    dpm.dpm_deleted_ind             = 1        
							AND    PROM.PROM_DELETED_IND           = 1      
							AND    EXCPM.EXCPM_DELETED_IND         = 1          
							AND    clidb_deleted_ind               = 1
							AND    dpam.dpam_crn_no                = @PA_CRN_NO 
							UNION
							SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
												, isnull(brokm.brom_desc ,'')     brom_desc          
												, convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,isnull(combrkg.clidb_eff_from_dt,'01/01/1900'),103)+'|*~|'+isnull(brokm.brom_id,0)+'|*~|Q'   value       
												, isnull(CONVERT(VARCHAR,combrkg.clidb_eff_from_dt,103),'')    clidb_eff_from_dt 
												, brokm.brom_id                   brom_id        
                                                 , isnull(CONVERT(VARCHAR,combrkg.clidb_eff_to_dt,103),'')    clidb_eff_to_dt 
							FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
												, company_mstr                    compm    WITH (NOLOCK)        
												, dp_mstr                         dpm      WITH (NOLOCK)        
												, dp_acct_mstr                    dpam     WITH (NOLOCK)        
														--LEFT OUTER JOIN           
												, clib_mak                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
														--LEFT OUTER JOIN          
												, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
												, product_mstr                    prom          
												, excsm_prod_mstr                 excpm
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
							AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
							AND    excsm_list.excsm_id             = excsm.excsm_id    
							AND    brokm.brom_excpm_id             = excpm.excpm_id      
							AND    prom.prom_cd                    = @l_product     
							AND    prom.prom_id                    = excpm.excpm_prom_id      
							AND    compm.compm_id                  = excsm.excsm_compm_id        
							AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
							AND    combrkg.clidb_brom_id           = brokm.brom_id        
							AND    dpam.dpam_dpm_id                = dpm.dpm_id         
							AND    Brokm.Brom_deleted_ind          = 1         
							AND    dpam.dpam_deleted_ind           = 1    
							AND    excsm.excsm_deleted_ind         = 1        
							AND    compm.compm_deleted_ind         = 1        
							AND    dpm.dpm_deleted_ind             = 1        
							AND    PROM.PROM_DELETED_IND           = 1      
							AND    EXCPM.EXCPM_DELETED_IND         = 1          
							AND    clidb_deleted_ind               IN (0,8)
							AND    dpam.dpam_crn_no                = @PA_CRN_NO
							union
							SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
												, isnull(brokm.brom_desc ,'')     brom_desc          
												, convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,isnull(combrkg.clidb_eff_from_dt,'01/01/1900'),103)+'|*~|'+isnull(brokm.brom_id,0)+'|*~|Q'   value       
												, isnull(CONVERT(VARCHAR,combrkg.clidb_eff_from_dt,103),'')    clidb_eff_from_dt 
												, brokm.brom_id                   brom_id        
                                                , isnull(CONVERT(VARCHAR,combrkg.clidb_eff_to_dt,103),'')    clidb_eff_to_dt 
							FROM   exch_seg_mstr                   excsm    WITH (NOLOCK)            
												, company_mstr                    compm    WITH (NOLOCK)        
												, dp_mstr                         dpm      WITH (NOLOCK)        
												, dp_acct_mstr_mak                    dpam     WITH (NOLOCK)        
														--LEFT OUTER JOIN           
												, clib_mak                  combrkg  --on (dpam.dpam_id = combrkg.clidb_dpam_id) AND (dpam.dpam_crn_no = 54556)           
														--LEFT OUTER JOIN          
												, Brokerage_mstr                  Brokm    --on (combrkg.clidb_brom_id  = brokm.brom_id)      
												, product_mstr                    prom          
												, excsm_prod_mstr                 excpm
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_excsm_id              = excsm.excsm_id      
							AND    excsm.excsm_id                  = excpm.excpm_excsm_id          
							AND    excsm_list.excsm_id             = excsm.excsm_id    
							AND    brokm.brom_excpm_id             = excpm.excpm_id      
							AND    prom.prom_cd                    = @l_product     
							AND    prom.prom_id                    = excpm.excpm_prom_id      
							AND    compm.compm_id                  = excsm.excsm_compm_id        
							AND    dpam.dpam_id                    = combrkg.clidb_dpam_id        
							AND    combrkg.clidb_brom_id           = brokm.brom_id        
							AND    dpam.dpam_dpm_id                = dpm.dpm_id         
							AND    Brokm.Brom_deleted_ind          = 1         
							AND    dpam.dpam_deleted_ind           in(0,8)         
							AND    excsm.excsm_deleted_ind         = 1        
							AND    compm.compm_deleted_ind         = 1        
							AND    dpm.dpm_deleted_ind             = 1        
							AND    PROM.PROM_DELETED_IND           = 1      
							AND    EXCPM.EXCPM_DELETED_IND         = 1          
							AND    clidb_deleted_ind               in(0,8)
							AND    dpam.dpam_crn_no                = @PA_CRN_NO 
							
							ORDER BY clidb_eff_from_dt DESC
				--        
    END 
    IF @PA_TAB = 'CLIDPHD'        
    BEGIN        
    --        
      SELECT dphd_dpam_id          
           , dphd_dpam_sba_no          
           , isnull(dphd_sh_fname,'')            dphd_sh_fname        
           , isnull(dphd_sh_mname,'')            dphd_sh_mname        
           , isnull(dphd_sh_lname,'')            dphd_sh_lname        
           , isnull(dphd_sh_fthname,'')          dphd_sh_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_sh_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_sh_dob,''),103) END    dphd_sh_dob          
           , isnull(dphd_sh_pan_no,'')           dphd_sh_pan_no        
           , isnull(dphd_sh_gender,'')           dphd_sh_gender        
           , isnull(dphd_th_fname,'')            dphd_th_fname        
           , isnull(dphd_th_mname,'')            dphd_th_mname        
           , isnull(dphd_th_lname,'')            dphd_th_lname        
           , isnull(dphd_th_fthname,'')          dphd_th_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_th_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_th_dob,''),103) END    dphd_th_dob         
           , isnull(dphd_th_pan_no,'')           dphd_th_pan_no        
           , isnull(dphd_th_gender,'')           dphd_th_gender        
           , isnull(dphd_nomgau_fname,'')           dphd_nomgau_fname        
           , isnull(dphd_nomgau_mname,'')           dphd_nomgau_mname        
           , isnull(dphd_nomgau_lname,'')           dphd_nomgau_lname        
           , isnull(dphd_nomgau_fthname,'')         dphd_nomgau_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103) END  dphd_nomgau_dob          
           , isnull(dphd_nomgau_pan_no,'')          dphd_nomgau_pan_no       
           , isnull(dphd_nomgau_gender,'')          dphd_nomgau_gender        
           , isnull(dphd_nom_fname,'')           dphd_nom_fname        
           , isnull(dphd_nom_mname,'')           dphd_nom_mname        
           , isnull(dphd_nom_lname,'')           dphd_nom_lname        
           , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103) ='01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103) END    dphd_nom_dob          
           , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
           , isnull(dphd_nom_gender,'')          dphd_nom_gender        
           , ISNULL(NOM_NRN_NO,'')               dphd_nom_NRN_NO
           , isnull(dphd_gau_fname,'')           dphd_gau_fname        
           , isnull(dphd_gau_mname,'')           dphd_gau_mname        
           , isnull(dphd_gau_lname,'')           dphd_gau_lname        
           , isnull(dphd_gau_fthname,'')         dphd_gau_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_gau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_gau_dob,''),103) END   dphd_gau_dob          
           , isnull(dphd_gau_pan_no,'')          dphd_gau_pan_no        
           , isnull(dphd_gau_gender,'')          dphd_gau_gender        
           , isnull(dphd_fh_fthname,'')          dphd_fh_fthname        
           , isnull(dpam_subcm_cd,'')            dpam_subcm_cd
		  , isnull(DPAM_CLICM_CD,'')               DPAM_CLICM_CD
		 , isnull(DPAM_ENTTM_CD,'')               DPAM_ENTTM_CD
  
      FROM   dp_holder_dtls_mak     dphd         WITH (NOLOCK)           
           , dp_acct_mstr_mak       dam          WITH (NOLOCK)            
      WHERE  dam.dpam_crn_no                = @pa_crn_no    
      and    dam.dpam_id                    = dphd_dpam_id     
      AND    dam.dpam_sba_no                = convert(varchar, @pa_value)         
      AND    dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
      AND    isnull(dphd.dphd_deleted_ind,0) IN (0,8)         
      AND    isnull(dam.dpam_deleted_ind,0)  IN (0,8)        
      UNION        
      SELECT dphd_dpam_id          
           , dphd_dpam_sba_no          
           , isnull(dphd_sh_fname,'')            dphd_sh_fname        
           , isnull(dphd_sh_mname,'')            dphd_sh_mname        
           , isnull(dphd_sh_lname,'')            dphd_sh_lname        
           , isnull(dphd_sh_fthname,'')          dphd_sh_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_sh_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_sh_dob,''),103) END    dphd_sh_dob          
           , isnull(dphd_sh_pan_no,'')           dphd_sh_pan_no        
           , isnull(dphd_sh_gender,'')           dphd_sh_gender     
           , isnull(dphd_th_fname,'')            dphd_th_fname        
           , isnull(dphd_th_mname,'')            dphd_th_mname        
           , isnull(dphd_th_lname,'')            dphd_th_lname        
           , isnull(dphd_th_fthname,'')          dphd_th_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_Th_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_Th_dob,''),103) END    dphd_Th_dob          
           , isnull(dphd_th_pan_no,'')           dphd_th_pan_no        
           , isnull(dphd_th_gender,'')           dphd_th_gender        
          , isnull(dphd_nomgau_fname,'')           dphd_nomgau_fname        
           , isnull(dphd_nomgau_mname,'')           dphd_nomgau_mname        
           , isnull(dphd_nomgau_lname,'')           dphd_nomgau_lname        
           , isnull(dphd_nomgau_fthname,'')         dphd_nomgau_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103)   = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103)    END dphd_nomgau_dob          
           , isnull(dphd_nomgau_pan_no,'')          dphd_nomgau_pan_no        
           , isnull(dphd_nomgau_gender,'')          dphd_nomgaugender        
           , isnull(dphd_nom_fname,'')           dphd_nom_fname        
           , isnull(dphd_nom_mname,'')           dphd_nom_mname        
           , isnull(dphd_nom_lname,'')           dphd_nom_lname        
           , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103)= '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103)    END   dphd_nom_dob          
           , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
           , isnull(dphd_nom_gender,'')          dphd_nom_gender        
           , ISNULL(NOM_NRN_NO,'')               dphd_nom_NRN_NO
           , isnull(dphd_gau_fname,'')           dphd_gau_fname        
           , isnull(dphd_gau_mname,'')           dphd_gau_mname        
           , isnull(dphd_gau_lname,'')           dphd_gau_lname        
           , isnull(dphd_gau_fthname,'')         dphd_gau_fthname        
           , CASE WHEN  convert(varchar,isnull(dphd_gau_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_gau_dob,''),103) END   dphd_gau_dob          
           , isnull(dphd_gau_pan_no,'')          dphd_gau_pan_no        
           , isnull(dphd_gau_gender,'')          dphd_gau_gender        
           , isnull(dphd_fh_fthname,'')          dphd_fh_fthname        
           , isnull(dpam_subcm_cd,'')            dpam_subcm_cd
			, isnull(DPAM_CLICM_CD,'')            DPAM_CLICM_CD
			, isnull(DPAM_ENTTM_CD,'')            DPAM_ENTTM_CD

      FROM   dp_holder_dtls_mak     dphd      WITH (NOLOCK)           
           , dp_acct_mstr           dam       WITH (NOLOCK)  
      
      WHERE  dam.dpam_crn_no                = @pa_crn_no 
      and    dam.dpam_id                    = dphd_dpam_id       
      AND    dam.dpam_sba_no                = convert(varchar, @pa_value)         
      AND    dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
      AND    isnull(dphd.dphd_deleted_ind,0)          IN (0,8)          
      AND    dam.dpam_deleted_ind =  1        
      UNION        
      SELECT dphd_dpam_id          
           , dphd_dpam_sba_no          
           , isnull(dphd_sh_fname,'')            dphd_sh_fname        
           , isnull(dphd_sh_mname,'')            dphd_sh_mname        
           , isnull(dphd_sh_lname,'')            dphd_sh_lname        
           , isnull(dphd_sh_fthname,'')          dphd_sh_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_sh_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_sh_dob,''),103) END    dphd_sh_dob          
           , isnull(dphd_sh_pan_no,'')           dphd_sh_pan_no        
           , isnull(dphd_sh_gender,'')           dphd_sh_gender        
           , isnull(dphd_th_fname,'')            dphd_th_fname        
           , isnull(dphd_th_mname,'')            dphd_th_mname        
           , isnull(dphd_th_lname,'')            dphd_th_lname        
           , isnull(dphd_th_fthname,'')          dphd_th_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_Th_dob,''),103) = '01/01/1900' THEN '' ELSE  convert(varchar,isnull(dphd_Th_dob,''),103) END    dphd_Th_dob          
           , isnull(dphd_th_pan_no,'')           dphd_th_pan_no        
           , isnull(dphd_th_gender,'')           dphd_th_gender        
           , isnull(dphd_nomgau_fname,'')           dphd_nomgau_fname        
           , isnull(dphd_nomgau_mname,'')           dphd_nomgau_mname        
           , isnull(dphd_nomgau_lname,'')           dphd_nomgau_lname        
           , isnull(dphd_nomgau_fthname,'')         dphd_nomgau_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103) END dphd_nomgau_dob          
           , isnull(dphd_nomgau_pan_no,'')          dphd_nomgau_pan_no        
           , isnull(dphd_nomgau_gender,'')          dphd_nomgau_gender        
           , isnull(dphd_nom_fname,'')           dphd_nom_fname        
           , isnull(dphd_nom_mname,'')           dphd_nom_mname        
           , isnull(dphd_nom_lname,'')           dphd_nom_lname        
           , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103) END    dphd_nom_dob          
           , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
           , isnull(dphd_nom_gender,'')          dphd_nom_gender        
           , ISNULL(NOM_NRN_NO,'')               dphd_nom_NRN_NO
           , isnull(dphd_gau_fname,'')           dphd_gau_fname        
           , isnull(dphd_gau_mname,'')           dphd_gau_mname        
           , isnull(dphd_gau_lname,'')           dphd_gau_lname        
           , isnull(dphd_gau_fthname,'')         dphd_gau_fthname        
           , CASE WHEN convert(varchar,isnull(dphd_gau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_gau_dob,''),103)    END   dphd_gau_dob          
           , isnull(dphd_gau_pan_no,'')          dphd_gau_pan_no        
           , isnull(dphd_gau_gender,'')          dphd_gau_gender        
           , isnull(dphd_fh_fthname,'')          dphd_fh_fthname        
           , isnull(dpam_subcm_cd,'')            dpam_subcm_cd
			, isnull(DPAM_CLICM_CD,'')            DPAM_CLICM_CD
			, isnull(DPAM_ENTTM_CD,'')            DPAM_ENTTM_CD
				
      FROM   dp_holder_dtls     dphd  WITH (NOLOCK)           
           , dp_acct_mstr       dam   WITH (NOLOCK)            
             /*        
             left outer join         
             entity_properties  entp  on (dam.dpam_crn_no = entp.entp_ent_id and entp.entp_deleted_ind = 1)        
             left outer join        
         (SELECT DISTINCT entpm.entpm_prop_id prop_id          
              FROM   dp_acct_mstr              dpam          
                   , client_ctgry_mstr         clicm          
                   , entity_property_mstr      entpm        
                   , entity_type_mstr          enttm            
              WHERE  clicm.clicm_cd          = dpam_clicm_cd          
              AND    dpam.dpam_crn_no        = @pa_crn_no            
              AND    entpm.entpm_clicm_id    = clicm.clicm_id        
              AND    enttm.enttm_cd          = dpam.dpam_enttm_cd           
              AND    entpm.entpm_enttm_id    = enttm.enttm_id          
              AND    entpm.entpm_cd          = 'FTH_NAME'          
              AND    entpm_deleted_ind       = 1           
              AND    dpam.dpam_deleted_ind   = 1          
              AND    clicm.clicm_deleted_ind = 1        
              AND    enttm.enttm_deleted_ind = 1          
             )x  on (x.prop_id              = entp.entp_entpm_prop_id)        
             */        
      WHERE   dam.dpam_id           NOT IN (SELECT dphd_dpam_id        
                                            FROM   dp_holder_dtls_mak    WITH (NOLOCK)        
                                            WHERE  dphd_deleted_ind IN (0,8)        
                                            )        
      AND     dam.dpam_crn_no                = @pa_crn_no    
      and    dam.dpam_id                    = dphd_dpam_id     
      AND     dam.dpam_sba_no                = convert(varchar, @pa_value)         
      AND     dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
      AND     dphd.dphd_deleted_ind          = 1          
      AND     dam.dpam_deleted_ind           = 1        
    --         
    END        
    --        
    IF @PA_TAB = 'CLIDPPD'        
				BEGIN        
				--    
				print '222' 
				update DP_POA_DTLS_MAK set DPPD_DELETED_IND= 0 where ISNULL(DPPD_DELETED_IND,0)=0  -- temp done as data is passing as null   
						SELECT dppd_dpam_id          
											, isnull(dppd_fname,'')           fname        
											, isnull(dppd_mname,'')           mname        
											, isnull(dppd_lname,'')           lname        
											, isnull(dppd_fthname,'')         fthname        
											, case when convert(varchar,isnull(dppd_dob,''),103)  = '01/01/1900' then '' else convert(varchar,isnull(dppd_dob,''),103) end dob          
											, isnull(dppd_pan_no,'')          pan        
											, isnull(dppd_gender,'')          gender        
											, isnull(dppd_hld,'')             holdertype
											, isnull(dppd_poa_type,'')        poatype
											, dpam_excsm_id                   excsm_id
											, dpm.dpm_dpid                    dpid  
											, compm_id                        compm_id
											, CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
											, compm.compm_short_name             compm_short_name        
											, excsm.excsm_exch_cd                excsm_exch_cd        
											, excsm.excsm_seg_cd                 excsm_seg_cd
											, dppd_poa_id 
											, case when convert(varchar(11),dppd_setup,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_setup,103) end dppd_setup
											, dppd_gpabpa_flg 
											, case when convert(varchar(11),dppd_eff_fr_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_fr_dt,103) end dppd_eff_fr_dt
           , case when convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_TO_dt,103) end dppd_eff_TO_dt
           ,dppd_id
            ,dppd_master_id
            ,'' dppd_relapptxt
            ,''dppd_uid
            ,'' dppd_polconntxt
            ,'' dppd_relapp
            ,'' dppd_polconn
						FROM   dp_poa_dtls_mak   dppd  WITH (NOLOCK)           
											, dp_acct_mstr_mak  dpam   WITH (NOLOCK)
											, dp_mstr           dpm   WITH (NOLOCK)
											, company_mstr      compm WITH (NOLOCK)
											, exch_seg_mstr     excsm WITH (NOLOCK)
											, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
						WHERE  dpam.dpam_crn_no                = @pa_crn_no  
						AND    dpam.dpam_dpm_id                = dpm.dpm_id
						AND    excsm.excsm_id                  = dpam.dpam_excsm_id
						AND    excsm_list.excsm_id             = excsm.excsm_id 
						AND    excsm.excsm_compm_id            = compm.compm_id
						AND    dpam.dpam_dpm_id                = dpm.dpm_id
						AND    dpam.dpam_id                    = dppd.dppd_dpam_id
						AND    dppd.dppd_deleted_ind           in (0,8)          
						AND    dpam.dpam_deleted_ind           in (0,8)          
						UNION        
					 SELECT dppd_dpam_id          
										, isnull(dppd_fname,'')           fname        
										, isnull(dppd_mname,'')           mname        
										, isnull(dppd_lname,'')           lname        
										, isnull(dppd_fthname,'')         fthname        
										, case when convert(varchar,isnull(dppd_dob,''),103)  = '01/01/1900' then '' else convert(varchar,isnull(dppd_dob,''),103) end dob          
										, isnull(dppd_pan_no,'')          pan        
										, isnull(dppd_gender,'')          gender        
										, isnull(dppd_hld,'')             holdertype
										, isnull(dppd_poa_type,'')        poatype
										, dpam_excsm_id                   excsm_id
										, dpm.dpm_dpid                    dpid  
										, compm_id                        compm_id
										, CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
										, compm.compm_short_name             compm_short_name        
										, excsm.excsm_exch_cd                excsm_exch_cd        
										, excsm.excsm_seg_cd                 excsm_seg_cd
										, dppd_poa_id 
										, case when convert(varchar(11),dppd_setup,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_setup,103) end dppd_setup
										, dppd_gpabpa_flg 
										, case when convert(varchar(11),dppd_eff_fr_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_fr_dt,103) end dppd_eff_fr_dt
           , case when convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_TO_dt,103) end dppd_eff_TO_dt
           ,dppd_id
            ,dppd_master_id
            ,'' dppd_relapptxt
            ,''dppd_uid
            ,'' dppd_polconntxt
            ,'' dppd_relapp
            ,'' dppd_polconn
						FROM   dp_poa_dtls_mak   dppd  WITH (NOLOCK)           
											, dp_acct_mstr      dpam   WITH (NOLOCK)
											, dp_mstr           dpm   WITH (NOLOCK)
											, company_mstr      compm WITH (NOLOCK)
											, exch_seg_mstr     excsm WITH (NOLOCK)
											, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
						WHERE  dpam.dpam_crn_no                = @pa_crn_no  
						AND    dpam.dpam_dpm_id                = dpm.dpm_id
						AND    excsm.excsm_id                  = dpam.dpam_excsm_id
						AND    excsm_list.excsm_id             = excsm.excsm_id 
						AND    excsm.excsm_compm_id            = compm.compm_id
						AND    dpam.dpam_dpm_id                = dpm.dpm_id
						AND    dpam.dpam_id                    = dppd.dppd_dpam_id
						AND    dppd.dppd_deleted_ind           in (0,8)       
						AND    dpam.dpam_deleted_ind           = 1       
						UNION        
						SELECT dppd_dpam_id          
											, isnull(dppd_fname,'')           fname        
											, isnull(dppd_mname,'')           mname        
											, isnull(dppd_lname,'')           lname        
											, isnull(dppd_fthname,'')         fthname        
											, case when convert(varchar,isnull(dppd_dob,''),103)  = '01/01/1900' then '' else convert(varchar,isnull(dppd_dob,''),103) end dob          
											, isnull(dppd_pan_no,'')          pan        
											, isnull(dppd_gender,'')          gender        
											, isnull(dppd_hld,'')             holdertype
											, isnull(dppd_poa_type,'')        poatype
											, dpam_excsm_id                   excsm_id
											, dpm.dpm_dpid                    dpid  
											, compm_id                        compm_id
											, CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
											, compm.compm_short_name             compm_short_name        
											, excsm.excsm_exch_cd                excsm_exch_cd        
											, excsm.excsm_seg_cd                 excsm_seg_cd
											, dppd_poa_id 
											, case when convert(varchar(11),dppd_setup,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_setup,103) end dppd_setup
											, dppd_gpabpa_flg 
											, case when convert(varchar(11),dppd_eff_fr_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_fr_dt,103) end dppd_eff_fr_dt
           , case when convert(varchar(11),dppd_eff_TO_dt,103)  ='01/01/1900' then '' else convert(varchar(11),dppd_eff_TO_dt,103) end dppd_eff_TO_dt
           ,dppd_id
            ,dppd_master_id
            ,'' dppd_relapptxt
            ,''dppd_uid
            ,'' dppd_polconntxt
            ,'' dppd_relapp
            ,'' dppd_polconn
							FROM   dp_poa_dtls       dppd  WITH (NOLOCK)           
												, dp_acct_mstr      dpam   WITH (NOLOCK)
												, dp_mstr           dpm   WITH (NOLOCK)
												, company_mstr      compm WITH (NOLOCK)
												, exch_seg_mstr     excsm WITH (NOLOCK)
												, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
							WHERE  dpam.dpam_crn_no                = @pa_crn_no  
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    excsm.excsm_id                  = dpam.dpam_excsm_id
							AND    excsm_list.excsm_id             = excsm.excsm_id 
							AND    excsm.excsm_compm_id            = compm.compm_id
							AND    dpam.dpam_dpm_id                = dpm.dpm_id
							AND    dpam.dpam_id                    = dppd.dppd_dpam_id
							AND    dppd.dppd_deleted_ind           = 1          
							AND    dpam.dpam_deleted_ind           = 1  
							and    dppd.dppd_id       not       IN (SELECT dppd_id FROM dp_poa_dtls_mak WHERE dppd_deleted_ind in (0,4,8) and dppd_dpam_id=dpam.dpam_id )        
				--         
    END   
    IF @pa_tab = 'CLIDPBA'        
    BEGIN        
    --        
    print 'pankaj'
      SELECT cliba.cliba_ac_name                cliba_ac_name        
           , cliba.cliba_banm_id                cliba_banm_id        
           , CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
           --, dpm.dpm_dpid+dpam.dpam_sba_no      acct_no                         
           , dpm.dpm_dpid                       dpid      
--           , banm.banm_name + '-' +isnull(BANM_BRANCH,'	') + '-' + convert(varchar(20),isnull(BANM_MICR,0)) 
--            + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) + '~'   bank_name   
--           , banm.banm_branch         
			, banm.banm_name + '-' + convert(varchar(20),isnull(BANM_MICR,0)) + '-' + ISNULL(banm_rtgs_cd,'') as BANK_NAME
			,isnull(BANM_BRANCH,'	') BANM_BRANCH
			, convert(varchar(20),isnull(BANM_MICR,0)) BANM_MICR
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) banm_add1
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) banm_add2
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) banm_add3
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) banm_city
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) banm_state
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) banm_nation
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) banm_pincode

           , cliba.cliba_ac_type                cliba_ac_type        
           , cliba.cliba_ac_no                  cliba_ac_no        
           , cliba.cliba_flg & 1                def_flg        
           , cliba.cliba_flg & 2                poa_flg        
           , compm.compm_id                     compm_id        
           , compm.compm_short_name             compm_short_name        
           , excsm.excsm_exch_cd                excsm_exch_cd        
           , excsm.excsm_seg_cd                 excsm_seg_cd        
           , excsm.excsm_id                     excsm_id  
           ,compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat         
        ,convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no) rel_value          
      FROM   dp_acct_mstr_mak                   dpam     WITH (NOLOCK)        
           , client_bank_accts_mak              cliba    WITH (NOLOCK)        
           , bank_mstr                          banm     WITH (NOLOCK)        
           , exch_seg_mstr                      excsm    WITH (NOLOCK)        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
           , company_mstr                       compm    WITH (NOLOCK)        
           , dp_mstr                            dpm      WITH (NOLOCK)        
      WHERE  dpam.dpam_crn_no                 = @pa_crn_no        
      AND    compm.compm_id                   = excsm.excsm_compm_id        
      AND    excsm.excsm_id                   = dpam.dpam_excsm_id         
      --AND    cliba.cliba_clisba_id            = dpam.dpammak_id        
      AND    cliba.cliba_clisba_id            = dpam.dpam_id        
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    dpm.dpm_id                       = dpam.dpam_dpm_id          
      AND    banm.banm_id                     = cliba.cliba_banm_id        
      AND    isnull(cliba.cliba_deleted_ind,0) in (0,8)        
      AND    banm.banm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind          = 1        
      AND    dpm.dpm_deleted_ind              = 1        
      AND    isnull(dpam.dpam_deleted_ind,0) in (0,8)        
      UNION        
      SELECT cliba.cliba_ac_name                cliba_ac_name        
           , cliba.cliba_banm_id                cliba_banm_id        
           , CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no            
           --, dpm.dpm_dpid+dpam.dpam_sba_no      acct_no                         
           , dpm.dpm_dpid                       dpid                         
--           , banm.banm_name + '-' +isnull(BANM_BRANCH,'	') + '-' + convert(varchar(20),isnull(BANM_MICR,0)) 
--            + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) + '~'   bank_name  
           --, banm.banm_branch         
			, banm.banm_name + '-' + convert(varchar(20),isnull(BANM_MICR,0)) + '-' + ISNULL(banm_rtgs_cd,'') --banm.banm_name BANK_NAME
			,isnull(BANM_BRANCH,'	') BANM_BRANCH
			, convert(varchar(20),isnull(BANM_MICR,0)) BANM_MICR
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) banm_add1
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) banm_add2
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) banm_add3
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) banm_city
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) banm_state
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) banm_nation
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) banm_pincode

           , cliba.cliba_ac_type                cliba_ac_type        
           , cliba.cliba_ac_no                  cliba_ac_no        
           , cliba.cliba_flg & 1                def_flg        
           , cliba.cliba_flg & 2                poa_flg        
           , compm.compm_id                     compm_id        
           , compm.compm_short_name             compm_short_name        
           , excsm.excsm_exch_cd                excsm_exch_cd        
           , excsm.excsm_seg_cd                 excsm_seg_cd        
           , excsm.excsm_id                     excsm_id 
           ,compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat         
        ,convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no) rel_value           
      FROM   dp_acct_mstr                       dpam     WITH (NOLOCK)        
           , client_bank_accts_mak              cliba    WITH (NOLOCK)        
           , bank_mstr                          banm     WITH (NOLOCK)        
           , exch_seg_mstr                      excsm    WITH (NOLOCK)        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
           , company_mstr                       compm    WITH (NOLOCK)        
           , dp_mstr                            dpm      WITH (NOLOCK)        
      WHERE  dpam.dpam_crn_no                 = @pa_crn_no        
      AND    compm.compm_id                   = excsm.excsm_compm_id        
      AND    excsm.excsm_id                   = dpam.dpam_excsm_id         
      AND    cliba.cliba_clisba_id            = dpam.dpam_id        
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    dpm.dpm_id                       = dpam.dpam_dpm_id          
      AND    banm.banm_id                     = cliba.cliba_banm_id        
      AND    isnull(cliba.cliba_deleted_ind,0) in (0,8)        
      AND    banm.banm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind          = 1        
      AND    dpm.dpm_deleted_ind              = 1        
      AND    dpam.dpam_deleted_ind            = 1        
      UNION        
      SELECT cliba.cliba_ac_name                cliba_ac_name        
           , cliba.cliba_banm_id                cliba_banm_id        
          -- , dpm.dpm_dpid+dpam.dpam_sba_no      acct_no      
           , CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END acct_no                              
           , dpm.dpm_dpid                       dpid                         
--           , banm.banm_name + '-' +isnull(BANM_BRANCH,'	') + '-' + convert(varchar(20),isnull(BANM_MICR,0))     + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) + '~'
--			+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) + '~' bank_name  
           --, banm.banm_branch      
			,banm.banm_name + '-' + convert(varchar(20),isnull(BANM_MICR,0)) + '-' + ISNULL(banm_rtgs_cd,'') -- banm.banm_name BANK_NAME
			,isnull(BANM_BRANCH,'	') BANM_BRANCH
			, convert(varchar(20),isnull(BANM_MICR,0)) BANM_MICR
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),1) banm_add1
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),2) banm_add2
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),3) banm_add3
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),4) banm_city
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),5) banm_state
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),6) banm_nation
			, citrus_usr.fn_splitval(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),7) banm_pincode
   
           , cliba.cliba_ac_type                cliba_ac_type        
           , cliba.cliba_ac_no                  cliba_ac_no        
           , cliba.cliba_flg & 1                def_flg        
           , cliba.cliba_flg & 2                poa_flg        
           , compm.compm_id                     compm_id        
           , compm.compm_short_name             compm_short_name        
           , excsm.excsm_exch_cd                excsm_exch_cd        
           , excsm.excsm_seg_cd                 excsm_seg_cd        
           , excsm.excsm_id                     excsm_id
           ,compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dpm.dpm_dpid),2) = 'IN' THEN dpm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat         
        ,convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no) rel_value            
      FROM   dp_acct_mstr                       dpam     WITH (NOLOCK)        
           , client_bank_accts                  cliba    WITH (NOLOCK)        
           , bank_mstr                          banm     WITH (NOLOCK)        
           , exch_seg_mstr                      excsm    WITH (NOLOCK)        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
           , company_mstr                       compm    WITH (NOLOCK)        
           , dp_mstr                            dpm      WITH (NOLOCK)        
      WHERE  compm.compm_id                   = excsm.excsm_compm_id        
      AND    excsm.excsm_id                   = dpam.dpam_excsm_id         
      AND    cliba.cliba_clisba_id            = dpam.dpam_id        
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    dpm.dpm_id                       = dpam.dpam_dpm_id        
      AND    dpam.dpam_crn_no                 = @pa_crn_no           
      AND    banm.banm_id                     = cliba.cliba_banm_id        
      AND    cliba.cliba_deleted_ind          = 1        
      AND    banm.banm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind          = 1        
      AND    dpm.dpm_deleted_ind              = 1        
     AND    dpam.dpam_deleted_ind            = 1     
     AND    NOT EXISTS (SELECT cliba_banm_id, cliba_compm_id, cliba_ac_no, cliba_clisba_id                            
                         FROM   client_bank_accts_mak    clibam                            
                              , (select dpam_id, dpam_crn_no from dp_Acct_mstr where dpam_crn_no = @pa_crn_no and dpam_deleted_ind = 1 
                                 union 
                                 select dpam_id, dpam_crn_no from dp_Acct_mstr_mak where dpam_crn_no = @pa_crn_no and dpam_deleted_ind in (0,4,8)) dpam                            
                         WHERE  dpam.dpam_id      = clibam.cliba_clisba_id                            
                         AND    clibam.cliba_banm_id   = cliba.cliba_banm_id                            
                         AND    clibam.cliba_compm_id  = compm.compm_id                            
                         AND    clibam.cliba_ac_no     = cliba.cliba_ac_no                            
                         AND    clibam.cliba_clisba_id = cliba.cliba_clisba_id                            
                         AND    clibam.cliba_deleted_ind IN (0, 4, 8)                            
                          AND    dpam.dpam_crn_no     = @pa_crn_no)
      and  cliba_clisba_id  not in (select dpam_id from dp_Acct_mstr_mak where dpam_crn_no = @pa_crn_no and dpam_deleted_ind in (4))        
   
    --          
    END        
    --        
    IF @PA_TAB = 'CLIDPENTR'        
    BEGIN        
    --        
      --SELECT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+convert(varchar, dpam.dpam_sba_no)    Comp_Exch_Seg_Demat        
      SELECT DISTINCT  compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dm.dpm_dpid),2) = 'IN' THEN dm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
           , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,entr.entr_from_dt,103)+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'        
                           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'        
                           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value         
          ,  convert(varchar,entr.entr_from_dt,103)   entr_from_dt         , isnull( CONVERT(varchar,entr.entr_to_dt,103) ,'2900-01-01 00:00:00.000')  entr_to_dt 
      FROM   entity_relationship_mak              entr     WITH (NOLOCK)        
          ,  exch_seg_mstr                        excsm    WITH (NOLOCK)        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
          ,  company_mstr                         compm    WITH (NOLOCK)        
          ,  dp_acct_mstr_mak                     dpam     WITH (NOLOCK)        
          ,  dp_mstr                              dm       WITH (NOLOCK)         
          ,  excsm_prod_mstr                       excpm    WITH (NOLOCK)    
      WHERE  entr.entr_crn_no                   = @pa_crn_no           
      AND    dpam.dpam_crn_no                   = entr.entr_crn_no        
      AND    dpam.dpam_sba_no                   = entr.entr_sba            
      AND    dpam.dpam_dpm_id                   = dm.dpm_id          
      AND    excpm.excpm_excsm_id                 = excsm.excsm_id
       and    entr.entr_excpm_id                 = excpm.excpm_id  
      AND    dpam.dpam_excsm_id                 = excsm.excsm_id           
      AND    compm.compm_id                     = excsm.excsm_compm_id        
      AND    excsm_list.excsm_id                 = excsm.excsm_id 
      AND    isnull(entr.entr_deleted_ind,0)   IN (0,8)         
      AND    excsm.excsm_deleted_ind            = 1        
      AND    compm.compm_deleted_ind            = 1        
      AND    dm.dpm_deleted_ind                 = 1        
      AND    isnull(dpam.dpam_deleted_ind,0)   IN (0,8)         
      UNION        
      --SELECT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+convert(varchar, dpam.dpam_sba_no)    Comp_Exch_Seg_Demat        
      SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dm.dpm_dpid),2) = 'IN' THEN dm.dpm_dpid + dpam.dpam_sba_no ELSE dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
            , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,entr.entr_from_dt,103)+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'        
                            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'        
                            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value         
            ,  convert(varchar,entr.entr_from_dt,103)   entr_from_dt        , isnull( CONVERT(varchar,entr.entr_to_dt,103) ,'2900-01-01 00:00:00.000')  entr_to_dt  
        FROM   entity_relationship_mak              entr     WITH (NOLOCK)        
            ,  exch_seg_mstr                        excsm    WITH (NOLOCK)        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            ,  company_mstr          compm    WITH (NOLOCK)        
            ,  dp_acct_mstr                         dpam     WITH (NOLOCK)        
            ,  dp_mstr                              dm       WITH (NOLOCK)         
            ,  excsm_prod_mstr                       excpm    WITH (NOLOCK)    
        WHERE  entr.entr_crn_no                   = @pa_crn_no           
        AND    dpam.dpam_crn_no                   = entr.entr_crn_no        
        AND    dpam.dpam_sba_no                   = entr.entr_sba            
        AND    dpam.dpam_dpm_id                   = dm.dpm_id          
        AND    dpam.dpam_excsm_id                 = excsm.excsm_id           
        AND    compm.compm_id                     = excsm.excsm_compm_id        
       AND    excpm.excpm_excsm_id                 = excsm.excsm_id
       and    entr.entr_excpm_id                 = excpm.excpm_id  
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND    isnull(entr.entr_deleted_ind,0)   IN (0,8)         
        AND    excsm.excsm_deleted_ind            = 1        
        AND    compm.compm_deleted_ind            = 1        
        AND    dm.dpm_deleted_ind                 = 1        
        AND    dpam.dpam_deleted_ind              = 1         
        UNION        
        --SELECT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+convert(varchar, dpam.dpam_sba_no)    Comp_Exch_Seg_Demat        
        SELECT DISTINCT compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+' - '+CASE WHEN LEFT(Ltrim(dm.dpm_dpid),2) = 'IN' THEN dm.dpm_dpid + dpam.dpam_sba_no ELSE  dpam.dpam_sba_no END    Comp_Exch_Seg_Demat        
             , convert(varchar,compm.compm_id)+'|*~|'+convert(varchar,Excsm.excsm_id)+'|*~|'+convert(varchar,dpam.dpam_acct_no)+'|*~|'+convert(varchar,dpam.dpam_sba_no)+'|*~|'+convert(varchar,entr.entr_from_dt,103)+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'        
                             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'        
                             +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value         
            ,  convert(varchar,entr.entr_from_dt,103)   entr_from_dt      
            ,   isnull( CONVERT(varchar,entr.entr_to_dt,103) ,'2900-01-01 00:00:00.000')  entr_to_dt   
        FROM   entity_relationship                  entr     WITH (NOLOCK)        
            ,  exch_seg_mstr                        excsm    WITH (NOLOCK)        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            ,  company_mstr                         compm    WITH (NOLOCK)        
            ,  dp_acct_mstr                         dpam     WITH (NOLOCK)        
            ,  dp_mstr                              dm       WITH (NOLOCK)         
            ,  excsm_prod_mstr                       excpm    WITH (NOLOCK)    
        WHERE  entr.entr_sba             NOT IN (SELECT entr_sba FROM entity_relationship_mak entrm WHERE entrm.entr_from_dt = entr.entr_from_dt and  entr_crn_no = @pa_crn_no and entr_deleted_ind IN (0,4,8))        
        AND    dpam.dpam_crn_no                   = entr.entr_crn_no        
        AND    dpam.dpam_sba_no                   = entr.entr_sba            
        AND    dpam.dpam_dpm_id                   = dm.dpm_id          
        AND    dpam.dpam_excsm_id                 = excsm.excsm_id           
        AND    excpm.excpm_excsm_id                 = excsm.excsm_id
        and    entr.entr_excpm_id                 = excpm.excpm_id  
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND    compm.compm_id                     = excsm.excsm_compm_id        
        AND    dpam.dpam_crn_no                   = @pa_crn_no           
        AND    entr.entr_deleted_ind              = 1         
        AND    excsm.excsm_deleted_ind            = 1        
        AND    compm.compm_deleted_ind            = 1        
        AND    dm.dpm_deleted_ind                 = 1        
        AND    dpam.dpam_deleted_ind              = 1         
        order by entr_from_dt desc        
     --           
     END        
     IF @pa_tab = 'DPA_APP_SELECT'        
     BEGIN        
      --        
      print '22'
        SELECT DISTINCT compm.compm_id           compm_id        
            , compm.compm_short_name             compm_short_name        
            , excsm.excsm_id                     excsm_id        
            , excsm.excsm_exch_cd                excsm_exch_cd        
            , excsm.excsm_seg_cd                 excsm_seg_cd        
            , dpamm.dpam_id                      dpam_id        
            , dpamm.dpam_acct_no                 dpam_acct_no        
            , dpm.dpm_dpid                       dpm_dpid         
            , ISNULL(dpamm.dpam_sba_name, 0)     dpam_sba_name        
            , CASE clil.clim_ins_upd_del WHEN 'I' THEN 'ADD'        
                                         WHEN 'E' THEN 'EDIT'        
                                         WHEN 'D' THEN 'DELETE'                   
                                         END     Status          
        FROM  dp_acct_mstr_mak                   dpamm    WITH (NOLOCK)        
            , dp_mstr                            dpm      WITH (NOLOCK)        
            , exch_seg_mstr                      excsm    WITH (NOLOCK)        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , company_mstr                       compm    WITH (NOLOCK)        
            , client_list                        clil     WITH (NOLOCK)        
        WHERE  excsm.excsm_id                  = dpamm.dpam_excsm_id        
        AND    dpamm.dpam_dpm_id               = dpm.dpm_id        
        AND    compm.compm_id                  = excsm.excsm_compm_id        
        AND    dpamm.dpam_id               = clil.clisba_no        
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND    dpamm.dpam_crn_no               = clil.clim_crn_no        
        AND    isnull(dpamm.dpam_deleted_ind,0) IN(0,8)        
        AND    excsm.excsm_deleted_ind         = 1        
        AND    compm.compm_deleted_ind         = 1        
        AND    dpamm.dpam_crn_no               = @pa_crn_no        
        AND    clil.clim_status               in (3,10)        
        AND    clil.clim_deleted_ind           = 1         
        AND    dpm.dpm_deleted_ind             = 1        
        UNION        
        SELECT DISTINCT compm.compm_id     compm_id        
             , compm.compm_short_name      compm_short_name        
             , excsm.excsm_id              excsm_id        
             , excsm.excsm_exch_cd         excsm_exch_cd        
             , excsm.excsm_seg_cd          excsm_seg_cd        
             , dpam.dpam_id                dpam_id        
             , dpam.dpam_acct_no           dpam_acct_no        
             , dpm.dpm_dpid                dpm_dpid         
             , ISNULL(dpam.dpam_sba_name, '') dpam_sba_name                       
             , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'        
                                           WHEN 'E' THEN 'EDIT'        
                                           WHEN 'D' THEN 'DELETE'                   
                                           END  Status        
        FROM  dp_Acct_mstr                 dpam  WITH (NOLOCK)          
            , dp_mstr                      dpm      WITH (NOLOCK)        
            , exch_seg_mstr                excsm   WITH (NOLOCK)        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , company_mstr                 compm   WITH (NOLOCK)        
            , client_list                  clil    WITH (NOLOCK)        
        WHERE excsm.excsm_id            =  dpam.dpam_excsm_id        
        AND   dpam.dpam_dpm_id          =  dpm.dpm_id        
        AND   compm.compm_id            =  excsm.excsm_compm_id        
        AND   dpam.dpam_id          =  clil.clisba_no        
        AND   dpam.dpam_crn_no          =  clil.clim_crn_no        
        AND    excsm_list.excsm_id                 = excsm.excsm_id 
        AND   ISNULL(excsm.excsm_deleted_ind, 0) = 1        
        AND   dpam.dpam_deleted_ind     = 1        
        AND   compm.compm_deleted_ind   = 1        
        AND   dpam.dpam_crn_no          = @pa_crn_no        
        AND   dpam.dpam_id         NOT IN (SELECT dpam_id          
                                           FROM   dp_acct_mstr_mak         
                                           WHERE  dpam_deleted_ind IN (0,8)        
                                           AND    dpam_crn_no       = @pa_crn_no        
                                          )
        AND    clil.clim_status         in (3,10)       
        AND    clil.clim_deleted_ind    = 1        
        AND    dpm.dpm_deleted_ind      = 1        
     --        
     END        
     --        
     IF @pa_tab = 'CLIDPAM_PROP'        
     BEGIN        
     --        
     
        declare  @l_temp_prop table(entpm_enttm_id int       
                   , entp_value      varchar(250)      
                   , entpm_prop_id   int     
                   , entpm_cd        varchar(25)      
                   , entpm_desc      varchar(200)      
                   , entpm_clicm_id  numeric     
                   , entp_id         numeric    
                   , entp_ent_id     numeric    
             , entpm_mdty      char(1)    
                   , entpm_datatype  varchar(5)    
                   , priority        int)    
    
    
declare @l_temp_dtls table(entpd_entp_id numeric    
        , entdm_id        numeric                    
                       , entdm_entpm_prop_id int    
        , entdm_cd        varchar(25)                    
        , entpd_value     varchar(250)                       
        , entdm_desc      varchar(200)                                         
        , entdm_mdty      char(1)                      
        , entdm_datatype  varchar(5)    
                       , priority        int )    
    
    
    
    
insert into @l_temp_prop(entpm_enttm_id     
                   , entp_value          
                   , entpm_prop_id       
                   , entpm_cd            
                   , entpm_desc          
                   , entpm_clicm_id      
                   , entp_id             
                   , entp_ent_id         
                   , entpm_mdty          
                   , entpm_datatype      
                   , priority        )    
  SELECT DISTINCT      entpm.entpm_enttm_id                entpm_enttm_id        
         , isnull(entp.entp_value,'')          entp_value        
         , entpm.entpm_prop_id                 entpm_prop_id        
         , entpm.entpm_cd                      entpm_cd        
         , isnull(entpm.entpm_desc,'')         entpm_desc            
         , entpm.entpm_clicm_id                entpm_clicm_id            
         , entp.entp_id                        entp_id        
         , entp.entp_ent_id                    entp_ent_id        
         , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty        
         , ISNULL(entpm.entpm_datatype,'')     entpm_datatype        
                           , 0    
    FROM  entity_property_mstr          entpm   WITH(NOLOCK)            
                     ,entity_properties             entp    WITH (NOLOCK)        
                WHERE entpm.entpm_prop_id         = entp.entp_entpm_prop_id         
    AND   ISNULL(entp_ent_id, 0)      = @pa_crn_no    
    AND   ISNULL(entp_deleted_ind, 1) = 1        
    and   entpm.entpm_deleted_ind     = 1            
    --and   entpm.entpm_clicm_id = @pa_clicm_id
    --and   entpm.entpm_enttm_id = @pa_enttm_id

insert into @l_temp_prop(entpm_enttm_id     
                   , entp_value          
                   , entpm_prop_id       
                   , entpm_cd            
                   , entpm_desc          
                   , entpm_clicm_id      
                   , entp_id             
                   , entp_ent_id         
                   , entpm_mdty          
                   , entpm_datatype      
                   , priority        )    
  SELECT DISTINCT     entpm.entpm_enttm_id                entpm_enttm_id        
         , isnull(entp.entp_value,'')          entp_value        
         , entpm.entpm_prop_id                 entpm_prop_id        
         , entpm.entpm_cd                      entpm_cd        
         , isnull(entpm.entpm_desc,'')         entpm_desc            
         , entpm.entpm_clicm_id                entpm_clicm_id            
         , entp.entp_id                        entp_id        
         , entp.entp_ent_id                    entp_ent_id        
         , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty        
         , ISNULL(entpm.entpm_datatype,'')     entpm_datatype        
                           , 1    
    FROM  entity_property_mstr          entpm   WITH(NOLOCK)            
                     ,entity_properties_mak             entp    WITH (NOLOCK)        
                WHERE entpm.entpm_prop_id         = entp.entp_entpm_prop_id         
    AND   ISNULL(entp_ent_id, 0)      = @pa_crn_no    
    AND   ISNULL(entp_deleted_ind, 0) in (0,4,8)    
    and   entpm.entpm_deleted_ind     = 1   
   --and   entpm.entpm_clicm_id = @pa_clicm_id
    --and   entpm.entpm_enttm_id = @pa_enttm_id         
    
    
    
delete from @l_temp_prop where entpm_prop_id in (select entpm_prop_id from @l_temp_prop where priority = 1) and priority = 0    
 --   
 --   
insert into @l_temp_dtls (entpd_entp_id     
        , entdm_id       
        , entdm_entpm_prop_id       
        , entdm_cd          
        , entpd_value       
        , entdm_desc        
        , entdm_mdty        
        , entdm_datatype    
                       , priority)     
select entpd_entp_id     
   , entdm_id          
   , entdm_entpm_prop_id    
   , entdm_cd          
   , entpd_value       
   , entdm_desc        
   , CASE entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty        
   , entdm_datatype    
   , 0    
from entity_property_dtls    
   , entpm_dtls_mstr     
where entpd_entdm_id = entdm_id     
and   entpd_entp_id in (select entp_id from @l_temp_prop)    
and   entpd_deleted_ind =1     
and   entdm_deleted_ind =1     
    
    
insert into @l_temp_dtls (entpd_entp_id     
        , entdm_id          
                       , entdm_entpm_prop_id    
        , entdm_cd          
        , entpd_value       
        , entdm_desc        
        , entdm_mdty        
        , entdm_datatype    
                       , priority)     
select entpd_entp_id     
   , entdm_id          
   , entdm_entpm_prop_id    
   , entdm_cd          
   , entpd_value       
   , entdm_desc        
   ,CASE entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty      
   , entdm_datatype    
   , 1    
from entity_property_dtls_mak    
   , entpm_dtls_mstr     
where entpd_entdm_id = entdm_id     
and   entpd_entp_id in (select entp_id from @l_temp_prop)    
and   entpd_deleted_ind in (0,4,8)     
and   entdm_deleted_ind =1     
    
    
delete from @l_temp_dtls where entpd_entp_id in (select entpd_entp_id from @l_temp_dtls where priority = 1 ) and priority = 0    
    
    
    
    
select DISTINCT excsm_exch_cd                       
   , excsm_seg_cd                                  
   , a.entpm_prop_id          entpm_prop_id                      
   , a.entpm_cd               entpm_cd                      
   , ISNULL(a.entp_value,'')              entp_value                      
   , a.entpm_desc             entpm_desc                      
   , isnull(b.entdm_id,0)               entdm_id                        
   , isnull(b.entdm_cd,'')               entdm_cd                      
   , isnull(b.entpd_value,'')           entpd_value                      
   , isnull(b.entdm_desc,'')             entdm_desc                      
   , isnull(b.entdm_datatype,'')         entdm_datatype                      
   , a.entpm_mdty                      
   , b.entdm_mdty                      
   , a.entpm_datatype         entpm_datatype                      
   , ord1                        
from     
(select excsm.excsm_exch_cd     
   , excsm.excsm_seg_cd               
   , entpm_enttm_id     
   , entp_value          
   , entpm_prop_id       
   , entpm_cd            
   , entpm_desc          
   , entpm_clicm_id      
   , entp_id             
   , entp_ent_id         
   , CASE entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty      
   , entpm_datatype      
, 0 d    
, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                        
from entity_property_mstr entpm    
     left outer join     
     entity_properties entp    
     on entp_entpm_prop_id = entpm_prop_id    
     and  isnull(entp_ent_id,@pa_crn_no) = @pa_crn_no     
, (select dpam_crn_no,dpam_enttm_cd,dpam_clicm_cd,dpam_deleted_ind,dpam_excsm_id from dp_acct_mstr where dpam_deleted_ind = 1 and dpam_Crn_no = @pa_crn_no    
   union    
   select dpam_crn_no,dpam_enttm_cd,dpam_clicm_cd,dpam_deleted_ind,dpam_excsm_id from dp_acct_mstr_mak where dpam_deleted_ind in (0,8) and dpam_Crn_no = @pa_crn_no ) dpam     
   left outer join     
   exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
, client_ctgry_mstr     
, entity_type_mstr    
, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list            
, excsm_prod_mstr excpm
WHERE dpam_clicm_cd = clicm_cd     
and   dpam_enttm_cd = enttm_cd     
and   entpm_clicm_id = clicm_id    
and   entpm_enttm_id = enttm_id   
AND   excsm_list.excsm_id = dpam.dpam_excsm_id    
and   excpm.excpm_id = entpm.entpm_excpm_id 
and   excpm_excsm_id = excsm_list.excsm_id   
AND   clicm_deleted_ind =1     
AND   enttm_deleted_ind =1     
and isnull(dpam_crn_no,@pa_crn_no) = @pa_crn_no    
and entpm_prop_id not in (select distinct entpm_prop_id from @l_temp_prop)    
    
union     
    
select excsm.excsm_exch_cd excsm_exch_cd                      
   , excsm.excsm_seg_cd           excsm_seg_cd          
   , entpm_enttm_id     
   , entp_value          
   , entpm_prop_id       
   , entpm_cd            
   , entpm_desc          
   , entpm_clicm_id      
   , entp_id             
   , entp_ent_id         
   , entpm_mdty          
   , entpm_datatype      
   , priority           
, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                        
from @l_temp_prop     
, dp_acct_mstr dpam     
  left outer join     
  exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
, client_ctgry_mstr     
, entity_type_mstr    
, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list            
where dpam_clicm_cd = clicm_cd     
and dpam_enttm_cd = enttm_cd     
AND    excsm_list.excsm_id                 = dpam.dpam_excsm_id    
and  entpm_clicm_id = clicm_id    
and  entpm_enttm_id = enttm_id    
AND   clicm_deleted_ind =1     
AND   enttm_deleted_ind =1     
and dpam_deleted_ind = 1     
and dpam_crn_no = @pa_crn_no    
    
union    
    
select excsm.excsm_exch_cd     
       , excsm.excsm_seg_cd      
       ,entpm_enttm_id     
       , entp_value          
       , entpm_prop_id       
       , entpm_cd            
       , entpm_desc          
       , entpm_clicm_id      
       , entp_id             
       , entp_ent_id         
       , entpm_mdty          
       , entpm_datatype      
       , priority         
, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                         
 from @l_temp_prop     
, dp_acct_mstr_mak dpam     
  left outer join     
  exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
, client_ctgry_mstr     
, entity_type_mstr    
, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list    
where dpam_clicm_cd = clicm_cd     
and dpam_enttm_cd = enttm_cd     
AND    excsm_list.excsm_id                 = dpam.dpam_excsm_id    
and  entpm_clicm_id = clicm_id    
and  entpm_enttm_id = enttm_id  
AND   clicm_deleted_ind =1     
AND   enttm_deleted_ind =1     
    
and dpam_deleted_ind in(0,8)    
and dpam_crn_no = @pa_crn_no ) a    
    
left outer join     
    
    
(select  entpd_entp_id     
    , entdm_id          
       , entdm_entpm_prop_id    
    , entdm_cd          
    , entpd_value       
    , entdm_desc        
    , CASE entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty      
    , entdm_datatype    
       , 0 b    
from entpm_dtls_mstr    
left outer join     
entity_property_dtls     
on entdm_id = entpd_entdm_id     
and entpd_entp_id in (select entp_id from @l_temp_prop)    
where entdm_id not in(select entdm_id from @l_temp_dtls)    
    
union    
    
select entpd_entp_id     
    , entdm_id          
       , entdm_entpm_prop_id    
    , entdm_cd          
    , entpd_value       
    , entdm_desc        
    , entdm_mdty        
    , entdm_datatype    
       , priority    
from @l_temp_dtls) b    
on a.entpm_prop_id =  b.entdm_entpm_prop_id    
ORDER BY ord1         
    --                      
    END        
    --        
    IF @pa_tab  = 'CLIDPAM_DOC'          
    BEGIN          
    --          
      SELECT DISTINCT y.excsm_exch_cd   excsm_exch_cd          
                    , y.excsm_seg_cd    excsm_seg_cd          
                    , isnull(x.clid_doc_path,'')   clid_doc_path          
                    , isnull(x.clid_remarks ,'')   clid_remarks          
                    , isnull(x.docm_doc_id ,0)   docm_doc_id          
                    , isnull(x.docm_desc,'')       docm_desc          
                    , y.clicm_id        clicm_id          
                    , isnull(x.docm_mdty ,'')      docm_mdty          
                    , isnull(x.clid_valid_yn,0)   clid_valid_yn           
                    , y.dpam_enttm_cd   dpam_enttm_cd          
                    , y.exch              exch          
      FROM           
      (SELECT DISTINCT ISNULL(clid.clid_doc_path,'') clid_doc_path            
            , ISNULL(clid.clid_remarks,'')           clid_remarks              
            , docm.docm_doc_id                       docm_doc_id            
            , ISNULL(docm.docm_desc,'')              docm_desc          
            , docm.docm_enttm_id                     docm_enttm_id            
            , docm.docm_clicm_id                     docm_clicm_id            
            , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty            
            , ISNULL(clid.clid_valid_yn,0)           clid_valid_yn        
              FROM    document_mstr                          docm      
              left outer join          
              client_documents_mak                   clid on (clid.clid_docm_doc_id = docm.docm_doc_id and clid.clid_crn_no = @pa_crn_no)          
      WHERE   isnull(clid.clid_deleted_ind,0)     IN (0,8)          
      AND     docm.docm_deleted_ind                = 1          
      )x          
      RIGHT OUTER JOIN          
      (SELECT DISTINCT clicm.clicm_id                clicm_id          
            , excsm.excsm_exch_cd                    excsm_exch_cd          
            , excsm.excsm_seg_cd                     excsm_seg_cd             
            , enttm.enttm_id                         enttm_id          
            , dpam.dpam_enttm_cd                     dpam_enttm_cd           
            , CASE excsm.excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  exch          
       FROM   dp_acct_mstr_mak                       dpam          
            , exch_seg_mstr                          excsm  WITH (NOLOCK)          
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , client_ctgry_mstr                      clicm  WITH (NOLOCK)          
            , entity_type_mstr                       enttm  WITH (NOLOCK)               
       WHERE  dpam.dpam_crn_no                     = @pa_crn_no          
       AND    dpam.dpam_clicm_cd                   = clicm.clicm_cd          
       AND    enttm.enttm_cd                       = dpam.dpam_enttm_cd          
       AND    dpam.dpam_excsm_id                   = excsm.excsm_id          
       AND    excsm_list.excsm_id                 = excsm.excsm_id 
       AND    isnull(dpam.dpam_deleted_ind,0)     IN (0,8)          
       AND    excsm.excsm_deleted_ind              = 1          
       AND    clicm.clicm_deleted_ind              = 1          
       AND    enttm.enttm_deleted_ind              = 1          
      )y          
      ON (x.docm_enttm_id = y.enttm_id) AND (x.docm_clicm_id = y.clicm_id)          
      UNION          
      SELECT DISTINCT y.excsm_exch_cd   excsm_exch_cd          
                    , y.excsm_seg_cd    excsm_seg_cd          
                      , isnull(x.clid_doc_path,'')   clid_doc_path          
                    , isnull(x.clid_remarks ,'')   clid_remarks          
                    , isnull(x.docm_doc_id ,0)   docm_doc_id          
                    , isnull(x.docm_desc,'')       docm_desc          
                    , y.clicm_id        clicm_id          
                    , isnull(x.docm_mdty ,'')      docm_mdty          
                    , isnull(x.clid_valid_yn,0)   clid_valid_yn           
                    , y.dpam_enttm_cd   dpam_enttm_cd          
                    , y.exch              exch       
      FROM           
      (SELECT DISTINCT ISNULL(clid.clid_doc_path,'') clid_doc_path            
            , ISNULL(clid.clid_remarks,'')           clid_remarks              
            , docm.docm_doc_id                       docm_doc_id            
            , ISNULL(docm.docm_desc,'')              docm_desc          
            , docm.docm_enttm_id                     docm_enttm_id            
            , docm.docm_clicm_id                     docm_clicm_id            
            , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty            
            , ISNULL(clid.clid_valid_yn,0)           clid_valid_yn          
            , clid_crn_no                            clid_crn_no           
      FROM    document_mstr                          docm          
              left outer join          
              client_documents                       clid           
      ON      clid.clid_docm_doc_id = docm.docm_doc_id          
      AND     clid.clid_crn_no  NOT IN (SELECT clidm.clid_crn_no clid_crn_no FROM client_documents_mak clidm  WITH(NOLOCK) WHERE  clidm.clid_crn_no       =  @pa_crn_no AND clidm.clid_deleted_ind IN (0,8))          
      AND     clid.clid_crn_no  = @pa_crn_no          
      WHERE   clid.clid_deleted_ind                = 1          
      AND     docm.docm_deleted_ind                = 1          
      )x          
      RIGHT OUTER JOIN          
      (SELECT DISTINCT clicm.clicm_id                clicm_id          
            , excsm.excsm_exch_cd                    excsm_exch_cd          
      , excsm.excsm_seg_cd                     excsm_seg_cd             
            , enttm.enttm_id                         enttm_id          
            , dpam.dpam_enttm_cd                     dpam_enttm_cd           
            , CASE excsm.excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  exch          
            , dpam_crn_no                            dpam_crn_no           
       FROM   dp_acct_mstr                           dpam          
            , exch_seg_mstr                          excsm  WITH (NOLOCK)          
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , client_ctgry_mstr                      clicm  WITH (NOLOCK)          
            , entity_type_mstr                       enttm  WITH (NOLOCK)               
       WHERE  dpam.dpam_crn_no                     = @pa_crn_no          
       AND    dpam.dpam_clicm_cd                   = clicm.clicm_cd          
       AND    enttm.enttm_cd                       = dpam.dpam_enttm_cd          
       AND    excsm_list.excsm_id                 = excsm.excsm_id 
       AND    dpam.dpam_excsm_id                   = excsm.excsm_id          
       AND    excsm.excsm_deleted_ind              = 1          
       AND    clicm.clicm_deleted_ind              = 1          
       AND    dpam.dpam_deleted_ind                = 1          
       AND    enttm.enttm_deleted_ind              = 1          
      )y          
      ON (x.docm_enttm_id = y.enttm_id) and (x.docm_clicm_id = y.clicm_id) AND  y.dpam_crn_no = ISNULL(x.clid_crn_no,y.dpam_crn_no)           
      --WHERE y.dpam_crn_no = x.clid_crn_no          
      UNION          
      SELECT DISTINCT y.excsm_exch_cd   excsm_exch_cd          
                    , y.excsm_seg_cd    excsm_seg_cd          
                     , isnull(x.clid_doc_path,'')   clid_doc_path          
                    , isnull(x.clid_remarks ,'')   clid_remarks          
                    , isnull(x.docm_doc_id ,0)   docm_doc_id          
                    , isnull(x.docm_desc,'')       docm_desc          
                    , y.clicm_id        clicm_id          
                    , isnull(x.docm_mdty ,'')      docm_mdty          
                    , isnull(x.clid_valid_yn,0)   clid_valid_yn           
                    , y.dpam_enttm_cd   dpam_enttm_cd          
                    , y.exch              exch         
      FROM           
      (SELECT DISTINCT ISNULL(clid.clid_doc_path,'') clid_doc_path            
            , ISNULL(clid.clid_remarks,'')           clid_remarks              
            , docm.docm_doc_id                       docm_doc_id            
            , ISNULL(docm.docm_desc,'')              docm_desc          
            , docm.docm_enttm_id                     docm_enttm_id            
            , docm.docm_clicm_id                     docm_clicm_id            
            , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty            
            , ISNULL(clid.clid_valid_yn,0)           clid_valid_yn          
            , clid_crn_no                            clid_crn_no           
      FROM    document_mstr                          docm          
              left outer join          
              client_documents_mak                   clid           
      ON      clid.clid_docm_doc_id                = docm.docm_doc_id          
      and     clid.clid_crn_no                     = @pa_crn_no          
      WHERE   docm.docm_deleted_ind                = 1          
      )x          
      RIGHT OUTER JOIN          
      (SELECT DISTINCT clicm.clicm_id                clicm_id          
            , excsm.excsm_exch_cd                    excsm_exch_cd          
            , excsm.excsm_seg_cd      excsm_seg_cd             
        , enttm.enttm_id                         enttm_id          
            , dpam.dpam_enttm_cd                     dpam_enttm_cd           
            , CASE excsm.excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  exch          
            , dpam_crn_no                            dpam_crn_no           
       FROM   dp_acct_mstr                           dpam          
            , exch_seg_mstr                          excsm  WITH (NOLOCK)          
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list
            , client_ctgry_mstr                      clicm  WITH (NOLOCK)          
            , entity_type_mstr                       enttm  WITH (NOLOCK)               
       WHERE  dpam.dpam_crn_no                     = @pa_crn_no          
       AND    dpam.dpam_clicm_cd                   = clicm.clicm_cd          
       AND    enttm.enttm_cd                       = dpam.dpam_enttm_cd          
       AND    excsm_list.excsm_id                 = excsm.excsm_id 
       AND    dpam.dpam_excsm_id                   = excsm.excsm_id          
       AND    excsm.excsm_deleted_ind              = 1          
       AND    clicm.clicm_deleted_ind              = 1          
       AND    dpam.dpam_deleted_ind                = 1          
       AND    enttm.enttm_deleted_ind              = 1          
      )y          
      ON (x.docm_enttm_id = y.enttm_id) and (x.docm_clicm_id = y.clicm_id) and y.dpam_crn_no = x.clid_crn_no          
      ORDER BY exch          
    --          
    END          
  --        
  END--chk_1        
--        
END        
        
        
        
      
    
  
--select * from client_dp_brkg
--clidb.clidb_eff_from_dt

GO
