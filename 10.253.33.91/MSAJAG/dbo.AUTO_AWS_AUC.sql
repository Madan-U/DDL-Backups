-- Object: PROCEDURE dbo.AUTO_AWS_AUC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[AUTO_AWS_AUC]  
AS  
BEGIN  
  
TRUNCATE TABLE AUC_CN  
  
DECLARE @SQL  VARCHAR(MAX),  
@FILEPATH  VARCHAR(200) ='J:\BackOffice\CN_INPUT\CLIENT_CODE.txt'              
   SET @SQL = LOWER('BULK INSERT AUC_CN FROM ''' + @FILEPATH + ''' WITH  (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\N'' )')              
   --print @sql  
   EXEC (@SQL)  
  
  
  select distinct party_code  from nse_bulk_process__AUC

TRUNCATE TABLE nse_bulk_process__AUC  
INSERT INTO nse_bulk_process__AUC  
SELECT *   FROM nse_bulk_process WHERE PARTY_CODE IN (SELECT * FROM AUC_CN WHERE P IS NOT NULL)  
  
declare @NSEQUERY varchar(max)  
set @NSEQUERY = ' bcp " select Data_text'  
set @NSEQUERY = @NSEQUERY + ' from AngelNseCM.msajag.dbo.nse_bulk_process__AUC  order by party_code ,sno,SRNO,EXCHANGE,SEGMENT,SCRIP_CD,OD_TIME " queryout j:\Contract_Note\ContractNote_AUC_'+replace(convert(varchar,GETDATE(),103),'/','')+'.txt -c -t"," -SAnand1 -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'  
set @NSEQUERY = '''' + @NSEQUERY + ''''  
set @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY  
print @NSEQUERY   
exec (@NSEQUERY)    
  
END

GO
