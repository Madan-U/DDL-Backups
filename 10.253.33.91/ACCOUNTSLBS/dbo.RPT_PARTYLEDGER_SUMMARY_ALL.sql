-- Object: PROCEDURE dbo.RPT_PARTYLEDGER_SUMMARY_ALL
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[RPT_PARTYLEDGER_SUMMARY_ALL]            
 @FDATE VARCHAR(11),            
 @TDATE VARCHAR(11),            
 @STDDATE VARCHAR(11),            
 @LSTDATE VARCHAR(11),            
 @STATUSID VARCHAR(20),            
 @STATUSNAME VARCHAR(20),            
 @DISPLAYRPT VARCHAR(3),            
 @FPARTY VARCHAR(10),            
 @TPARTY VARCHAR(10),            
 @REPORTNAME VARCHAR(100),            
 @nseflg varchar(1)  ,                
 @bseflg varchar(1)  ,                
 @nfoflg varchar(1) ,         
 @SESSIONID VARCHAR(10)        
            
            
AS            
BEGIN            
DECLARE            
@@SQL AS VARCHAR(2000),            
@@RECCOUNTER AS NUMERIC,            
@@SHAREDB AS VARCHAR(25),            
@@OBJID AS INT,            
@@ACCNSESERV AS  VARCHAR(25),           
@@ACCBSESERV AS  VARCHAR(25),           
@@ACCNFOSERV AS  VARCHAR(25),           
@@ACCNSEDB AS  VARCHAR(25),           
@@ACCBSEDB AS  VARCHAR(25),           
@@ACCNFODB AS  VARCHAR(25)        
          
          
          
select @@ACCNSEDB = AccountDb,@@ACCNSESERV = AccountServer from pradnya.dbo.multicompany where Exchange = 'NSE' and Segment = 'CAPITAL'          
select @@ACCBSEDB =AccountDb,@@ACCBSESERV = AccountServer from pradnya.dbo.multicompany where Exchange = 'BSE' and Segment = 'CAPITAL'          
select @@ACCNFODB =AccountDb,@@ACCNFOSERV = AccountServer from pradnya.dbo.multicompany where Exchange = 'NSE' and Segment = 'FUTURES'          
          
Select @@ACCNSESERV = '[' + @@ACCNSESERV + ']'          
Select @@ACCBSESERV = '[' + @@ACCBSESERV + ']'          
Select @@ACCNFOSERV = '[' + @@ACCNFOSERV + ']'          
          
          
SELECT @@OBJID = ISNULL(OBJECT_ID('NEWPARTYLEDGER1'), 0)            
IF @@OBJID = 0            
 BEGIN            
  EXEC CREATEPARTYLEDGER_new            
 END            
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
            
DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID            
        
            
--SELECT TOP 1 @@SHAREDB = SHAREDB FROM OWNER            
            
            
IF @REPORTNAME = 'BRANCH'            
 Begin            
 If @nseflg ='Y'            
  Begin            
 Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'             
 Select @@SQL = @@SQL  + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
 EXEC( @@SQL)       
PRINT (@@SQL)        
  end            
 If @bseflg = 'Y'            
  Begin            
    Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'          
    Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
    EXEC( @@SQL)          
  End            
 If @nfoflg ='Y'            
  Begin            
    Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (BRANCH_CODE, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'             
    Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
 EXEC( @@SQL)             
  end            
end            
-------------------------------      
IF @REPORTNAME = 'AREA'            
 begin            
 If @nseflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (AREA, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'               
   Select @@SQL = @@SQL    + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT
   
+ ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC( @@SQL)               
end            
 If @bseflg = 'Y'            
  Begin            
 Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1(AREA, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'           
 Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + '''' EXEC(@@SQL)          
  end            
 If @nfoflg ='Y'            
  Begin            
    Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (AREA, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'          
    Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
  end            
 end            
----------------------------------            
IF @REPORTNAME = 'REGION'            
 begin            
 If @nseflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (REGION, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
 If @bseflg = 'Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (REGION, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
 EXEC(@@SQL)          
  end            
 If @nfoflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (REGION, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
end            
--------------------------------            
IF @REPORTNAME = 'SUBBROKER'            
 begin            
 If @nseflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (SUB_BROKER, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'              
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)         
print (@@SQL)        
  end            
 If @bseflg = 'Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (SUB_BROKER, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
 If @nfoflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (SUB_BROKER, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
 end            
            
-----------------------------------            
            
IF @REPORTNAME = 'TRADER'            
 begin            
 If @nseflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (TRADER, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'                
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
 If @bseflg = 'Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (TRADER, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'            
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + 
  
''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
  end            
 If @nfoflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (TRADER, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'            
    Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
 end            
end            
-----------------------------------            
            
            
IF @REPORTNAME = 'FAMILY'            
 begin            
 If @nseflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (FAMILY, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'      
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
print (@@SQL) 
 end            
 If @bseflg = 'Y'            
  Begin            
  Select @@SQL = ' INSERT INTO NEWPARTYLEDGER1 (FAMILY, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'             
  Select @@SQL = @@SQL  + 'Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)
print (@@SQL)           
  end            
 If @nfoflg ='Y'            
  Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (FAMILY, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + 'Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT + ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   EXEC(@@SQL)          
print (@@SQL)           
  end            
 end            
            
---------------------------------------            
IF @REPORTNAME = 'PARTY'            
 begin            
 If @nseflg ='Y'            
 Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH,NSEVAMT,VAMT,NSEMAMT,MAMT, NSEUNREALISED,UNREALISED,NSEHTOTAL,HTOTAL,SESSIONID)'             
   Select @@SQL = @@SQL  + ' Exec ' + @@ACCNSESERV + '.' + @@ACCNSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   PRINT(@@SQL)           
   EXEC(@@SQL)          
 end            
 If @bseflg = 'Y'            
 Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH,BSEVAMT,VAMT,BSEMAMT,MAMT,BSEUNREALISED,UNREALISED,BSEHTOTAL,HTOTAL,SESSIONID)'              
   Select @@SQL = @@SQL  + ' Exec ' + @@ACCBSESERV + '.' + @@ACCBSEDB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
PRINT(@@SQL)             
EXEC(@@SQL)          
 end            
 If @nfoflg ='Y'            
 Begin            
   Select @@SQL = 'INSERT INTO NEWPARTYLEDGER1 (CLTCODE, BRANCH,NFOVAMT,VAMT,NFOMAMT,MAMT,NFOUNREALISED, UNREALISED,NFOHTOTAL,HTOTAL,SESSIONID)'            
   Select @@SQL = @@SQL  + ' Exec ' + @@ACCNFOSERV + '.' + @@ACCNFODB  + '.DBO.RPT_PARTYLEDGER_SUMMARY_V3_new ''' + @FDATE + ''',''' + @TDATE + ''',''' + @STDDATE + ''',''' + @LSTDATE + ''',''' + @STATUSID + ''',''' + @STATUSNAME + ''',''' + @DISPLAYRPT +
  
 ''',''' + @FPARTY + ''',''' + @TPARTY + ''',''' + @REPORTNAME + ''',''' +  @SESSIONID + ''''          
   PRINT(@@SQL)           
   EXEC(@@SQL)          
 end            
end            
---------------------------------------------          
          
IF @REPORTNAME = 'BRANCH'            
 Begin            
            
Print 'vin'        
        
 Select ISNULL(BRANCH_CODE,''), BRANCH,ISNULL(SUM(NSEVAMT), 0) AS NSEL,ISNULL(SUM(BSEVAMT), 0) AS BSEL,ISNULL(SUM(NFOVAMT), 0) AS NFOL,ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,          
 ISNULL(SUM(NSEMAMT), 0) AS NSEM,ISNULL(SUM(BSEMAMT), 0) AS BSEM,ISNULL(SUM(NFOMAMT), 0) AS NFOL,ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT,          
 ISNULL(SUM(NSEUNREALISED), 0) AS NSEU , ISNULL(SUM(BSEUNREALISED), 0) AS BSEU , ISNULL(SUM(NFOUNREALISED), 0) AS NFOU ,ISNULL(SUM(UNREALISED), 0) AS UNREALISED ,           
 ISNULL(SUM(NSEHTOTAL), 0) AS NSEH,ISNULL(SUM(BSEHTOTAL), 0) AS BSEH,ISNULL(SUM(NFOHTOTAL), 0) AS NHOH,ISNULL(SUM(HTOTAL), 0) AS HTOTAL           
          
from NEWPARTYLEDGER1             
            
 GROUP BY BRANCH_CODE, BRANCH            
 Order BY BRANCH_CODE, BRANCH            
 COMPUTE SUM(ISNULL(SUM(NSEVAMT), 0)),SUM(ISNULL(SUM(BSEVAMT), 0)),SUM(ISNULL(SUM(NFOVAMT), 0)),SUM(ISNULL(SUM(VAMT), 0)), SUM(ISNULL(SUM(NSEMAMT), 0)) , SUM(ISNULL(SUM(BSEMAMT), 0)) , SUM(ISNULL(SUM(NFOMAMT), 0)) , SUM(ISNULL(SUM(MAMT), 0)) , SUM(ISNULL 
  
    
     
(        
          
SUM(NSEUNREALISED), 0)) ,SUM(ISNULL(SUM(BSEUNREALISED), 0)) ,SUM(ISNULL(SUM(NFOUNREALISED), 0)) ,SUM(ISNULL(SUM(UNREALISED), 0)) , SUM(ISNULL(SUM(BSEHTOTAL), 0)),SUM(ISNULL(SUM(NSEHTOTAL), 0)),SUM(ISNULL(SUM(NFOHTOTAL), 0)),SUM(ISNULL(SUM(HTOTAL), 0))    
  
    
      
        
end            
          
DECLARE          
@@SQL1 AS VARCHAR(200),          
@@SQL2 AS VARCHAR(200),          
@@SQL3 AS VARCHAR(200),          
@@SQL4 AS VARCHAR(200),          
@@SQL5 AS VARCHAR(200),          
@@SQL6 AS VARCHAR(200),          
@@SQL7 AS VARCHAR(200),          
@@SQL8 AS VARCHAR(200),          
@@SQL9 AS VARCHAR(200),          
@@SQL10 AS VARCHAR(200),          
@@SQLCOMPUTE1 AS VARCHAR(200),          
@@SQLCOMPUTE2 AS VARCHAR(200),          
@@SQLCOMPUTE3 AS VARCHAR(200),          
@@SQLCOMPUTE4 AS VARCHAR(200),          
@@SQLFIN AS VARCHAR(2000)          
          
select @@SQL1 =''          
select @@SQL2 =''          
select @@SQL3 =''          
select @@SQL4 =''          
select @@SQLCOMPUTE1 =''          
select @@SQLCOMPUTE2 =''          
select @@SQLCOMPUTE3 =''          
select @@SQLCOMPUTE4 =''          
          
if @nseflg = 'Y'          
 begin          
 select @@SQL1 = 'ISNULL(SUM(NSEVAMT), 0) AS NSEL,'          
 select @@SQL2 = 'ISNULL(SUM(NSEMAMT), 0) AS NSEM,'          
 select @@SQL3 = 'ISNULL(SUM(NSEUNREALISED), 0) AS NSEU,'          
 select @@SQL4 = 'ISNULL(SUM(NSEHTOTAL), 0) AS NSEH,'          
 select @@SQLCOMPUTE1 = 'SUM(ISNULL(SUM(NSEVAMT), 0)),'          
 select @@SQLCOMPUTE2 = 'SUM(ISNULL(SUM(NSEMAMT), 0)),'          
 select @@SQLCOMPUTE3 = 'SUM(ISNULL(SUM(NSEUNREALISED), 0)),'          
 select @@SQLCOMPUTE4 = 'SUM(ISNULL(SUM(NSEHTOTAL), 0)),'          
 end          
          
if @bseflg = 'Y'            
   begin          
  select @@SQL1 = @@SQL1 + 'ISNULL(SUM(BSEVAMT), 0) AS BSEL,'          
  select @@SQL2 = @@SQL2 + 'ISNULL(SUM(BSEMAMT), 0) AS BSEM,'          
  select @@SQL3 = @@SQL3 + 'ISNULL(SUM(BSEUNREALISED), 0) AS BSEU,'          
  select @@SQL4 = @@SQL4 + 'ISNULL(SUM(NSEHTOTAL), 0) AS BSEH,'          
  select @@SQLCOMPUTE1 = @@SQLCOMPUTE1 + 'SUM(ISNULL(SUM(BSEVAMT), 0)),'          
  select @@SQLCOMPUTE2 = @@SQLCOMPUTE2 + 'SUM(ISNULL(SUM(BSEMAMT), 0)),'          
  select @@SQLCOMPUTE3 = @@SQLCOMPUTE3 + 'SUM(ISNULL(SUM(BSEUNREALISED), 0)),'          
  select @@SQLCOMPUTE4 = @@SQLCOMPUTE4 + 'SUM(ISNULL(SUM(NSEHTOTAL), 0)),'          
   end          
           
if @nfoflg = 'Y'            
    begin          
  select @@SQL1 = @@SQL1 + 'ISNULL(SUM(NFOVAMT), 0) AS NFOL,'          
  select @@SQL2 = @@SQL2 + 'ISNULL(SUM(NFOMAMT), 0) AS NFOM,'          
  select @@SQL3 = @@SQL3 + 'ISNULL(SUM(NFOUNREALISED), 0) AS NFOU,'          
  select @@SQL4 = @@SQL4 + 'ISNULL(SUM(NFOHTOTAL), 0) AS NFOH,'          
  select @@SQLCOMPUTE1 = @@SQLCOMPUTE1 + 'SUM(ISNULL(SUM(NFOVAMT), 0)) ,'          
  select @@SQLCOMPUTE2 = @@SQLCOMPUTE2 + 'SUM(ISNULL(SUM(NFOMAMT), 0)) ,'          
  select @@SQLCOMPUTE3 = @@SQLCOMPUTE3 + 'SUM(ISNULL(SUM(NFOUNREALISED), 0)) ,'          
  select @@SQLCOMPUTE4 = @@SQLCOMPUTE4 + 'SUM(ISNULL(SUM(NFOHTOTAL), 0)),'          
 end          
           
  select @@SQL1 = @@SQL1 + 'ISNULL(SUM(VAMT), 0) AS LEDGERAMOUNT,'          
  select @@SQL2 = @@SQL2 + 'ISNULL(SUM(MAMT), 0) AS MARGINAMOUNT,'          
  select @@SQL3 = @@SQL3 + 'ISNULL(SUM(UNREALISED), 0) AS UNREALISED,'          
  select @@SQL4 = @@SQL4 + 'ISNULL(SUM(HTOTAL), 0) AS HTOTAL'          
  select @@SQLCOMPUTE1 = @@SQLCOMPUTE1 + 'SUM(ISNULL(SUM(VAMT), 0)),'          
  select @@SQLCOMPUTE2 = @@SQLCOMPUTE2 + 'SUM(ISNULL(SUM(MAMT), 0)),'          
  select @@SQLCOMPUTE3 = @@SQLCOMPUTE3 + 'SUM(ISNULL(SUM(UNREALISED), 0)),'          
  select @@SQLCOMPUTE4 = @@SQLCOMPUTE4 + 'SUM(ISNULL(SUM(HTOTAL), 0))'          
          
            
IF @REPORTNAME = 'AREA'            
 begin            
  select @@SQLFIN =  'select  AREA, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4          
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY AREA, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'Order BY AREA, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
            
            
            
IF @REPORTNAME = 'REGION'            
 begin            
  select @@SQLFIN =  'select REGION, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4          
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY REGION, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'Order BY REGION, BRANCH '          
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
            
            
IF @REPORTNAME = 'SUBBROKER'            
 begin            
  select @@SQLFIN =  'select SUB_BROKER, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4          
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY SUB_BROKER, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'Order BY SUB_BROKER, BRANCH '          
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
            
            
            
IF @REPORTNAME = 'TRADER'            
 begin            
  select @@SQLFIN =  'select TRADER, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4          
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY TRADER, BRANCH '           
  select @@SQLFIN = @@SQLFIN + 'ORDER BY TRADER, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
            
            
            
IF @REPORTNAME = 'FAMILY'            
 begin            
  select @@SQLFIN =  'select FAMILY, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4           
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY FAMILY, BRANCH '           
  select @@SQLFIN = @@SQLFIN + 'ORDER BY FAMILY, BRANCH '          
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
            
            
            
IF @REPORTNAME = 'PARTY'            
 begin            
--select * from NEWPARTYLEDGER1             
  select @@SQLFIN =  'select CLTCODE, BRANCH,' + @@SQL1 + @@SQL2 + @@SQL3 + @@SQL4           
  select @@SQLFIN = @@SQLFIN + ' from NEWPARTYLEDGER1 '              
  select @@SQLFIN = @@SQLFIN + ' WHERE  SESSIONID =  '''   + @SESSIONID + ''''        
  select @@SQLFIN = @@SQLFIN + 'GROUP BY CLTCODE, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'ORDER BY CLTCODE, BRANCH '            
  select @@SQLFIN = @@SQLFIN + 'COMPUTE ' + @@SQLCOMPUTE1 + @@SQLCOMPUTE2 + @@SQLCOMPUTE3 + @@SQLCOMPUTE4          
end            
PRINT @@SQLFIN          
EXEC (@@SQLFIN)            
            
           
            
--DELETE FROM NEWPARTYLEDGER1 WHERE SPID = @@SPID          
        
DELETE FROM NEWPARTYLEDGER1 WHERE SESSIONID = @SESSIONID        
            
END

GO
