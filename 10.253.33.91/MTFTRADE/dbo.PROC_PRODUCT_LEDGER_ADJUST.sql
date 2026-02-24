-- Object: PROCEDURE dbo.PROC_PRODUCT_LEDGER_ADJUST
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------




CREATE PROC [dbo].[PROC_PRODUCT_LEDGER_ADJUST]            
(            
 @SAUDA_DATE  VARCHAR(11),            
 @FLAG   INT = 0             
)            
AS    
DECLARE @GLCODE VARCHAR(10)  ,         
   @PROCESSDATE DATETIME,      
   @SDTCUR varchar(11),    
   @LDTCUR varchar(11)

  
DECLARE @SQL VARCHAR(MAX) 

 SELECT @SDTCUR = SDTCUR, @LDTCUR = LDTCUR FROM ACCOUNT.DBO.PARAMETER     
 WHERE @SAUDA_DATE BETWEEN SDTCUR AND LDTCUR

  SET @PROCESSDATE = GETDATE()            

  
  UPDATE TBL_MTF_DATA SET MTFLEDBAL = VAMT  
  FROM (  
 SELECT VAMT = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),  
 CLTCODE FROM LEDGER  
 WHERE VDT BETWEEN @SDTCUR AND @LDTCUR + ' 23:59:59'  
 AND VDT <= @SAUDA_DATE + ' 23:59'  
 GROUP BY CLTCODE  
  ) L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE  
    
  UPDATE TBL_MTF_DATA SET CMLEDBAL = VAMT  
  FROM (  
 SELECT VAMT = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),  
 CLTCODE FROM ACCOUNT.DBO.LEDGER L, TBLCLIENTMARGIN T  
 WHERE VDT BETWEEN @SDTCUR AND @LDTCUR + ' 23:59:59'  
 AND VDT <= @SAUDA_DATE + ' 23:59'  
 AND T.PARTY_CODE = CLTCODE  
 GROUP BY CLTCODE  
  ) L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE  
  
truncate table TBL_LED_OTHER

SET @SQL = ' insert into TBL_LED_OTHER  select a.* from ( SELECT * from OPENQUERY(AngelBSECM, ''select VAMT = SUM(CASE WHEN DRCR = ''''C'''' THEN VAMT ELSE -VAMT END), CLTCODE '
set @sql=@sql + ' FROM ACCOUNT_AB.DBO.LEDGER L WHERE VDT BETWEEN ''''' + @SDTCUR + ''''' AND ''''' + @LDTCUR + ' 23:59:59'''' AND VDT <= ''''' + @SAUDA_DATE + ' 23:59'''' group by cltcode'') ) a ,' 
set @sql=@sql + ' TBLCLIENTMARGIN T  '
set @sql=@sql + '  WHERE T.PARTY_CODE = CLTCODE'
exec (@sql)

  UPDATE TBL_MTF_DATA SET CMLEDBAL = CMLEDBAL + VAMT  
  FROM  TBL_LED_OTHER L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE 
  
  
truncate table TBL_LED_OTHER
SET @SQL = ' insert into TBL_LED_OTHER select a.* from ( SELECT * from OPENQUERY(ANGELFO, ''select VAMT = SUM(CASE WHEN DRCR = ''''C'''' THEN VAMT ELSE -VAMT END), CLTCODE '
set @sql=@sql + ' FROM ACCOUNTFO.DBO.LEDGER L WHERE VDT BETWEEN ''''' + @SDTCUR + ''''' AND ''''' + @LDTCUR + ' 23:59:59'''' AND VDT <= ''''' + @SAUDA_DATE + ' 23:59'''' group by cltcode'') ) a ,' 
set @sql=@sql + ' TBLCLIENTMARGIN T  '
set @sql=@sql + '  WHERE T.PARTY_CODE = CLTCODE'
exec (@sql)

  UPDATE TBL_MTF_DATA SET FOLEDBAL = VAMT  
  FROM  TBL_LED_OTHER L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE 
  
truncate table TBL_LED_OTHER
SET @SQL = ' insert into TBL_LED_OTHER select a.* from ( SELECT * from OPENQUERY(ANGELFO, ''select VAMT = SUM(CASE WHEN DRCR = ''''C'''' THEN VAMT ELSE -VAMT END), CLTCODE '
set @sql=@sql + ' FROM ACCOUNTcurFO.DBO.LEDGER L WHERE VDT BETWEEN ''''' + @SDTCUR + ''''' AND ''''' + @LDTCUR + ' 23:59:59'''' AND VDT <= ''''' + @SAUDA_DATE + ' 23:59'''' group by cltcode'') ) a ,' 
set @sql=@sql + ' TBLCLIENTMARGIN T  '
set @sql=@sql + '  WHERE T.PARTY_CODE = CLTCODE'
exec (@sql) 
 
 
  UPDATE TBL_MTF_DATA SET FOLEDBAL = VAMT  
  FROM  TBL_LED_OTHER L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE 

  
truncate table TBL_LED_OTHER
SET @SQL = ' insert into TBL_LED_OTHER select a.* from ( SELECT * from OPENQUERY(ANGELCOMMODITY, ''select VAMT = SUM(CASE WHEN DRCR = ''''C'''' THEN VAMT ELSE -VAMT END), CLTCODE '
set @sql=@sql + ' FROM ACCOUNTNCDX.DBO.LEDGER L WHERE VDT BETWEEN ''''' + @SDTCUR + ''''' AND ''''' + @LDTCUR + ' 23:59:59'''' AND VDT <= ''''' + @SAUDA_DATE + ' 23:59'''' group by cltcode'') ) a ,' 
set @sql=@sql + ' TBLCLIENTMARGIN T  '
set @sql=@sql + '  WHERE T.PARTY_CODE = CLTCODE'
exec (@sql) 
 
 
  UPDATE TBL_MTF_DATA SET FOLEDBAL = VAMT  
  FROM  TBL_LED_OTHER L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE 
  
truncate table TBL_LED_OTHER
SET @SQL = ' insert into TBL_LED_OTHER select a.* from ( SELECT * from OPENQUERY(ANGELCOMMODITY, ''select VAMT = SUM(CASE WHEN DRCR = ''''C'''' THEN VAMT ELSE -VAMT END), CLTCODE '
set @sql=@sql + ' FROM ACCOUNTMCDX.DBO.LEDGER L WHERE VDT BETWEEN ''''' + @SDTCUR + ''''' AND ''''' + @LDTCUR + ' 23:59:59'''' AND VDT <= ''''' + @SAUDA_DATE + ' 23:59'''' group by cltcode'') ) a ,' 
set @sql=@sql + ' TBLCLIENTMARGIN T  '
set @sql=@sql + '  WHERE T.PARTY_CODE = CLTCODE'
exec (@sql) 
 
 
  UPDATE TBL_MTF_DATA SET FOLEDBAL = VAMT  
  FROM  TBL_LED_OTHER L  
  WHERE SAUDA_DATE = @SAUDA_DATE  
  AND PARTY_CODE = CLTCODE

GO
