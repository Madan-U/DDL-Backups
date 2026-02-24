-- Object: PROCEDURE citrus_usr.pr_fill_and_upd_properties_obj_bak_06052016
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


create procedure [citrus_usr].[pr_fill_and_upd_properties_obj_bak_06052016]
(
	@pa_action varchar(100),
	@pa_excsmid numeric,
	@pa_value varchar(8000),
	@pa_crnno numeric = 0,
	@pa_entpm_value varchar(8000),
	@pa_roles varchar(8000),
	@pa_scr_id numeric,
	@pa_client_id varchar(20),
	@pa_ref_cur varchar(8000) output
)
as
begin 
	declare @L_ENTP_VALUE varchar(1000)
    declare @L_DP_ACCT_VALUES varchar(1000)
	declare @l_dpm_dpid varchar(100)
	declare @l_excsm_id  numeric
	declare @l_compm_id  numeric
	declare @l_dppd_details varchar(8000)
	declare @l_error numeric
	declare @l_errorstr varchar(8000)
	declare @l_rowdelimiter  char(4)  = '*|~*',@pa_id integer
	declare @l_sh_fname varchar(150), @l_th_fname varchar(150)
	declare @l_master_id varchar(20)
	
	if @pa_action = 'VALIDATE_SAME_POA_DTLS'
	BEGIN
		select top 1 @l_master_id = dppd_master_id
		from dp_poa_dtls,dp_acct_mstr
		where DPPD_HLD = citrus_usr.fn_splitval(@pa_value,2)
		and dppd_master_id = citrus_usr.fn_splitval(@pa_value,1)
		and DPPD_DPAM_ID = dpam_id
		and dpam_sba_no = @pa_client_id
		and DPPD_DELETED_IND = '1'
		and (dppd_eff_TO_dt > GETDATE() or dppd_eff_TO_dt = '1900-01-01 00:00:00.000')
			and DPPD_POA_TYPE = citrus_usr.fn_splitval(@pa_value,3)

		if ISNULL(@l_master_id,'') = '' or ISNULL(@l_master_id,'') = null
		begin
			select 'N' as validatePoaDtls
		end
		else
		begin
			select 'Y' as validatePoaDtls
		end
	END
	
	if @pa_action = 'TYPE_HOLDER_DTLS_VALIDATION'
	BEGIN
		if @pa_value = '2ND HOLDER'
		begin
			select @l_sh_fname = DPHD_SH_FNAME from dp_holder_dtls where dphd_dpam_sba_no = @pa_client_id
				if @l_sh_fname = null or @l_sh_fname = '' 
				begin
					set @l_sh_fname = 'N'
				end
				else
				begin
					set @l_sh_fname = 'Y'
				end
			select @l_sh_fname as hldgType
		end
		else
		begin
			select @l_th_fname = DPHD_TH_FNAME from dp_holder_dtls where dphd_dpam_sba_no = @pa_client_id
				if @l_th_fname = null or @l_th_fname = '' 
				begin
					set @l_th_fname = 'N'
				end
				else
				begin
					set @l_th_fname = 'Y'
				end
			select @l_th_fname as hldgType
		end
	END

	if @pa_action = 'ANNUAL_INCOME'
	begin
		select '--SELECT--' bitrm_values
		union
		select 'NOT AVAILABLE' bitrm_values
		union
		SELECT DISTINCT bitrm.bitrm_values bitrm_values
		FROM  bitmap_ref_mstr bitrm , entity_property_mstr 
		WHERE  bitrm.bitrm_deleted_ind  = 1
		AND  bitrm.bitrm_tab_type IN ('ENTPM', 'ENTDM')
		--and    bitrm.bitrm_parent_cd = '15'
		AND ENTPM_PROP_ID = BITRM_PARENT_CD
		AND ENTPM_CD = @pa_value --'ANNUAL_INCOME'
		AND ENTPM_DELETED_IND = '1'
	end
	if @pa_action = 'OCCUPATION'
	begin
		select '--SELECT--' bitrm_values
		union
		select 'NOT AVAILABLE' bitrm_values
		union
		SELECT DISTINCT bitrm.bitrm_values bitrm_values
		FROM  bitmap_ref_mstr bitrm , entity_property_mstr 
		WHERE  bitrm.bitrm_deleted_ind  = 1
		AND  bitrm.bitrm_tab_type IN ('ENTPM', 'ENTDM')
		--and    bitrm.bitrm_parent_cd = '15'
		AND ENTPM_PROP_ID = BITRM_PARENT_CD
		AND ENTPM_CD = @pa_value --'ANNUAL_INCOME'
		AND ENTPM_DELETED_IND = '1'
	end
	if @pa_action = 'PAN_UPDATE'
	begin
	
		SET @L_ENTP_VALUE       = ''  

		SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(@pa_value) + '|*~|*|~*' 
		FROM DP_ACCT_MSTR  ,ENTITY_PROPERTY_MSTR  WHERE dpam_sba_no = @pa_client_id  AND ENTPM_CD   = 'PAN_GIR_NO'  
		
		BEGIN TRANSACTION
		EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@pa_crnno,'',@L_ENTP_VALUE,'',2,'*|~*','|*~|',''
		
		SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client pan successfully inserted\edited '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --

		SET @pa_ref_cur = @l_errorstr 
    end 
	if @pa_action = 'INCOME_UPDATE'
	begin
			
		SET @L_ENTP_VALUE       = ''  

		SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(@pa_value) + '|*~|*|~*' 
		FROM DP_ACCT_MSTR  ,ENTITY_PROPERTY_MSTR  WHERE dpam_sba_no = @pa_client_id  AND ENTPM_CD = 'ANNUAL_INCOME'  

		BEGIN TRANSACTION
		EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@pa_crnno,'',@L_ENTP_VALUE,'',2,'*|~*','|*~|',''  
		SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client annual income successfully inserted\edited '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --

		SET @pa_ref_cur = @l_errorstr
	end  
	if @pa_action = 'OCCUPATION_UPDATE'
	begin
			
		SET @L_ENTP_VALUE       = ''  

		SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(@pa_value) + '|*~|*|~*' 
		FROM DP_ACCT_MSTR  ,ENTITY_PROPERTY_MSTR  WHERE dpam_sba_no = @pa_client_id  AND ENTPM_CD = 'OCCUPATION'  

		BEGIN TRANSACTION
		EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@pa_crnno,'',@L_ENTP_VALUE,'',2,'*|~*','|*~|',''  
		SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client occupation successfully inserted\edited '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --

		SET @pa_ref_cur = @l_errorstr
	end
	if @pa_action = 'SUB_STATUS_UPDATE'
	begin
			

		    select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
			where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and excsm_id = @pa_excsmid
--			and dpm_dpid = (select top 1 left(dpam_sba_no,8) from dp_acct_mstr)

			select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id  
            and excsm_id = @pa_excsmid
	        
			SELECT @L_DP_ACCT_VALUES = ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'
			+ ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')+'|*~|'+ISNULL(dpam_sba_no,'')+'|*~|'
								+ISNULL(dpam_sba_name,'')+'|*~|'+ ISNULL(LTRIM(RTRIM(dpam_acct_no)),'') +'|*~|'
								+DPAM_STAM_CD + '|*~|'
								+dpam_enttm_cd+ '|*~|' 
								+DPAM_CLICM_CD + '|*~|'
								+@pa_value +'|*~|0|*~|E|*~|*|~*' 
			FROM DP_ACCT_MSTR 
			WHERE  DPAM_SBA_NO = @pa_client_id   
            		   print @L_DP_ACCT_VALUES
		
			BEGIN TRANSACTION
            EXEC PR_INS_UPD_DPAM @pa_crnno,'EDT','MIG',@pa_crnno,@L_DP_ACCT_VALUES,2,'*|~*','|*~|',''
            
            --SELECT @pa_action = 'I'  
            --SELECT @pa_id = dpam_crn_no FROM dp_acct_mstr WHERE dpam_crn_no = @pa_crnno  
            --EXEC pr_ins_upd_list @pa_id, @pa_action,'dp acct mstr', 'MIG', '*|~*', '|*~|', ''     
			
			SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client bo sub catagory successfully inserted\edited '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --

		SET @pa_ref_cur = @l_errorstr
	end 
    if @pa_action = 'POA_DEACTIVATION' and @pa_value = 'YES'    
	begin
        --declare @l_dppd_details varchar(1000)
		select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
		where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and excsm_id = @pa_excsmid

		select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id  
        and excsm_id = @pa_excsmid

        SET @l_dppd_details = ''  
         
		SELECT @l_dppd_details = @l_dppd_details + isnull(convert(varchar,@l_compm_id),'')+'|*~|'
		+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'
		+isnull(convert(varchar,LEFT(dpam.dpam_sba_no,8)),'')+'|*~|'
		+isnull(dpam.dpam_sba_no,'')+'|*~|'
		+isnull(DPPD_POA_TYPE,'')+'|*~|'
		+ DPPD_HLD  +'|*~|'
--		+ISNULL(ltrim(rtrim(poam_name1)),'') +'|*~|'
--        +ISNULL(ltrim(rtrim(poam_name2)),'')+'|*~|'
--		+ISNULL(ltrim(rtrim(poam_name3)),'')+'|*~|'
		+ISNULL(ltrim(rtrim(DPPD_FNAME)),'') +'|*~|'
        +ISNULL(ltrim(rtrim(DPPD_MNAME)),'')+'|*~|'
		+ISNULL(ltrim(rtrim(DPPD_LNAME)),'')+'|*~|'
		+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'
		+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(dppd_poa_id)),'')+'|*~|'
		+ISNULL(ltrim(rtrim(dppd_gpabpa_flg)),'') 
		+'|*~|'+convert(varchar,dppd_setup,103)
		+'|*~|'+convert(varchar,CONVERT(datetime,dppd_eff_fr_dt,103)) 
		 --+'|*~|'+ convert(varchar,CONVERT(datetime,@pa_entpm_value,103)) --todate
		+'|*~|'+ convert(varchar,CONVERT(datetime,getdate(),103)) --todate
		+'|*~|'+ltrim(rtrim(poam_master_id))+'|*~|'
		+'0'+'|*~|'
		+ convert(varchar,citrus_usr.fn_splitval(@pa_roles,2)) + '|*~|'+'E*|~*'  
		FROM dp_Acct_mstr dpam, dp_poa_dtls , poam --poa_mstr 
		WHERE dppd_master_id = poam_master_id 
		and  dpam.DPAM_SBA_NO  = @pa_client_id 
		--AND POARegNum <>''   
		and dppd_dpam_id = DPAM_ID 
		--and DPPD_POA_TYPE = @pa_roles
		and dppd_poa_id =  citrus_usr.fn_splitval(@pa_roles,1) 
		and dppd_master_id = @pa_entpm_value
        -- select  '1',@l_crn_no,'INS','MIG',@l_dppd_details,0,'*|~*','|*~|',''  

		print @l_dppd_details
        if @l_dppd_details <> '' 
		BEGIN
		BEGIN TRANSACTION
		
        EXEC pr_ins_upd_dppd '1',@pa_crnno,'EDT','MIG',@l_dppd_details,2,'*|~*','|*~|',''    
		
		SELECT @pa_action = 'I'  
                SELECT @pa_id    = dpam_crn_no     FROM dp_acct_mstr WHERE dpam_crn_no = @pa_crnno  
                --  
                
                
                EXEC pr_ins_upd_list @pa_id, @pa_action,'dp poa dtls', 'MIG', '*|~*', '|*~|', ''   
		
		SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client poa successfully deactivated '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --
            END

		SET @pa_ref_cur = @l_errorstr
	end
	if @pa_action = 'NOMINEE_DTLS'
	begin
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
--            , isnull(dphd_nomgau_fname,'')        dphd_nomgau_fname        
--            , isnull(dphd_nomgau_mname,'')        dphd_nomgau_mname        
--            , isnull(dphd_nomgau_lname,'')        dphd_nomgau_lname        
--            , isnull(dphd_nomgau_fthname,'')      dphd_nomgau_fthname        
--            , CASE WHEN convert(varchar,isnull(dphd_nomgau_dob,''),103) = '01/01/1900' THEN '' ELSE convert(varchar,isnull(dphd_nomgau_dob,''),103)    END    dphd_nomgau_dob          
--            , isnull(dphd_nomgau_pan_no,'')       dphd_nomgau_pan_no        
--            , isnull(dphd_nomgau_gender,'')       dphd_nomgau_gender       
            , isnull(dphd_nom_fname,'')           dphd_nom_fname        
            , isnull(dphd_nom_mname,'')           dphd_nom_mname        
            , isnull(dphd_nom_lname,'')           dphd_nom_lname        
            , isnull(dphd_nom_fthname,'')         dphd_nom_fthname        
            , CASE WHEN convert(varchar,isnull(dphd_nom_dob,''),103)   = '01/01/1900' THEN  '' ELSE convert(varchar,isnull(dphd_nom_dob,''),103)    END dphd_nom_dob          
            , isnull(dphd_nom_pan_no,'')          dphd_nom_pan_no        
            , isnull(dphd_nom_gender,'')          dphd_nom_gender        
			, ISNULL(NOM_NRN_NO,'')           dphd_nom_NRN_NO
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
        WHERE  dam.dpam_crn_no                = @pa_crnno        
        AND    dam.dpam_sba_no                = convert(varchar, @pa_client_id)         
        AND    dam.dpam_sba_no                = dphd.dphd_dpam_sba_no          
        AND    dphd.dphd_deleted_ind          = 1          
        AND    dam.dpam_deleted_ind           = 1    
	end
	if @pa_action = 'NOMINEE_DEL'
	BEGIN
--		UPDATE H SET H.dphd_nom_fname = '', 
--					 H.dphd_nom_mname = '',
--					 H.dphd_nom_lname = '',
--					 H.dphd_nom_fthname = '',
--					 H.dphd_nom_dob = '',
--					 H.dphd_nom_pan_no = '',
--					 H.dphd_nom_gender = '',
--					 H.NOM_NRN_NO = ''
--		WHERE dp_holder_dtls H, dp_acct_mstr DPAM
--		AND    DPAM.dpam_crn_no                = @pa_crnno        
--        AND    DPAM.dpam_sba_no                = convert(varchar, @pa_client_id)         
--        AND    DPAM.dpam_sba_no                = H.dphd_dpam_sba_no          
--        AND    H.dphd_deleted_ind              = 1          
--        AND    DPAM.dpam_deleted_ind           = 1
		 
		     declare   @PA_FH_DTLS varchar(500)
			 declare   @PA_SH_DTLS varchar(500)
			 declare   @PA_TH_DTLS varchar(500)
			 declare   @PA_NOMGAU_DTLS varchar(500)
			 declare   @PA_NOM_DTLS varchar(500)
			 declare   @PA_GAU_DTLS varchar(500)
			  

             SET  @PA_FH_DTLS =''
			 SET  @PA_SH_DTLS =''
			 SET  @PA_TH_DTLS =''
			 SET  @PA_NOMGAU_DTLS =''
			 SET  @PA_NOM_DTLS=''
			 SET  @PA_GAU_DTLS =''
			  
			  
					   SELECT @PA_FH_DTLS = ''+'|*~|'+''+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_FH_FTHNAME )),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
--					   SELECT @PA_SH_DTLS =  ISNULL(DPHD_SH_FNAME ,'')+'|*~|'+ISNULL(DPHD_SH_MNAME ,'')+'|*~|'+ISNULL(DPHD_SH_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_SH_FTHNAME )),'')+'|*~|'+CITRUS_USR.FNGETDATE(DPHD_SH_DOB )+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_SH_PAN_NO )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
--					   SELECT @PA_TH_DTLS =  ISNULL(DPHD_tH_FNAME ,'')+'|*~|'+ISNULL(DPHD_tH_MNAME ,'')+'|*~|'+ISNULL(DPHD_tH_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_tH_FTHNAME )),'')+'|*~|'+CITRUS_USR.FNGETDATE(DPHD_tH_DOB )+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_tH_PAN_NO )),'')+'|*~|'+'|*~|*|~*'    FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
--					   SELECT @PA_NOMGAU_DTLS =ISNULL(dphd_nomgau_fname ,'')+'|*~|'+ISNULL(dphd_nomgau_mname ,'')+'|*~|'+ISNULL(dphd_nomgau_lname ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(dphd_nomgau_fthname  )),'')+'|*~|'+CITRUS_USR.FNGETDATE(dphd_nomgau_dob )+'|*~|'+ISNULL(LTRIM(RTRIM(dphd_nomgau_pan_no )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   SELECT @PA_SH_DTLS =  ISNULL(DPHD_SH_FNAME ,'')+'|*~|'+ISNULL(DPHD_SH_MNAME ,'')+'|*~|'+ISNULL(DPHD_SH_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_SH_FTHNAME )),'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_SH_DOB)),'') +'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_SH_PAN_NO )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   SELECT @PA_TH_DTLS =  ISNULL(DPHD_tH_FNAME ,'')+'|*~|'+ISNULL(DPHD_tH_MNAME ,'')+'|*~|'+ISNULL(DPHD_tH_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_tH_FTHNAME )),'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_tH_DOB)),'') +'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_tH_PAN_NO )),'')+'|*~|'+'|*~|*|~*'    FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   SELECT @PA_NOMGAU_DTLS =ISNULL(dphd_nomgau_fname ,'')+'|*~|'+ISNULL(dphd_nomgau_mname ,'')+'|*~|'+ISNULL(dphd_nomgau_lname ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(dphd_nomgau_fthname  )),'')+'|*~|'+ ISNULL(LTRIM(RTRIM(dphd_nomgau_dob)),'') +'|*~|'+ISNULL(LTRIM(RTRIM(dphd_nomgau_pan_no )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   --SELECT @PA_NOM_DTLS = ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+CITRUS_USR.FNGETDATE('')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   SELECT @PA_NOM_DTLS = ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   --SELECT @PA_GAU_DTLS = ISNULL(DPHD_GAU_FNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_MNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_FTHNAME )),'')+'|*~|'+CITRUS_USR.FNGETDATE(DPHD_GAU_DOB )+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_PAN_NO )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   --SELECT @PA_GAU_DTLS = ISNULL(DPHD_GAU_FNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_MNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_FTHNAME )),'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_DOB )),'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_PAN_NO )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 
					   SELECT @PA_GAU_DTLS = ISNULL(DPHD_GAU_FNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_MNAME ,'')+'|*~|'+ISNULL(DPHD_GAU_LNAME ,'')+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_FTHNAME )),'')+'|*~|'+NULL+'|*~|'+ISNULL(LTRIM(RTRIM(DPHD_GAU_PAN_NO )),'')+'|*~|'+'|*~|*|~*'   FROM   DP_HOLder_dtls  WHERE DPHD_DPAM_SBA_NO = @pa_client_id 

		print @PA_FH_DTLS
		print @PA_SH_DTLS
		print @PA_TH_DTLS
		print @PA_NOMGAU_DTLS
		print @PA_NOM_DTLS
		print @PA_GAU_DTLS
		  BEGIN TRANSACTION
           EXEC PR_INS_UPD_DPHD '0',@pa_crnno,@pa_client_id,'EDT','MIG',@PA_FH_DTLS,@PA_SH_DTLS,@PA_TH_DTLS,@PA_NOMGAU_DTLS,@PA_NOM_DTLS
           ,@PA_GAU_DTLS,1,'*|~*','|*~|','' 
           
           SELECT @pa_action = 'I'  
            SELECT @pa_id = dpam_crn_no FROM dp_acct_mstr WHERE dpam_crn_no = @pa_crnno  
            EXEC pr_ins_upd_list @pa_id, @pa_action,'dp holder dtls', 'MIG', '*|~*', '|*~|', ''   
		
		SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_ref_cur = 'Error : Please contact Administrator..'
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'Nominee successfully deleted '+ @l_rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --

		SET @pa_ref_cur = @l_errorstr              
  
	END


end

GO
