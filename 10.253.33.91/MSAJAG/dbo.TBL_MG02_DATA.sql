-- Object: PROCEDURE dbo.TBL_MG02_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

                     
           
           
---TBL_MG02_DATA 'FEB 01 2021'  
  
   
CREATE PROCEDURE [dbo].[TBL_MG02_DATA]  
  
(@DATE DATETIME)  
AS BEGIN   
TRUNCATE TABLE TBL_MG02_REPORT  
    
INSERT INTO TBL_MG02_REPORT  
SELECT Margin_Date,Rec_Type,Party_Code,Scrip_Cd,Series,Sett_Type,Sett_No,BuyQty,BUYAMT,SELLQTY,SELLAMT,NETQTY,NETAMT,CL_RATE,MTOM,VARAMT,MINIMUM_MARGIN    FROM TBL_MG02 WITH (NOLOCK) WHERE Margin_Date= @DATE  
  
  
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\Automation\mg02\'                     
SET @FILE1 = @PATH1 + 'TBL_MG02_FILE' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name   
  
DECLARE @S1 VARCHAR(MAX)                            
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''MARGIN_DATE'''',''''REC_TYPE'''',''''PARTY_CODE'''',''''Scrip_Cd'''',''''Series'''',''''Sett_Type'''',''''Sett_No'''',''''BuyQty'''',''''BUYAMT'''',''''SELLQTY'''',''''SELLAMT'''',''''NETQTY'''',''''NETAMT'''',''''CL_RATE'''',''''MTOM'''',''''VARAMT'''',''''MINIMUM_MARGIN'''''    --Column Name  
SET @S1 = @S1 + ' UNION ALL SELECT  CONVERT (VARCHAR (11),Margin_Date,109) as Margin_Date,cast([REC_TYPE] as varchar), cast([PARTY_CODE] as varchar), cast([Scrip_Cd] as varchar), cast([Series] as varchar), cast([Sett_Type] as varchar), cast([Sett_No] as v
archar), cast([BuyQty] as varchar) ,cast([BUYAMT] as varchar),cast([SELLQTY] as varchar),cast([SELLAMT] as varchar),cast([NETQTY] as varchar),cast([NETAMT] as varchar),cast([CL_RATE] as varchar),cast([MTOM] as varchar),cast([VARAMT] as varchar),cast([MINI
MUM_MARGIN] as varchar) FROM [MSAJAG].[dbo].[TBL_MG02_REPORT]    " QUERYOUT ' --Convert data type if required  
  
 +@FILE1+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''   
--       PRINT  (@S)   
EXEC(@S1)     
 END

GO
