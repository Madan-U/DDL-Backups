-- Object: PROCEDURE citrus_usr.pr_map_loginrange
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*CREATE TABLE login_limit_mapping
(iim_id bigint identity(1,1),llm_login_name VARCHAR(1000)
,llm_RANGENAME  VARCHAR(1000)
,llm_created_by VARCHAR(100)
,llm_created_dt DATETIME
,llm_lst_upd_by VARCHAR(100)
,llm_lst_upd_dt DATETIME
,llm_deleted_ind smallint)
*/
-- pr_map_loginrange 0,'range_select','HO','','',''			
CREATE PROCEDURE [citrus_usr].[pr_map_loginrange](@pa_id NUMERIC
,@pa_action VARCHAR(20)
,@pa_loginname VARCHAR(1000)
,@pa_range_name VARCHAR(100)
,@pa_login_name VARCHAR(100)
,@PA_ERRMSG VARCHAR(8000) OUTPUT)
AS
BEGIN


DECLARE @@t_errorstr       VARCHAR(8000)  
,@coldelimiter VARCHAR(25)
,@rowdelimiter VARCHAR(25)
        , @@l_error          BIGINT  
     

	IF @pa_action = 'login_select'
	BEGIN
		SELECT logn_name from login_names WHERE logn_name LIKE @pa_loginname + '%' AND logn_deleted_ind = 1
	END 
	else IF @pa_action = 'range_select'
	BEGIN
		SELECT ID,RANGENAME from MASTERLIMITS WHERE RANGENAME LIKE @pa_range_name + '%' AND DELETED_IND = 1
	END
	else IF @pa_action = 'loginrange_select'
	BEGIN
		SELECT iim_id,llm_login_name,llm_RANGENAME 
		from login_limit_mapping WHERE llm_RANGENAME  LIKE @pa_range_name + '%' 
		and  llm_login_name LIKE @pa_loginname + '%' 
		AND  llm_deleted_ind = 1
	END
	else IF @pa_action = 'INS'
	BEGIN

		BEGIN TRAN        

		insert into login_limit_mapping 
		SELECT @pa_loginname,@pa_range_name,@pa_login_name,GETDATE(),@pa_login_name,GETDATE(),1


         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @PA_ERRMSG='0'+'|*~|'+@pa_range_name+'|*~|'+@pa_loginname+'|*~|'+convert(varchar,@@l_error)+'*|~*'  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
        
	END
	else IF @pa_action = 'EDT'
	BEGIN
		update login_limit_mapping 
		set llm_login_name  = @pa_loginname
		, llm_RANGENAME = @pa_range_name
		, llm_lst_upd_by = @pa_login_name
		, llm_lst_upd_dt = GETDATE()
		WHERE iim_id = @pa_id
	END
	else IF @pa_action = 'DEL'
	BEGIN
		DELETE FROM  login_limit_mapping 
		WHERE iim_id = @pa_id
	END
	
END

GO
