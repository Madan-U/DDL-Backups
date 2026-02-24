-- Object: PROCEDURE citrus_usr.pr_ins_upd_name_reason_cd_bak_15032016
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create procedure [citrus_usr].[pr_ins_upd_name_reason_cd_bak_15032016]
(
	@pa_crn_no numeric,
	@pa_action varchar(50),
	@pa_nmcrcd_sba_no varchar(16),
	@pa_nmcrcd_reason_cd char(2),
	@pa_nmcrcd_reason_desc varchar(200),
	@pa_loginname varchar(50),
	@rowdelimiter    CHAR(4),        
    @coldelimiter    CHAR(4),
	@pa_msg VARCHAR(8000) OUTPUT  
)
AS BEGIN
	DECLARE @@t_errorstr      VARCHAR(8000)        
			,@@l_error        BIGINT 


		IF @pa_action = 'INS'
		BEGIN
				IF EXISTS(SELECT  nmcrcd_crn_no     
                  FROM   name_change_reason_cd             
                  WHERE  nmcrcd_deleted_ind		IN (0,4,8)      
                  AND    nmcrcd_crn_no			= @pa_crn_no      
                  AND    nmcrcd_sba_no			= nmcrcd_sba_no)      
				BEGIN                
				--      
				  UPDATE name_change_reason_cd      
				  SET    nmcrcd_deleted_ind =  3       
				  WHERE  nmcrcd_crn_no      = @pa_crn_no      
				  AND    nmcrcd_deleted_ind IN (0,4,8)      
				  AND    nmcrcd_sba_no    = nmcrcd_sba_no      
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
				   nmcrcd_deleted_ind
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
				   '0'
				   )  
					
				   update client_mstr_mak set CLIM_RMKS = @pa_nmcrcd_reason_desc 
				   where clim_crn_no = @pa_crn_no
				   and clim_deleted_ind in ('8','0','1')
				   
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
