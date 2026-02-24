-- Object: PROCEDURE dbo.Automation_VBB_LIST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE PROC [dbo].[Automation_VBB_LIST]  
  
AS  
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\VBB\'                     
  
SET @FILE = @PATH + 'VBB' + CONVERT(VARCHAR(11), GETDATE(), 112) + '.xls' --Folder Name   
  
  
DECLARE @D VARCHAR(100)  
SET @D = 'VBB Client List For' + ' ' + CONVERT (VARCHAR (11),GETDATE(),109)  
  
  
DECLARE @S VARCHAR(MAX)                            
  
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SP_Party_Code'''',''''SCHEME_NAME'''',''''SP_Date_From'''''    --Column Name  
  
    
SET @S = @S + ' UNION ALL SELECT  cast([SP_Party_Code] as varchar), cast([SCHEME_NAME] as varchar),CONVERT (VARCHAR (11),SP_Date_From,109) as SP_Date_From FROM [MSAJAG].[dbo].[Vw_VBB_SCHEME] where SP_Date_From >= getdate()-5  " QUERYOUT ' --Convert data type if required  
  
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
  
              
PRINT (@S)                                  
  
EXEC(@S)     
  
  
--EXEC MSDB.DBO.SP_SEND_DBMAIL                                    
  
--@PROFILE_NAME ='DBA',                                    
  
--@RECIPIENTS ='tushar.jorigal@angelbroking.com;csosurveillance@angelbroking.com;Lalitendu.Acharya@angelbroking.com',   
  
--@COPY_RECIPIENTS='punit.verma@angelbroking.com',                                    
  
--@FILE_ATTACHMENTS= @FILE,  
  
--@BODY = 'Dear Team,<br><br> Please find attached file. <br><br><br> Regards,<br>Punit Verma',  
  
--@BODY_FORMAT ='HTML',                                   
  
--@SUBJECT = @D

GO
