-- Object: PROCEDURE citrus_usr.pr_ins_upd_name_reason_cd
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE procedure [citrus_usr].[pr_ins_upd_name_reason_cd]
(
	@pa_crn_no numeric,
	@pa_action varchar(50),
	@pa_nmcrcd_sba_no varchar(16),
	@pa_nmcrcd_reason_cd char(2),
	@pa_nmcrcd_reason_desc varchar(200),
	@pa_loginname varchar(50),
	@pa_holder_type varchar(20),
	@rowdelimiter    CHAR(4),        
    @coldelimiter    CHAR(4),
	@pa_msg VARCHAR(8000) OUTPUT  
)
AS BEGIN
	DECLARE @@t_errorstr      VARCHAR(8000)        
			,@@l_error        BIGINT 
			,@@reason_father varchar(1000)
			,@@reason_father_split varchar(8000)
		IF @pa_action = 'INS'
		BEGIN
				IF EXISTS(SELECT  nmcrcd_crn_no     
                  FROM   name_change_reason_cd             
                  WHERE  nmcrcd_deleted_ind		IN (0,4,8)      
                  AND    nmcrcd_crn_no			= @pa_crn_no      
                  AND    nmcrcd_sba_no			= nmcrcd_sba_no
				  AND	 nmcrcd_holder_type = @pa_holder_type)      
				BEGIN                
				--      
				  UPDATE name_change_reason_cd      
				  SET    nmcrcd_deleted_ind =  3       
				  WHERE  nmcrcd_crn_no      = @pa_crn_no      
				  AND    nmcrcd_deleted_ind IN (0,4,8)      
				  AND    nmcrcd_sba_no    = nmcrcd_sba_no
				  AND	 nmcrcd_holder_type = @pa_holder_type      
				--      
				END    
		 
			BEGIN TRANSACTION
				INSERT INTO name_change_reason_cd        
				  (
				   nmcrcd_crn_no,
				   nmcrcd_sba_no,
				   nmcrcd_reason_cd,
				   nmcrd_reason_desc,
				   nmcrcd_created_dt,
				   nmcrcd_created_by,
				   nmcrcd_lst_upd_dt,
				   nmcrcd_lst_upd_by,
				   nmcrcd_deleted_ind,
				   nmcrcd_holder_type
				  )
				  VALUES
				  (
				   @pa_crn_no,
				   @pa_nmcrcd_sba_no,
				   @pa_nmcrcd_reason_cd,
				   @pa_nmcrcd_reason_desc,
				   getdate(),
				   @pa_loginname,
				   getdate(),
				   @pa_loginname,
				   '0',
				   @pa_holder_type
				   )  
					
				   if @pa_holder_type = 'Ist Holder'
				   begin
					   update client_mstr_mak set CLIM_RMKS = @pa_nmcrcd_reason_desc 
					   where clim_crn_no = @pa_crn_no
				   and clim_deleted_ind in ('8','0','1')
				   end
				   else if @pa_holder_type = 'IInd Holder'
				   begin
						select @@reason_father = DPHD_SH_FTHNAME from DP_HOLDER_DTLS_MAK
						where DPHD_DPAM_SBA_NO = @pa_nmcrcd_sba_no
						and DPHD_DELETED_IND in ('8','0')
						
						set @@reason_father_split = citrus_usr.[FN_SPLITVAL_BY](@@reason_father,2,'/')
						
						if @@reason_father_split = ''
						begin 
							update DP_HOLDER_DTLS_MAK set DPHD_SH_FTHNAME = @pa_nmcrcd_reason_desc + '/' + DPHD_SH_FTHNAME
							where DPHD_DPAM_SBA_NO = @pa_nmcrcd_sba_no
							and DPHD_DELETED_IND in ('8','0')
						end
						else
						begin
							update DP_HOLDER_DTLS_MAK set DPHD_SH_FTHNAME = @pa_nmcrcd_reason_desc + '/' + citrus_usr.[FN_SPLITVAL_BY](@@reason_father,2,'/')
							where DPHD_DPAM_SBA_NO = @pa_nmcrcd_sba_no
							and DPHD_DELETED_IND in ('8','0')
						end
						
						--update DP_HOLDER_DTLS_MAK set DPHD_SH_FTHNAME = @pa_nmcrcd_reason_desc + '/' + DPHD_SH_FTHNAME
						--where DPHD_DPAM_SBA_NO = @pa_nmcrcd_sba_no
						--and DPHD_DELETED_IND in ('8','0')
				   end
				   else if @pa_holder_type = 'IIIrd Holder'
				   begin
						update DP_HOLDER_DTLS_MAK set DPHD_TH_FTHNAME = @pa_nmcrcd_reason_desc + '/' + DPHD_TH_FTHNAME
						where DPHD_DPAM_SBA_NO = @pa_nmcrcd_sba_no
						and DPHD_DELETED_IND in ('8','0')
				   end
				   
				SET @@l_error = @@error        
          
          IF @@l_error > 0 --if any error reports then generate the error string        
          BEGIN        
            SET @@t_errorstr = 'Error: Could not be Inserted'+@rowdelimiter+@@t_errorstr       
            ROLLBACK TRANSACTION 
		  END 
		  ELSE        
          BEGIN        
            --        
            COMMIT TRANSACTION     
		  END

		  IF @@t_errorstr=''        
		  BEGIN        
			--        
		   SET @pa_msg = 'First Name Change Successfully Inserted/Edited'+ @rowdelimiter        
			--        
		  END        
		  ELSE        
		  BEGIN        
			--        
			SET @pa_msg = @@t_errorstr        
			--        
		  END    
	 END 
END

GO
