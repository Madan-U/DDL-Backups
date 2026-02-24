-- Object: PROCEDURE dbo.COMBINE_MARGIN_REPORTING_AUTO_JOB
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE PROC [dbo].[COMBINE_MARGIN_REPORTING_AUTO_JOB]

	AS 
	BEGIN 
	
	
		DECLARE @SAUDA VARCHAR(11)
		SET @SAUDA=CONVERT(VARCHAR(11),getdate(),100)

		INSERT INTO  CMR_AUTO_PROCESS_LOG
		SELECT @SAUDA,GETDATE(),'AFTER_APPORVAL','START'

		INSERT INTO PROCESS_STATUS_MASTER
		SELECT 'COMBINE_MARGIN_STARTED ',@SAUDA,GETDATE(),'Y'  
		
		EXEC PROC_COMBINE_MARGIN_REPORTING @SAUDA,1

		INSERT INTO  CMR_AUTO_PROCESS_LOG
		SELECT @SAUDA,GETDATE(),'AFTER_APPORVAL','END'

	
		INSERT INTO PROCESS_STATUS_MASTER
		SELECT 'COMBINE_MARGIN_COMPLETED ',@SAUDA,GETDATE(),'Y'  
	
DECLARE @D VARCHAR(1000)
DECLARE @B VARCHAR(1000)
SET @D = 'COMBINE_MARGIN_REPORTING PROCESS FOR ' + @SAUDA 
SET @B = '<B>Dear Team,<br><br> COMBINE_MARGIN_REPORTING PROCESS COMPLETED SUCCESSFULLY FOR ' + @SAUDA +' ..!!!' +'<br><br><br> Regards,<br>Punit Verma </B>'
EXEC MSDB.DBO.SP_SEND_DBMAIL                                  

@PROFILE_NAME ='DBA',     
--@RECIPIENTS =  'punit.verma@angelbroking.com',                            
@RECIPIENTS ='updationteam@angelbroking.com;Shashi.soni@angelbroking.com;BHARAT.ghadigaonkar@angelbroking.com', 
@COPY_RECIPIENTS='punit.verma@angelbroking.com',                                  
@BODY = @B ,
@BODY_FORMAT ='HTML',                                 
@SUBJECT = @D 

	END

GO
