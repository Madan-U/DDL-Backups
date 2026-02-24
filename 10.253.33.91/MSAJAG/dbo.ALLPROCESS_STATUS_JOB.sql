-- Object: PROCEDURE dbo.ALLPROCESS_STATUS_JOB
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE  PROC [dbo].[ALLPROCESS_STATUS_JOB]

	AS 
BEGIN
	
DECLARE @S VARCHAR(1000)
DECLARE @A VARCHAR(1000)
DECLARE @D VARCHAR(1000)
DECLARE @M VARCHAR(1000)
DECLARE @B VARCHAR(1000)
DECLARE @C INT 

	SELECT @S=PROCESS_STATUS,@D =PROCESS_DATE ,@M =PROCESS_STATUS_TIME FROM PROCESS_STATUS_MASTER WITH (NOLOCK) WHERE STATUS_FLAG='Y'
	SELECT @C=COUNT(1) FROM PROCESS_STATUS_MASTER WITH (NOLOCK) WHERE STATUS_FLAG='Y'

IF @C =0
BEGIN
			RETURN 
END 

SET @A =@S +' ' +@D
SET @B = '<B>Dear Team,<br><br> ' + @S +'..!!!' +'<br><br><br> Regards,<br>Punit Verma </B>'
EXEC MSDB.DBO.SP_SEND_DBMAIL                                  

@PROFILE_NAME ='DBA',     
--@RECIPIENTS =  'punit.verma@angelbroking.com',                            
@RECIPIENTS ='updationteam@angelbroking.com;Shashi.soni@angelbroking.com;BHARAT.ghadigaonkar@angelbroking.com', 
@COPY_RECIPIENTS='punit.verma@angelbroking.com',                                  
@BODY = @B ,
@BODY_FORMAT ='HTML',                                 
@SUBJECT = @A

UPDATE PROCESS_STATUS_MASTER SET STATUS_FLAG='N' WHERE STATUS_FLAG='Y'

	END

GO
