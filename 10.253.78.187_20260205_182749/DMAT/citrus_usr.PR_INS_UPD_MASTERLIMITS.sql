-- Object: PROCEDURE citrus_usr.PR_INS_UPD_MASTERLIMITS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*CREATE TABLE MASTERLIMITS
(ID BIGINT IDENTITY(1,1)
,RANGENAME VARCHAR(1000)
,FROM_LIMIT NUMERIC(18,0)
,TO_LIMIT   NUMERIC(18,0)
,CREATED_BY VARCHAR(100)
,CREATED_DT DATETIME
,LST_UPD_BY VARCHAR(100)
,LST_UPD_DT DATETIME
,DELETED_IND BIGINT
)
*/
	---0	INS	SS	11	11	HO	
--PR_INS_UPD_MASTERLIMITS 	'0','INS','CHECKER',1,100000,'HO',''	
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_MASTERLIMITS](@PA_ID NUMERIC
,@PA_ACTION VARCHAR(20)
,@pa_range_name VARCHAR(1000)
,@PA_FROM_LIMIT NUMERIC
,@pa_to_limit NUMERIC
,@pa_login_name VARCHAR(100)
,@PA_ERRMSG VARCHAR(8000) OUTPUT)
AS
BEGIN
  IF @pa_action = 'select'
  BEGIN
  	SELECT id,RANGENAME,FROM_LIMIT,TO_LIMIT ,'' ErrMsg FROM MASTERLIMITS 
  	WHERE  RANGENAME LIKE  @pa_range_name +  '%'
  END	
  ELSE IF @pa_action = 'INS'
  BEGIN
  	INSERT INTO MASTERLIMITS
  	SELECT @pa_range_name,@PA_FROM_LIMIT,@pa_to_limit,@pa_login_name,GETDATE(),@pa_login_name,GETDATE(),1
  	
  	
  	set @PA_ERRMSG ='RECORD SUCCESSFULLY ADDED'
  END
  ELSE IF @pa_action = 'EDT'
  BEGIN
  	update MASTERLIMITS
  	set RANGENAME  = @pa_range_name
  	,FROM_LIMIT = @PA_FROM_LIMIT
  	,TO_LIMIT = @pa_to_limit
  	,LST_UPD_BY = @pa_login_name
  	,LST_UPD_DT = GETDATE()
  	WHERE id = @pa_id
  	
  	set @PA_ERRMSG ='RECORD SUCCESSFULLY UPDTAED'
   
  END
  ELSE IF @pa_action = 'DEL'
  BEGIN
  	
  	IF exists(select * from MASTERLIMITS
  	WHERE id = @pa_id
  	AND EXISTS(SELECT llm_RANGENAME   , llm_login_name FROM login_limit_mapping 
  	               WHERE llm_RANGENAME  =   RANGENAME ))
    begin  	               
  	set @PA_ERRMSG ='You can not delete , Range already mapped with user'
  	return
  	END 
  	
  	
  	delete from MASTERLIMITS
  	WHERE id = @pa_id
  	AND NOT EXISTS(SELECT llm_RANGENAME   , llm_login_name FROM login_limit_mapping 
  	               WHERE llm_RANGENAME  =   RANGENAME )
  END
  
END

GO
