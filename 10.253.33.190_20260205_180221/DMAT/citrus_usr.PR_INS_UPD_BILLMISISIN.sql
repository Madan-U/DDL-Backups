-- Object: PROCEDURE citrus_usr.PR_INS_UPD_BILLMISISIN
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--	CDSL	14/05/2008	INE013A01015	30	0	*|~*	|*~|	
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_BILLMISISIN]
(
 @PA_TYPE VARCHAR(10)
,@PA_TRXDT DATETIME
,@PA_ISIN_CD VARCHAR(20)
,@PA_CLORT NUMERIC(18,3) 
,@PA_LOGINNAME VARCHAR(20)
,@rowdelimiter     CHAR(4) =     '*|~*'    
,@coldelimiter     CHAR(4) =     '|*~|'    
,@PA_ERRMSG VARCHAR(8000) OUTPUT
)
AS 
BEGIN 
DECLARE  @t_errorstr      VARCHAR(8000),
         @l_error         BIGINT
--
IF @PA_TYPE='CDSL'
BEGIN 
        BEGIN TRANSACTION

		delete from CLOSING_PRICE_MSTR_CDSL where CLOPM_ISIN_CD = @PA_ISIN_CD and CLOPM_DT = @PA_TRXDT and isnull(CLOPM_CDSL_RT,0) = 0 

		INSERT INTO CLOSING_PRICE_MSTR_CDSL
		(
			 CLOPM_ISIN_CD
			,CLOPM_DT
			,CLOPM_CDSL_RT
			,CLOPM_CREATED_BY
			,CLOPM_CREATED_DT
			,CLOPM_LST_UPD_BY
			,CLOPM_LST_UPD_DT
			,CLOPM_DELETED_IND
			,CLOPM_EXCH
		)
        VALUES
        (
           @PA_ISIN_CD
          ,@PA_TRXDT
          ,@PA_CLORT
          ,@PA_LOGINNAME
          ,GETDATE()
          ,@PA_LOGINNAME
          ,GETDATE()
          ,1
          ,'BSE'    
        )
       SET @l_error=@@ERROR
       IF @l_error<>0 
       BEGIN
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
       END 
       ELSE
       BEGIN 
                SELECT @t_errorstr ='1'
				COMMIT TRANSACTION

       END
--
END 
ELSE IF @PA_TYPE='NSDL'
BEGIN 
        BEGIN TRANSACTION
		INSERT INTO CLOSING_PRICE_MSTR_NSDL
		(
			 CLOPM_ISIN_CD
			,CLOPM_DT
			,CLOPM_NSDL_RT
			,CLOPM_CREATED_BY
			,CLOPM_CREATED_DT
			,CLOPM_LST_UPD_BY
			,CLOPM_LST_UPD_DT
			,CLOPM_DELETED_IND
			
		)
        VALUES
        (
           @PA_ISIN_CD
          ,@PA_TRXDT
          ,@PA_CLORT
          ,@PA_LOGINNAME
          ,GETDATE()
          ,@PA_LOGINNAME
          ,GETDATE()
          ,1
          
        )
       SET @l_error=@@ERROR
       IF @l_error<>0 
       BEGIN
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
       END 
       ELSE
       BEGIN 
                SELECT @t_errorstr ='1'
				COMMIT TRANSACTION

       END
--

END 
SET @pa_errmsg = @t_errorstr
END

GO
