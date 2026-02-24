-- Object: PROCEDURE citrus_usr.pr_outward_book_details
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*

ors_id
ors_po_no
ors_book_type
ors_no_of_books
ors_size_of_books
ors_from_no
ors_to_no
ors_from_slip
ors_to_slip
ors_tratm_id
ors_dpm_id
ors_series_type
ors_remarks
ors_created_dt
ors_created_by
ors_lst_upd_dt
ors_lst_upd_by
ord_deleted_ind

*/

CREATE PROCEDURE [citrus_usr].[pr_outward_book_details](@pa_id             VARCHAR(8000)  
													, @pa_action         VARCHAR(20)  
													, @pa_login_name     VARCHAR(20)  
													, @pa_po_no      VARCHAR(20)  
													, @pa_Book_type      CHAR(1)
													, @pa_NO_Book_type   numeric(10,0)
													, @pa_Size_Book      bigint
													, @pa_From_Book      bigint
													, @pa_To_Book        bigint
													, @pa_From_slip      bigint
													, @pa_To_slip        bigint
													, @pa_slibm_tratm_id NUMERIC
													, @pa_dpm_dpid       VARCHAR(50)
													, @pa_series_type    VARCHAR(50)
													, @pa_rmks           VARCHAR(11)
                                                    , @pa_dt             datetime
													, @pa_chk_yn         INT  
													, @rowdelimiter      CHAR(4)       = '*|~*'  
													, @coldelimiter      CHAR(4)       = '|*~|'  
																																										, @pa_errmsg         VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_outward_book_details
 DESCRIPTION    : 
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            14-Apr-2008   VERSION.
-----------------------------------------------------------------------------------*/
BEGIN
--
DECLARE @t_errorstr      VARCHAR(8000)
      , @l_error         BIGINT
      , @delimeter       VARCHAR(10)
      , @remainingstring VARCHAR(8000)
      , @currstring      VARCHAR(8000)
      , @foundat         INTEGER
      , @delimeterlength INT
      , @l_slibm_id      NUMERIC
      , @l_slibmm_id     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)
      , @l_dpm_id       NUMERIC
      , @l_deleted_ind  int 


declare @c_access_cursor cursor
set @l_excm_cd = ''
set @l_access1       = 0 
SET @l_error         = 0
SET @t_errorstr      = ''
SET @delimeter        = '%'+ @ROWDELIMITER + '%'
SET @delimeterlength = LEN(@ROWDELIMITER)
SET @remainingstring = @pa_id  

		WHILE @remainingstring <> ''
		BEGIN
		--
				SET @foundat = 0
				SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)
				--
				IF @foundat > 0
				BEGIN
				--
						SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)
						SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)
				--
				END
				ELSE
				BEGIN
				--
						SET @currstring      = @remainingstring
						SET @remainingstring = ''
				--
				END
				--
				IF @currstring <> ''
				BEGIN
				--
										
				  IF @pa_chk_yn = 0
				  BEGIN
				  --
if @pa_dpm_dpid='999'
begin 
SELECT @l_dpm_id  = '999'
end 
else 
begin
SELECT @l_dpm_id  = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_excsm_id = @pa_dpm_dpid and isnull(default_dp,'0') = dpm_excsm_id
end				  			

				  			
				    IF @PA_ACTION = 'INS'
				    BEGIN
				    --
										
										IF exists(select ors_id from Order_Slip where ors_tratm_id = @pa_slibm_tratm_id and (@pa_From_Book between ors_from_no and  ors_to_no)  and (@pa_to_Book between ors_from_no and  ors_to_no) and ors_series_type = @pa_series_type )
										Begin
										--
										  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can Not Process, Book No Already Used In Another Purchase Order!'
										  SET @pa_errmsg = @t_errorstr
										  return
										--
										END
																			
										BEGIN TRANSACTION
										
				      SELECT @l_slibm_id   = isnull(MAX(ors_id),0) + 1 FROM Order_Slip 
				      
				      
				      INSERT INTO Order_Slip 
				      (ors_id
										,ors_po_no
										,ors_book_type
										,ors_no_of_books
										,ors_size_of_books
										,ors_from_no
										,ors_to_no
										,ors_from_slip
										,ors_to_slip
										,ors_tratm_id
										,ors_dpm_id	
										,ors_series_type
										,ors_remarks
										,ors_created_dt
										,ors_created_by
										,ors_lst_upd_dt
										,ors_lst_upd_by
										,ord_deleted_ind, ors_po_dt 
				      )VALUES
				      (@l_slibm_id   
			      	,@pa_po_no 
										,@pa_Book_type 
										,@pa_NO_Book_type 
										,@pa_Size_Book    
										,@pa_From_Book    
										,@pa_To_Book      
										,@pa_From_slip    
										,@pa_To_slip      
										,@pa_slibm_tratm_id 
										, @l_dpm_id      
										,@pa_series_type    
										,@pa_rmks           										
										,getdate()
										,@pa_login_name
										,getdate()
										,@pa_login_name										
										,1,@pa_dt
				      )
				      
				      SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)
												--
												END
												ELSE
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
												--
            END
            
												ROLLBACK TRANSACTION 
												
												RETURN
										--
										END
										ELSE
										BEGIN
										--
												COMMIT TRANSACTION
										--
  								END
				      
				    --
				    END
				    ELSE IF @PA_ACTION = 'EDT'
				    BEGIN
				    --
				      BEGIN TRANSACTION
				    
				       Update   Order_Slip 
											set      ors_book_type = @pa_Book_type
																			,ors_no_of_books = @pa_NO_Book_type 
																			,ors_size_of_books=@pa_Size_Book  
																			,ors_from_no=@pa_From_Book  
																			,ors_to_no=@pa_To_Book
																			,ors_from_slip=@pa_From_slip  
																			,ors_to_slip=@pa_To_slip   
																			,ors_tratm_id=@pa_slibm_tratm_id 
																			,ors_series_type=@pa_series_type  
																			,ors_lst_upd_dt=getdate()
																			,ors_lst_upd_by=@pa_login_name , ors_po_dt = @pa_dt
										  WHERE   ors_id = @pa_id       
										
										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)
												--
												END
												ELSE
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
												--
												END

												ROLLBACK TRANSACTION 

												RETURN
										--
										END
										ELSE
										BEGIN
										--
												COMMIT TRANSACTION
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  BEGIN TRANSACTION
								  
								     Update   Order_Slip 
													set      ord_deleted_ind = 0 
																					,ors_lst_upd_dt=getdate()
																					,ors_lst_upd_by=@pa_login_name
										   WHERE    ors_id = @pa_id  
										   AND      ord_deleted_ind =1 
										  
									 										
										
										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)
												--
												END
												ELSE
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
												--
												END

												ROLLBACK TRANSACTION 

												RETURN
										--
										END
										ELSE
										BEGIN
										--
												COMMIT TRANSACTION
										--
  								END
								--
				    END
				  --
				  END
				  					 	
				--
				END
		--
		END
		
		SET @pa_errmsg = @t_errorstr
--
END

GO
