-- Object: PROCEDURE dbo.AUTO_MTF_PROCESS
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

CREATE  PROC [dbo].[AUTO_MTF_PROCESS]       
( @SAUDA_DATE datetime  

)      
AS      
 BEGIN       
 
 DECLARE @MAX_SAUDA_DATE varchar(11)

 SELECT @MAX_SAUDA_DATE=MAX(SAUDA_DATE) from MSAJAG.dbo.Settlement with(nolock) where sett_type='M'

 IF (@SAUDA_DATE=@MAX_SAUDA_DATE)

 BEGIN

 EXEC msdb.DBO.SP_START_JOB 'AUTO_MTF_PROCESS'       

SELECT 'MTF process has started for the dated-'+CONVERT(VARCHAR(11), @SAUDA_DATE, 120)+'. You will be notified by email after completion.'  AS REMARK  
    
	END

	ELSE 

	BEGIN
SELECT 'Equity T-Day billing does not match the specified date'  AS REMARK  
	END
       END

GO
