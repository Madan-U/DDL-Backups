-- Object: PROCEDURE dbo.UPD_PEAK_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 
--EXEC UPD_PEAK_DATA_TEST 'DEC 15 2020' 
CREATE PROCEDURE [dbo].[UPD_PEAK_DATA]
(@DATE DATETIME )
AS 
BEGIN 
TRUNCATE TABLE PEAK_SSRS_DATA
TRUNCATE TABLE PEAK_SSRS_DETAIL

INSERT INTO PEAK_SSRS_DATA
select DISTINCT MARGINDATE,EXCHANGE,SEGMENT,PARTY_CODE,TDAY_LEDGER,TDAY_MARGIN,TDAY_MTM,TDAY_CASHCOLL,TDAY_FDBG,TDAY_CASH,TDAY_NONCASH,TDAY_MARGIN_SHORT,TDAY_MTM_SHORT,T1DAY_LEDGER,T1DAY_MARGIN,T1DAY_MTM,T1DAY_CASHCOLL,T1DAY_FDBG,T1DAY_CASH,T1DAY_NONCASH,T1DAY_MARGIN_SHORT,T1DAY_MTM_SHORT,T2DAY_LEDGER,T2DAY_MARGIN,T2DAY_MTM,T2DAY_CASHCOLL,T2DAY_FDBG,T2DAY_CASH,T2DAY_NONCASH,T2DAY_MARGIN_SHORT,T2DAY_MTM_SHORT from TBL_COMBINE_REPORTING_PEAK where MARGINDATE=@DATE

DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\PEAK_DATA\'                     
SET @FILE = @PATH + 'PEAK_DATA' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name   
DECLARE @S VARCHAR(MAX)                            
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''MARGINDATE'''',''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''TDAY_LEDGER'''',''''TDAY_MARGIN'''',''''TDAY_MTM'''',''''TDAY_CASHCOLL'''',''''TDAY_FDBG'''',''''TDAY_CASH'''',''''TDAY_NONCASH'''',''''TDAY_MARGIN_SHORT'''',''''TDAY_MTM_SHORT'''',''''T1DAY_LEDGER'''',''''T1DAY_MARGIN'''',''''T1DAY_MTM'''',''''T1DAY_CASHCOLL'''',''''T1DAY_FDBG'''',''''T1DAY_CASH'''',''''T1DAY_NONCASH'''',''''T1DAY_MARGIN_SHORT'''',''''T1DAY_MTM_SHORT'''',''''T2DAY_LEDGER'''',''''T2DAY_MARGIN'''',''''T2DAY_MTM'''',''''T2DAY_CASHCOLL'''',''''T2DAY_FDBG'''',''''T2DAY_CASH'''',''''T2DAY_NONCASH'''',''''T2DAY_MARGIN_SHORT'''',''''T2DAY_MTM_SHORT'''''    --Column Name  
SET @S = @S + ' UNION ALL SELECT  CONVERT (VARCHAR (11),MARGINDATE,109) as MARGINDATE, cast([EXCHANGE] as varchar), cast([SEGMENT] as varchar), cast([PARTY_CODE] as varchar),cast([TDAY_LEDGER] as varchar),cast([TDAY_MARGIN] as varchar),cast([TDAY_MTM] as varchar),cast([TDAY_CASHCOLL] as varchar),cast([TDAY_FDBG] as varchar),cast([TDAY_CASH] as varchar),cast([TDAY_NONCASH] as varchar),cast([TDAY_MARGIN_SHORT] as varchar),cast([TDAY_MTM_SHORT] as varchar),cast([T1DAY_LEDGER] as varchar),cast([T1DAY_MARGIN] as varchar),cast([T1DAY_MTM] as varchar),cast([T1DAY_CASHCOLL] as varchar) ,cast([T1DAY_FDBG] as varchar),cast([T1DAY_CASH] as varchar),cast([T1DAY_NONCASH] as varchar),cast([T1DAY_MARGIN_SHORT] as varchar) ,cast([T1DAY_MTM_SHORT] as varchar),cast([T2DAY_LEDGER] as varchar),cast([T2DAY_MARGIN] as varchar),cast([T2DAY_MTM] as varchar) ,cast([T2DAY_CASHCOLL] as varchar),cast([T2DAY_FDBG] as varchar),cast([T2DAY_CASH] as varchar),cast([T2DAY_NONCASH] as varchar) ,cast([T2DAY_MARGIN_SHORT] as varchar),cast([T2DAY_MTM_SHORT] as varchar) FROM [MSAJAG].[dbo].[PEAK_SSRS_DATA]    " QUERYOUT ' --Convert data type if required  
  
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''   
--       PRINT  (@S)   
EXEC(@S)

INSERT INTO PEAK_SSRS_DETAIL

select   * from TBL_COMBINE_REPORTING_PEAK_DETAIL where MARGINDATE=@DATE

DECLARE @FILE3 VARCHAR(MAX),@PATH3 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\PEAK_DATA\'                     
SET @FILE3 = @PATH3 + 'PEAK_DETAIL' +'_'+ CONVERT(VARCHAR(11),@DATE  , 112) + '.csv' --Folder Name   
DECLARE @S3 VARCHAR(MAX)                            
SET @S3 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT  ''''MARGINDATE'''',''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''TDAY_LEDGER'''',''''TDAY_MARGIN'''',''''TDAY_MTM'''',''''TDAY_CASHCOLL'''',''''TDAY_FDBG'''',''''TDAY_NONCASH'''',''''TDAY_MARGIN_SHORT'''',''''TDAY_MTM_SHORT'''',''''T1DAY_LEDGER'''',''''T1DAY_MARGIN'''',''''T1DAY_MTM'''',''''T1DAY_CASHCOLL'''',''''T1DAY_FDBG'''',''''T1DAY_NONCASH'''',''''T1DAY_MARGIN_SHORT'''',''''T1DAY_MTM_SHORT'''',''''T2DAY_LEDGER'''',''''T2DAY_MARGIN'''',''''T2DAY_MTM'''',''''T2DAY_CASHCOLL'''',''''T2DAY_FDBG'''',''''T2DAY_NONCASH'''',''''T2DAY_MARGIN_SHORT'''',''''T2DAY_MTM_SHORT'''',''''T_MARGINAVL'''',''''T_MTMAVL'''''  --Column Name 
SET @S3 = @S3 + ' UNION ALL SELECT  CONVERT (VARCHAR (11),MARGINDATE,109) as MARGINDATE, cast([EXCHANGE] as varchar), cast([SEGMENT] as varchar), cast([PARTY_CODE] as varchar),cast([TDAY_LEDGER] as varchar),cast([TDAY_MARGIN] as varchar), cast([TDAY_MTM] as varchar),cast([TDAY_CASHCOLL] as varchar) ,cast([TDAY_FDBG] as varchar), cast([TDAY_NONCASH] as varchar), cast([TDAY_MARGIN_SHORT] as varchar),cast([TDAY_MTM_SHORT] as varchar) ,cast([T1DAY_LEDGER] as varchar),cast([T1DAY_MARGIN] as varchar),cast([T1DAY_MTM] as varchar) ,cast([T1DAY_CASHCOLL] as varchar) ,cast([T1DAY_FDBG] as varchar),cast([T1DAY_NONCASH] as varchar) ,cast([T1DAY_MARGIN_SHORT] as varchar) ,cast([T1DAY_MTM_SHORT] as varchar),cast([T2DAY_LEDGER] as varchar) ,cast([T2DAY_MARGIN] as varchar ),cast([T2DAY_MTM] as varchar) ,cast([T2DAY_CASHCOLL] as varchar) ,cast([T2DAY_FDBG] as varchar),cast([T2DAY_NONCASH] as varchar),cast([T2DAY_MARGIN_SHORT] as varchar) ,cast([T2DAY_MTM_SHORT] as varchar)  ,cast([T_MARGINAVL] as varchar),cast([T_MTMAVL] as varchar )  FROM [MSAJAG].[dbo].[PEAK_SSRS_DETAIL]    " QUERYOUT ' --Convert data type if required  

  
 +@file3+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''   
      -- PRINT  (@S)   
EXEC(@S3)    

END

GO
